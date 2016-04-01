defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.SlackPullRequest, as: PullRequest

  def slack_request(conn) do
    slack_request(webhook_type(conn.req_headers), conn.body_params)
  end

  defp slack_request("pull_request", payload) do
    PullRequest.json(payload)
  end

  defp slack_request(_webhook_type, _payload) do
    {:error, "unsupported webhook type"}
  end

  defp webhook_type([]) do
    :not_provided
  end

  defp webhook_type([head | tail]) do
    case head do
      {"x-github-event", type} -> type
      _ -> webhook_type(tail)
    end
  end
end
