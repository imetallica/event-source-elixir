defmodule Es.Integration.Router do
  @moduledoc """

  """
  use Plug.Router

  plug(Plug.Logger)
  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:es, :api])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  get "/api/v1/orders" do
    with {:ok, response} <- Jason.encode(%{hello: "123"}) do
      conn |> send_resp(200, response) |> halt()
    end
  end

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :es
  end
end
