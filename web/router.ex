defmodule HookProxy.Router do
  use HookProxy.Web, :router

  require Logger

  alias HookProxy.SlackClient, as: Slack

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HookProxy do
    pipe_through :api

    post "/webhook/:a/:b/:c", SlackWebhookController, :webhook
  end
end
