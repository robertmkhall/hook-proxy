defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.SlackPullRequest, as: PullRequest

  def slack_request("pull_request", payload) do
    {:ok, PullRequest.json(payload)}
  end

  def slack_request(_webhook_type, _payload) do
    {:error, "unsupported webhook type"}
  end
end
