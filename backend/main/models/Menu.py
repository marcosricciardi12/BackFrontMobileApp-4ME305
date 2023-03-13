from .. import db
from datetime import datetime

class Menu(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)
    imageURL = db.Column(db.String(1024), nullable=False)
    # title = db.Column(db.String(100), nullable=False)
    sale_detail = db.relationship('SaleDetail', back_populates = "menu") # Un menu corresponde a muchos detalles de venta


    def __repr__(self):
        return '<Menu: %r %r >' % (self.title, self.content, self.user_id)

    def to_json(self):
        menu_json = {
            'id': self.id,
            'name': str(self.name),
            'description': str(self.description),
            'price': self.price,
            'imageURL': self.imageURL,
        }
        return menu_json
    
    def to_json_short(self):
        menu_json = {
            'name': str(self.name),
            'description': str(self.description),
            'price': self.price
        }
        return menu_json

    def to_json_onlyname(self):
        menu_json = {
            'name': str(self.name),
        }
        return menu_json

    @staticmethod
    def from_json(menu_json):
        id = menu_json.get('id')
        name = menu_json.get('name')
        description = menu_json.get('description')
        price = menu_json.get('price')
        imageURL = menu_json.get('imageURL')
        return Menu(id=id,
                name=name,
                description=description,
                price = price,
                imageURL = imageURL
                )