defmodule HookProxy.GitHubWebhook do
  def number(payload) do
    Map.get(payload, "number")
  end

  defmodule Repo do
    def repo(payload, key) do
      payload
      |> Map.get("repository")
      |> Map.get(key)
    end

    def name(payload) do
      repo(payload, "full_name")
    end
  end

  defmodule User do
    def user(payload, key) do
      payload
      |> Map.get("sender")
      |> Map.get(key)
    end

    def login(payload) do
      user(payload, "login")
    end

    def url(payload) do
      user(payload, "html_url")
    end
  end
end
