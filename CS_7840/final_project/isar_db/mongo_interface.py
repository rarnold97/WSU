from pymongo import MongoClient
from isar_db.isar_db_model import SignatureRecord, CompImageRecord
import os
from pprint import pprint
from bson.objectid import ObjectId
from typing import Union

mongo_port = os.environ.get('MONGO_PORT')
mongo_port = 27017 if mongo_port is None else mongo_port

mongo_url = os.environ.get("MONGO_URL")
mongo_url = "mongodb://localhost:"+mongo_port+"/" if mongo_url is None else mongo_url


class isar_db:
    # going to connect to the standard default mongo client
    client = MongoClient(mongo_url,
                         username="ryanm",
                         password="1997")
    db = client["isar_ml_data"]

    def __init__(self):

        # initialize the two primary database collections
        self.signature_col = self.db["signature_records"]
        self.img_data_col = self.db["comp_img_data"]

    def insert_sig_record(self, record: SignatureRecord):
        entry = self.signature_col.insert_one(record.get_dict())
        return entry

    def insert_isar_record(self, record: CompImageRecord):
        entry = self.img_data_col.insert_one(record.get_dict())
        return entry

    def del_sig_from_id(self, sig_id: Union[str, int]):
        self.signature_col.delete_one({"_id": ObjectId(sig_id)})

    def get_all_sig_record_ids(self):
        cursor = self.signature_col.find({})
        return [doc['_id'] for doc in cursor]

    def get_all_img_record_ids(self):
        cursor = self.img_data_col.find({})
        return [doc['_id'] for doc in cursor]

    @staticmethod
    def get_sig_query_template():
        q = {"hwb": None,
             "model_file": None,
             "model_type": None,
             "kappa": None,
             "theta": None,
             "prec_period": None}

    def query_sig_records(self, hwb_filename=None, model_filename=None, motion_filename=None):

        q =[]
        if hwb_filename is not None:
            q.append({"hwb_filename": hwb_filename})

        if model_filename is not None:
            q.append({"model_file": model_filename})

        if motion_filename is not None:
            q.append({"motion_filename": motion_filename})

        if q:
            if len(q) == 1:
                doc = self.signature_col.find(q[0])
            else:
                doc = self.signature_col.find({"$and": q})

        return doc

    def query_isar_records(self, par_id=None, kappa=None, theta=None):
        q = []

        if par_id is not None:
            q.append({"parent_doc_id": par_id})

        if kappa is not None:
            q.append({"kappa_label": kappa})

        if theta is not None:
            q.append({"theta_label": theta})

        if q:
            if len(q) == 1:
                doc = self.img_data_col.find(q[0])
            else:
                doc = self.img_data_col.find({"$and": q})

        return doc


if __name__ =="__main__":
    mongodb = isar_db()
    hwb_filename = "G:/WSU/CS_7840/final_project/input_cfgs/seed/loc0_time1.hwb"
    kappa = 90
    theta = 90
    mtx_filename = "G:/WSU/CS_7840/final_project/input_cfgs/seed/satSim.mtx"

    for db in mongodb.client.list_databases():
        print(db)

    sig_rec = SignatureRecord()
    sig_rec.model_file = mtx_filename
    sig_rec.kappa = kappa
    sig_rec.theta = theta
    sig_rec.SNR = 330
    sig_rec.hwb_filename = hwb_filename
    sig_rec.prec_period = 47.0

    mongodb.insert_sig_record(sig_rec)