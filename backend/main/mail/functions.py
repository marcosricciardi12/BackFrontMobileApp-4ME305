from email import message
from unittest import result
from .. import mailsender
from flask import render_template, current_app
from flask_mail import Message
from smtplib import SMTPException

def sendmail(to, subject, template, **kwargs):
    msg = Message(subject, sender = current_app.config['FLASKY_MAIL_SENDER'], recipients = to)
    try:
        msg.body = render_template(template + '.txt', **kwargs)
        response = mailsender.send(msg) #enviar
    except SMTPException as e:
        print(e)
        return 'Mail Delivery Fail'
    return True