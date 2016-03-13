defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.GitHubPullRequest, as: PullRequest
  alias HookProxy.GitHubWebhook, as: Webhook
  alias HookProxy.SlackClient, as: Slack

  def request_json(conn) do
    case request_json(conn.assigns.webhook_type, conn.body_params) do
      {:ok, request_json} -> {:ok,  request_json |> Poison.encode!}
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  defp request_json("pull_request", payload) do
    {:ok, request_json("Pull request", payload, PullRequest.slack_title(payload))}
  end

  defp request_json(_, payload) do
    {:error, "unsupported webhook type"}
  end

  defp request_json(display_type, payload, webhook_title) do
    %{
      "username": "github",
      "icon_emoji": ":github:",
      "text": Slack.custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "#{webhook_type_message(display_type, payload)}",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*#{webhook_title}*",
          }
        ]
      }
    ]}
  end

  defp webhook_type_message(display_type, payload) do
    "[#{Webhook.Repo.name(payload)}] #{display_type} submitted by #{webhook_submitter(payload)}"
  end

  defp webhook_submitter(payload) do
    "<#{Webhook.User.url(payload)}|#{Webhook.User.login(payload)}>"
  end
end