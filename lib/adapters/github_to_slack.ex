defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.SlackPullRequest

  alias HookProxy.GitHubWebhook, as: Webhook
  alias Webhook.{Repo, User, PullRequest}

  def slack_request(conn) do
    slack_request(webhook_type(conn.req_headers), conn.body_params)
  end

  defp slack_request("pull_request", payload) do
    payload
    |> pull_request_data
    |> SlackPullRequest.json
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

  defp pull_request_data(payload) do
    %{
      action: Webhook.action(payload),
      repo_name: Repo.name(payload),
      user_url: User.url(payload),
      user_id: User.login(payload),
      request_url: PullRequest.url(payload),
      number: Webhook.number(payload),
      title: PullRequest.title(payload),
      slack_user: "github",
      slack_emoji: ":github:"
    }
  end
end
