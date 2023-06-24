import argparse
from flask import Flask, send_from_directory, request
from werkzeug.serving import run_simple

app = Flask(__name__)

# old
# @app.route('/', defaults={'path': ''})
# @app.route('/<path:path>')
# def serve_static_content(path):
#     return send_from_directory('static', path)

@app.route('/')
def serve_current_folder():
    return send_from_directory('static/content', 'control.html')

# @app.route('/your-page')
# def your_page():
#     return render_template('your_page.html')    



def parse_arguments():
    parser = argparse.ArgumentParser(prog='ssl_server')
    parser.add_argument('-p', '--port', type=int, default=443,
                        help='Port to serve [Default=443]')
    args = parser.parse_args()
    return args

def main():
    args = parse_arguments()

    ssl_context = ('cert.pem', 'privkey.pem')
    run_simple("0.0.0.0", int(args.port), app, ssl_context=ssl_context)

if __name__ == '__main__':
    main()








# old with vulnerable paths
# import argparse
# from flask import Flask, send_from_directory, request
# from werkzeug.serving import run_simple

# app = Flask(__name__)


# @app.route('/', defaults={'path': ''})
# @app.route('/<path:path>')
# def serve_static_content(path):
#     return send_from_directory('static', path)

# def parse_arguments():
#     parser = argparse.ArgumentParser(prog='ssl_server')
#     parser.add_argument('-p', '--port', type=int, default=443,
#                         help='Port to serve [Default=443]')
#     args = parser.parse_args()
#     return args

# def main():
#     args = parse_arguments()

#     ssl_context = ('cert.pem', 'privkey.pem')
#     run_simple("0.0.0.0", int(args.port), app, ssl_context=ssl_context)

# if __name__ == '__main__':
#     main()
