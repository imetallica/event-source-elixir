defmodule Es.Integration.Router do
  @moduledoc """
  Routes.
  """
  use Plug.Router

  alias Es.Aggregates.Order

  plug(:match)
  plug(Plug.Logger)
  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:es, :api])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  post "/api/command" do
    with :ok <- Order.create(conn.body_params["payload"]),
         {:ok, response} <-
           Jason.encode(%{command: "create_user", version: "v1", payload: "accepted"}) do
      conn |> send_resp(202, response) |> halt()
    end
  end

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :es
  end
end
