defmodule WebhookProxy.WebhookController do
  use WebhookProxy.Web, :controller

  def webhook(conn, _params) do
    conn
    |> send_resp(200, "OK")
  end
end
