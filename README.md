# DST_ChaosMode

Mod for the game Don't Starve Together that allows your viewers to mess with your game while playing.

# Warning

Event that teleport player currently don't work with lag compensation: predictive.
This includes Bad connection, Random tp, Hermit tp, Spawn tp.

# Description

Chaos mode lets your viewers interact with your game. Every 60 seconds, the game will generate a set of events. Then your viewers can vote in chat for what option they want to happen. 
After 60 seconds, the option with the most votes will happen and new events will be generated. Events such as changing in game stats, summoning entities, environmental effects, giving player items and more.

# Twitch

1. Download this github repository
2. Add ChaosMode to your DST mod file (something like ..\steamapps\common\Don't Starve Together\mods)
3. Run twitch.exe

# Youtube

1. Download this github repository
2. Add ChaosMode to your DST mod file (something like ..\steamapps\common\Don't Starve Together\mods)
3. Run youtube.exe

# Afterword

In case you come across anything that is not working or some event that you want to add, let me know. I tested this mode but there may still be some bugs. 
File twitch_communication_plus_server.py/youtube_communication_plus_server.py have same code as twitch.exe/youtube.exe but without secrets, you can check it if you want. 
You can also run python code by yourself but you need some libaries and also secret for twitch (you cen get your secret here https://twitchapps.com/tmi/).
