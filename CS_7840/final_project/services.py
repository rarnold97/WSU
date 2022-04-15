from libISAR.ECP import ecp, plot_ecp
from libISAR.rdi import RDI
import sys
import time
from datetime import datetime
from typing import Union, List, Tuple
from pathlib import Path
from BatchIsarGen.InitAngleNest import AngleNest, CreateAngleLevels, AngleID, mapModelstoPatterns
from BatchIsarGen.CreateMastersimRun import MastersimGenerate
from isar_db.mongo_interface import isar_db
from isar_db.isar_db_model import SignatureRecord, CompImageRecord, Models
from scipy import ndimage
from libISAR.rdi import dotdict
import threading
import time
import numpy as np
import warnings

#from libISARML.logging import get_logger
#logger = get_logger()

# dont want to plot during the service
RDI.doPlots = False

# Creating lock for threads
lock = threading.Lock()




class SimThread(threading.Thread):

    def __init__(self, patternFilename: Path, modelFilename: Path, batch):
        threading.Thread.__init__(self)

        # patter file and model file are static to each batch
        self.patternFilename = patternFilename
        self.modelFilename = modelFilename
        self.batch = batch
        self.simGenerator = MastersimGenerate()

    def _init(self, minibatch: dotdict):
        self.simGenerator.init_run(self.patternFilename, self.modelFilename, minibatch)

    def run(self):
        mongodb = isar_db()
        output_log = []

        for minibatch in self.batch.mini_batches:
            output_log.append("------------------------------------------\n")
            output_log.append("Starting Run for: ShapeID - %s\n" % (self.batch.shape))

            for key, item in minibatch.items():
                output_log.append("Angle Type - " + str(key) + " Angle Value - " + str(item)+'\n')

            self._init(minibatch)

            # figured out how to get the mastersim dump from the subprocess
            # no longer need to lock the log file anymore
            #lock.acquire()

            run_outputs = self.simGenerator.execute()

            time.sleep(0.001)

            #lock.release()

            if run_outputs.exit_code != 0:
                warnings.warn("Mastersim run failed, skipping ...")
                continue

            ## do signature database query here
            hwb_filename = run_outputs.hwb_path
            sig_rec = SignatureRecord()
            sig_rec.hwb_filename = hwb_filename
            sig_rec.model_file = str(self.modelFilename)
            sig_rec.motion_filename = str(run_outputs.mtx)
            sig_rec.kappa = self.simGenerator.kappa
            sig_rec.theta = self.simGenerator.theta
            sig_rec.simxml = run_outputs.simxml

            try:
                db_entry = mongodb.insert_sig_record(sig_rec)
                sig_record_id = db_entry.inserted_id
                output_log.append("Singature Record: %s inserted to mongodb !\n" %(str(sig_record_id)))

                ## do rdi stuff now
                isar_entries = generate_isar_entry(mongodb, hwb_filename, minibatch, self.batch.snr, self.batch.shape, sig_record_id)

                [output_log.append("ISAR Record: %s with SNR: %s inserted to mongodb !\n"%(str(isar_entry_tup[0].inserted_id), isar_entry_tup[1])) for isar_entry_tup in isar_entries]
                output_log.append("------------------------------------------\n")
                print("".join(output_log))

                #logger.info("".join(output_log))

            except Exception as e:
                warnings.warn("Error Performing DB inserstion on current batch: " + str(e))
                continue


def generate_isar_entry(
        db: isar_db,
        hwb_filename: Union[Path, str],
        minibatch: dotdict,
        snr_arr: Union[Tuple, List, np.ndarray],
        current_shape_id: int,
        par_id
    ):

    # load signature file
    rdi = RDI.from_hwb_file(hwb_filename)

    # generate noise free dataset
    rdi.generate_isar()

    db_entries = []
    # process noisy images
    for snr in snr_arr:
        if not np.isclose(snr, 0):
            rdi.addNoise(snr)

        ecp_img_data, bounds = ecp(rdi)
        ecp_img_db = 20.0*np.log10(np.abs(ecp_img_data.T))
        compressed_img = ndimage.interpolation.zoom(ecp_img_db, 0.5)

        isar_record = CompImageRecord(compressed_img, par_id)

        isar_record.kappa_label = minibatch[AngleID.KAPPA]
        isar_record.theta_label = minibatch[AngleID.THETA]

        isar_record.crossRangeStart = bounds.cross_range[0]
        isar_record.crossRangeStop = bounds.cross_range[1]
        isar_record.relRangeStart = bounds.rel_range[0]
        isar_record.relRangeStop = bounds.rel_range[1]

        isar_record.model_label = current_shape_id

        isar_record.SNR = snr

        entry = db.insert_isar_record(isar_record)
        db_entries.append((entry, snr))

    return db_entries


def createThreads() -> List:

    Threads = []
    pattern_map = mapModelstoPatterns()
    # angle spacing stays the same
    levels = CreateAngleLevels(useKappa=True, useTheta=True)

    for entry in pattern_map:
        batch_generator = AngleNest(levels, shape_id=entry.shape_id, snr_vals=(0, 30))
        Threads.append(SimThread(entry.pattern, entry.model, batch_generator.createBatches()))

    return Threads


def main_service():

    Threads = createThreads()

    for thread in Threads:
        thread.start()

    for thread in Threads:
        thread.join()


def test_thread():
    Threads = createThreads()

    thread = Threads[0]

    thread.run()


def main():
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Services Started at: ", current_time)

    start_time = time.time()
    # Threaded services entry point
    main_service()

    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Services Ended at: ", current_time)

    print("----- Total Time elapsed: %s [seconds] -----" % (time.time() - start_time))


if __name__ == "__main__":

    ## UNCOMMENT TO DEBUG A SINGLE THREAD
    #test_thread()
    main()
