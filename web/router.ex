defmodule HookProxy.Router do
  use HookProxy.Web, :router

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HookProxy do
    pipe_through :api

    post "/webhook/#{Slack.webhook_slug}", SlackWebhookController, :webhook
  end
end
