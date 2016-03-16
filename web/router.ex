defmodule HookProxy.Router do
  use HookProxy.Web, :router

  require Logger

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HookProxy do
    pipe_through :api

    Logger.info "Slack.webhook_slug=/webhook/#{Slack.webhook_slug}"

    post "/webhook/#{Slack.webhook_slug}", SlackWebhookController, :webhook
  end
end
