defmodule HookProxy.SlackClient do
  use HTTPoison.Base

  def post(body) do
    post "https://hooks.slack.com/services/" <> System.get_env("SLACK_WEBHOOK_URL"), body
  end
end
