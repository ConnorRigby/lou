defmodule Lou.Lua.Table do
  alias Lou.Lua

  @callback alloc(Lua.t(), term()) :: Lua.t()
  @callback install(Lua.t(), Path.t(), term()) :: Lua.t()
  @callback table(term()) :: Lua.table()

  @type alloced :: {Lua.table(), Lua.t()}

  def fetch!(lua, table, key) do
    table = Lua.decode(lua, table)

    Enum.find_value(table, fn
      {^key, value} -> value
      {_, _} -> false
    end) || raise(KeyError, key: key, term: table)
  end

  def alloc(lua, data) do
    {table, lua} = Lua.alloc_table(lua, data)
    {table, lua}
  end

  def alloc_embed({table, lua}, _module, key, nil) do
    lua = Lua.set_table_key(lua, table, key, nil)
    {table, lua}
  end

  def alloc_embed({table, lua}, module, key, data) do
    {sub_table, lua} = module.alloc(lua, data)
    lua = Lua.set_table_key(lua, table, key, sub_table)
    {table, lua}
  end

  @doc """
  takes structured enumerable data such as

      %{"abc" => %SomeData{id: "abc", key: "value"}}

  and converts it into a lua table:

      {"abc" = {id = "abc", key = "value"}}

  `module` should be a module that implements `Table`
  `key_mutator` should be an annon function that takes the left side of the enum
  `key` is the key where the enumerable should be allocated to
  `data` is the data that will be passed to the `Table` implementation.
  """
  @spec alloc_map(alloced, module, (any -> any), any, any) :: alloced
  def alloc_map({table, lua}, module, key_mutator, key, data) do
    {sub_table, lua} = Lua.alloc_table(lua, [])

    lua =
      Enum.reduce(data, lua, fn
        {id, sub_sub_data}, lua ->
          {sub_sub_table, lua} = module.alloc(lua, sub_sub_data)
          Lua.set_table_key(lua, sub_table, key_mutator.(id), sub_sub_table)
      end)

    lua = Lua.set_table_key(lua, table, key, sub_table)
    {table, lua}
  end

  def install(lua, module, path, data) do
    {table, lua} = module.alloc(lua, data)
    Lua.set_table_keys(lua, path, table)
  end
end
