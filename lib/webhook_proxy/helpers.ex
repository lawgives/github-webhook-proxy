defmodule WebhookProxy.Helpers do
  require Logger

  def proxy_url, do: System.get_env("WEBHOOK_PROXY_URL")

  def post_to_proxy_url(repository_url) do
    Logger.debug(["Proxying to: ", inspect(proxy_url)])
    case HTTPoison.post proxy_url, ["repository_url=", repository_url], %{"Content-Type" => "application/x-www-form-urlencoded", "Confirm" => "true"} do
      {:ok, %HTTPoison.Response{status_code: 200, body: _}} ->
        {:ok, 200, "OK"}
      {:ok, %HTTPoison.Response{status_code: 201, body: _}} ->
        {:ok, 200, "OK"}
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        IO.puts ["Error when proxying. code=", Integer.to_string(code), " body=", body]
        {:ok, 500, "Error"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "Error when proxying. reason:"
        IO.inspect(reason)
        {:ok, 500, "Error"}
    end
  end
end
