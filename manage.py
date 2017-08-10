# -*- coding=utf-8 -*-
from app import create_app, db
from flask.ext.script import Manager, Shell
from app.models import User
from flask_bootstrap import Bootstrap
from flask.ext.moment import Moment
from flask.ext.migrate import Migrate, MigrateCommand

app = create_app('default')
manager = Manager(app)
bootstrap = Bootstrap(app)
moment = Moment(app)
migrate = Migrate(app, db)

manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()