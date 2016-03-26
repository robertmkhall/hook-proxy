defmodule HookProxy.GitHubWebhook do
  def number(payload), do: payload["number"]

  defmodule Repo do
    def repo(payload, key), do: payload["repository"][key]

    def name(payload), do: repo(payload, "full_name")
  end

  defmodule User do
    def user(payload, key), do: payload["sender"][key]

    def login(payload), do: user(payload, "login")

    def url(payload), do: user(payload, "html_url")
  end
end
