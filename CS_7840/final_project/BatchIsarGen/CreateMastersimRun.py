from BatchIsarGen.InitAngleNest import AngleNest
from BatchIsarGen.cfgInject import probeMotionFile, probeMasterSimConfigFileMono, init_mastersim_params, init_motion_params

from pathlib import Path
from typing import Union, List
import os
from libISAR.rdi import dotdict, RDI
from BatchIsarGen.cfgInject import init_mastersim_params, init_motion_params, probeMotionFile, probeMasterSimConfigFileMono
from BatchIsarGen.InitAngleNest import AngleID
import uuid
from shutil import copy2


SEED_PATH = os.environ.get("ISAR_ML_SEED_PATH")
DATA_PATH = os.environ.get("ISAR_ML_ROOT")
MASTERSIM_PATH = os.environ.get("MASTERSIM_PATH")
LOG_PATH = os.environ.get("WXRAWS")


def getMonoStaticSensorCoords():

    try:
        curr_path = Path(__file__).parent.absolute()
        sensor_filename = curr_path.parent.absolute() / "xmit_coords.txt"
        with open(sensor_filename, 'r') as file:
            data = file.readlines()
            coords = data[-1]
            lat, lon, height = coords.split(' ')
    except Exception as e:
        print("Cannot import sensor coordinates, aborting.  Error: ", e)

    return float(lat), float(lon), float(height)


class MastersimGenerate:

    outputDir: Path = Path("X:/isar_img_ml") if DATA_PATH is None else Path(DATA_PATH)
    SeedDir: Path = Path("X:/isar_img_ml/seed") if SEED_PATH is None else Path(SEED_PATH)
    # make sure there is a folder titled trajectory in the data path that contains a valid state vector file
    stateVectorFile = outputDir / "trajectory" / "satSim.gsv"
    motionSeed: Path = SeedDir / "satSim.mtx"
    # ensure there is a folder titled signature_files in the data path
    hwbOutput: Path = outputDir / "signature_files"
    simxmlSeed: Path = SeedDir / "MasterSimParams.simxml"
    logPath: Path = Path("G:/BSI/cdr4/log/mastersim.log") if LOG_PATH is None else Path(LOG_PATH) / "log" / "mastersim.log"

    masterSimExe: Path = Path("G:/BSI/mastersim_win/hb-dev-mar-22/mastersim.exe") if MASTERSIM_PATH is None else Path(MASTERSIM_PATH) / "mastersim.exe"

    startTime: float = 23900.0
    stopTime: float = 24000.0

    def __init__(self):

        self.mtxParams: dotdict = None
        self.simParams: dotdict = None

        self.modelFilename: Path = None
        self.patternFilename: Path = None

        self.currentMtx: Path = None
        self.currentSimxml: Path = None

        self.kappa, self.theta, self.spin = 0.0, 0.0, 0.0


    def _getUniqueMtx(self):

        mtx_dir = self.outputDir / "motion"
        if not mtx_dir.is_dir():
            raise NotADirectoryError(str(mtx_dir)+ " Does not exist ...")

        basename = self.motionSeed.stem

        uid = uuid.uuid4()
        newLeaf = str(basename) + '_' + str(uid) + '.mtx'
        new_path = mtx_dir / newLeaf

        return new_path

    def _getUniqueSimxml(self):
        simxml_dir = self.outputDir / "mastersim_cfg"
        if not simxml_dir.is_dir():
            raise NotADirectoryError(str(simxml_dir)+' Does not exist ...')

        basename = self.simxmlSeed.stem
        uid = uuid.uuid4()
        new_leaf = basename + '_' + str(uid) + '.simxml'
        new_path = simxml_dir / new_leaf

        return new_path

    @classmethod
    def fetch_sim_hwb_from_log(cls) -> Path:

        with open(cls.logPath, 'r') as file:
            log_content = file.readlines()
            file.close()

        latest_hwb_line = log_content[-2]
        hwb_filename = Path(latest_hwb_line.split(' ')[-1].rstrip('\n'))

        new_file_loc = cls.hwbOutput / hwb_filename.name

        new_hwb_filename = copy2(hwb_filename, new_file_loc)

        # clear the log to keep the buffer clean
        open(cls.logPath, 'w').close()

        return new_hwb_filename

    def _genCfg(self, minibatch: dotdict):

        ##:todo add support for other motion angles
        kappa: float = 0
        theta: float = 0
        spin: float = 0

        for key, value in minibatch.items():
            if key == AngleID.KAPPA:
                self.kappa = value
            elif key == AngleID.THETA:
                self.theta = value
            elif key == AngleID.SPIN:
                self.spin = value

        self.currentMtx = self._getUniqueMtx()

        self.mtxParams = init_motion_params(
            traj_ref_file=self.stateVectorFile,
            kappa=self.kappa,
            theta=self.theta,
            prec_period=RDI.period # this is more or less constant for this application
        )

        success = probeMotionFile(self.motionSeed, self.currentMtx, self.mtxParams)

        if success:
            self.simParams = init_mastersim_params(
                (self.startTime, self.stopTime),
                time_step=0.01,
                output_path=self.hwbOutput,
                pattern_filename=self.patternFilename,
                traj_filename=self.stateVectorFile,
                motion_filename= self.currentMtx,
                model_filename=self.modelFilename,
                sensor_coords=getMonoStaticSensorCoords(),
                loop_gain=330,
                bwd= 1000.0 #MHz
            )

            self.currentSimxml = self._getUniqueSimxml()
            sim_gen_success = probeMasterSimConfigFileMono(self.simxmlSeed, self.currentSimxml, self.simParams)
            if not sim_gen_success:
                raise IOError('Cannot write simxml file, aborting current mastersim run generation ...')

        else:
            raise IOError('Cannot write mtx file, aborting current mastersim run generation ...')


    def init_run(self, patternFilename: Path, modelFilename: Path, minibatch):

        self.patternFilename = patternFilename
        self.modelFilename = modelFilename

        self._genCfg(minibatch)

    def execute(self):
        cmd = str(self.masterSimExe) + " " + str(self.currentSimxml) + " " + "-nogui"

        ## lock with a mutex here
        ret_code = -1
        try:
            ret_code = os.system(cmd)
        except Exception as e:
            print("Error calling mastersim subprocess: ", e)
            return dotdict({
                "exit_code": ret_code,
                "mtx": str(self.currentMtx),
                "simxml": str(self.currentSimxml),
                "hwb_path": None
            })

        # retrieve the lastest output file
        new_hwb: Path = MastersimGenerate.fetch_sim_hwb_from_log()
        #unlock mutex

        # convert paths to strings to make json encoding smoother
        run_summary = dotdict({
            "exit_code": ret_code,
            "mtx": str(self.currentMtx),
            "simxml": str(self.currentSimxml),
            "hwb_path": str(new_hwb)
        })

        return dotdict(run_summary)


if __name__ == "__main__":
    latest_hwb = MastersimGenerate.fetch_sim_hwb_from_log()
    print(latest_hwb)
