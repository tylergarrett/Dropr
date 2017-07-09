from flask import Flask, jsonify, abort, make_response
from flask_restful import Api, Resource, reqparse, fields, marshal

app = Flask(__name__, static_url_path="")
api = Api(app)

dots = [
    {
        'id': 1,
        'title': u'Free food',
        'desc': u'There is currently free food at clem! Come and get it', 
        'upVoteCount': 0,
        'imagePath': u'testImagePath1',
        'green': True,
        'latitude': 38.036235,
        'longitude': -78.506288,
        'deviceID': 27
        
    },
    {
        'id': 2,
        'title': u'Something cool is here',
        'desc': u'something something something', 
        'upVoteCount': 2,
        'imagePath': u'testimagepath2',
        'green': False,
        'latitude': 38.034235,
        'longitude': -78.506228,
        'deviceID': 27
    }
]

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
        self.reqparse.add_argument('green', type=bool, default=True,
                                   location='json')
        self.reqparse.add_argument('latitude', type=float, default=0.0,
                                   location='json')
        self.reqparse.add_argument('longitude', type=float, default=-0.0,
                                   location='json')
        self.reqparse.add_argument('deviceID', type=int, default=0,
                                   location='json')
        super(DotListAPI, self).__init__()

    def get(self):
        return {'dots': [marshal(dot, dot_fields) for dot in dots]}

    def post(self):
        args = self.reqparse.parse_args()
        dot = {
            'id': dots[-1]['id'] + 1,
            'title': args['title'],
            'desc': args['desc'],
            'upVoteCount': args['upVoteCount'],
            'imagePath': args['imagePath'],
            'green': args['green'],
            'latitude': args['latitude'],
            'longitude': args['longitude'],
            'deviceID': args['deviceID']
        }
        dots.append(dot)
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

    def get(self, id):
        dot = [dot for dot in dots if dot['id'] == id]
        if len(dot) == 0:
            abort(404)
        return {'dot': marshal(dot[0], dot_fields)}

    def put(self, id):
        dot = [dot for dot in dots if dot['id'] == id]
        if len(dot) == 0:
            abort(404)
        dot = dot[0]
        args = self.reqparse.parse_args()
        for k, v in args.items():
            if v is not None:
                dot[k] = v
        return {'dot': marshal(dot, dot_fields)}

    def delete(self, id):
        dot = [dot for dot in dots if dot['id'] == id]
        if len(dot) == 0:
            abort(404)
        dots.remove(dot[0])
        return {'result': True}


api.add_resource(DotListAPI, '/dropr/api/v1.0/dots', endpoint='dots')
api.add_resource(DotAPI, '/dropr/api/v1.0/dots/<int:id>', endpoint='dot')


if __name__ == '__main__':
    app.run(debug=True)