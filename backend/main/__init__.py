from mailbox import Mailbox
import os
from flask import Flask
from dotenv import load_dotenv
from flask_restful import Api
from flask_cors import CORS



api = Api()

def create_app():
	app = Flask(__name__)
	CORS(app)
	load_dotenv()
	api.init_app(app)
	
	from main.login import routes
	app.register_blueprint(routes.login_blueprint)


	return app
