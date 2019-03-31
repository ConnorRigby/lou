defmodule Lou.Discord.Snowflake do
  @behaviour Ecto.Type

  def cast(data) do
    Nostrum.Snowflake.cast(data)
  end

  def dump(data) do
    {:ok, Nostrum.Snowflake.dump(data)}
  end

  def load(data) do
    Nostrum.Snowflake.cast(data)
  end

  def type, do: :string
end
