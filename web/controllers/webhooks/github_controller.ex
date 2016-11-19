defmodule WebhookProxy.Webhooks.GithubController do
  use WebhookProxy.Web, :controller
  require Logger

  # Github endpoints require JSON
  plug :accepts, ["json"]
  plug BasicAuth, use_config: { :basic_auth, :webhook }

  def webhook_for_git_url(conn, %{"repository" => %{"git_url" => repository_url}}) do
    handle_webhook conn, repository_url
  end

  def webhook_for_git_url(conn, _params), do: bad_request(conn, "repository.ssh_url")

  def webhook_for_ssh_url(conn, %{"repository" => %{"ssh_url" => repository_url}}) do
    handle_webhook conn, repository_url
  end

  def webhook_for_ssh_url(conn, _params), do: bad_request(conn, "repository.ssh_url")

  defp handle_webhook(conn, repository_url) do
    # Proxy with the real credentials
    {:ok, status, message} = WebhookProxy.Helpers.post_to_proxy_url(repository_url)
    conn
    |> send_resp(status, message)
  end

  defp bad_request(conn, key), do: send_resp(conn, 400, ["Must pass ", key])
end
