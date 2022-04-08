# XML FILE HANDLING
from libISAR.rdi import dotdict

import xml.etree.ElementTree as ET
from xml.dom import minidom

import pathlib
from pathlib import Path
from typing import Union, List, Tuple

import numpy as np

def path_to_str(filename: Union[str, Path]):

    if type(filename) is Path or type(filename) is pathlib.WindowsPath:
        new_filename = str(filename.as_posix())
    else:
        new_filename = filename

    return new_filename

def init_mastersim_params(times: Union[List, Tuple, np.ndarray], time_step: float, output_path: Path,
                          pattern_filename: Path,
                          traj_filename: Path, motion_filename: Path, model_filename: Path,
                          sensor_coords: Union[List, Tuple, np.ndarray],
                          loop_gain: float, bwd: float):
    if len(times) != 2:
        raise ValueError("Invalid number of time entries, enter : (Start, Stop)")

    if len(sensor_coords) != 3:
        raise ValueError("Enter geodetic coordinate array, 3 elements: lat[deg]-lon[deg]-height[m]")

    params = dotdict({
        "start_time": times[0],
        "stop_time": times[1],
        "step_time": time_step,
        "motion_filename": motion_filename,
        "model_filename": model_filename,
        "traj_filename": traj_filename,
        "output_path": output_path,
        "pattern_filename": pattern_filename,
        "sensor_lat": sensor_coords[0],
        "sensor_lon": sensor_coords[1],
        "sensor_height": sensor_coords[2],
        "ref_freq": 9500,
        "bwd": bwd,
        "rflg": loop_gain
    })

    return params


def init_motion_params(traj_ref_file: Path, kappa: float, theta: float, prec_period: float):
    params = dotdict({"sv_filename": traj_ref_file, "kappa": kappa, "theta": theta, "prec_period": prec_period})

    return params


def probeMotionFile(filename: Union[str, Path], output_filename: Union[str, Path], params: dotdict):
    success = True

    try:
        tree = ET.parse(str(filename.as_posix()))
        root = tree.getroot()

        MotionElementListNode = root.find("Motion_Element_List")
        MotionElementNode = MotionElementListNode.find("Motion_Element")

        svField = MotionElementNode.find("SV_File_Reference")
        svField.text = path_to_str(params.sv_filename)

        kappaField = MotionElementNode.find("Kappa0")
        kappaField.text = str(params.kappa)

        thetaField = MotionElementNode.find("Precession_Cone_Angle")
        thetaField.text = str(params.theta)

        periodField = MotionElementNode.find("Precession_Period")
        periodField.text = str(params.prec_period)

        sdofField = MotionElementNode.find("Flag_Doing_6DOF_Motion")
        # we dont want to do 6dof quite yet, maybe in the future installments
        sdofField.text = "0"

        xml_str = minidom.parseString(ET.tostring(root)).toprettyxml(indent="    ")
        xml_str_new = '\n'.join([line for line in xml_str.split('\n') if line.strip()])

        with open(output_filename, "w") as file:
            file.write(xml_str_new)

        file.close()

    except Exception as e:
        print("Error exporting motion file, ", output_filename, " : ", e)
        success = False

    return success


def probeMasterSimConfigFileMono(filename: Union[str, Path], output_filename: Union[str, Path], params: dotdict):
    success = True

    try:
        tree = ET.parse(str(filename.as_posix()))
        root = tree.getroot()

        paramsNode = root.find("params")
        trajFileNode = paramsNode.find("trajectory_file")
        trajFileNode.text = path_to_str(params.traj_filename)

        mot_node = paramsNode.find("motion_file")
        mot_node.text = path_to_str(params.motion_filename)

        output_node = paramsNode.find("output_path")
        output_node.text = path_to_str(params.output_path)

        model_node = paramsNode.find("model_file")
        model_node.text = path_to_str(params.model_filename)

        xmit_lat_node = paramsNode.find("sensor_latitude_xmit")
        xmit_lat_node.text = str(params.sensor_lat)

        xmit_lon_node = paramsNode.find("sensor_longitude_xmit")
        xmit_lon_node.text = str(params.sensor_lon)

        xmit_height_node = paramsNode.find("sensor_height_xmit")
        xmit_height_node.text = str(params.sensor_height)

        # doing monostatic for now
        """
        rec_lat_node = paramsNode.find("sensor_latitude_rcv")
        rec_lat_node.text = str(params.sensor_lat)

        rec_lon_node = paramsNode.find("sensor_longitude_rcv")
        rec_lon_node.text = str(params.sensor_lon)

        rec_height_node = paramsNode.find("sensor_height_rcv")
        rec_height_node.text = str(params.sensor_height)
        """
        start_time_node = paramsNode.find("process_start_time")
        start_time_node.text = str(params.start_time)

        stop_time_node = paramsNode.find("process_stop_time")
        stop_time_node.text = str(params.stop_time)

        step_time_node = paramsNode.find("process_step_time")
        step_time_node.text = str(params.step_time)

        pattern_node = paramsNode.find("wb_pattern_file")
        pattern_node.text = path_to_str(params.pattern_filename)

        # set the noise level
        loop_gain_node = paramsNode.find("rflg")
        loop_gain_node.text = str(params.rflg)

        # set the control flags
        do_sigsim_node = paramsNode.find("flag_do_sigsim")
        do_sigsim_node.text = "1"

        sim_type_node = paramsNode.find("sigsim_type")
        # do a monostatic run
        sim_type_node.text = "0"

        do_bistatic_view_node = paramsNode.find("flag_do_bistatic_view")
        do_bistatic_view_node.text = "0"

        # make sure output type is hwb
        output_sig_node = paramsNode.find("output_file_type")
        output_sig_node.text = "0"

        # frequency node
        freq_node = paramsNode.find("ref_freq")
        freq_node.text = str(params.ref_freq)

        orientNode = root.find("orient")
        doFlag = orientNode.find("flag_do_estimation")
        doFlag.text = "0"

        """
        sensorNode = root.find("sensor")
        waveformNode = sensorNode.find("waveform")
        freqMinNode = waveformNode.find("frequency_center_min")
        freqMaxNode = waveformNode.find("frequency_center_max")
        #freqNumNode = waveformNode.find("number_of_frequencies")

        freqMinNode.text = str(params.ref_freq - params.bwd/2)
        freqMaxNode.text = str(params.ref_freq + params.bwd/2)
        #freqNumNode.text = str(params.freq_steps)
        #autoFreqNode = waveformNode.find("frequency_center_auto")
        #autoFreqNode.text = "0"
        """

        temp = orientNode.find("orient_list")
        if temp is not None:
            orientNode.remove(temp)

        xml_str = minidom.parseString(ET.tostring(root)).toprettyxml(indent="    ")
        xml_str_new = '\n'.join([line for line in xml_str.split('\n') if line.strip()])

        with open(output_filename, "w") as file:
            file.write(xml_str_new)

        file.close()

    except Exception as e:
        print("Error exporting mastersime config: ", output_filename, " : ", e)
        success = False

    return success
