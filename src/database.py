from flask_sqlalchemy import SQLAlchemy
import bcrypt
import datetime
import hashlib
import os

db = SQLAlchemy()

association_table = db.Table('association',
    db.Column('like_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('beliked_id', db.Integer, db.ForeignKey('user.id'))
)

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=True)#
    gender = db.Column(db.String, nullable=True)#
    age = db.Column(db.Integer)
    hobby = db.Column(db.String)
    job = db.Column(db.String)
    aboutme = db.Column(db.Text)
    # login information
    email = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False)
    # Session information
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)
    # photo
    like = db.relationship('User', 
        secondary=association_table, 
        primaryjoin=id == association_table.c.beliked_id,
        secondaryjoin=id == association_table.c.like_id, 
        backref=db.backref('passive'))
    likedby = db.relationship('User', 
        secondary=association_table, 
        primaryjoin=id == association_table.c.like_id,
        secondaryjoin=id == association_table.c.beliked_id,
        backref=db.backref('active'))

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.gender = kwargs.get('gender', '')
        self.age = kwargs.get('age')
        self.hobby = kwargs.get('hobby')
        self.job = kwargs.get('job')
        self.aboutme = kwargs.get('aboutme')

        #login information
        self.email = kwargs.get('email')
        self.password_digest = bcrypt.hashpw(kwargs.get('password').encode('utf8'),
                                            bcrypt.gensalt(rounds=13))
        self.renew_session()

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'gender': self.gender,
            'age': self.age,
            'hobby': self.hobby,
            'job': self.job,
            'aboutme': self.aboutme,
            # photo
            'like': [like.brief_serialize() for like in self.like],
            'likedby': [likedby.brief_serialize() for likedby in self.likedby]
        }

    def brief_serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'gender': self.gender,
            'age': self.age,
            'hobby': self.hobby,
            'job': self.job,
            'aboutme': self.about_me
            # photo
        }
    # Used to randomly generate session/update tokens
    def _urlsafe_base_64(self):
        return hashlib.sha1(os.urandom(64)).hexdigest()

    # Generates new tokens, and resets expiration time
    def renew_session(self):
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + \
                                datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        return bcrypt.checkpw(password.encode('utf8'),
                              self.password_digest)

    # Checks if session token is valid and hasn't expired
    def verify_session_token(self, session_token):
        return session_token == self.session_token and \
            datetime.datetime.now() < self.session_expiration

    def verify_update_token(self, update_token):
        return update_token == self.update_token