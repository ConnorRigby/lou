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
```