from flask import Flask, jsonify, request
from flask_cors import CORS

# from cassandra.cluster import Cluster, ExecutionProfile, EXEC_PROFILE_DEFAULT
# from cassandra.policies import DCAwareRoundRobinPolicy, TokenAwarePolicy
# from cassandra.auth import PlainTextAuthProvider

from card_api import *

app = Flask(__name__)
CORS(app, origins=["http://localhost:8080"])


# cluster = getCluster()
# session = cluster.connect('card') # connect to 'card' keyspace
cc = client_connector()

@app.route("/cards", methods=["GET"])
def get_flashcards():
    rows = cc.get_cards()
    return jsonify(rows), 200

if __name__ == "__main__":
    app.run(debug=True, port=5000)
