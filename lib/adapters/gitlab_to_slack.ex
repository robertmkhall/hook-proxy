defmodule HookProxy.Adapters.GitlabToSlack do
  alias HookProxy.Webhooks.Slack.PullRequest, as: SlackPullRequest

  alias HookProxy.Webhooks.Gitlab, as: Webhook
  alias Webhook.{Repo, User, LastCommit}

  def slack_request(conn) do
    slack_request(Webhook.type(conn.body_params), conn.body_params)
  end

  defp slack_request("merge_request", payload) do
    payload
    |> pull_request_data
    |> SlackPullRequest.json
  end

  defp slack_request(_webhook_type, _payload) do
    {:error, "unsupported webhook type"}
  end

  defp pull_request_data(payload) do
    %{
      action: Webhook.action(payload),
      repo_name: Repo.name(payload),
      user_url: User.url(payload),
      user_id: User.login(payload),
      request_url: Webhook.url(payload),
      number: Webhook.number(payload),
      title: Webhook.title(payload),
      slack_user: "gitlab",
      slack_emoji: ":gitlab:"
    }
  end
end
