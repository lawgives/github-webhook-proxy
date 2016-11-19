defmodule WebhookProxy.WebhookTestController do
  use WebhookProxy.Web, :controller

  # Test this for now, use env variables later
  plug BasicAuth, use_config: { :basic_auth, :webhook_test }

  def test_ok(conn, %{"repository_url" => repository_url}) do
    conn
    |> send_resp(200, "OK")
  end

  def test_ok(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end
end
