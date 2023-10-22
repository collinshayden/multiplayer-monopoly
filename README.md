# CS3050 Final Project
Aidan Bonner, Jordan Bourdeau, Hayden Collins, Alex Hall


## Loading Flask App to Silk

[Documentation](https://silk.uvm.edu/manual/python/)

Creating Venv:
```
python -m venv env
source env/bin/activate
pip install flask
pip install flask-socketio
pip install requests
deactivate
```

Loading Silk App:
```
silk app <hostname> load
# Use this to load app for the first time
silk app jbourde2.w3.uvm.edu load
silk site jbourde2.w3.uvm.edu update
```

Logs:
```
App Server: /usr/lib/unit-user-jbourde2/unit.log
Error:      /users/j/b/jbourde2/www-logs/error-log
Access:     /users/j/b/jbourde2/www-logs/access-log
```
