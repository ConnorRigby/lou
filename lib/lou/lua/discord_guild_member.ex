defmodule Lou.Lua.DiscordGuildMember do
  alias Nostrum.Struct.Guild.Member
  alias Lou.Lua.Table
  @behaviour Table

  @impl Table
  def alloc(lua, %Member{} = member) do
    Table.alloc(lua, table(member))
  end

  @impl Table
  def install(lua, path, %Member{} = member) do
    Table.install(lua, __MODULE__, path, member)
  end

  @impl Table
  def table(%Member{} = member) do
    [
      {"deaf", member.deaf},
      {"mute", member.mute},
      {"joined_at", member.joined_at},
      {"nick", member.nick}
    ]
  end
end
