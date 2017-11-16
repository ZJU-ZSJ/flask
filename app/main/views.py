# -*- coding=utf-8 -*-
from datetime import datetime
from flask import render_template, redirect,request, url_for, flash,Response
from .forms import AddRecordForm,CommentForm
from ..models import Record,Article,Comment,Category
from . import main
from .. import db


@main.route('/')
def index():
    a = Article.query.order_by(Article.create_time.desc()).all()
    return render_template('main/index.html', list=a)

@main.route('/read/', methods=['GET', 'POST'])
def read():
    a = Article.query.filter_by(id=request.args.get('id')).first()
    form = CommentForm()

    if form.validate_on_submit():
        comment = Comment(body = form.body.data,email = form.email.data,name = form.name.data,articles = a)
        db.session.add(comment)
        flash(u'评论添加成功')
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
