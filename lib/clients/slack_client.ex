defmodule HookProxy.SlackClient do
  use HTTPoison.Base

  def post_webhook(body, params) do
    post "#{base_url}/services/#{webhook_slug(params)}", body
  end

  def custom_message, do: Keyword.fetch!(config, :custom_message)

  defp webhook_slug(params), do: "#{params["a"]}/#{params["b"]}/#{params["c"]}"

  defp config, do: Application.fetch_env!(:hook_proxy, :slack)

  defp base_url, do: Keyword.fetch!(config, :base_url)
end
