import logging
import os
from pathlib import Path


def get_isarml_logger():
    root_path = os.environ.get("ISAR_ML_ROOT")
    root_path = Path(root_path) if root_path is not None else Path("X:/isar_img_ml")

    log_path = root_path / "log" / "isarml_log.txt"

    logging.basicConfig(filename = str(log_path))

    logger = logging.getLogger(__name__)

    return logger