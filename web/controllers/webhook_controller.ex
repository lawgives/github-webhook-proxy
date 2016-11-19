defmodule WebhookProxy.WebhookController do
  use WebhookProxy.Web, :controller

  def webhook(conn, %{"repository_url" => repository_url}) do
    conn
    |> send_resp(200, "OK")
  end

  def webhook(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end

end
