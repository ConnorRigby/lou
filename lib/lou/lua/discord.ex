defmodule Lou.Lua.Discord do
  @moduledoc """
  Responsible for exposing Discord API functions to Lua
  """
  alias Lou.{Lua, Lua.Table, Lua.DiscordMessage, Lua.DiscordApiError, Lua.DiscordEmbed}
  @behaviour Lua.Module

  alias Nostrum.{Api, Snowflake}
  require Logger

  def install(lua) do
    Lua.alloc_table(lua, table())
  end

  def table() do
    [
      {"create_message", {:erl_func, &create_message/2}},
      {"create_reaction", {:erl_func, &create_reaction/2}},
      {"edit_message", {:erl_func, &edit_message/2}},
      {"delete_message", {:erl_func, &delete_message/2}},
      {"update_status", {:erl_func, &update_status/2}},
      {"new_embed", {:erl_func, &new_embed/2}}
    ]
  end

  def create_message([channel_id, {:tref, _} = table], lua) do
    "Elixir.Lou.Lua.DiscordEmbed" = Table.fetch!(lua, table, "__struct__")
    {:userdata, embed} = Table.fetch!(lua, table, "_embed")
    IO.puts("here")

    with {:ok, channel_id} <- Snowflake.cast(channel_id),
         {:ok, message} <- Api.create_message(channel_id, embed: embed) do
      {table, lua} = DiscordMessage.alloc(lua, message)
      {[table, nil], lua}
    else
      error -> handle_http_error(error, :create_message, lua)
    end
  end

  def create_message([channel_id, content], lua) when is_binary(content) do
    with {:ok, channel_id} <- Snowflake.cast(channel_id),
         {:ok, message} <- Api.create_message(channel_id, content: content) do
      {table, lua} = DiscordMessage.alloc(lua, message)
      {[table, nil], lua}
    else
      error -> handle_http_error(error, :create_message, lua)
    end
  end

  def edit_message([channel_id, message_id, content], lua) do
    with {:ok, channel_id} <- Snowflake.cast(channel_id),
         {:ok, message_id} <- Snowflake.cast(message_id),
         {:ok, message} <- Api.edit_message(channel_id, message_id, content: content) do
      {table, lua} = DiscordMessage.alloc(lua, message)
      {[table, nil], lua}
    else
      error -> handle_http_error(error, :edit_message, lua)
    end
  end

  def delete_message([channel_id, message_id], lua) do
    with {:ok, channel_id} <- Snowflake.cast(channel_id),
         {:ok, message_id} <- Snowflake.cast(message_id),
         {:ok} <- Api.delete_message(channel_id, message_id) do
      {[nil, nil], lua}
    else
      error -> handle_http_error(error, :delete_message, lua)
    end
  end

  def create_reaction([channel_id, message_id, emoji], lua) do
    with {:ok, channel_id} <- Snowflake.cast(channel_id),
         {:ok, message_id} <- Snowflake.cast(message_id),
         {:ok} <- Api.create_reaction(channel_id, message_id, emoji) do
      {[nil, nil], lua}
    else
      error -> handle_http_error(error, :create_reaction, lua)
    end
  end

  def update_status([status, game], lua) do
    with {:ok, status} <- decode_status(status),
         :ok <- Api.update_status(status, game) do
      {[nil, nil], lua}
    else
      error -> handle_http_error(error, :update_status, lua)
    end
  end

  defp decode_status("dnd"), do: {:ok, :dnd}
  defp decode_status("idle"), do: {:ok, :idle}
  defp decode_status("online"), do: {:ok, :online}
  defp decode_status("invisible"), do: {:ok, :invisible}
  defp decode_status(_), do: {:error, "unknown status"}

  defp handle_http_error(:error, function_name, lua) do
    Logger.error("[#{function_name}] Error encoding/decoding Snowflake")
    {[nil, "bad id"], lua}
  end

  defp handle_http_error({:error, error}, function_name, lua) do
    Logger.error("[#{function_name}] HTTP error: #{inspect(error)}")
    {error, lua} = DiscordApiError.alloc(lua, error)
    {[nil, error], lua}
  end

  def new_embed(_, lua) do
    {table, lua} = DiscordEmbed.alloc(lua, %Nostrum.Struct.Embed{})
    {[table], lua}
  end
end
