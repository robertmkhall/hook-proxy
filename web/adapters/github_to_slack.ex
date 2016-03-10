defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.GitHubPullRequest, as: PullRequest
  alias HookProxy.GitHubWebhook, as: Webhook

  def slack_request(conn) do
    slack_request(request_type(conn.req_headers), conn.body_params)
  end

  defp request_type([]) do
    :not_recognised
  end

  defp request_type([head | tail]) do
    case head do
      {"x-github-event", type} -> type
      _ -> request_type(tail)
    end
  end

  defp slack_request(type, payload) do
    request_json(type, payload)
    |> Poison.encode!
  end

  defp request_json(type, payload) do
    %{
      "username": "github",
      "icon_emoji": ":github:",
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
    "[#{Webhook.Repo.name(payload)}] #{format_request_type(type)} submitted by <#{Webhook.User.url(payload)}|#{Webhook.User.login(payload)}>"
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