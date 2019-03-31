defmodule Lou.Lua.DiscordGuild do
  alias Nostrum.{
    Snowflake,
    Struct.Guild
    # Struct.Channel,
    # Struct.Guild.Role,
    # Struct.Guild.Member
  }

  alias Lou.{
    Lua,
    Lua.Table,
    Lua.DiscordChannel,
    Lua.DiscordGuildRole,
    Lua.DiscordGuildMember
  }

  @behaviour Table

  @impl Table
  def alloc(lua, %Guild{} = guild) do
    lua
    |> Table.alloc(table(guild))
    |> Table.alloc_map(DiscordGuildRole, &Snowflake.dump/1, "roles", guild.roles)
    |> Table.alloc_map(DiscordGuildMember, &Snowflake.dump/1, "members", guild.members)
    |> Table.alloc_map(DiscordChannel, &Snowflake.dump/1, "channels", guild.channels)
  end

  @impl Table
  def install(lua, path, %Guild{} = guild) do
    {guild_table, lua} = alloc(lua, guild)
    Lua.set_table_keys(lua, path, guild_table)
  end

  @impl Table
  def table(%Guild{} = guild) do
    [
      {"name", guild.name},
      {"id", Snowflake.dump(guild.id)},
      {"system_channel_id", Snowflake.dump(guild.system_channel_id)},
      {"owner_id", Snowflake.dump(guild.system_channel_id)},
      {"unavailable", guild.unavailable},
      {"joined_at", guild.joined_at}
    ]
  end
end
