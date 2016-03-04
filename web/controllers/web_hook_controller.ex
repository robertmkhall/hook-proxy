defmodule HookProxy.WebHookController do
  use HookProxy.Web, :controller

  def forward(conn, _params) do
    print_body Plug.Conn.read_body(conn)
    conn
  end

  def print_body({status, body, conn}) do
    IO.inspect body
  end
end