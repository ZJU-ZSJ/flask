# -*- coding=utf-8 -*-
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, TextAreaField
from wtforms.validators import Required, length, Regexp, EqualTo
from flask_pagedown.fields import PageDownField


class AddRecordForm(FlaskForm):

    comment = PageDownField(u'* 填写你的评论:', validators=[Required()])
    submit = SubmitField(u'提交')

class CommentForm(FlaskForm):
    body = StringField(u'填写你的评论',validators = [Required()])
    email = StringField(u'你的邮箱',validators = [Required()])
    name = StringField(u'昵称',validators = [Required()])
    submit = SubmitField(u'提交')