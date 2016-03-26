defmodule HookProxy.SlackClient do
  use HTTPoison.Base

  def post_webhook(body, params) do
    post "#{base_url}/services/#{params["a"]}/#{params["b"]}/#{params["c"]}", body
  end

  def webhook_slug, do: Keyword.fetch!(config, :webhook_slug)
  def custom_message, do: Keyword.fetch!(config, :custom_message)

  defp config, do: Application.fetch_env!(:hook_proxy, :slack)
  defp base_url, do: Keyword.fetch!(config, :base_url)
end
