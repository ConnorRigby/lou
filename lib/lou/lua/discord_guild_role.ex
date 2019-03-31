defmodule Lou.Lua.DiscordGuildRole do
  alias Nostrum.{Snowflake, Struct.Guild.Role}
  alias Lou.Lua.Table
  @behaviour Table

  @impl Table
  def alloc(lua, %Role{} = role) do
    Table.alloc(lua, table(role))
  end

  @impl Table
  def install(lua, path, %Role{} = role) do
    Table.install(lua, __MODULE__, path, role)
  end

  @impl Table
  def table(%Role{} = role) do
    [
      {"id", Snowflake.dump(role.id)},
      {"hoist", role.hoist},
      {"managed", role.managed},
      {"mentionable", role.mentionable},
      {"name", role.name},
      {"permissions", role.permissions},
      {"position", role.position}
    ]
  end
end
