defmodule HookProxy.Webhooks.Slack.PullRequest do
  alias HookProxy.Clients.Slack

  def json(data) do
    case data.action do
      "opened" -> {:ok, opened_json(data, "submitted")}
      "open" -> {:ok, opened_json(data, "submitted")}
      "reopened" -> {:ok, opened_json(data, "reopened")}
      "closed" -> {:ok, closed_json(data)}
      unsupported -> {:error, "pull request action '#{unsupported}' not supported"}
    end
  end

  defp opened_json(data, action) do
    %{
      "username": data.slack_user,
      "icon_emoji": data.slack_emoji,
      "text": Slack.custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "#{repo_name(data)} Pull request #{action} by #{user(data)}",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*#{request_title(data)}*",
          }
        ]
      }
    ]}
  end

  defp closed_json(data) do
    %{
      "username": data.slack_user,
      "icon_emoji": data.slack_emoji,
      "mrkdwn": true,
      "attachments": [
      %{
        "mrkdwn_in": ["fields"],
        "fields": [
          %{
            "value": "#{repo_name(data)} Pull request closed: #{request_title(data)} by #{user(data)}",
          }
        ]
      }
    ]}
  end

  defp repo_name(data) do
    "[#{data.repo_name}]"
  end

  defp user(data) do
    "<#{data.user_url}|#{data.user_id}>"
  end

  defp request_title(data) do
    "<#{data.request_url}|##{data.number} #{data.title}>"
  end
end
