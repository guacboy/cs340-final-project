from flask import Flask, render_template, json, redirect, send_from_directory
from flask_mysqldb import MySQL
from flask import request
import os

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_[your_onid]'
app.config['MYSQL_PASSWORD'] = '[your_db_password]'
app.config['MYSQL_DB'] = 'cs340_[your_onid]'
app.config['MYSQL_CURSORCLASS'] = "DictCursor"
app.config['MYSQL_AUTOCOMMIT'] = True

mysql = MySQL(app)


# Set up paths to frontend build
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
FRONTEND_DIST = os.path.join(BASE_DIR, '../frontend/dist')

app = Flask(__name__)

# Serve static files
@app.route('/assets/<path:filename>')
def serve_static(filename):
    return send_from_directory(os.path.join(FRONTEND_DIST, 'assets'), filename)

# Serve Vue application
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_vue_app(path):
    return send_from_directory(FRONTEND_DIST, 'index.html')


# Listener
if __name__ == "__main__":
    app.run(port=5173, debug=True)