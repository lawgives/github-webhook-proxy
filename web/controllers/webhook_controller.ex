defmodule WebhookProxy.WebhookController do
  use WebhookProxy.Web, :controller

  # Test this for now, use env variables later
  plug BasicAuth, use_config: { :basic_auth, :webhook }

  def webhook(conn, %{"repository_url" => repository_url}) do
    # Proxy with the real credentials
    HTTPoison.post "http://username:password@localhost/basic_auth", "repository_url="<>repository_url, %{}

    conn
    |> send_resp(200, "OK")
  end

  def webhook(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end
end
