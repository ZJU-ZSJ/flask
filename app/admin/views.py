# -*- coding=utf-8 -*-
from datetime import datetime

from flask import render_template, redirect, url_for, flash
from flask_login import login_required, login_user, logout_user

from app.admin.forms import LogForm, RegistrationForm
from app.admin import admin
from app import db
from app.models import User, Record


@admin.route('/', methods=['GET', 'POST'])
def index():
	return render_template('admin/index.html',  current_time=datetime.utcnow())

@admin.route('/login', methods=['GET', 'POST'])
def login():
    form = LogForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is not None and user.verify_password(form.password.data):
            login_user(user)
            return redirect(url_for('admin.welcome'))
        flash(u'用户密码不正确')

    return render_template('admin/login.html', form=form,current_time=datetime.utcnow())

@admin.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
            if form.password.data != form.password2.data:
                flash(u'两次输入密码不一')
                return redirect(url_for('admin.register'))
            else:
                try:
                    user = User(username=form.username.data, password=form.password.data)
                    print(user.password_hash)
                    print(user.username)
                    db.session.add(user)
                    print('done')
                    print('done')
                    flash(u'您已经成功注册')
                    return redirect(url_for('admin.login'))
                except:
                    db.session.rollback()
                    flash(u'用户名已存在')
    return render_template('admin/register.html', form=form,current_time=datetime.utcnow())

@admin.route('/welcome')
@login_required
def welcome():
    return render_template('admin/welcome.html',current_time=datetime.utcnow())

@admin.route('/logout')
@login_required
def logout():
    logout_user()
    flash(u'您已经登出了系统')
    return redirect(url_for('main.index'))

@admin.route('/record', methods=['GET', 'POST'])
@login_required
def record():
    results = db.session.query(Record).order_by(-Record.id)
    return render_template('admin/record.html', results=results,current_time=datetime.utcnow())