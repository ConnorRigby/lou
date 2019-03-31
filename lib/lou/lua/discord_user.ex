defmodule Lou.Lua.DiscordUser do
  alias Nostrum.{Snowflake, Struct.User}
  alias Lou.{Lua.Discord, Lua.Table}

  @behaviour Table

  @impl Table
  def alloc(lua, %User{} = user) do
    Table.alloc(lua, table(user))
  end

  @impl Table
  def install(lua, path, %User{} = user) do
    Table.install(lua, __MODULE__, path, user)
  end

  @impl Table
  def table(%User{} = user) do
    [
      {"id", Snowflake.dump(user.id)},
      {"avatar", user.avatar},
      {"username", user.username},
      {"reply", {:erl_func, &reply/2}}
    ]
  end

  def reply([{:tref, _} = this, channel_id, content], lua) when is_binary(content) do
    id = Table.fetch!(lua, this, "id")
    Discord.create_message([channel_id, "<@!#{id}> #{content}"], lua)
  end
end
