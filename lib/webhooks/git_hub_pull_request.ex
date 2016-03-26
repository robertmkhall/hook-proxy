defmodule HookProxy.GitHubPullRequest do
  alias HookProxy.GitHubWebhook, as: Webhook

  def title(payload) do
    pull_request(payload, "title")
  end

  def url(payload) do
    pull_request(payload, "html_url")
  end

  def slack_title(payload) do
    "<#{url(payload)}|##{Webhook.number(payload)} #{title(payload)}>"
  end

  defp pull_request(payload, key) do
    payload["pull_request"][key]
  end
end
