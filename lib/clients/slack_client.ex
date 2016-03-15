defmodule HookProxy.SlackClient do
  use HTTPoison.Base

  def post(body) do
    post base_url <> "/services/" <> webhook_url, body
  end

  def webhook_url, do: Keyword.fetch!(config, :webhook_url)
  def custom_message, do: Keyword.fetch!(config, :custom_message)

  defp config, do: Application.fetch_env!(:hook_proxy, :slack)
  defp base_url, do: Keyword.fetch!(config, :base_url)
end
