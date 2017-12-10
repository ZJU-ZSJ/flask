# -*- coding=utf-8 -*-
from datetime import datetime

from flask import render_template, redirect, url_for, flash,request,session
from flask_login import login_required, login_user, logout_user,current_user
from app.admin.forms import EditC5gameForm,C5gameForm,PostCategoryForm,PostArticleForm,LogForm, RegistrationForm,ModifyForm,EditRecordForm,EditArticleForm,EditCategoryForm
from app.admin import admin
from app import db,mail
from app.models import User, Record, Article,Category,Comment,C5game
import requests
import json
import re
from flask_mail import Mail, Message


def get_price(id):
    headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/62.0.3202.89 Chrome/62.0.3202.89 Safari/537.36",
        "X-Requested-With": "XMLHttpRequest"}
    resp = requests.get(
        "https://www.c5game.com/api/product/sale.json?id="+id+"&quick=&gem_id=0&page=1&flag=&callback=jQuery",
        headers=headers)
    # print resp.text
    temp = re.findall('\"price\":(.*?)\,', resp.text)
    return temp[0]

def flushprice():
    print "flush success"
    c5list = db.session.query(C5game).all()
    print "c5"
    for item in c5list:
        if(item.verify == True):
            price = get_price(str(item.id))
            print u"成功得到价格"
            item.price = price
            if (float(price) < float(item.min)):
                send_mail(item.name, item.price, item.min, item.address)
                item.verify = False

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
    register_key = 'zhucema'
    form = RegistrationForm()
    if form.validate_on_submit():
        if form.registerkey.data != register_key:
            flash(u'注册码不符，请返回重试')
            return redirect(url_for('admin.register'))
        else:
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
    return redirect(url_for('main.index'))

@admin.route('/record', methods=['GET', 'POST'])
@login_required
def record():
    results = db.session.query(Record).order_by(-Record.id)
    form = ModifyForm()
    if form.validate_on_submit():
        return redirect(url_for('admin.modify', id=form.id.data))
    return render_template('admin/record.html', form=form,results=results,current_time=datetime.now())

@admin.route('/article', methods=['GET', 'POST'])
@login_required
def article():
    form = PostArticleForm()
    alist = Article.query.order_by(Article.create_time.desc()).all()
    if form.validate_on_submit():
        acticle = Article(title=form.title.data, body=form.body.data, category_id=str(form.category_id.data.id),
                          user_id=current_user.id,create_time=datetime.now())
        db.session.add(acticle)
        flash(u'文章添加成功')
        acticle1 = db.session.query(Article).filter(Article.title == form.title.data).one()
        return redirect(url_for('main.read',id=acticle1.id))
    return render_template('admin/article.html', form=form,list=alist)

