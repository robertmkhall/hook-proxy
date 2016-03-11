defmodule HookProxy.Loaders do
  import Plug.Conn

  def load_webhook_type(conn, _) do
    assign(conn, :webhook_type, webhook_type(conn.req_headers))
  end

  defp webhook_type([]) do
    :not_recognised
  end

  defp webhook_type([head | tail]) do
    case head do
      {"x-github-event", type} -> type
      _ -> webhook_type(tail)
    end
  end
end
