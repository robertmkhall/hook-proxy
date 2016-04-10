defmodule HookProxy.SlackWebhookControllerTest do
  use HookProxy.ConnCase, async: false
  use Plug.Test

  @github_pull_request_json File.read!("test/fixtures/github_opened_pull_request.json")
  @gitlab_pull_request_json File.read!("test/fixtures/gitlab_opened_pull_request.json")

  @webhook_slug "dsf563f/xasxasdl97fbn/blasdassd"

  setup do
    bypass = Bypass.open

    Application.put_env :hook_proxy, :slack,
      base_url: "http://localhost:#{bypass.port}",
      custom_message: "check out this sweet pull request"

    on_exit fn ->
       System.delete_env("VCAP_SERVICES")
    end

    {:ok, bypass: bypass}
  end

  test "POST /api/webhook/slack forwards github pull request to slack with custom text", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "POST" == conn.method
      assert "/services/#{@webhook_slug}" == conn.request_path

      Plug.Conn.resp(conn, 200, "request recieved at slack")
    end

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("x-github-event", "pull_request")
    |> post("/api/webhook/slack/#{@webhook_slug}", @github_pull_request_json)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert String.contains?(conn.resp_body, "request recieved at slack")
  end

  test "POST /api/webhook/slack forwards gitlab pull request to slack with custom text", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "POST" == conn.method
      assert "/services/#{@webhook_slug}" == conn.request_path

      Plug.Conn.resp(conn, 200, "request recieved at slack")
    end

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> post("/api/webhook/slack/#{@webhook_slug}", @gitlab_pull_request_json)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert String.contains?(conn.resp_body, "request recieved at slack")
  end

  test "POST /api/webhook/slack with unsupported request type returns 400" do
    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("x-github-event", "invalid-type")
    |> post("/api/webhook/slack/#{@webhook_slug}", @github_pull_request_json)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 400
    assert String.contains?(conn.resp_body, "unsupported webhook type")
  end

  test "POST with slack proxy", %{bypass: bypass} do
    cf_env = "{\"proxy\":[{\"credentials\":{\"host\":\"http://localhost\",\"port\":#{bypass.port},\"username\":\"proxyuser\",\"password\":\"password\"}}]}"
    System.put_env("VCAP_SERVICES", cf_env)

    Bypass.expect bypass, fn conn ->
      assert "POST" == conn.method
      assert "/services/#{@webhook_slug}" == conn.request_path

      Plug.Conn.resp(conn, 200, "request recieved at slack")
    end

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("x-github-event", "pull_request")
    |> post("/api/webhook/slack/#{@webhook_slug}", @github_pull_request_json)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert String.contains?(conn.resp_body, "request recieved at slack")
  end
end