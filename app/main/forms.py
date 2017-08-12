# -*- coding=utf-8 -*-
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, TextAreaField
from wtforms.validators import Required, length, Regexp, EqualTo
from flask_pagedown.fields import PageDownField


class AddRecordForm(FlaskForm):

    comment = PageDownField(u'* 填写你的评论:', validators=[Required(),length(1, 64)])
    submit = SubmitField(u'提交')