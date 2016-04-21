defmodule HookProxy.Webhooks.Gitlab do
  def type(payload), do: payload["object_kind"]

  def action(payload), do: attributes(payload)["action"]

  def url(payload), do: attributes(payload)["url"]

  def number(payload), do: attributes(payload)["iid"]

  def title(payload), do: attributes(payload)["title"]

  defp attributes(payload), do: payload["object_attributes"]

  defmodule Repo do
    defp repo(payload, key), do: payload["object_attributes"]["source"][key]

    def name(payload), do: repo(payload, "name")
  end

  defmodule User do
    defp user(payload, key), do: payload["user"][key]

    def url(payload), do: user(payload, "avatar_url")

    def login(payload), do: user(payload, "username")
  end

  defmodule LastCommit do
    defp last_commit(payload, key), do: payload["object_attributes"]["last_commit"][key]

    def title(payload), do: last_commit(payload, "message")
  end
end
