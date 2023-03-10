from flask import request, jsonify, Blueprint, send_file
import os
from io import BytesIO
import qrcode
import random
import string
from base64 import encodebytes

#Blueprint para acceder a los métodos de autenticación
login_blueprint = Blueprint('login', __name__, url_prefix='/login')

#Método de logueo
@login_blueprint.route('/<randomID>', methods=['GET', 'POST'])
def login(randomID):
    if request.method == 'POST':
        filePATH = "/tmp/" + randomID + ".txt"
        with open (filePATH, "w") as tokenfile:
            data = request.get_json()
            tokenfile.write(str(data['token']))
        return (data)
    if request.method == 'GET':
        filePATH = "/tmp/" + randomID + ".txt"
        if os.path.isfile(filePATH):
            print('El archivo existe.')
            with open (filePATH, "r") as tokenfile:
                data = tokenfile.read()
            os.remove(filePATH)
            return ({"tokenID": data})
        else:
            return ({"tokenID": None})

@login_blueprint.route('/qrcode', methods=['GET'])
def qr_generate():
    buffer = BytesIO()
    data = str(get_random_string(16))

    img = qrcode.make(data)
    img.save(buffer)
    buffer.seek(0)
    send_file(buffer, mimetype='image/png')
    encoded_img = encodebytes(buffer.getvalue()).decode('ascii')
    response =  { 'status' : 'Success', 'randomID': data , 'imageBytes': encoded_img}
    return response


def get_random_string(length):
    # choose from all lowercase letter
    letters = string.ascii_letters
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str
    