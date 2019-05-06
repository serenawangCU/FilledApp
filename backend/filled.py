import json
import random
from database import db, User, Chat, Message
from flask import Flask, request

app = Flask(__name__)
db_filename = 'user.db'

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()

@app.route('/')
def showOff():
    return 'FILLED! is awesome!!!'

@app.route('/api/users/', methods= ['POST'])
def create_user():
    user_body = json.loads(request.data)
    check = User.query.filter_by(email=user_body.get('email')).first()
    if check is None:
        user = User(
            password = user_body.get('password'),
            email = user_body.get('email'),
            username = user_body.get('username'),
            picture = user_body.get('picture')
        )
        db.session.add(user)
        db.session.commit()
        return json.dumps({'success': True, 'data': user.serialize()}), 201
    return json.dumps({'success': False, 'error': 'USER ALREADY EXISTS!'}), 406

@app.route('/api/user/login/', methods= ['POST'])
def get_user():
    user_body = json.loads(request.data)
    user_email = user_body.get('email')
    user = User.query.filter_by(email=user_email).first()
    if user is not None:
        if user_body.get('password') == user.password:
            return json.dumps({'success': True, 'data': user.serialize()}), 200
        else:
            return json.dumps({'success': False, 'error': 'PASSWORD INCORRECT!'}), 406
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/users/random/')
def get_random_users():
    users = User.query.all()
    sample = []
    for user in users:
        sample.append(user)
    random = findRandom(sample, 5)
    res = {'success': True, 'data': random}
    return json.dumps(res), 200

def findRandom(sequence, number):
    # if number == 1:
    #     return random.choice(sequence).serialize()
    result = [random.choice(sequence).brief()]
    current = 1
    while current < number:
        e = result[-1]
        while e in result:
            e = random.choice(sequence).brief()
        result.append(e)
        current += 1
    return result

@app.route('/api/user_profile/', methods= ['POST'])
def update_user_profile():
    user_body = json.loads(request.data)
    user_id = user_body.get('id')
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        # user.password = user_body.get('password', user.password)
        # user.email = user_body.get('email', user.email)
        user.username = user_body.get('username', user.username)
        user.age = user_body.get('age', user.age)
        user.height = user_body.get('height', user.height)
        user.gender = user_body.get('gender', user.gender)
        user.picture = user_body.get('Picture', user.picture)
        db.session.commit()
        return json.dumps({'success': True, 'data': user.serialize()}), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/user_likes/<int:user_id>/')
def get_helikes(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        res = {'success': True, 'data': [helike.brief() for helike in user.helike]}
        return json.dumps(res), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/user_likedbys/<int:user_id>/')
def get_likehim(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        res = {'success': True, 'data': [likehim.brief() for likehim in user.likehim]}
        return json.dumps(res), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/user_like/', methods= ['POST'])
def add_like():
    s_body = json.loads(request.data)
    s_id = s_body.get('s_id')
    s = User.query.filter_by(id=s_id).first()
    if s is not None:
        r_body = json.loads(request.data)
        r_id = r_body.get('r_id')
        r = User.query.filter_by(id=r_id).first()
        if r is not None:
            s.helike.append(r)
            r.likehim.append(s)
            db.session.commit()
        else:
            return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404
        return json.dumps({'success': True, 'data': s.brief()}), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/user_unlike/', methods= ['POST'])
def unlike():
    s_body = json.loads(request.data)
    s_id = s_body.get('s_id')
    s = User.query.filter_by(id=s_id).first()
    if s is not None:
        r_body = json.loads(request.data)
        r_id = r_body.get('r_id')
        r = User.query.filter_by(id=r_id).first()
        if r is not None:
            s.helike.remove(r)
           # r.likedby.remove(s) ???
            db.session.commit()
        else:
            return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404
        return json.dumps({'success': True, 'data': s.brief()}), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/chats/', methods= ['POST'])
def create_chat():
    chat_body = json.loads(request.data)
    user_id1 = chat_body.get('user_id1')
    user_id2 = chat_body.get('user_id2')
    check = Chat.query.filter_by(user_id1=user_id1, user_id2=user_id2).first()
    if check is None:
        check = Chat.query.filter_by(user_id1=user_id2, user_id2=user_id2).first()
    if check is None:
        chat = Chat(
            user_id1= chat_body.get('user_id1'),
            user_id2= chat_body.get('user_id2'),
        )
        db.session.add(chat)
        db.session.commit()
        return json.dumps({'success': True, 'data': chat.serialize()}), 201
    return json.dumps({'success': False, 'error': 'CHAT ALREADY EXISTS!'}), 406

@app.route('/api/chat/', methods= ['POST'])
def get_chat():
    c_body = json.loads(request.data)
    user_id1 = c_body.get('user_id1')
    user_id2 = c_body.get('user_id2')
    chat = Chat.query.filter_by(user_id1=user_id1, user_id2=user_id2).first()
    if chat is None:
        chat = Chat.query.filter_by(user_id1=user_id2, user_id2=user_id1).first()
    if chat is not None:
        return json.dumps({'success': True, 'data': [message.brief() for message in chat.history]}), 200
    return json.dumps({'success': False, 'error': 'CHAT NOT FOUND!'}), 404

@app.route('/api/chat/add/', methods= ['POST'])
def add_message():
    m_body = json.loads(request.data)
    user_id1 = m_body.get('user_id1')
    user_id2 = m_body.get('user_id2')
    chat = Chat.query.filter_by(user_id1=user_id1, user_id2=user_id2).first()
    if chat is None:
        chat = Chat.query.filter_by(user_id1=user_id2, user_id2=user_id1).first()
    if chat is not None:
        message = Message(
        sender_id = m_body.get('sender_id'),
        text = m_body.get('text'),
        chat_id = chat.id,
        )
        chat.history.append(message)
        db.session.add(message)
        db.session.commit()
        return json.dumps({'success': True, 'data': message.brief()}), 200  
    return json.dumps({'success': False, 'error': 'CHAT NOT FOUND!'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
