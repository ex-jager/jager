defmodule Jager.Documentation.Response do
  @moduledoc """
  A struct that represents a response in a connection.
  """
  use TypedStruct

  typedstruct do
    field(:response_format, atom(), default: :json)
    field(:response_body, map(), default: %{})
    field(:response_headers, list(), default: [])
    field(:status, integer(), enforce: true)
  end

  @spec new(Plug.Conn.t()) :: Jager.Documentation.Response.t()
  def new(conn = %Plug.Conn{}) do
    %__MODULE__{
      response_format: String.to_atom(conn.private.phoenix_format),
      response_body: conn.resp_body,
      response_headers: conn.resp_headers,
      status: conn.status
    }
  end
end
