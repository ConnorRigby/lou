defmodule LouWeb.PageController do
  use LouWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
