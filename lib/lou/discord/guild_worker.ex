defmodule Lou.Discord.GuildWorker do
  use GenServer
  require Logger

  alias Lou.{
    Lua,
    Lua.DiscordGuild,
    Lua.DiscordMessage,
    Lua.DiscordUser
  }

  def start_link(args) do
    %{id: guild_id} = Keyword.fetch!(args, :guild)
    GenServer.start_link(__MODULE__, args, name: name(guild_id))
  end

  def message_create(%{guild_id: guild_id} = message) do
    GenServer.cast(name(guild_id), {:message_create, message})
  end

  def message_reaction_add(%{guild_id: guild_id} = reaction_add) do
    GenServer.cast(name(guild_id), {:message_reaction_add, reaction_add})
  end

  def typing_start(%{guild_id: guild_id} = typing_start) do
    GenServer.cast(name(guild_id), {:typing_start, typing_start})
  end

  def init(args) do
    guild = Keyword.fetch!(args, :guild)
    ready = Keyword.fetch!(args, :ready)
    Logger.info("GuildWorker #{guild.name} #{guild.id}")

    lua =
      Lua.init()
      |> Lua.load_module("discord", Lua.Discord)
      |> DiscordUser.install(["user"], struct(Nostrum.Struct.User, ready.user))

    {:ok, %{guild: guild, lua: lua}}
  end

  def handle_cast({:message_create, message}, state) do
    hook = File.read!("nou.lua")

    state.lua
    |> DiscordGuild.install(["guild"], state.guild)
    |> DiscordMessage.install(["message"], message)
    |> Lua.eval(hook)
    |> IO.inspect(label: "eval")

    {:noreply, state}
  end

  def handle_cast({:message_reaction_add, _message_reaction_add}, state) do
    {:noreply, state}
  end

  def handle_cast({:typing_start, _typing_start}, state) do
    {:noreply, state}
  end

  # TODO(Connor) - this should be a `{:via, Module}`
  defp name(guild_id) do
    Module.concat(__MODULE__, to_string(guild_id))
  end
end
