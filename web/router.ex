defmodule HookProxy.Router do
  use HookProxy.Web, :router

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HookProxy do
    pipe_through :api

    post "/webhook/#{System.get_env("SLACK_WEBHOOK_URL")}", SlackWebhookController, :webhook
  end
end
