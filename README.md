# Lou

A discord bot that is configured by lua snippits.

# TODOs

A number of things still need to be implemented before this can actually be
deployed for real.

## Storage of scripts

Right now there is a phoenix app, but its just the basic scafolding. Scripts
should be stored in a relational resource that can be used by other resources.

For example one might have a script:

```lua
message:create_reaction("🤖");
message:reply("Thanks for your participation in this year's survey");
```

and it could be called on different events such as messages in a particular 
channel, or messages from a particular user.

## Registration of scripts

Related to the above TODO. Once a script is stored, it needs to be assosiated
with an event of some sort.

the list of scriptable events isn't fully fleshed out yet, but i'm thinking
at least:

* `MESSAGE_CREATE`
* `MESSAGE_UPDATE`
* `MESSAGE_DELETE`
* `MESSAGE_REACTION_ADD`
* `MESSAGE_REACTION_DELETE`
* `CHANNEL_CREATE`
* `CHANNEL_DELETE`
* `CHANNEL_UPDATE` ? i don't know if this is a real event.

It might also be worth supporting the above events in particular conditions
such as `MESSAGE_CREATE` when a particular `user` in a `guild` posts.

## State updates

It would be nice for scripts to be stateful. Potential ideas for this is allowing
a script to return a Table that is merged with the `_G` table. 

# API

Here are some examples of the Lua API. There are some "magic" (read `global`)
variables exported before execution. These include:

* `guild` - a `guild` object of the current server.
* `user` - a `user` object of the bot user.
* `message` a `message` object of the message that caused the script to run.

```lua
-- Send a message
message, err = discord.create_message(message.channel_id, "I copy-pasted this from the internet!");
if err then
  print("error creating message: " .. err.message);
end

-- Mention someone by using the `reply` method.
message = updated:reply("lol owned");

-- Channel also has a `create_message` method.
guild.channels[message.channel_id]:create_message("https://i.imgur.com/U5sYgEf.jpg");

-- Update a message
updated = discord.edit_message(channel_id, "I copy-pasted a typo from the internet!"));

-- Or use the helper method
updated:edit_message("typo fixed");

-- Delete a message
discord.delete(updated.channel_id, updated.id);

-- Or use the Delete method
updated:delete();

-- Add reactions
discord.create_reaction(message.channel_id, message.id, "🤖");

-- Or use the create_reaction method
message:create_reaction("🤖");

-- Update the bot's status
discord.update_status("dnd", "playing minecraft lol");

-- Of course regular lua functions exist
if string.match(message.content, "lua is cool") then
  message:reply("Hey thanks!");
end

-- Let's try an example of me trying to get out of completing this project

-- Random must be seeded
math.randomseed(os.time());

-- Lua has global variables, so tagging as `local` is probably useful in many cases
local is_playing = string.match(message.content, "play");

-- Play a round.
local game_result = math.random(0, 5);

-- If a user wants to play, and the result was 0
if (is_playing and game_result == 0) then
  -- winner winner!
  message.author:reply(message.channel_id, "BANG!");
elseif is_playing then
  -- play again?
  message:reply("click. "..game_result);
end

-- Be careful not to create feedback loops..

-- Count number of occurences of the "repeate stuff!" in the message content
local _, count = message.content:gsub("repeate stuff!", '');
-- Duplicate the content that many times.
message:reply(message.content:rep(count));
-- Get rate limited lol

-- Use the global `user` struct to escape these cases
if message.author.id == user.id then
  return;
elseif count > 1 then
  message:reply(message.content:rep(count));
end
```