# Lou

## API

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