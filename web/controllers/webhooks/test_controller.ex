defmodule WebhookProxy.Webhooks.TestController do
  use WebhookProxy.Web, :controller

  # Test this for now, use env variables later
  plug BasicAuth, use_config: { :basic_auth, :webhook_test }
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]

  def test_ok(conn, %{"repository_url" => repository_url}) do
    conn
    |> send_resp(200, "OK " <> repository_url)
  end

  def test_ok(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end
end
