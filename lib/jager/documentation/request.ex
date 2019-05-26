defmodule Jager.Documentation.Request do
  @moduledoc """
  A struct that represents a request in a connection.
  """
  use TypedStruct

  typedstruct do
    field(:method, String.t(), enforce: true)
    field(:route, String.t(), enforce: true)
    field(:body_params, map(), default: %{})
    field(:query_params, map(), default: %{})
    field(:request_headers, list(), default: [])
  end

  @spec new(Plug.Conn.t()) :: Jager.Documentation.Request.t()
  def new(conn = %Plug.Conn{}) do
    %__MODULE__{
      method: conn.method,
      route: conn.request_path,
      body_params: conn.body_params,
      query_params: conn.query_params,
      request_headers: conn.req_headers
    }
  end
end
