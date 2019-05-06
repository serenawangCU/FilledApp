from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table = db.Table('association_table',
    db.Column('helike_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('likehim_id', db.Integer, db.ForeignKey('user.id'))
)

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    password = db.Column(db.String)
    username = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)
    age = db.Column(db.Integer)
    height = db.Column(db.String)
    gender = db.Column(db.String)
    picture = db.Column(db.String)
    helike = db.relationship('User', 
        secondary=association_table, 
        primaryjoin=id == association_table.c.likehim_id,
        secondaryjoin=id == association_table.c.helike_id, 
        backref=db.backref('passive'))
    likehim = db.relationship('User', 
        secondary=association_table, 
        primaryjoin=id == association_table.c.helike_id,
        secondaryjoin=id == association_table.c.likehim_id,
        backref=db.backref('active'))

    def __init__(self, **kwargs):
        self.password = kwargs.get('password', '')
        self.username = kwargs.get('username', '')
        self.email = kwargs.get('email', '')
        self.age = kwargs.get('age', -1)
        self.height = kwargs.get('height', '')
        self.gender = kwargs.get('gender', '')
        self.picture = kwargs.get('picture', '')

    def serialize(self):
        return {
            'id': self.id,
            'password': self.password,
            'email': self.email,
            'username': self.username,
            'age': self.age,
            'height': self.height,
            'gender': self.gender,
            'Picture': self.picture,
            'helike': [helike.brief() for helike in self.helike],
            'likedhim': [likehim.brief() for likehim in self.likehim]
        }

    def brief(self):
        return {
            'id': self.id,
            'password': self.password,
            'email': self.email,
            'username': self.username,
            'age': self.age,
            'height': self.height,
            'gender': self.gender,
            'Picture': self.picture
        }

class Chat(db.Model):
    __tablename__ = 'chat'
    id = db.Column(db.Integer, primary_key=True)
    user_id1 = db.Column(db.Integer, nullable=False)
    user_id2 = db.Column(db.Integer, nullable=False)
    history = db.relationship('Message', cascade='delete')

    def __init__(self, **kwargs):
        self.user_id1 = kwargs.get('user_id1')
        self.user_id2 = kwargs.get('user_id2')
        self.history = []

    def serialize(self):
        return {
            'id': self.id,
            'user_id1': self.user_id1,
            'user_id2': self.user_id2,
            'history': [message.brief() for message in self.history]
        }

class Message(db.Model):
    __tablename__ = 'message'
    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, nullable=False)
    text = db.Column(db.String, nullable=False)
    chat_id = db.Column(db.Integer, db.ForeignKey('chat.id'), nullable=False)

    def __init__(self, **kwargs):
        self.sender_id = kwargs.get('sender_id')
        self.text = kwargs.get('text')
        self.chat_id = kwargs.get('chat_id')

    # def serialize(self):
    #     return {
    #         'id': self.id,
    #         'sender_id': self.sender_id,
    #         'text': self.text,
    #         'chat_id': self.chat_id
    #     }


    def brief(self):
        return {
            'id': self.sender_id,
            'chat': self.text
        }
