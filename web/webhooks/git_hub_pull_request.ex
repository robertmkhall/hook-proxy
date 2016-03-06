defmodule HookProxy.GitHubPullRequest do
  alias HookProxy.GitHubWebhook, as: Webhook

  def pull_request(payload, key) do
    payload
    |> Map.get("pull_request")
    |> Map.get(key)
  end

  def head(payload) do
    pull_request(payload, "head")
  end

  def title(payload) do
    pull_request(payload, "title")
  end

  def url(payload) do
    pull_request(payload, "html_url")
  end

  def slack_message(payload) do
    %{"attachments": [
      %{
        "pretext": "[#{Webhook.repo_name(payload)}] Pull request submitted by #{Webhook.user_login(payload)}",
        "color": "good",
        "fields": [
          %{
            "value": "##{Webhook.number(payload)} #{title(payload)}",
            "short": false
          }
        ]
      }
    ]}
  end

  def title(payload) do
    "<#{url(payload)}|#{title(payload)}>"
  end
end
