from mailbox import Mailbox
import os
from flask import Flask, request, redirect, jsonify
from dotenv import load_dotenv
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_cors import CORS

db = SQLAlchemy()
jwt = JWTManager()

api = Api()

def create_app():
	app = Flask(__name__)
	CORS(app)
	load_dotenv()

	app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
	MYSQL_ROUTE = ('mysql+pymysql://' + str(os.getenv('DATABASE_USERNAME')) + ':' + str(os.getenv('DATABASE_PASSWORD')) + 
                                            '@' + str(os.getenv('DATABASE_ADDRESS')) + '/' + str(os.getenv('DATABASE_NAME')))
	app.config['SQLALCHEMY_DATABASE_URI'] = MYSQL_ROUTE
	db.init_app(app)
	import main.resources as resources
	api.add_resource(resources.MenusResource, '/menus')
	api.add_resource(resources.MenuResource, '/menu/<id>')
	api.add_resource(resources.UsersResource, '/users')
	api.add_resource(resources.UserResource, '/user/<id>')
	api.init_app(app)
	app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY')
	app.config['JWT_ACCESS_TOKEN_EXPIRES'] = int(os.getenv('JWT_ACCESS_TOKEN_EXPIRES'))
	jwt.init_app(app)
	
	from main.login import routes
	app.register_blueprint(routes.login_blueprint)
	from main.auth import routes
	app.register_blueprint(routes.auth)
	from main.newsale import routes
	app.register_blueprint(routes.newsale_blueprint)


	return app
