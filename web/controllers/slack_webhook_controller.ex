defmodule HookProxy.SlackWebhookController do
  use HookProxy.Web, :controller

  import HookProxy.Loaders

  alias HookProxy.Clients.Slack
  alias HookProxy.Adapters.GithubToSlack, as: GithubAdapter
  alias HookProxy.Adapters.GitlabToSlack, as: GitlabAdapter

  plug :load_webhook_source

  def webhook(conn, params) do
    response = case slack_request(conn.assigns.webhook_source, conn) do
      {:ok, json} -> forward_to_slack(json, params)
      {:error, error} -> {:error, %{status_code: 400, body: error}}
    end

    IO.inspect response

    send_response(conn, response)
  end

  defp slack_request(:github, conn) do
    GithubAdapter.slack_request(conn)
  end

  defp slack_request(:gitlab, conn) do
    GitlabAdapter.slack_request(conn)
  end

  defp forward_to_slack(json, params) do
    json
    |> Poison.encode!
    |> Slack.post_webhook(params)
  end

  defp send_response(conn, {_status, response}) do
    Plug.Conn.send_resp(conn, response.status_code, response.body)
  end
end
