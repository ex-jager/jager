defmodule Jager.Documentation.Connection do
  @moduledoc """
  A struct that represents a connection.
  """
  alias Jager.Documentation.{Response, Request}

  use TypedStruct

  typedstruct do
    field(:controller, module())
    field(:name, String.t(), enforce: true)
    field(:action, atom())
    field(:documentation, String.t())
    field(:request, Request.t(), enforce: true)
    field(:response, Response.t(), enforce: true)
  end

  @spec new(Plug.Conn.t(), keyword()) :: Jager.Documentation.Connection.t()
  def new(conn = %Plug.Conn{}, opts) do
    %__MODULE__{
      name: Keyword.get(opts, :name, "#{conn.method} #{conn.request_path}"),
      action: Keyword.get(opts, :action, conn.private.phoenix_action),
      controller: conn.private.phoenix_controller,
      documentation: Keyword.get(opts, :documentation, nil),
      request: Request.new(conn),
      response: Response.new(conn)
    }
  end
end
