defmodule Jager.Generator.ApiBlueprint do
  @behaviour Jager.Generator

  alias Jager.Documentation
  alias Jager.Documentation.Group

  @format "FORMAT: 1A"
  @line_break "\n"
  @spacing_between_elements 2
  @markdown_header "#"
  @space " "

  @spec generate(Documentation.t()) :: {:ok, String.t()}
  @impl Jager.Generator
  def generate(documentation = %Documentation{}) do
    groups(documentation)

    doc =
      [
        metadata(documentation),
        title(documentation)
      ]
      |> join_docs()

    {:ok, doc}
  end

  defp metadata(documentation = %Documentation{}),
    do: join_docs([@format, documentation.host])

  defp title(documentation = %Documentation{}) do
    [
      header(documentation.title),
      documentation.description
    ]
    |> join_docs(@spacing_between_elements)
  end

  defp join_docs(list, number_of_lines \\ 1) do
    lines_to_skip = @line_break |> List.duplicate(number_of_lines) |> Enum.join()
    list |> Enum.join(lines_to_skip) |> Kernel.<>(@line_break)
  end

  defp groups(documentation) do
    Enum.reduce(documentation.grouped_records, "", fn group, _ ->
      single_group(group)
    end)
  end

  defp single_group(group = %Group{}) do
    IO.inspect(group)
  end

  defp header(string, n \\ 1),
    do: @markdown_header |> List.duplicate(n) |> Enum.join() |> space() |> Kernel.<>(string)

  defp space(string, n \\ 1), do: string <> (@space |> List.duplicate(n) |> Enum.join())
end
