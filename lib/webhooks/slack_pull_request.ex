defmodule HookProxy.SlackPullRequest do
  alias HookProxy.SlackClient, as: Slack

  alias HookProxy.GitHubWebhook, as: Webhook
  alias Webhook.Repo, as: GithubRepo
  alias Webhook.User, as: GithubUser
  alias Webhook.PullRequest, as: PullRequest

  def json(payload) do
    json(Webhook.action(payload), payload)
  end

  defp json("opened", payload) do
    %{
      "username": "github",
      "icon_emoji": ":github:",
      "text": Slack.custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "#{repo_name(payload)} Pull request submitted by #{user(payload)}",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*#{request_title(payload)}*",
          }
        ]
      }
    ]}
  end

  defp json("closed", payload) do
    %{
      "username": "github",
      "icon_emoji": ":github:",
      "text": Slack.custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "mrkdwn_in": ["fields"],
        "fields": [
          %{
            "value": "#{repo_name(payload)} Pull request closed: #{request_title(payload)} by #{user(payload)}",
          }
        ]
      }
    ]}
  end

  defp repo_name(payload) do
    "[#{GithubRepo.name(payload)}]"
  end

  defp user(payload) do
    "<#{GithubUser.url(payload)}|#{GithubUser.login(payload)}>"
  end

  defp request_title(payload) do
    "<#{PullRequest.url(payload)}|##{Webhook.number(payload)} #{PullRequest.title(payload)}>"
  end
end
