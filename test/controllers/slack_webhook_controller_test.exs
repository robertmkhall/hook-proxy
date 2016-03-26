defmodule HookProxy.SlackWebhookControllerTest do
  use HookProxy.ConnCase, async: false
  use Plug.Test

  @github_pull_request_json File.read!("test/fixtures/github_pull_request.json")
  @webhook_slug "dsf563f/xasxasdl97fbn/blasdassd"

  setup do
    bypass = Bypass.open

    Application.put_env :hook_proxy, :slack,
      base_url: "http://localhost:#{bypass.port}",
      webhook_slug: @webhook_slug,
      custom_message: "check out this sweet pull request"

    {:ok, bypass: bypass}
  end

  test "POST /api/webhook forwards pull request to slack with custom text", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "POST" == conn.method
      assert "/services/#{@webhook_slug}" == conn.request_path

      Plug.Conn.resp(conn, 200, "request recieved at slack")
    end

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("x-github-event", "pull_request")
    |> post("/api/webhook/#{@webhook_slug}", @github_pull_request_json)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert String.contains?(conn.resp_body, "request recieved at slack")
  end

  test "POST /api/webhook with unsupported request type returns 400", %{bypass: bypass} do
    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("x-github-event", "invalid-type")
    |> post("/api/webhook/#{@webhook_slug}", @github_pull_request_json)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 400
    assert String.contains?(conn.resp_body, "unsupported webhook type")
  end
end