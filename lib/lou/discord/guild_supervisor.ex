defmodule Lou.Discord.GuildSupervisor do
  use DynamicSupervisor
  alias Lou.Discord.GuildWorker

  @doc "Start a guild worker"
  def start_child(supervisor \\ __MODULE__, guild, ready) do
    spec = {GuildWorker, guild: guild, ready: ready}
    DynamicSupervisor.start_child(supervisor, spec)
  end

  @doc false
  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
