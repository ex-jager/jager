defmodule Jager.Documentation do
  use TypedStruct
  alias Jager.Documentation.{Connection, Group}
  alias Jager.Writer

  @default_title "API Documentation"
  @default_host "http://localhost:4000"
  @default_description "Update description in Jager configuration in config.exs."
  @default_path "priv/static/docs"
  @default_file_name "api.apib"
  @default_type :apib

  typedstruct do
    field(:title, String.t(), enforce: true, default: @default_title)
    field(:description, String.t())
    field(:host, String.t(), enfoce: true)
    field(:records, [Connection.t()])
    field(:path, String.t(), enforce: true)
    field(:file_name, String.t(), enforce: true)
    field(:text, String.t())
    field(:writer, module(), enforce: true)
    field(:grouped_records, [Group.t()], enforce: false)
  end

  @spec new() :: Jager.Documentation.t()
  def new() do
    %__MODULE__{
      title: get_config(:title, @default_title),
      description: get_config(:description, @default_description),
      host: get_config(:host, @default_host),
      records: [],
      path: get_config(:file_path, @default_path),
      file_name: get_config(:file_name, @default_file_name),
      writer: get_writer(),
      grouped_records: []
    }
  end

  @spec get_config(atom(), any()) :: any()
  defp get_config(config, default), do: Application.get_env(:jager, config, default)

  @spec parse_record(Plug.Conn.t(), keyword()) :: Jager.Documentation.Connection.t()
  def parse_record(conn = %Plug.Conn{}, opts), do: Connection.new(conn, opts)

  @spec parse_record({Plug.Conn.t(), keyword()}) :: Jager.Documentation.Connection.t()
  def parse_record({conn, opts}), do: parse_record(conn, opts)

  @spec group_routes(Jager.Documentation.t()) :: Jager.Documentation.t()
  def group_routes(documentation = %__MODULE__{records: records}) do
    groups =
      records
      |> Enum.group_by(& &1.controller)
      |> Enum.map(fn {controller, records} -> Group.new("name", controller, records) end)

    %{documentation | grouped_records: groups}
  end

  defp get_writer(), do: :type |> get_config(@default_type) |> Writer.get_writer()
end
