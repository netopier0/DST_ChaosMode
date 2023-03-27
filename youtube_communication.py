import pytchat
import os

# url adress of your stream is just the video id, * in example
# https://www.youtube.com/watch?v=***********
url = 'URL'

#Transfer file location
file = "textak.txt"

def main():
    text = ""
    chat = pytchat.create(video_id=url)
    f = open(file, 'w')

    while chat.is_alive():
        for c in chat.get().sync_items():
            text += c.author.name
            text += ": "
            text += c.message
            text += "\n"
            
            # Uncomment if you want to see messages that come through this script
            #print(f"{c.author.name}: {c.message}")
        
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

    print('Connection closed')
 
if __name__ == '__main__':
    main()
