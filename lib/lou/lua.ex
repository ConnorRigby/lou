defmodule Lou.Lua do
  @type t() :: tuple()
  @type table() :: [{any, any}]

  @spec init() :: t()
  def init do
    :luerl.init()
  end

  @spec load_module(t(), String.t(), module) :: t()
  def load_module(lua, name, module) do
    :luerl.load_module([name], module, lua)
  end

  @spec alloc_table(t(), table()) :: t()
  def alloc_table(lua, table) do
    :luerl_emul.alloc_table(table, lua)
  end

  @spec set_table(t(), Path.t(), any()) :: t()
  def set_table(lua, path, value) do
    IO.puts("setting table: #{inspect(path)} #{inspect(value)}")
    :luerl.set_table(path, value, lua)
  end

  @spec set_table_keys(t(), Path.t(), table) :: t()
  def set_table_keys(lua, path, table) do
    {lfp, lua} = :luerl.encode_list(path, lua)
    :luerl_emul.set_table_keys(lfp, table, lua)
  end

  def set_table_key(lua, table, key, value) do
    :luerl_emul.set_table_key(table, key, value, lua)
  end

  def decode(lua, data) do
    :luerl.decode(data, lua)
  end

  @spec eval(t(), String.t()) :: {:ok, any()} | {:error, any()}
  def eval(lua, hook) when is_binary(hook) do
    :luerl.eval(hook, lua)
  end
end
