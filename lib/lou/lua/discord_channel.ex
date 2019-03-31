defmodule Lou.Lua.DiscordChannel do
  alias Nostrum.{Snowflake, Struct.Channel}
  alias Lou.{Lua.Table, Lua.Discord}
  @behaviour Table

  @impl Table
  def alloc(lua, %Channel{} = channel) do
    Table.alloc(lua, table(channel))
  end

  @impl Table
  def install(lua, path, %Channel{} = channel) do
    Table.install(lua, __MODULE__, path, channel)
  end

  @impl Table
  def table(%Channel{} = channel) do
    [
      {"id", Snowflake.dump(channel.id)},
      {"guild_id", Snowflake.dump(channel.guild_id)},
      # {"last_message_id", Snowflake.dump(channel.last_message_id)},
      # {"owner_id", Snowflake.dump(channel.owner_id)},
      # {"parent_id", Snowflake.dump(channel.parent_id)},
      {"last_pin_timestamp", channel.last_pin_timestamp},
      {"name", channel.name},
      {"nsfw", channel.nsfw},
      {"position", channel.position},
      {"topic", channel.topic},
      {"type", channel.type},
      {"user_limit", channel.user_limit},
      {"create_message", {:erl_func, &create_message/2}}
    ]
  end

  def create_message([{:tref, _} = this, content], lua) do
    channel_id = Table.fetch!(lua, this, "id")
    Discord.create_message([channel_id, content], lua)
  end
end
