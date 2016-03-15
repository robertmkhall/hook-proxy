defmodule HookProxy.Router do
  use HookProxy.Web, :router

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HookProxy do
    pipe_through :api

    post "/webhook/T02GEFU92/B0QJEDM5X/Upu3iT4s4gwP3tEZwd93mKrI", SlackWebhookController, :webhook
  end
end
