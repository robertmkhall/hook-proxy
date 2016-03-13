defmodule HookProxy.Router do
  use HookProxy.Web, :router

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HookProxy do
    pipe_through :api

    scope "/webhook" do
      post "#{Slack.webhook_url}", SlackWebhookController, :webhook
    end
  end
end
