defmodule Jager.Generator do
  use GenServer
  require Logger
  alias Jager.{Documentation, Recorder, Writer}

  @moduledoc """
  This module is the one that is instantiated by ExUnit.start (or configure).


  test_helper.exs
  ```elixir
  ExUnit.start(formatters: [ExUnit.CLIFormatter, Jager.Generator])
  ...
  ```

  The ExUnit calls all modules with `:suite_finished` once it finishes the test suite, this means that we can start
  generating the documentation for the API.
  """

  def init(_args), do: {:ok, nil}

  def handle_cast({:suite_finished, _, _}, nil) do
    generate()
    {:noreply, nil}
  end

  def handle_cast(_, nil), do: {:noreply, nil}

  defp generate() do
    Documentation.new()
    |> parse_records()
    |> Documentation.group_routes()
    |> Writer.write()
  end

  defp parse_records(documentation = %Documentation{}),
    do: %{documentation | records: Recorder.get_records() |> Enum.map(&Documentation.parse_record/1)}
end
