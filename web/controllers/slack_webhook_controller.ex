defmodule HookProxy.SlackWebhookController do
  use HookProxy.Web, :controller

  import HookProxy.Loaders

  alias HookProxy.SlackClient, as: Slack
  alias HookProxy.GithubToSlackAdapter, as: GithubAdapter

  plug :load_webhook_type

  def webhook(conn, _params) do
    IO.puts "webhook-url= #{Slack.webhook_url}"

    conn
    |> forward_to_slack
    |> send_response(conn)
  end

  defp forward_to_slack(conn) do
    case GithubAdapter.request_json(conn) do
      {:ok, request_json} -> Slack.post(request_json)
      {:error, error_message} -> {:error, %{status_code: 400, body: error_message}}
    end
  end

  defp send_response({_status, response}, conn) do
    Plug.Conn.send_resp(conn, response.status_code, response.body)
  end
end
