from libISAR.rdi import dotdict, RDI
import numpy as np
from typing import List
import pandas as pd
from pathlib import Path

from enum import Enum

class AngleID(Enum):
    KAPPA = 1
    THETA = 2
    SPIN = 3
    BETA = 4


def mapModelstoPatterns():
    curr_path = Path(__file__).parent.absolute()
    pattern_map_csv = curr_path.parent.absolute() / "pattern_map.csv"

    if not pattern_map_csv.is_file():
        raise FileNotFoundError("Cannot Locate static pattern shape mapping, exiting")

    df = pd.read_csv(pattern_map_csv, skiprows=1, names=['shape_id', 'pattern', 'model'])

    #index the 1 element because iterrows is an enumerate pattern (index, value)
    map = [dotdict({"shape_id": row[1].shape_id, "pattern": row[1].pattern , "model": row[1].model}) for row in df.iterrows()]
    return map


def genAngleSweep(startAngle: float, stopAngle: float, nSteps: int, angleType: AngleID)->dotdict:
    angleSpan = np.linspace(startAngle, stopAngle, nSteps)
    return dotdict({"id": angleType, "span": angleSpan})


def CreateAngleLevels(useKappa=True, useTheta=True, useBeta=False, useSpin=False)->List[dotdict]:

    levels = []

    if useKappa:
        levels.append(genAngleSweep(0, 90, 19, AngleID.KAPPA))

    if useTheta:
        levels.append(genAngleSweep(0, 90, 19, AngleID.THETA))

    if useSpin:
        levels.append(genAngleSweep(0, RDI.period, 11, AngleID.SPIN))

    if useBeta:
        levels.append(genAngleSweep(0, 180, 19, AngleID.BETA))

    return levels

## For threading
class AngleNest:

    def __init__(self, angleLevels, shape_id: str, snr_vals=(0, 30)):

        self.id = shape_id

        self.angleLevels = angleLevels

        self.snr_vals = snr_vals

        self.miniBatches = []

        self.__snr_bookeep = 0

        angValues = {}
        self._iter_levels(self.angleLevels.copy(), angValues)

    def _iter_levels(self, angleLevels, values: dict):

        thisValues = values.copy()
        thisAngleLevels = angleLevels.copy()

        if len(thisAngleLevels) == 0:
            # hopefully we are at the bottom of the recursive hole by now
            self.miniBatches.append(dotdict(thisValues))
        else:
            currLevel = thisAngleLevels.pop()
            # recurse
            for ang in currLevel.span:
                thisValues[currLevel.id] = ang
                self._iter_levels(thisAngleLevels, thisValues)


    def createBatches(self):
        return dotdict({"shape": self.id, "snr": [snr for snr in self.snr_vals], "mini_batches": self.miniBatches.copy()})



if __name__ == "__main__":

    levels = CreateAngleLevels()

    SNR = (0, 20)

    nest = AngleNest(levels, "Conic", SNR)
    thisShapeBatch = nest.createBatches()
    print('debug')
