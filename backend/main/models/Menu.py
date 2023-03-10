from .. import db
from datetime import datetime

class Menu(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)
    # title = db.Column(db.String(100), nullable=False)
    sale_detail = db.relationship('SaleDetail', back_populates = "menu") # Un menu corresponde a muchos detalles de venta


    def __repr__(self):
        return '<Menu: %r %r >' % (self.title, self.content, self.user_id)

    def to_json(self):
        poem_json = {
            'id': self.id,
            'name': str(self.name),
            'description': str(self.description),
            'price': self.price
        }
        return poem_json
    
    def to_json_short(self):
        poem_json = {
            'name': str(self.name),
            'description': str(self.description),
            'price': self.price
        }
        return poem_json

    def to_json_onlyname(self):
        poem_json = {
            'name': str(self.name),
        }
        return poem_json

    @staticmethod
    def from_json(poem_json):
        id = poem_json.get('id')
        name = poem_json.get('name')
        description = poem_json.get('description')
        price = poem_json.get('price')
        return Menu(id=id,
                name=name,
                description=description,
                price = price
                )