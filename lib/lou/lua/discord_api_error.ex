defmodule Lou.Lua.DiscordApiError do
  alias Nostrum.Error.ApiError
  alias Lou.{Lua, Lua.Table}
  @behaviour Table

  @impl Table
  def alloc(lua, %ApiError{} = error) do
    Lua.alloc_table(lua, table(error))
  end

  @impl Table
  def install(lua, path, %ApiError{} = error) do
    {error_table, lua} = alloc(lua, error)
    Lua.set_table_keys(lua, path, error_table)
  end

  @impl Table
  def table(%ApiError{} = error) do
    [
      {"message", error.response[:message]},
      {"status_code", error.status_code}
    ]
  end
end
