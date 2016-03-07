defmodule HookProxy.GitHubPullRequest do
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

  def slack_title(payload) do
    "<#{url(payload)}|#{title(payload)}>"
  end
end
