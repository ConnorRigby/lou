defmodule Lou.Lua.DiscordMessage do
  alias Nostrum.{Snowflake, Struct.Message}
  alias Lou.{Lua.Table, Lua.Discord, Lua.DiscordUser, Lua.DiscordGuildMember}
  @behaviour Table

  @impl Table
  def alloc(lua, %Message{} = message) do
    lua
    |> Table.alloc(table(message))
    |> Table.alloc_embed(DiscordUser, "author", message.author)
    |> Table.alloc_embed(DiscordGuildMember, "member", message.member)
  end

  @impl Table
  def install(lua, path, %Message{} = message) do
    Table.install(lua, __MODULE__, path, message)
  end

  @impl Table
  def table(%Message{} = message) do
    [
      {"id", Snowflake.dump(message.id)},
      {"channel_id", Snowflake.dump(message.channel_id)},
      {"content", message.content},
      {"timestamp", message.timestamp},
      {"reply", {:erl_func, &reply/2}},
      {"create_reaction", {:erl_func, &create_reaction/2}},
      {"edit", {:erl_func, &edit/2}},
      {"delete", {:erl_func, &delete/2}}
    ]
  end

  def create_reaction([{:tref, _} = this, emoji], lua) do
    channel_id = Table.fetch!(lua, this, "channel_id")
    message_id = Table.fetch!(lua, this, "id")
    Discord.create_reaction([channel_id, message_id, emoji], lua)
  end

  def edit([{:tref, _} = this, content], lua) do
    channel_id = Table.fetch!(lua, this, "channel_id")
    message_id = Table.fetch!(lua, this, "id")
    Discord.edit_message([channel_id, message_id, content], lua)
  end

  def delete([{:tref, _} = this], lua) do
    channel_id = Table.fetch!(lua, this, "channel_id")
    message_id = Table.fetch!(lua, this, "id")
    Discord.delete_message([channel_id, message_id], lua)
  end

  def reply([{:tref, _} = this, content], lua) do
    channel_id = Table.fetch!(lua, this, "channel_id")
    Discord.create_message([channel_id, content], lua)
  end
end
