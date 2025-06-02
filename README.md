# Entity-Finder-Tool
This is a github version of "my" AI generated Entity Fider Tool that I published on the Garry's Mod Steam Workshop.
https://steamcommunity.com/sharedfiles/filedetails/?id=3492265457

Originally this was just going to be a quick AI generated script to help me figure out why certain NPCs would just shoot in the air on a map I like. After realizing the entity was somewhere mid-air, I had AI add more features, package it as a tool, and figured others might find it useful. So here it is.

This tool marks player and map entities with a red halo/outline that can be seen through walls.  [b][u]You can find it in the "Render" category of your tool gun. [/u][/b] If an entity doesn't have a physical model or is hard to see from a distance, its location will be marked with a super fancy orb (watermelon) and put a halo/outline around that. It will also paste the name of the entity, how far you are away from it, and its coordinates in chat (useful if you have a teleport addon). If it is marked with an orb it will say so in chat. 

If the entity is far away, or behind a wall, your camera will snap to look in the direction of the entity. The camera will only snap in these instances in case you're trying to mark a bunch of entities around a single point.

After an entity is marked, you can mart the 2nd nearest entity, 3rd nearest entity, 4th nearest entity etc.

[b]Primary Fire: Marks the nearest entity to the point you're looking at.
Secondary Fire: Removes all marks, outlines, and orbs.
R: Marks the nearest entity to you.[/b]

[h2] FAQ: [/h2]
[b][u]I tried to mark an entity and the tool pasted its info in chat, but I can't see an outline![/u][/b]
Sometimes, if an entity is in another "area" it can fail to create a halo/outline around the entity/orb. If you mark an entity and your camera snaps to a wall without an outline, you can noclip forward and find it that way. If you then mark the entity while in the same "area" the outline will work just fine.

[b][u]It keeps marking the same entity![/u][/b]
Keep in mind that there can be multiple entities with the same name in the same coordinates. I've seen situations where 5+ entities with the same name and coordinates will get marked before finding others.

[b][u]Are there entities this tool can't mark?[/u][/b]
It should ignore entities that are on you like predicted_viewmodel and gmod_hands. I also, for whatever reason, it always refused to mark npc_enemyfinder on the map I was using, even though it recognized it in chat. I ended up having it hardcoded to use an orb to mark npc_enemyfinder. So there very well could be other entities it doesn't work with. If you want to see a more detailed look at map entities, I recommend checking out NextKurome's Simple Map IO Viewer.
https://steamcommunity.com/sharedfiles/filedetails/?id=2928263128

[b][u]Which AIs did you use and how much work did you really do on this tool?[/u] [/b]
The code for this tool is kind of a frankenstein child of ChatGPT, Grok, Gemini, and Deepseek. Turns out, AI isn't nearly as good at coding as people say. While I didn't write the code, I did spend hours on troubleshooting lua errors, waiting for the various AIs to process my request, and writing just the right words to get the AIs to do code exactly what I had in mind. I used so many AIs because of limits their companies set on their free usage, and I found that AIs would quickly hallucinate if I tried to do more than a few prompts. There were would also be errors that one AI couldn't solve that another could. Clearly these companies still have a ways to go before perfecting AI LUA coding...

[b][u] Can I change/improve this addon and upload my own version?[/u][/b]
Sure. While I did a lot of playtesting and error troubleshooting, ultimately AI made the code, and due to legal precedent (in the USA as of writing) I couldn't claim the rights to this code even if I wanted to since it wasn't made by a human.
