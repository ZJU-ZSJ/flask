# -*- coding=utf-8 -*-
from flask_wtf import Form
from wtforms import StringField, SubmitField, PasswordField,BooleanField, TextAreaField
from wtforms.validators import Required, length, Regexp, EqualTo
from wtforms.ext.sqlalchemy.fields import QuerySelectField
from ..models import Category
from flask.ext.pagedown.fields import PageDownField

class LogForm(Form):
	username = StringField(u'帐号', validators=[Required(), length(1, 64)])
	password = PasswordField(u'密码', validators=[Required()])
	submit = SubmitField(u'提交')

class RegistrationForm(Form):
    username = StringField(u'用户名', validators=[Required(), length(2, 128)])
    password = PasswordField(
        u'密码', validators=[Required(), EqualTo('password2', message=u'两次密码不一致')])
    password2 = PasswordField(u'重复密码', validators=[Required()])
    registerkey = PasswordField(u'注册码', validators=[Required()])
    submit = SubmitField(u'注册')

class ModifyForm(Form):
    id = StringField(u'id')
    submit = SubmitField(u'修改')

class EditRecordForm(Form):
    comment = TextAreaField(u'更改评论为:', validators=[Required()])
    verify = BooleanField(u'加精请打勾')
    delete = StringField(u'如果你要删除这条记录，输入“确认删除”之后点击提交！否则请留空。')
    submit = SubmitField(u'提交')

class EditArticleForm(Form):
    title = TextAreaField(u'更改标题为:', validators=[Required()])
    body = PageDownField(u'更改内容为:', validators=[Required()])
    category_id = QuerySelectField(u'分类', query_factory=lambda: Category.query.all(
    ), get_pk=lambda a: str(a.id), get_label=lambda a: a.name)
    delete = StringField(u'如果你要删除这条记录，输入“确认删除”之后点击提交！否则请留空。')
    submit = SubmitField(u'提交')

class EditCategoryForm(Form):
    name = TextAreaField(u'更改名字为:', validators=[Required()])
    delete = StringField(u'如果你要删除这条记录，输入“确认删除”之后点击提交！否则请留空。')
    submit = SubmitField(u'提交')

class PostArticleForm(Form):
    title = StringField(u'标题', validators=[Required(), length(1, 64)])
    body = PageDownField(u'内容')
    category_id = QuerySelectField(u'分类', query_factory=lambda: Category.query.all(
    ), get_pk=lambda a: str(a.id), get_label=lambda a: a.name)
    submit = SubmitField(u'发布')

class PostCategoryForm(Form):
    name = StringField(u'分类名', validators=[Required(), length(1, 64)])
    submit = SubmitField(u'发布')