defmodule HookProxy.PageController do
  use HookProxy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
