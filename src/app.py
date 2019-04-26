import json
# from db import db, User
from flask import Flask, request
# import users
# import filled
from database import db, User

# db_filename = 'auth.db'
db_filename = 'user.db'
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def extract_token(request):
    auth_header = request.headers.get('Authorization')
    if auth_header is None:
        return False, json.dumps({'error': 'Missing authorization header.'})

    bearer_token = auth_header.replace('Bearer ', '').strip()
    if not bearer_token:
        return False, json.dumps({'error': 'Invalid authorization header.'}) 

    return True, bearer_token
    
@app.route('/')
def hello_world():
    return json.dumps({'message': 'Hello, World!'})

@app.route('/register/', methods=['POST'])
def register_account():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')

    if email is None or password is None:
        return json.dumps({'error': 'Invalid email or password'})
    
    created, user = users.create_user(email, password)

    if not created:
        return json.dumps({'error': 'User already exists'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })

@app.route('/login/', methods=['POST'])
def login():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')

    if email is None or password is None:
        return json.dumps({'error': 'Invalid email or password'})

    success, user = users.verify_credentials(email, password)

    if not success:
        return json.dumps({'error': 'Incorrect email or password'}) 
    
    # return redirect(url_for('entry'))
    # return json.dumps({'success':'login success'})
    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route('/session/', methods=['POST'])
def update_session():
    success, update_token = extract_token(request)

    if not success:
        return update_token 

    try:
        user = users.renew_session(update_token)
    except:
        return json.dumps({'error': 'Invalid update token'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })

@app.route('/secret/', methods=['GET'])
def secret_message():
    success, session_token = extract_token(request)

    if not success:
        return session_token
    
    user = users.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({'error': 'Invalid session token'})

    return json.dumps({'message': 'Logged in as ' + user.email })


@app.route('/api/<int:user_id>/users/', methods= ['POST'])
def create_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        user_body = json.loads(request.data)
        user.name = user_body.get('name')
        user.gender = user_body.get('gender')
        user.age = user_body.get('age')
        user.hobby = user_body.get('hobby')
        user.job = user_body.get('job')
        user.aboutme = user_body.get('aboutme')
        # user = User(
        #     name = user_body.get('name'),
        #     gender = user_body.get('gender'),
        #     age = user_body.get('age'),
        #     hobby = user_body.get('hobby'),
        #     job = user_body.get('job'),
        #     aboutme = user_body.get('aboutme'),
        # )
        #db.session.add(user)
        db.session.commit()
        return json.dumps({'success': True, 'data': user.serialize()}), 201
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/user/<int:user_id>/')
def get_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        return json.dumps({'success': True, 'data': user.serialize()}), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404

@app.route('/api/user_profile/<int:user_id>/', methods= ['POST'])
def update_user_profile(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        user_body = json.loads(request.data)
        user.name = user_body.get('name')
        user.gender = user_body.get('gender')
        user.age = user_body.get('age')
        user.hobby = user_body.get('hobby')
        user.job = user_body.get('job')
        user.aboutme = user_body.get('aboutme')
        db.session.commit()
        return json.dumps({'success': True, 'data': user.serialize()}), 200
    return json.dumps({'success': False, 'error': 'USER NOT FOUND!'}), 404





@app.route('/api/entry/', methods=['GET'])
def entry():
    return json.dumps({'success':'entry page'})

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)
