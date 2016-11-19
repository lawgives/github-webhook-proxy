defmodule WebhookProxy.Router do
  use WebhookProxy.Web, :router

  pipeline :webhook do
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebhookProxy do
    pipe_through :webhook

    get "/webhook", WebhookController, :webhook
    post "/webhooks/github/git", Webhooks.GithubController, :webhook_for_git_url
    post "/webhooks/github/ssh", Webhooks.GithubController, :webhook_for_ssh_url

    # Make a test endpoint available for dev
    if Mix.env == :dev do
      post "/webhook_test", WebhookTestController, :test_ok
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", WebhookProxy do
  #   pipe_through :api
  # end
end
