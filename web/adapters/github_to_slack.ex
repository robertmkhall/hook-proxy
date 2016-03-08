defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.GitHubPullRequest, as: PullRequest
  alias HookProxy.GitHubWebhook, as: Webhook

  def slack_request(conn) do
    slack_request(request_type(conn), request_body(conn))
  end

  defp request_type(conn) do
    conn
    |> request_headers
    |> request_type_header_val
  end

  defp request_type_header_val([]) do
    :not_recognised
  end

  defp request_type_header_val([head | tail]) do
    case head do
      {"x-github-event", type} -> type
      _ -> request_type_header_val(tail)
    end
  end

  defp request_headers(conn) do
    Map.get(conn, :req_headers)
  end

  defp request_body(conn) do
    Map.get(conn, :body_params)
  end

  defp slack_request(type, payload) do
    request_json(type, payload)
    |> Poison.encode!
  end

  defp request_json(type, payload) do
    %{
      "username": "github",
      "icon_emoji": ":trollface:",
      "text": custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "#{webhook_type_message(type, payload)}",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*#{webhook_title(type, payload)}*",
          }
        ]
      }
    ]}
  end

  defp custom_message do
    System.get_env("CUSTOM_SLACK_MESSAGE")
    |> check_custom_message
  end

  defp check_custom_message(msg) do
    if String.length(msg) > 0 do
      "#{msg}\n"
    else
      ""
    end
  end

  defp webhook_type_message(type, payload) do
    "[#{Webhook.repo_name(payload)}] #{format_request_type(type)} submitted by #{Webhook.user_login(payload)}"
  end

  defp format_request_type(type) do
    String.replace(type, "_", " ")
    |> String.capitalize
  end

  defp webhook_title(type, payload) do
    case type do
      "pull_request" -> PullRequest.slack_title(payload)
      _ -> default_message(payload)
    end
  end

  defp default_message(payload) do
    "a change was made..."
  end
end