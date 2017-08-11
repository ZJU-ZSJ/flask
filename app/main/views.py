# -*- coding=utf-8 -*-
from datetime import datetime
from flask import render_template, redirect,request, url_for, flash,Response
from .forms import AddRecordForm
from ..models import Record,Article
from . import main
from .. import db


@main.route('/')
def index():
    a = Article.query.all()
    return render_template('main/index.html', list=a)

@main.route('/read/', methods=['GET'])
def read():
    a = Article.query.filter_by(id=request.args.get('id')).first()
    if a is not None:
        return render_template('main/read.html', a=a)
    flash(u'未找到相关文章')
    return redirect(url_for('main.index'))

@main.route('/user/comment', methods=['GET', 'POST'])
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
                return redirect(url_for('main'))
            except:
                db.session.rollback()
    return render_template('main/comment.html', form=form)