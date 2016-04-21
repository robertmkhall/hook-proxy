defmodule HookProxy.GitlabToSlackAdapterTest do
  use ExUnit.Case

  alias HookProxy.Adapters.GitlabToSlack, as: GitlabAdapter

  @gitlab_opened_pull_request_json File.read!("test/fixtures/gitlab_opened_pull_request.json")

  @custom_message "check out this sweet pull request"

  setup do
    Application.put_env :hook_proxy, :slack,
      custom_message: @custom_message
  end

  test "request_json returns slack webhook opened pull request json" do
    conn = %{body_params: Poison.decode! @gitlab_opened_pull_request_json}
    {_, json} = GitlabAdapter.slack_request(conn)

    assert Map.equal?(json, expected_open_pull_request_json)
  end

  def expected_open_pull_request_json do
    %{"username": "gitlab",
      "icon_emoji": ":gitlab:",
      "text": @custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "[awesome_project] Pull request submitted by <http://www.gravatar.com/avatar/e64c7d89f26bd19|root>",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*<http://example.com/diaspora/merge_requests/1|#1 Some awesome changes>*"
          }
        ]
      }]
    }
  end
end
