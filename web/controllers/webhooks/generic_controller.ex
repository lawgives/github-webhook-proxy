defmodule WebhookProxy.Webhooks.GenericController do
  use WebhookProxy.Web, :controller

  plug BasicAuth, use_config: { :basic_auth, :webhook }

  def webhook(conn, %{"repository_url" => repository_url}) do
    # Proxy with the real credentials
    {:ok, status, message} = WebhookProxy.Helpers.post_to_proxy_url(repository_url)
    conn
    |> send_resp(status, message)
  end

  def webhook(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end
end
