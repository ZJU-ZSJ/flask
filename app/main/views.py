# -*- coding=utf-8 -*-
from datetime import datetime
from flask import render_template, redirect,request, url_for, flash,Response,session
from .forms import AddRecordForm,CommentForm
from ..models import Record,Article,Comment,Category
from . import main
from .. import db,mail
from flask_mail import Mail, Message


@main.route('/')
def index():
    a = Article.query.order_by(Article.create_time.desc()).all()
    c = Category.query.all()
    return render_template('main/index.html', list=a,category = c)

@main.route('/category')
def category():
    a = Article.query.order_by(Article.create_time.desc()).filter_by(category_id=request.args.get('id')).all()
    c = Category.query.all()
    return render_template('main/index.html', list=a,category = c)

@main.route('/read/', methods=['GET', 'POST'])
def read():
    a = Article.query.filter_by(id=request.args.get('id')).first()
    form = CommentForm()
    session['article_id'] = request.args.get('id')

    if form.validate_on_submit():
        comment = Comment(body = form.body.data,email = form.email.data,name = form.name.data,articles = a)
        db.session.add(comment)
        flash(u'评论添加成功')
        msg = Message(u"有人评论了你的文章：{0}".format(a.title), recipients=['616626829@qq.com'])
        msg.html = "<body style=\"background-color:blue\">"\
                    u"<h1>有人评论了你的文章：</h1>" \
                   u"<p>用户：{0}</p>" \
                   u"<p>邮箱:{1}</p>" \
                   u"<p>内容：{2}</p>" \
                   u"</body>".format(form.name.data,form.email.data,form.body.data)

        mail.send(msg)
        return redirect(url_for('main.read',id = a.id))


    if a is not None:
        return render_template('main/read.html', a=a,form = form,comments = a.comments)
    return redirect(url_for('main.index'))

@main.route('/comment', methods=['GET', 'POST'])
def comment():
    form = AddRecordForm()
    if form.validate_on_submit():
        record = Record(comment = form.comment.data,create_time=datetime.now())
        i = 1
        while(i):
            try:
                db.session.add(record)
                db.session.commit()
                flash(u'评论提交成功')
                i = 0
                return redirect(url_for('main.comment'))
            except:
                db.session.rollback()
    return render_template('main/comment.html', form=form)

@main.route('/google04e9c053081c788b.html')
def google():
    return render_template('main/google04e9c053081c788b.html')

@main.route('/bdunion.txt')
def baidu():
    return render_template('main/baidu.html')

@main.route('/jd_root.txt')
def jd():
    return render_template('main/jd.html')


@main.route('/baidu_verify_cnZpq5XNeG.html')
def baidushoulu():
    return render_template('main/baidu_verify_cnZpq5XNeG.html')

@main.route('/sendmail')
def send_mail():
    msg = Message("EmailTest", recipients=['616626829@qq.com'])
    msg.body = "Hello World! This  Email from Web"
    mail.send(msg)
    return '<h3>Sended  email to U! ^^</h3>'


