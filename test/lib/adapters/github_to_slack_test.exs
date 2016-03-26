defmodule HookProxy.GithubToSlackAdapterTest do
  use ExUnit.Case

  alias HookProxy.GithubToSlackAdapter, as: GithubAdapter

  @github_json File.read!("test/fixtures/github_pull_request.json")
  @custom_message "check out this sweet pull request"

  setup do
    Application.put_env :hook_proxy, :slack,
      custom_message: @custom_message
  end

  test "request_json returns slack webhook request json" do
    {status, json} = GithubAdapter.request_json("pull_request", Poison.decode! @github_json)

    assert Map.equal?(json, expected_slack_json)
  end

  def expected_slack_json do
    %{"username": "github",
      "icon_emoji": ":github:",
      "text": @custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "[wackaday] Pull request submitted by <http://some.url.com/timmy_mallet|@timmymallett>",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*<http://github.com/pull_request|#23 some changes made to github>*",
          }
        ]
      }]
    }
  end
end
