defmodule HookProxy.Router do
  use HookProxy.Web, :router

  require Logger

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/hookproxy/api", HookProxy do
    pipe_through :api

    post "/webhook/slack/:slug_1/:slug_2/:slug_3", SlackWebhookController, :webhook
  end
end
