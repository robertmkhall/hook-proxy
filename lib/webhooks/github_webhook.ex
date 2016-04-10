defmodule HookProxy.Webhooks.GitHub do
  def number(payload), do: payload["number"]

  def action(payload), do: payload["action"]

  defmodule Repo do
    defp repo(payload, key), do: payload["repository"][key]

    def name(payload), do: repo(payload, "full_name")
  end

  defmodule User do
    defp user(payload, key), do: payload["sender"][key]

    def login(payload), do: user(payload, "login")

    def url(payload), do: user(payload, "html_url")
  end

  defmodule PullRequest do
    defp pull_request(payload, key), do: payload["pull_request"][key]

    def title(payload), do: pull_request(payload, "title")

    def url(payload), do: pull_request(payload, "html_url")
  end
end
