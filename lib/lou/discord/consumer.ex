defmodule Lou.Discord.Consumer do
  use Nostrum.Consumer
  alias Lou.Discord.EventRouter

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({type, data, _state}) do
    GenStage.cast(EventRouter, {type, data})
  end
end
