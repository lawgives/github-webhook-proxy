defmodule WebhookProxy.WebhookController do
  use WebhookProxy.Web, :controller

  # Test this for now, use env variables later
  plug BasicAuth, use_config: { :basic_auth, :webhook }

  def webhook(conn, %{"repository_url" => repository_url}) do
    # Proxy with the real credentials
    case HTTPoison.post "http://username:password@localhost/basic_auth", "repository_url="<>repository_url, %{} do
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

    conn
    |> send_resp(200, "OK")
  end

  def webhook(conn, _params) do
    conn
    |> send_resp(400, "Must pass repository_url")
  end
end
