from .. import db
from datetime import datetime

class Sale(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    sale_date = db.Column(db.DateTime, nullable = False, default = datetime.now())
    price = db.Column(db.Float, nullable=True)
    user = db.relationship('User', back_populates = "purchases", uselist = False, single_parent = True) # Una Venta tiene un Usuario
    details = db.relationship('SaleDetail', back_populates = "sale", cascade = 'all, delete-orphan') # Una Venta tiene n detalleventa(SaleDetail)


    def __repr__(self):
        return '<Sale: %r %r >' % (self.user_id, self.price, self.sale_date)

    def to_json(self):
        details = [detail.to_json_detailsale() for detail in self.details]
        sale_json = {
            'id': self.id,
            'user': self.user.to_json_onlyname()['user'],
            'sale_date': self.sale_date.strftime("%Y-%m-%d  %H:%M:%S"),
            'total_price': self.price,
            'details': details
        }
        return sale_json
    
    def to_json_short(self):
        details = [detail.to_json_detailsale() for detail in self.details]
        sale_json = {
            'id': self.id,
            'sale_date': self.sale_date.strftime("%Y-%m-%d  %H:%M:%S"),
            'total_price': self.price,
            'details': details
        }
        return sale_json

