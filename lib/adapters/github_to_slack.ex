defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.GitHubPullRequest, as: PullRequest
  alias HookProxy.SlackClient, as: Slack
  alias HookProxy.GitHubWebhook.Repo, as: GithubRepo
  alias HookProxy.GitHubWebhook.User, as: GithubUser

  def slack_request("pull_request", payload) do
    {:ok, json("Pull request", payload, PullRequest.slack_title(payload))}
  end

  def slack_request(_webhook_type, _payload) do
    {:error, "unsupported webhook type"}
  end

  defp json(display_type, payload, title) do
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
            "value": "*#{title}*",
          }
        ]
      }
    ]}
  end

  defp webhook_pretext(display_type, payload) do
    "[#{repo_name(payload)}] #{display_type} submitted by #{submitter(payload)}"
  end

  defp submitter(payload) do
    "<#{GithubUser.url(payload)}|#{GithubUser.login(payload)}>"
  end

  defp repo_name(payload) do
    GithubRepo.name(payload)
  end
end
