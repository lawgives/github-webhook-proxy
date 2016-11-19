defmodule WebhookProxy.WebhookController do
  use WebhookProxy.Web, :controller

  # Test this for now, use env variables later
  plug BasicAuth, use_config: { :basic_auth, :webhook }

  def webhook(conn, %{"repository_url" => repository_url}) do
    # Proxy with the real credentials
    IO.inspect Application.get_env(:webhook_proxy, :proxy_url)
    case HTTPoison.post Application.get_env(:webhook_proxy, :proxy_url), "repository_url="<>repository_url, %{} do
      {:ok, %HTTPoison.Response{status_code: 200, body: _}} ->
        conn
        |> send_resp(200, "OK")
      {:ok, %HTTPoison.Response{status_code: 201, body: _}} ->
        conn
        |> send_resp(200, "OK")
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        IO.puts ["Error when proxying. code=", code, " body=", body]
        conn
        |> send_resp(500, "Error")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "Error when proxying. reason:"
        IO.inspect(reason)
        conn
        |> send_resp(500, "Error")
    end
  end

  def webhook(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end
end
