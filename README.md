# DST_ChaosMode

Mod for the game Don't Starve Together that allows your viewers to mess with your game while playing.

# Description
Chaos mode lets your viewers interact with your game. Every 60 seconds, the game will generate a set of events. Then your viewers can vote in chat for what option they want to happen. 
After 60 seconds, the option with the most votes will happen and new events will be generated. Events such as changing in game stats, summoning entities, environmental effects, giving player items and more.
# Dependencies

- [Python 3](www.python.org)
- [sockets package](https://pypi.org/project/sockets/)

# Installation

1. Download this github repository
2. Go to website [https://twitchapps.com/tmi/](https://twitchapps.com/tmi/) and get your oath token (I advise you to use second account)
3. Edit twitch_communication.py:
- set nickname to your twitch username you used to get oath token
- set token to token you got from website in the previous step
- set channel to channel you want to get chat from 
- set file to full path to file you will use for transfer of data (can be any .txt file)
4. Edit transfer_file variable in modmain.lua and set it to the same file as in python
5. Add ChaosMode to your DST mod file (something like ..\steamapps\common\Don't Starve Together\mods)
6. Run python script and have fun or suffer (sometimes you need to rerun the script a few times at start so it will connect to twitch successfully)

# Afterword

In case you come across anything that is not working or some event that you want to add, let me know. I tested this mode but there may still be some bugs.
