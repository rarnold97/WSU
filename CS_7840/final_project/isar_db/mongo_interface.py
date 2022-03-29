from pymongo import MongoClient
from isar_db.isar_db_model import SignatureRecord, CompImageRecord
import os
from pprint import pprint
from bson.objectid import ObjectId
from typing import Union

mongo_port = os.environ.get('MONGO_PORT')
mongo_port = 27017 if mongo_port is None else mongo_port

mongo_url = os.environ.get("MONGO_URL")
mongo_url = "mongodb://localhost"+mongo_port+"/" if mongo_url is None else mongo_url


class isar_db:
    # going to connect to the standard default mongo client
    client = MongoClient("mongodb://localhost:27017/")
    db = client["isar_ml_data"]

    def __init__(self):

        # initialize the two primary database collections
        self.signature_col = self.db["signature_records"]
        self.img_data_col = self.db["comp_img_data"]

    def insert_sig_record(self, record: SignatureRecord):
        entry = self.signature_col.insert_one(record.get_dict())

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
             "model_type": None}
    def query_sig_records(self, ):
