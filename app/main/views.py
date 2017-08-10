# -*- coding=utf-8 -*-
from datetime import datetime
from flask import render_template, redirect, url_for, flash
from .forms import AddRecordForm
from ..models import Record
from . import main
from .. import db


@main.route('/', methods=['GET', 'POST'])
def index():
	return render_template('main/index.html',  current_time=datetime.utcnow())

@main.route('/user/comment', methods=['GET', 'POST'])
def comment():
    form = AddRecordForm()
    if form.validate_on_submit():
        record = Record(comment = form.comment.data)
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