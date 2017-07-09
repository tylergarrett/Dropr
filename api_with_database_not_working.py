from flask import Flask, jsonify, abort, make_response, request
from flask_restful import Api, Resource, reqparse, fields, marshal

import os

app = Flask(__name__, static_url_path="")
api = Api(app)
from flask_sqlalchemy import SQLAlchemy
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ['DATABASE_URL']

db = SQLAlchemy(app)

class Dot(db.Model):
    id = db.Column(db.Integer, primary_key = True, nullable = False)
    title = db.Column(db.String(40))
    desc = db.Column(db.String(150))
    upVoteCount = db.Column(db.Integer)
    imagePath = db.Column(db.String(250))
    green = db.Column(db.Boolean)
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    deviceID = db.Column(db.Integer)

    def __init__(self, title, desc, upVoteCount, imagePath, green, latitude, longitude, deviceID):
        self.title = title
        self.desc = desc
        self.upVoteCount = upVoteCount
        self.imagePath = imagePath
        self.green = green
        self.latitude = latitude
        self.longitude = longitude
        self.deviceID = deviceID


# dots = [
#     {
#         'id': 1,
#         'title': u'Free food',
#         'desc': u'There is currently free food at clem! Come and get it', 
#         'upVoteCount': 0,
#         'imagePath': u'testImagePath1',
#         'green': True,
#         'latitude': 38.036235,
#         'longitude': -78.506288,
#         'deviceID': 27
        
#     },
#     {
#         'id': 2,
#         'title': u'Something cool is here',
#         'desc': u'something something something', 
#         'upVoteCount': 2,
#         'imagePath': u'testimagepath2',
#         'green': False,
#         'latitude': 38.034235,
#         'longitude': -78.506228,
#         'deviceID': 27
#     }
# ]

dot_fields = {
    'title': fields.String,
    'desc': fields.String,
    'upVoteCount': fields.Integer,
    'imagePath': fields.String,
    'green': fields.Boolean,
    'latitude': fields.Float,
    'longitude': fields.Float,
    'uri': fields.Url('dot'),
    'deviceID': fields.Integer
}


class DotListAPI(Resource):

    def __init__(self):
        self.reqparse = reqparse.RequestParser()
        self.reqparse.add_argument('title', type=str, required=True,
                                    help='No dot title provided',
                                    location='json')
        self.reqparse.add_argument('desc', type=str, default="",
                                   location='json')
        self.reqparse.add_argument('upVoteCount', type=int, default=0,
                                   location='json')
        self.reqparse.add_argument('imagePath', type=str, default="",
                                   location='json')
        self.reqparse.add_argument('green', type=bool, default=False,
                                   location='json')
        self.reqparse.add_argument('latitude', type=float, default=0.0,
                                   location='json')
        self.reqparse.add_argument('longitude', type=float, default=-0.0,
                                   location='json')
        self.reqparse.add_argument('deviceID', type=int, default=0,
                                   location='json')
        super(DotListAPI, self).__init__()

    def get(self):
        dotz = []        
        #.query(SomeMappedClass)
        #for dotDB in db.query(Dot).order_by(Dot.id):
        dotsDB = db.session.query(Dot).all()
        for dotDB in dotsDB:
            dotz.append({'id': dotDB.id,
                        'title': dotDB.title,
                        'desc': dotDB.desc,
                        'upVoteCount': dotDB.upVoteCount,
                        'imagePath': dotDB.imagePath,
                        'green': dotDB.green,
                        'latitude': dotDB.latitude,
                        'longitude': dotDB.longitude,
                        'deviceID': dotDB.deviceID})

        return {'dots': [marshal(dot, dot_fields) for dot in dotz]}

    def post(self):
        args = self.reqparse.parse_args()
        dot = {
            'id': 99,
            'title': args['title'],
            'desc': args['desc'],
            'upVoteCount': args['upVoteCount'],
            'imagePath': args['imagePath'],
            'green': args['green'],
            'latitude': args['latitude'],
            'longitude': args['longitude'],
            'deviceID': args['deviceID']
        }
        #dots.append(dot)

        #args = request.form
        dot1 = Dot(args['title'], args['desc'], args['upVoteCount'], args['imagePath'], args['green'], args['latitude'], args['longitude'], args['deviceID'])
        db.session.add(dot1)
        db.session.commit()

        return {'dot': marshal(dot, dot_fields)}, 201

class DotAPI(Resource):

    def __init__(self):
        self.reqparse = reqparse.RequestParser()
        self.reqparse.add_argument('title', type=str, location='json'),
        self.reqparse.add_argument('title', type=str, location='json'),
        self.reqparse.add_argument('desc', type=str,location='json'),
        self.reqparse.add_argument('upVoteCount', type=int,location='json'),
        self.reqparse.add_argument('imagePath', type=str, location='json'),
        self.reqparse.add_argument('green', type=bool, location='json'),
        self.reqparse.add_argument('latitude', type=float, location='json'),
        self.reqparse.add_argument('longitude', type=float, location='json'),
        self.reqparse.add_argument('deviceID', type=int, location='json')
        super(DotAPI, self).__init__()

    # def get(self, id):
    #     dot = [dot for dot in dots if dot['id'] == id]
    #     if len(dot) == 0:
    #         abort(404)
    #     return {'dot': marshal(dot[0], dot_fields)}

    # def put(self, id):
    #     dot = [dot for dot in dots if dot['id'] == id]
    #     if len(dot) == 0:
    #         abort(404)
    #     dot = dot[0]
    #     args = self.reqparse.parse_args()
    #     for k, v in args.items():
    #         if v is not None:
    #             dot[k] = v
    #     return {'dot': marshal(dot, dot_fields)}

    def delete(self, id):

        currentDot = db.session.query(Dot).filter(Dot.id == id).one()
        db.session.delete(currentDot)
        db.session.commit()

        #dot = [dot for dot in dots if dot['id'] == id]
        # if len(dot) == 0:
        #     abort(404)
        #dots.remove(dot[0])
        return {'result': True}


api.add_resource(DotListAPI, '/dropr/api/v1.0/dots', endpoint='dots')
api.add_resource(DotAPI, '/dropr/api/v1.0/dots/<int:id>', endpoint='dot')


if __name__ == '__main__':
    app.run(debug=True)