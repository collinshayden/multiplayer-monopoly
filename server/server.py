from flask import Flask
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.secret_key = 'secret_key'
socketio = SocketIO(app)

@socketio.on('connect')
def handle_connect():
    print('(Socket.IO) connect: Client connected.')


@socketio.on('disconnect')
def handle_disconnect():
    print('(Socket.IO) disconnect: Client disconnected.')

@socketio.on('custom_event')
def handle_message(data: str):
    print(f'(Socket.IO) custom_event: {data}')
    emit('custom_event', data)  # Reflect back to client

if __name__ == '__main__':
    socketio.run(app, debug=True, port=5000)
