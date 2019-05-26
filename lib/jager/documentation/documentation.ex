defmodule Jager.Documentation do
  use TypedStruct
  alias Jager.Documentation.Connection

  @default_title "API Documentation"
  @default_host "http://localhost:4000"
  @default_description "Update description in Jager configuration in config.exs."
  @default_path "priv/static/docs"
  @default_file_name "api.apib"
  @default_type :apib

  typedstruct do
    field(:type, Atom.t(), enforce: true, default: @default_type)
    field(:title, String.t(), enforce: true, default: @default_title)
    field(:description, String.t())
    field(:host, String.t(), enfoce: true)
    field(:records, [Connection.t()])
    field(:path, String.t(), enforce: true)
    field(:file_name, String.t(), enforce: true)
    field(:text, String.t())
  end

  @spec new() :: Jager.Documentation.t()
  def new() do
    %__MODULE__{
      type: get_config(:type, @default_type),
      title: get_config(:title, @default_title),
      description: get_config(:description, @default_description),
      host: get_config(:host, @default_host),
      records: [],
      path: get_config(:file_path, @default_path),
      file_name: get_config(:file_name, @default_file_name)
    }
  end

  @spec get_config(atom(), any()) :: any()
  def get_config(config, default), do: Application.get_env(:jager, config, default)

  @spec parse_record(Plug.Conn.t(), keyword()) :: Jager.Documentation.Connection.t()
  def parse_record(conn = %Plug.Conn{}, opts), do: Connection.new(conn, opts)

  @spec parse_record({Plug.Conn.t(), keyword()}) :: Jager.Documentation.Connection.t()
  def parse_record({conn, opts}), do: parse_record(conn, opts)

  def group_routes(documentation = %__MODULE__{}) do
    documentation
  end
end
