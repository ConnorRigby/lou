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

    # {guild_table, lua} = Lua.alloc_table(lua, table(guild))
    # {roles_table, lua} = Lua.alloc_table(lua, [])
    # {members_table, lua} = Lua.alloc_table(lua, [])
    # {channels_table, lua} = Lua.alloc_table(lua, [])

    # lua =
    #   Enum.reduce(guild.roles, lua, fn
    #     {id, %Role{} = role}, lua ->
    #       {role_table, lua} = DiscordGuildRole.alloc(lua, role)
    #       Lua.set_table_key(lua, roles_table, Snowflake.dump(id), role_table)
    #   end)

    # lua =
    #   Enum.reduce(guild.members, lua, fn
    #     {id, %Member{} = member}, lua ->
    #       {member_table, lua} = DiscordGuildMember.alloc(lua, member)
    #       Lua.set_table_key(lua, members_table, Snowflake.dump(id), member_table)
    #   end)

    # lua =
    #   Enum.reduce(guild.channels, lua, fn
    #     {id, %Channel{} = channel}, lua ->
    #       {channel_table, lua} = DiscordChannel.alloc(lua, channel)
    #       Lua.set_table_key(lua, channels_table, Snowflake.dump(id), channel_table)
    #   end)

    # lua = 
    #   lua
    #   |> Lua.set_table_key(guild_table, "roles", roles_table)
    #   |> Lua.set_table_key(guild_table, "members", members_table)
    #   |> Lua.set_table_key(guild_table, "channels", channels_table)

    # {guild_table, lua}
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
