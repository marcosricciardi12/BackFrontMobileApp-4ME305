from flask_restful import Resource
from flask import request, jsonify
from .. import db
from main.models import MenuModel

from sqlalchemy import func
from flask_jwt_extended import jwt_required, get_jwt_identity, get_jwt

#Recurso usuario
class Menu(Resource):
    

    def get(self, id):
        menu = db.session.query(MenuModel).get_or_404(id)
        return menu.to_json()


class Menus(Resource):

    def get(self):
        page = 1
        per_page = 15
        menus = db.session.query(MenuModel)

        menus = menus.paginate(page = page, per_page = per_page, error_out=True, max_per_page=20) #Ahora no es una lista de lementos, es una paginacion
        return jsonify({"menus":[user.to_json() for user in menus.items],
                        'total': menus.total, 
                        'pages': menus.pages, 
                        'page': page})
  
    def post(self):
        menu = MenuModel.from_json(request.get_json())
        db.session.add(menu)
        db.session.commit()
        return menu.to_json(), 201