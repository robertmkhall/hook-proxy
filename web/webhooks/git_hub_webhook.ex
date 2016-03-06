defmodule HookProxy.GitHubWebhook do
  def repo(payload, key) do
    payload
    |> Map.get("repository")
    |> Map.get(key)
  end

  def repo_name(payload) do
    repo(payload, "full_name")
  end

  def user(payload, key) do
    payload
    |> Map.get("sender")
    |> Map.get(key)
  end

  def user_login(payload) do
    user(payload, "login")
  end

  def number(payload) do
    Map.get(payload, "number")
  end
end
