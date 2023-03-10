from flask_restful import Resource
from flask import request, jsonify
from .. import db
from main.models import UserModel
from sqlalchemy import func
from flask_jwt_extended import jwt_required, get_jwt_identity, get_jwt
from main.auth.decorators import admin_required

#Recurso usuario
class User(Resource):
    
    #obtener recurso
    def get(self, id):
        user = db.session.query(UserModel).get_or_404(id)
        return user.to_json()

    #eliminar recurso
    # @admin_required
    def delete(self, id):
        user = db.session.query(UserModel).get_or_404(id)
        db.session.delete(user)
        db.session.commit()
        return 'User deleted', 204
    
    #modificar recurso
    @jwt_required()
    def put(self, id):
        user = db.session.query(UserModel).get_or_404(id)
        data = request.get_json().items()
        token_id = get_jwt_identity()
        if token_id == user.id:
            for key,value in data:
                if str(key) == 'password':
                    hash = user.change_pass(value)
                    setattr(user,key,hash)
                else:
                    setattr(user,key,value)
            db.session.add(user)
            db.session.commit()
            return user.to_json(), 201
        else:
            return 'Not allowed, only owner or admin can modify', 403

class Users(Resource):

    def post(self):
        user = UserModel.from_json(request.get_json())
        db.session.add(user)
        db.session.commit()
        return user.to_json(), 201