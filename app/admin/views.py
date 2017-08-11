# -*- coding=utf-8 -*-
from datetime import datetime

from flask import render_template, redirect, url_for, flash,request
from flask_login import login_required, login_user, logout_user,current_user
from app.admin.forms import PostCategoryForm,PostArticleForm,LogForm, RegistrationForm,ModifyForm,EditRecordForm
from app.admin import admin
from app import db
from app.models import User, Record, Article,Category


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
    flash(u'您已经登出了系统')
    return redirect(url_for('main.index'))

@admin.route('/record', methods=['GET', 'POST'])
@login_required
def record():
    results = db.session.query(Record).order_by(-Record.id)
    form = ModifyForm()
    if form.validate_on_submit():
        return redirect(url_for('admin.modify', id=form.id.data))
    return render_template('admin/record.html', form=form,results=results,current_time=datetime.utcnow())

@admin.route('/article', methods=['GET', 'POST'])
@login_required
def article():
    form = PostArticleForm()
    alist = Article.query.all()
    if form.validate_on_submit():
        acticle = Article(title=form.title.data, body=form.body.data, category_id=str(form.category_id.data.id),
                          user_id=current_user.id)
        db.session.add(acticle)
        flash(u'文章添加成功')
        redirect(url_for('main.index'))
    return render_template('admin/article.html', form=form, list=alist)

@admin.route('/article/del', methods=['GET'])
@login_required
def article_del():
    if request.args.get('id') is not None and request.args.get('a') == 'del':
        x = Article.query.filter_by(id=request.args.get('id')).first()
        if x is not None:
            db.session.delete(x)
            db.session.commit()
            flash(u'已经删除' + x.title)
            return redirect(url_for('admin.article'))
        flash(u'请检查输入')
        return redirect(url_for('admin.article'))

@admin.route('/category', methods=['GET', 'POST'])
def category():
    clist = Category.query.all()
    form = PostCategoryForm()
    if form.validate_on_submit():
        category = Category(name=form.name.data)
        db.session.add(category)
        flash(u'分类添加成功')
        return redirect(url_for('main.index'))
    return render_template('admin/category.html', form=form, list=clist)

@admin.route('/category/del', methods=['GET'])
@login_required
def category_del():
    if request.args.get('id') is not None and request.args.get('a') == 'del':
        x = Category.query.filter_by(id=request.args.get('id')).first()
        if x is not None:
            db.session.delete(x)
            db.session.commit()
            flash(u'已经删除' + x.name)
            return redirect(url_for('admin.category'))
        flash(u'请检查输入')
        return redirect(url_for('admin.category'))

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