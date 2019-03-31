defmodule Lou.Discord.EventRouter do
  @moduledoc """
  This is the producer stage for Discord Message
  """
  use GenStage

  def start_link(args, opts \\ [name: __MODULE__]) do
    GenStage.start_link(__MODULE__, args, opts)
  end

  def init(_args) do
    {:producer, []}
  end

  def handle_demand(demand, events) when demand > 0 do
    {to_process, events} = Enum.split(events, demand)
    {:noreply, to_process, events}
  end

  def handle_cast({type, data}, state) do
    {:noreply, [{type, data}], state}
  end
end
