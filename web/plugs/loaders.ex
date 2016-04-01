defmodule HookProxy.Loaders do
  import Plug.Conn

  def load_webhook_source(conn, _) do
    assign(conn, :webhook_source, webhook_source(conn))
  end

  defp webhook_source(conn) do
    cond do
      Enum.any?(conn.req_headers, fn({key, val}) -> key == "x-github-event" end) ->
        :github
      Map.has_key?(conn.body_params, "object_kind") ->
        :gitlab
      true ->
        :unsupported
    end
  end
end
