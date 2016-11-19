defmodule WebhookProxy.PageController do
  use WebhookProxy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
