from flask import Flask, request, Response, jsonify
import io 
import json
import base64
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  

@app.route('/')
def hello():
    return 'Hello, Flask is running!'

@app.route('/check_connection')
def check_connection():
    return jsonify({'status': 'success', 'message': 'Connection is successful'})


@app.route('/detect', methods=['POST'])
def detect():
    try:
        if 'image' not in request.files:
            return Response('Image data not provided', status=400)
        
        # Access the image file
        image_file = request.files['image']

        # Perform object detection on the image_file
        boxes = detect_objects_on_image(image_file)
        return jsonify(boxes)
    except Exception as e:
        return str(e), 500


def detect_objects_on_image(image):
    # Your object detection logic here
    # This is a dummy implementation for demonstration purposes
    # Replace this with your actual object detection code
    boxes = [
        [100, 100, 200, 200, 'disease A', 0.9],
        [300, 300, 400, 400, 'disease B', 0.8]
    ]
    return boxes

if __name__ == '__main__':
    app.run(debug=True)
