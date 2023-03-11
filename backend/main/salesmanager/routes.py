from flask import request, jsonify, Blueprint, send_file
from flask_jwt_extended import jwt_required, get_jwt_identity, get_jwt

from .. import db
from main.models import UserModel
from main.models import MenuModel
from main.models import SaleModel
from main.models import SaleDetailModel
# from main.mail.functions import sendmail


#Blueprint para acceder a los métodos de autenticación
newsale_blueprint = Blueprint('newsale', __name__, url_prefix='/salesmanager')

#Método de logueo


@newsale_blueprint.route('/newsale', methods=['POST'])
@jwt_required()
def newsale():
    if request.method == 'POST':
        buyer_user_id = get_jwt_identity()
        user = db.session.query(UserModel).get_or_404(buyer_user_id)
        data = request.get_json()
        newsale = SaleModel(user_id = buyer_user_id)
        db.session.add(newsale)
        db.session.commit()
        db.session.refresh(newsale)
        totalPrice = 0
        for element in data:
            priceMenu = db.session.query(MenuModel).get_or_404(element['menu_id']).price
            detailPrice = priceMenu * float(element['cant'])
            totalPrice = totalPrice + detailPrice
            newDetailSale = SaleDetailModel(sale_id = newsale.id, menu_id = element['menu_id'], 
                                            price_detail = detailPrice, cant = element['cant'])
            db.session.add(newDetailSale)
            db.session.commit()

        setattr(newsale, "price", totalPrice)
        db.session.add(newsale)
        db.session.commit()
        return (newsale.to_json())

@newsale_blueprint.route('/userpurchases', methods=['GET'])
@jwt_required()
def getpurchases():
    if request.method == 'GET':
        page = 1
        per_page = 20
        buyer_user_id = get_jwt_identity()
        purchases = db.session.query(SaleModel)
        
        purchases = purchases.filter(SaleModel.user).filter(UserModel.id.like(str(buyer_user_id))) #funciona

        purchases = purchases.paginate(page = page, per_page = per_page, error_out=True, max_per_page=20)
        return jsonify({"purchases":[purchase.to_json_short() for purchase in purchases.items],
                        'total': purchases.total, 
                        'pages': purchases.pages, 
                        'page': page})
