defmodule HookProxy.WebHookController do
  use HookProxy.Web, :controller

  def forward(conn, _params) do
    IO.inspect conn
    print_body Plug.Conn.read_body(conn)
    Plug.Conn.send_resp(conn, 200, "Success!")
  end

  def print_body({status, body, conn}) do
    IO.inspect body
  end
end