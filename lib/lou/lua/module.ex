defmodule Lou.Lua.Module do
  @moduledoc """
  A module that can be installed on the Lua state.
  """

  alias Lou.Lua
  @callback install(Lua.t()) :: Lua.t()
end
