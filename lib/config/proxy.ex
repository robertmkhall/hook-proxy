defmodule HookProxy.Config.Proxy do

  def cf_config, do: System.get_env("VCAP_SERVICES")

  defp parsed_config, do: Poison.decode!(cf_config, keys: :atoms)

  defp proxy, do: List.first parsed_config.proxy

  defp credentials, do: proxy.credentials

  def host, do: credentials.host

  def port, do: credentials.port

  def user, do: credentials.username

  def password, do: credentials.password
end