@admin.route('/article/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def article_edit(id):
    ar = db.session.query(Article).filter(Article.id == id).one()
    form = EditArticleForm(title=ar.title,body=ar.body,category_id=ar.category_id)
    if form.validate_on_submit():
        if form.delete.data == u"确认删除":
            dar = Article.query.get_or_404(id)
            try:
                db.session.delete(dar)
                db.session.commit()
                return redirect(url_for('admin.article'))
            except:
                flash(u'删除失败，请联系管理员。')
                return redirect(url_for('admin.article_edit', id=id))
        elif form.delete.data == "":
            dar = Article.query.get_or_404(id)
            dar.title = form.title.data
            dar.body = form.body.data
            dar.category_id=str(form.category_id.data.id)
            try:
                db.session.add(dar)
                db.session.commit()
                return redirect(url_for('admin.article'))
            except:
                flash(u'提交失败')
                return redirect(url_for('admin.article_edit', id=id))
        else:
            flash(u'删除栏输入有误，请重新输入')
            return redirect(url_for('admin.article_edit', id=id))
    return render_template("admin/article_edit.html", form=form, id=ar.id)

@admin.route('/category', methods=['GET', 'POST'])
def category():
    clist = Category.query.all()
    form = PostCategoryForm()
    if form.validate_on_submit():
        category = Category(name=form.name.data)
        db.session.add(category)
        flash(u'分类添加成功')
        return redirect(url_for('admin.category'))
    return render_template('admin/category.html', form=form, list=clist)

@admin.route('/comment_del/<int:id>', methods=['GET', 'POST'])
@login_required
def comment_del(id):
    comment = db.session.query(Comment).filter(Comment.id == id).one()
    try:
        db.session.delete(comment)
        db.session.commit()
    except:
        flash(u'删除失败，请联系管理员。')
    return redirect(url_for('main.read', id=session['article_id']))

@admin.route('/category/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def category_edit(id):
    ca = db.session.query(Category).filter(Category.id == id).one()
    form = EditCategoryForm(name=ca.name)
    if form.validate_on_submit():
        if form.delete.data == u"确认删除":
            dca = Category.query.get_or_404(id)
            try:
                db.session.delete(dca)
                db.session.commit()
                return redirect(url_for('admin.category'))
            except:
                flash(u'删除失败，请联系管理员。')
                return redirect(url_for('admin.category_edit', id=id))
        elif form.delete.data == "":
            dca = Category.query.get_or_404(id)
            dca.name = form.name.data
            try:
                db.session.add(dca)
                db.session.commit()
                return redirect(url_for('admin.category'))
            except:
                flash(u'提交失败')
                return redirect(url_for('admin.category_edit', id=id))
        else:
            flash(u'删除栏输入有误，请重新输入')
            return redirect(url_for('admin.category_edit', id=id))
    return render_template("admin/category_edit.html", form=form, id=ca.id)

@admin.route('/modify/<int:id>', methods=['GET', 'POST'])
@login_required
def modify(id):
    re = db.session.query(Record).filter(Record.id == id).one()
    form = EditRecordForm(comment=re.comment,verify=re.verify)
    if form.validate_on_submit():
        if form.delete.data == u"确认删除":
            cord = Record.query.get_or_404(id)
            try:
                db.session.delete(cord)
                db.session.commit()
                return redirect(url_for('admin.record'))
            except:
                flash(u'删除失败，请联系管理员。')
                return redirect(url_for('admin.modify', id=id))
        elif form.delete.data == "":
            cord = Record.query.get_or_404(id)
            cord.comment = form.comment.data
            if form.verify.data:
                cord.verify = True
            else:
                cord.verify = False
            try:
                db.session.add(cord)
                db.session.commit()
                return redirect(url_for('admin.record'))
            except:
                flash(u'提交失败')
                return redirect(url_for('admin.modify', id=id))
        else:
            flash(u'删除栏输入有误，请重新输入')
            return redirect(url_for('admin.modify', id=id))
    return render_template("admin/modify.html", form=form, id=re.id)

@admin.route('/c5game', methods=['GET', 'POST'])
@login_required
def c5game():
    print 1
    c5list = db.session.query(C5game).all()
    flushprice()
    form = C5gameForm()
    if form.validate_on_submit():
        c5game = C5game(id = form.id.data,name = form.name.data,min = form.min.data,price = form.price.data,address = form.address.data)
        db.session.add(c5game)
        flash(u'添加成功')
        return redirect(url_for('admin.c5game'))
    return render_template('admin/c5game.html', form=form, list=c5list)

@admin.route('/c5game/change/<int:id>', methods=['GET', 'POST'])
@login_required
def c5game_change(id):
    c5 = db.session.query(C5game).filter(C5game.id == id).one()
    form = EditC5gameForm(min=c5.min,verify = c5.verify)
    if form.validate_on_submit():
        if form.delete.data == u"确认删除":
            cord = C5game.query.get_or_404(id)
            try:
                db.session.delete(cord)
                db.session.commit()
                return redirect(url_for('admin.c5game'))
            except:
                flash(u'删除失败，请联系管理员。')
                return redirect(url_for('admin.c5game_change', id=id))
        elif form.delete.data == "":
            cord = C5game.query.get_or_404(id)
            cord.min = form.min.data
            if form.verify.data:
                cord.verify = True
            else:
                cord.verify = False
            try:
                db.session.add(cord)
                db.session.commit()
                return redirect(url_for('admin.c5game'))
            except:
                flash(u'提交失败')
                return redirect(url_for('admin.c5game_change', id=id))
        else:
            flash(u'删除栏输入有误，请重新输入')
            return redirect(url_for('admin.c5game_change', id=id))
    return render_template("admin/changec5.html", form=form, id=c5.id,info = c5)



def send_mail(name,price,min,address):
    msg = Message(u"有饰品低于您的价格区间了：{0}".format(name), recipients=['616626829@qq.com'])
    msg.html = u"<h1>有饰品低于您的价格区间了</h1>" \
               u"<p>名称：{0}</p>" \
               u"<p>当前价格:{1}</p>" \
               u"<p>预设价格：{2}</p>" \
               u"<a href{3}>前往购买</a>" .format(name,price,min,address)

    mail.send(msg)