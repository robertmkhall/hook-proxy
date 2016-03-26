defmodule HookProxy.SlackWebhookController do
  use HookProxy.Web, :controller

  import HookProxy.Loaders

  alias HookProxy.SlackClient, as: Slack
  alias HookProxy.GithubToSlackAdapter, as: GithubAdapter

  plug :load_webhook_type

  def webhook(conn, params) do
    conn
    |> forward_to_slack(params)
    |> send_response(conn)
  end

  defp forward_to_slack(conn, params) do
    case GithubAdapter.request_json(conn.assigns.webhook_type, conn.body_params) do
      {:ok, request_json} -> Poison.encode!(request_json) |> Slack.post_webhook(params)
      {:error, error_message} -> {:error, %{status_code: 400, body: error_message}}
    end
  end

  defp send_response({_status, response}, conn) do
    Plug.Conn.send_resp(conn, response.status_code, response.body)
  end
end
