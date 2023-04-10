from http.server import HTTPServer, BaseHTTPRequestHandler
import cgi
import socket
from threading import Thread, Event
from time import sleep
import requests
import pytchat

alive = Event()
url = "http://127.0.0.1:8080"

# For Website
channel = []
channel_chat = dict()

class requestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.endswith('/user'):
            self.send_response(200)
            self.send_header('content_type', 'text/html')
            self.end_headers()

            output = '<html><body>'
            output += '<a href="/user/add">Connect to channel</a> </br>'
            output += '<a href="/end">End session</a> </br>'

            if len(channel) == 0:
                output += 'Not connected to any channel'
            else:
                output += 'Connected to '
                output += '<a href="/%s/chat">%s</a> </br>'%(channel[0],channel[0])
                
            output += '</body></html>'
            self.wfile.write(output.encode())

            
        elif self.path.endswith('/user/add'):
            self.send_response(200)
            self.send_header('content_type', 'text/html')
            self.end_headers()
            
            output = '<html><body>'
            output += '<a href="/user">Go back</a>'
            
            output += '''
                <form method="POST" enctype="multipart/form-data" action="/user/add">
                <input name="setChannel" type="text">
                <input type="submit" value="Submit">
                </form>'''

            output += '</body></html>'
            self.wfile.write(output.encode())

        elif self.path.endswith('/end'):
            self.send_response(200)
            self.send_header('content_type', 'text/html')
            self.end_headers()

            output = '<html><body>'
            output += 'Are you sure you want to end session?</br>'
            output += '<a href="/user">Cancel</a> </br>'
            output += '<a href="/end/yes">Confirm</a> </br>'
            output += '</body></html>'
            
            self.wfile.write(output.encode())

        elif self.path.endswith('/end/yes'):
            alive.set()
            raise KeyboardInterrupt

        elif self.path.endswith('/channel'):
            self.send_response(200)
            self.send_header('content_type', 'text/html')
            self.end_headers()

            
            output = 'NONE'
            if len(channel) != 0:
                output = '%s' %channel[0]
                
            self.wfile.write(output.encode())

        elif len(channel) == 1 and self.path.endswith('/%s/chat' %channel[0]):
            self.send_response(200)
            self.send_header('content_type', 'text/html')
            self.end_headers()

            output = channel_chat.get(channel[0])
            if output is None:
                output = 'None'
                
            self.wfile.write(output.encode())

        elif len(channel) == 1 and self.path.endswith('/%s/chat/delete' %channel[0]):
            self.send_response(200)
            self.send_header('content_type', 'text/html')
            self.end_headers()

            channel_chat.update({channel[0]: 'None'})
            output = "Delete chat"
            self.wfile.write(output.encode())


        else:
            self.send_response(301)
            self.send_header('Location', '/user')
            self.end_headers()
        

    def do_POST(self):
        global channel
        if self.path.endswith('/user/add'):
            c_type, p_dict = cgi.parse_header(self.headers.get('content-Type'))
            content_len = int(self.headers.get('Content-length'))
            p_dict['boundary'] = bytes(p_dict['boundary'], "utf-8")
            p_dict['CONTENT-LENGTH'] = content_len
            message_content = ''
            if c_type == 'multipart/form-data':
                fields = cgi.parse_multipart(self.rfile, p_dict)
                channel_name = fields.get('setChannel')[0]
                if len(channel_name) > 0:
                    if len(channel) != 0:
                        channel.pop()
                    channel.append(channel_name)

            self.send_response(301)
            self.send_header('content_type', 'text/html')
            self.send_header('Location', '/user')
            self.end_headers()

        elif len(channel) == 1 and self.path.endswith('/%s/chat' %channel[0]):
            c_type, p_dict = cgi.parse_header(self.headers.get('content-Type'))
            content_len = int(self.headers.get('Content-length'))
            p_dict['boundary'] = bytes(p_dict['boundary'], "utf-8")
            p_dict['CONTENT-LENGTH'] = content_len
            message_content = ''
            if c_type == 'multipart/form-data':
                fields = cgi.parse_multipart(self.rfile, p_dict)
                chat_message = fields.get('chatMessage')[0]
                if len(chat_message) > 0:
                    channel_chat.update({channel[0]: chat_message})

            self.send_response(301)
            self.send_header('content_type', 'text/html')
            self.send_header('Location', '/%s/chat' %channel[0])
            self.end_headers()


def server_code():
    PORT = 8080
    server = HTTPServer(('', PORT), requestHandler)
    print('Server up and running on port %s' % PORT)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('Server from port %s down' % PORT)
        server.socket.close()

def youtube_communication(stream_id):

    print("Start connection")

    youtube_channel = 'youtubestream'

    text = ""
    chat = pytchat.create(video_id=stream_id, interruptable=False)
        
    try:
        while chat.is_alive():
            for c in chat.get().sync_items():
                text += c.author.name
                text += ": "
                text += c.message
                text += "\n"
                print(f"{c.author.name}: {c.message}")

            if alive.is_set():
                raise KeyboardInterrupt
            
            ##Add to Server

            response = requests.get(url+'/%s/chat' %youtube_channel)
            if response.text == 'None':
                files = {'chatMessage': (None, text)}
                response = requests.post(url+'/%s/chat' %youtube_channel, files=files)
                text = ''


    except KeyboardInterrupt:
        print("End connection")
            

def stream_code(vid_id):

    sleep(1)
    files = {'setChannel': (None, 'youtubestream')}
    response = requests.post(url+'/user/add', files=files)    
    
    youtube_communication(vid_id)

def main():

    connect_to_channel = input('Put here video id of stream you wouldlike to connect to:\n')

    server_thread = Thread(target=server_code)
    stream_thread = Thread(target=stream_code, args=(connect_to_channel,))

    server_thread.daemon = True
    stream_thread.daemon = True
    
    server_thread.start()
    stream_thread.start()

    server_thread.join()
    stream_thread.join()

if __name__ == '__main__':
    main()
