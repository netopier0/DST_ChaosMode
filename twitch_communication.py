import socket
from time import sleep
import os

#Link to generate token: https://twitchapps.com/tmi/
#The main idea how I get data from twitch comes from this website:
#https://www.learndatasci.com/tutorials/how-stream-text-data-twitch-sockets-python/

server = 'irc.chat.twitch.tv'
port = 6667
nickname = 'NAME' # Twitch username
token = 'TOKEN' #oauth token
channel = '#CHANELNAME' #channel in format '#CHANELNAME'

#Transfer file location
file = "textak.txt"

def main():
    sock = socket.socket()
    sock.connect((server, port))
    sock.send(f"PASS {token}\r\n".encode('utf-8'))
    sock.send(f"NICK {nickname}\r\n".encode('utf-8'))
    sock.send(f"JOIN {channel}\r\n".encode('utf-8'))

    text = ""
    delete_first_three = 3

    try:
        while True:
            resp = sock.recv(2048).decode('utf-8')

            if resp.startswith('PING'):
                # print(resp)
                sock.send("PONG\n".encode('utf-8'))
                
            elif resp.startswith(':tmi.twitch.tv'):
                # print(resp)
                continue
            
            elif delete_first_three:
                delete_first_three -= 1
            
            elif len(resp) > 0:
                sep_mesg = resp.split("\n")
                for comment in sep_mesg[:-1]:
                    name = comment.split("!", 1)[0][1:]
                    msg = comment.split(channel, 1)[1][2:]
            
                    # Uncomment if you want to see messages that come through this script
                    #print(name, end=": ")
                    #print(msg[:-1])

                    text += name
                    text += ": "
                    text += msg[:-1]
                    text += "\n"

                ##Add to file
                size = os.path.getsize(file)
                if size == 0:
                    f = open(file, 'w')
                    for l in text.splitlines(True):
                        try:
                            f.write(l)
                        except:
                            pass
                    f.close()
                    text = ""
            

    except KeyboardInterrupt:
        print('Connection closed')
        sleep(1)
        sock.close()
        

 
if __name__ == '__main__':
    main()
