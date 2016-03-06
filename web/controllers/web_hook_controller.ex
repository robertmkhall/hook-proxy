defmodule HookProxy.WebHookController do
  use HookProxy.Web, :controller

  alias HookProxy.SlackClient, as: Slack
  alias HookProxy.GithubToSlackAdapter, as: GithubAdapter

  def process_webhook(conn, _params) do
    conn
    |> forward_to_slack
    |> send_response(conn)
  end

  def response_body(response) do
    Map.get(response, :body)
  end

  def response_status_code(response) do
    Map.get(response, :status_code)
  end

  def forward_to_slack(conn) do
    conn
    |> slack_payload
    |> Slack.post
  end

  def send_response({_status, response}, conn) do
    Plug.Conn.send_resp(conn, response_status_code(response), response_body(response))
  end

  def slack_payload(conn) do
    GithubAdapter.slack_request(conn)
  end
end
