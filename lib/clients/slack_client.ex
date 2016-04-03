defmodule HookProxy.SlackClient do
  use HTTPoison.Base

  def post_webhook(body, params) do
    post "#{base_url}/services/#{webhook_slug(params)}", body
  end

  def custom_message, do: Keyword.fetch!(config, :custom_message)

  defp webhook_slug(params), do: "#{params["slug_1"]}/#{params["slug_2"]}/#{params["slug_3"]}"

  defp config, do: Application.fetch_env!(:hook_proxy, :slack)

  defp base_url, do: Keyword.fetch!(config, :base_url)
end
