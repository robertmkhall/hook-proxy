defmodule HookProxy.Clients.Slack do
  use HTTPoison.Base

  alias HookProxy.Config.Proxy

  def post_webhook(body, params) do
    post "#{base_url}/services/#{webhook_slug(params)}", body, [], proxy_params
  end

  def custom_message, do: Keyword.fetch!(config, :custom_message)

  defp webhook_slug(params), do: "#{params["slug_1"]}/#{params["slug_2"]}/#{params["slug_3"]}"

  defp config, do: Application.fetch_env!(:hook_proxy, :slack)

  defp base_url, do: Keyword.fetch!(config, :base_url)

  defp proxy_params do
    if Proxy.cf_config do
      [{:proxy, "#{Proxy.host}:#{Proxy.port}"}, {:proxy_auth, {Proxy.user, Proxy.password}}]
    else
      []
    end
  end
end
