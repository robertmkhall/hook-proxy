defmodule HookProxy.GithubToSlackAdapterTest do
  use ExUnit.Case

  alias HookProxy.GithubToSlackAdapter, as: GithubAdapter

  @github_opened_pull_request_json File.read!("test/fixtures/github_opened_pull_request.json")
  @github_reopened_pull_request_json File.read!("test/fixtures/github_reopened_pull_request.json")
  @github_closed_pull_request_json File.read!("test/fixtures/github_closed_pull_request.json")
  @github_unknown_pull_request_json File.read!("test/fixtures/github_unknown_pull_request.json")

  @custom_message "check out this sweet pull request"

  setup do
    Application.put_env :hook_proxy, :slack,
      custom_message: @custom_message
  end

  test "request_json returns slack webhook opened pull request json" do
    {_, json} = GithubAdapter.slack_request("pull_request", Poison.decode! @github_opened_pull_request_json)

    assert Map.equal?(json, expected_open_pull_request_json("submitted"))
  end

  test "request_json returns slack webhook reopened pull request json" do
    {_, json} = GithubAdapter.slack_request("pull_request", Poison.decode! @github_reopened_pull_request_json)

    assert Map.equal?(json, expected_open_pull_request_json("reopened"))
  end

  test "request_json returns slack webhook closed pull request json" do
    {_, json} = GithubAdapter.slack_request("pull_request", Poison.decode! @github_closed_pull_request_json)

    assert Map.equal?(json, expected_closed_pull_request_json)
  end

  test "request_json for unsupported request type returns error message" do
    {status, error_message} = GithubAdapter.slack_request("unknown_type", Poison.decode! @github_opened_pull_request_json)

    assert {status, error_message} == {:error, "unsupported webhook type"}
  end

  test "request_json for unsupported action returns error message" do
    {status, error_message} = GithubAdapter.slack_request("pull_request", Poison.decode! @github_unknown_pull_request_json)

    assert {status, error_message} == {:error, "unknown pull request action not supported"}
  end

  def expected_open_pull_request_json(action) do
    %{"username": "github",
      "icon_emoji": ":github:",
      "text": @custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "pretext": "[wackaday] Pull request #{action} by <http://some.url.com/timmy_mallet|@timmymallett>",
        "color": "good",
        "mrkdwn_in": ["fields", "pretext"],
        "fields": [
          %{
            "value": "*<http://github.com/pull_request|#23 some changes made to github>*"
          }
        ]
      }]
    }
  end

  def expected_closed_pull_request_json do
    %{"username": "github",
      "icon_emoji": ":github:",
      "text": @custom_message,
      "mrkdwn": true,
      "attachments": [
      %{
        "mrkdwn_in": ["fields"],
        "fields": [
          %{
            "value": "[wackaday] Pull request closed: <http://github.com/pull_request|#23 some changes made to github> by <http://some.url.com/timmy_mallet|@timmymallett>"
          }
        ]
      }]
    }
  end
end
