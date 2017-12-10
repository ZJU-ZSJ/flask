# -*- coding=utf-8 -*-
from app import create_app, db
from flask_script import Manager, Shell
from app.models import User
from flask_bootstrap import Bootstrap
from flask_moment import Moment
from flask_migrate import Migrate, MigrateCommand
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.schedulers.blocking import BlockingScheduler
from app.admin.views import flushprice
from flask_apscheduler import APScheduler


app = create_app('default')
manager = Manager(app)
bootstrap = Bootstrap(app)
moment = Moment(app)
migrate = Migrate(app, db)






manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()