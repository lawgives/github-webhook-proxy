# WebhookProxy

## Overview
[Go CD](https://go.cd) is built to to poll SCMs such as Github.com. If you wanted to use their
notification API, then we need:

  1. A go.cd user that has admin credentials
  2. Somehow convert the incoming Github webhook from a JSON POST to a CGI POST

Since we do not want to expose admin credentials outside, we need to convert something like a
randomized token into the correct credentials. We can do this by using a proxy that accepts
some sort of authentication and then sends the request with the real credentials to Go.cd

See:
  * https://github.com/gocd/gocd/issues/217
  * https://github.com/gocd/gocd/issues/1591
  * https://docs.go.cd/15.1.0/api/materials_api.html#git
  * https://developer.github.com/v3/activity/events/types/#pushevent

### Configuration

Set these environmental variables:

  * `WEBHOOK_PROXY_URL` should be something like `http://admin:pass@gocd-server:8153/go/api/material/notify/git`
  * `WEBHOOK_USERNAME` randomly generate something, such as `dkaDadkwjKjdfk`
  * `WEBHOOK_PASSWORD` randomly generate something, such as `kdj2k9d23Dkdaf`

When setting up the webhook on Github, populate for the values `WEBHOOK_USERNAME` and `WEBHOOK_PASSWORD`, such as:

```
https://WEBHOOK_USERNAME:WEBHOOK_PASSWORD@gocd.example.com/webhooks/github/ssh
```

This proxy responds to the `webhooks/` endpoints. You should map it from the reverse proxy handling the SSL.

#### Endpoints

  * GET  `/webhooks/generic` will accept a `repository_url=` query param and POST to GoCD
  * POST `/webhooks/github/git` will accept a Github PushEvent payload into a POST to GoCD with (public) git url
  * POST `/webhooks/github/ssh` will accept a Github PushEvent payload into a POST to GoCD with (public) ssh url

#### Dev Endpoint

`/webhooks/test` will pretend to be Go CD and accept a urlencoded POST request with `repository_url`. This is
only available in dev mode.

### Docker

TODO: Get this built on Docker so people using this will not have to install Erlang or Elixir.

## Phoenix Instructions
To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

