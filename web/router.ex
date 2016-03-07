defmodule HookProxy.Router do
  use HookProxy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HookProxy do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", HookProxy do
    pipe_through :api

    scope "/webhook" do
      post "/#{System.get_env("SLACK_WEBHOOK_URL")}", SlackWebHookController, :process_webhook
    end
  end
end
