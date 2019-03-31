defmodule Lou.Discord.EventHandler do
  @moduledoc """
  Responsible for acting upon Discord events
  """
  alias Lou.Discord.{
    EventRouter,
    GuildSupervisor,
    GuildWorker
  }

  use GenServer

  def start_link(args) do
    GenStage.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:consumer, %{ready: nil}, [subscribe_to: [EventRouter]]}
  end

  def handle_events(events, _from, state) do
    state = Enum.reduce(events, state, &handle_discord_event/2)
    {:noreply, [], state}
  end

  def handle_discord_event({:READY, {data}}, state) do
    %{state | ready: data}
  end

  # TODO(Connor) try to stop a guild worker here
  def handle_discord_event({:GUILD_UNAVAILABLE, {_guild}}, state) do
    state
  end

  def handle_discord_event({:GUILD_AVAILABLE, {guild}}, state) do
    _ = GuildSupervisor.start_child(guild, state.ready)
    state
  end

  def handle_discord_event({:GUILD_CREATE, {guild}}, state) do
    _ = GuildSupervisor.start_child(guild, state.ready)
    state
  end

  def handle_discord_event({:MESSAGE_CREATE, {message}}, state) do
    _ = GuildWorker.message_create(message)
    state
  end

  def handle_discord_event({:MESSAGE_REACTION_ADD, {reaction}}, state) do
    _ = GuildWorker.message_reaction_add(reaction)
    state
  end

  def handle_discord_event({:TYPING_START, {typing_start}}, state) do
    _ = GuildWorker.typing_start(typing_start)
    state
  end

  def handle_discord_event({:PRESENCE_UPDATE, _presences}, state) do
    state
  end

  def handle_discord_event({type, data}, state) do
    IO.inspect({type, data}, label: "unhandled discord event")
    state
  end
end
