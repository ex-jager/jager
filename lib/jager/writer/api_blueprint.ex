defmodule Jager.Writer.ApiBlueprint do
  alias Jager.Documentation

  @format "FORMAT: 1A"
  @line_break "\n"
  @spacing_between_elements 2
  @markdown_header "#"
  @spacing " "

  def generate(documentation = %Documentation{}) do
    doc =
      [
        metadata(documentation),
        title(documentation)
        #   description(documentation),
        #   routes(documentation)
      ]
      |> join_docs()

    %{documentation | text: doc}
  end

  defp metadata(documentation = %Documentation{}), do: join_docs([@format, documentation.host])

  defp title(documentation = %Documentation{}) do
    [
      header(documentation.title),
      documentation.description
    ]
    |> join_docs(@spacing_between_elements)
  end

  defp join_docs(list, number_of_lines \\ 1)

  defp join_docs(list, number_of_lines) do
    lines_to_skip = @line_break |> List.duplicate(number_of_lines) |> Enum.join()
    list |> Enum.join(lines_to_skip) |> Kernel.<>(@line_break)
  end

  defp header(string, n \\ 1)

  defp header(string, n),
    do: @markdown_header |> List.duplicate(n) |> Enum.join() |> space() |> Kernel.<>(string)

  defp indent(string, n \\ 2)
  defp indent(string, n), do: @spacing |> List.duplicate(n) |> Enum.join() |> Kernel.<>(string)

  defp space(string, n \\ 1)

  defp space(string, n), do: string <> (@spacing |> List.duplicate(n) |> Enum.join())
end
