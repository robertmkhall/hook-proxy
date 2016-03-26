defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.GitHubPullRequest, as: PullRequest
  alias HookProxy.GitHubWebhook, as: Webhook
  alias HookProxy.SlackClient, as: Slack

  def request_json("pull_request", payload) do
    {:ok, json("Pull request", payload)}
  end

  def request_json(_webhook_type, _payload) do
    {:error, "unsupported webhook type"}
  end

  defp json(display_type, payload) do
    %{
      "username": "github",
      "icon_emoji": ":github:",
      "text": Slack.custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": webhook_pretext(display_type, payload),
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*#{webhook_title(payload)}*",
          }
        ]
      }
    ]}
  end

  defp webhook_pretext(display_type, payload) do
    "[#{repo_name(payload)}] #{display_type} submitted by #{submitter(payload)}"
  end

  defp submitter(payload) do
    "<#{Webhook.User.url(payload)}|#{Webhook.User.login(payload)}>"
  end

  defp repo_name(payload) do
    Webhook.Repo.name(payload)
  end

  defp webhook_title(payload) do
    PullRequest.slack_title(payload)
  end
end
