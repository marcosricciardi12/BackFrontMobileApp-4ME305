from .. import db
from datetime import datetime

class SaleDetail(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sale_id = db.Column(db.Integer, db.ForeignKey('sale.id'), nullable=False)
    menu_id = db.Column(db.Integer, db.ForeignKey('menu.id'), nullable=False)
    price_detail = db.Column(db.Float, nullable=False)
    cant = db.Column(db.Integer, nullable=False)
    menu = db.relationship('Menu', back_populates = "sale_detail", uselist = False, single_parent = True) # Un DetalleVenta tiene un Menu
    sale = db.relationship('Sale', back_populates = "details", single_parent = True) # Un detalle venta corresponde a una venta


    def __repr__(self):
        return '<Detail: %r %r >' % (self.id, self.price_detail, self.menu_id, self.sale_id)

    def to_json(self):
        detail_json = {
            'id_detail': self.id,
            'sale_id': self.sale_id,
            'menu_id': self.menu_id,
            'cant': self.cant,
            'menu': self.menu.to_json_onlyname()['name'],
        }
        return detail_json

    def to_json_detailsale(self):
        detail_json = {
            #'id': self.id,
            'cant': self.cant,
            'price_detail': self.price_detail,
            'menu': self.menu.to_json_onlyname()['name'],
        }
        return detail_json