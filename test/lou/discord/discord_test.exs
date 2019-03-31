defmodule Lou.DiscordTest do
  use Lou.DataCase

  alias Lou.Discord

  describe "discord_servers" do
    alias Lou.Discord.Server

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def server_fixture(attrs \\ %{}) do
      {:ok, server} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discord.create_server()

      server
    end

    test "list_discord_servers/0 returns all discord_servers" do
      server = server_fixture()
      assert Discord.list_discord_servers() == [server]
    end

    test "get_server!/1 returns the server with given id" do
      server = server_fixture()
      assert Discord.get_server!(server.id) == server
    end

    test "create_server/1 with valid data creates a server" do
      assert {:ok, %Server{} = server} = Discord.create_server(@valid_attrs)
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discord.create_server(@invalid_attrs)
    end

    test "update_server/2 with valid data updates the server" do
      server = server_fixture()
      assert {:ok, %Server{} = server} = Discord.update_server(server, @update_attrs)
    end

    test "update_server/2 with invalid data returns error changeset" do
      server = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Discord.update_server(server, @invalid_attrs)
      assert server == Discord.get_server!(server.id)
    end

    test "delete_server/1 deletes the server" do
      server = server_fixture()
      assert {:ok, %Server{}} = Discord.delete_server(server)
      assert_raise Ecto.NoResultsError, fn -> Discord.get_server!(server.id) end
    end

    test "change_server/1 returns a server changeset" do
      server = server_fixture()
      assert %Ecto.Changeset{} = Discord.change_server(server)
    end
  end
end
