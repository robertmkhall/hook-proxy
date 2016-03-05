defmodule HookProxy.WebHookController do
  use HookProxy.Web, :controller
  alias HookProxy.SlackClient, as: Slack

  def forward(conn, _params) do
    conn
    |> request_body
    |> forward_to_slack
    |> send_response(conn)
  end

  def request_body(conn) do
    Map.get(conn, :body_params)
  end

  def response_body(response) do
    Map.get(response, :body)
  end

  def response_status_code(response) do
    Map.get(response, :status_code)
  end

  def forward_to_slack(body) do
    body
    |> Poison.encode!
    |> Slack.post
  end

  def send_response({_status, response}, conn) do
     Plug.Conn.send_resp(conn, response_status_code(response), response_body(response))
  end
end