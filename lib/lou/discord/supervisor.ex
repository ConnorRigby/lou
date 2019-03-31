defmodule Lou.Discord.Supervisor do
  use Supervisor

  alias Lou.Discord.{
    Consumer,
    EventRouter,
    EventHandler,
    GuildSupervisor
  }

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      GuildSupervisor,
      EventRouter,
      EventHandler,
      Consumer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
