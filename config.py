# -*- coding=utf-8 -*-

'''
要注意的是，这里可以写入多个配置，就仿照DevelopmentConfig这个类一样，继承Config类即可。
并在最下方的Config字典里添加对应的key:value。
'''
def flushit():
    print "flush"


class Config:
    SECRET_KEY = 'zxcvbnm750612' #填入密钥
    SQLALCHEMY_COMMIT_ON_TEARDOWN = True
    SQLALCHEMY_TRACK_MODIFICATIONS = True

    MAIL_SERVER = 'smtp.zju.edu.cn'
    MAIL_PORT = 994
    MAIL_USE_SSL = True
    MAIL_USERNAME = '3160102448@zju.edu.cn'
    MAIL_PASSWORD = '11381X'
    MAIL_DEFAULT_SENDER = 'ZJU-ZSJ<3160102448@zju.edu.cn>'

    JOBS = [
        {
            'id': 'job1',
            'func': 'flushit',
            'trigger': 'interval',
            'seconds': 2
        }
    ]

    @staticmethod
    def init_app(app):
        '''
        _handler = RotatingFileHandler(
            'app.log', maxBytes=10000, backupCount=1)
        _handler.setLevel(logging.WARNING)
        app.logger.addHandler(_handler)
        '''
        pass
class DevelopmentConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'mysql://root:zxcvbnm750612@localhost/zsj?charset=utf8'
    #SQLALCHEMY链接数据库都是以URI方式格式为'mysql://账户名:密码@地址/数据库表名'



config = {
    'default': DevelopmentConfig
}