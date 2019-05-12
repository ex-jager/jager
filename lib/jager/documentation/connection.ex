defmodule Jager.Documentation.Connection do
  @moduledoc """
  A struct that represents a connection.
  """
  use TypedStruct

  typedstruct do
    field(:method, String.t(), enforce: true)
    field(:route, String.t(), enforce: true)
    field(:controller, module())
    field(:body_params, map(), default: %{})
    field(:query_params, map(), default: %{})
    field(:request_headers, list(), default: [])
    field(:response_format, atom(), default: :json)
    field(:response_body, map(), default: %{})
    field(:response_headers, list(), default: [])
    field(:status, integer(), enforce: true)
    field(:name, String.t(), enforce: true)
    field(:action, atom())
    field(:documentation, String.t())
  end

  @spec new(Plug.Conn.t(), keyword()) :: Jager.Documentation.Connection.t()
  def new(conn = %Plug.Conn{}, opts) do
    %__MODULE__{
      method: conn.method,
      route: conn.request_path,
      body_params: conn.body_params,
      query_params: conn.query_params,
      request_headers: conn.req_headers,
      response_format: String.to_atom(conn.private.phoenix_format),
      response_body: conn.resp_body,
      response_headers: conn.resp_headers,
      status: conn.status,
      name: Keyword.get(opts, :name, "#{conn.method} #{conn.request_path}"),
      action: Keyword.get(opts, :action, conn.private.phoenix_action),
      controller: conn.private.phoenix_controller,
      documentation: Keyword.get(opts, :documentation, nil)
    }
  end
end
