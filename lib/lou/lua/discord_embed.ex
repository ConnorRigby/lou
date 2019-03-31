defmodule Lou.Lua.DiscordEmbed do
  @moduledoc """
  Responsible for exposing Discord embed functions to Lua
  """
  alias Nostrum.Struct.Embed
  alias Lou.{Lua, Lua.Table}
  @behaviour Table

  @impl Table
  def alloc(lua, %Embed{} = embed) do
    lua
    |> Table.alloc(table(embed))
    |> Table.alloc_userdata("_embed", embed)
  end

  @impl Table
  def install(lua, path, %Embed{} = embed) do
    Table.install(lua, __MODULE__, path, embed)
  end

  @impl Table
  def table(%Embed{} = _embed) do
    [
      {"__struct__", to_string(__MODULE__)},
      {"put_title", {:erl_func, &put_title/2}},
      {"put_field", {:erl_func, &put_field/2}}
    ]
  end

  def put_title([{:tref, _} = this, title], lua) do
    {:userdata, embed} = Table.fetch!(lua, this, "_embed")
    embed = Embed.put_title(embed, title)
    {data, lua} = :luerl.encode({:userdata, embed}, lua)
    lua = Lua.set_table_key(lua, this, "_embed", data)
    {[], lua}
  end

  def put_field([{:tref, _} = this, field, value], lua) do
    {:userdata, embed} = Table.fetch!(lua, this, "_embed")
    embed = Embed.put_field(embed, field, value)
    {data, lua} = :luerl.encode({:userdata, embed}, lua)
    lua = Lua.set_table_key(lua, this, "_embed", data)
    {[], lua}
  end
end
