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
  end


  # Other scopes may use custom stacks.
  # scope "/api", WebhookProxy do
  #   pipe_through :api
  # end
end
