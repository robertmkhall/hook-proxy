defmodule HookProxy.GithubToSlackAdapter do
  alias HookProxy.GitHubPullRequest, as: PullRequest

  def slack_request(conn) do
    slack_request(request_type(conn), request_body(conn))
  end

  defp request_type(conn) do
    conn
    |> request_headers
    |> request_type_header_val
  end

  defp request_type_header_val([]) do
    :not_recognised
  end

  defp request_type_header_val([head | tail]) do
    case head do
      {"x-github-event", type} -> type
      _ -> request_type_header_val(tail)
    end
  end

  defp request_headers(conn) do
    Map.get(conn, :req_headers)
  end

  defp request_body(conn) do
    Map.get(conn, :body_params)
  end

  defp slack_request(type, payload) do
    request_json(type, payload)
    |> Poison.encode!
  end

  defp request_json(type, payload) do
    case type do
      "pull_request" -> PullRequest.slack_message(payload)
      _ -> default_message(payload)
    end
  end

  defp default_message(payload) do
    "a change was made..."
  end
end