defmodule Jager.Generator.ApiBlueprint do
  @behaviour Jager.Generator

  alias Jager.Documentation
  alias Jager.Documentation.Group

  @format "FORMAT: 1A"
  @line_break "\n"
  @spacing_between_elements 2
  @markdown_header "#"
  @markdown_header_2 "##"
  @base_identation "    "
  @base_identation_3 @base_identation <> @base_identation <> @base_identation
  @space " "

  @impl Jager.Generator
  def generate(documentation = %Documentation{}) do
    doc =
      [
        metadata(documentation),
        title(documentation),
        groups(documentation)
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

  defp groups(documentation),
    do: Enum.reduce(documentation.grouped_records, "", fn group, _ -> single_group(group) end)

  defp single_group(group = %Group{}) do
    group_header = @markdown_header <> @space <> group.name <> @space <> resource_header(group.name)
    group_description = group.documentation
    methods = methods(group.records)

    [
      group_header,
      group_description,
      methods
    ]
    |> join_docs()
  end

  defp resource_header(name), do: "[/#{String.downcase(name)}]"

  defp methods(records) do
    methods = Enum.map(records, fn record -> single_record(record) end)
    join_docs(methods)
  end

  defp single_record(record) do
    record_header = @markdown_header_2 <> @space <> record.name <> @space <> record_method(record.request.method)
    record_description = record.documentation || ""
    record_request = record_request(record)
    # record_response = record_response(record)

    [record_header, record_description, record_request] |> join_docs()
  end

  defp record_method(method), do: "[#{String.upcase(method)}]"

  defp record_request(record) do
    request_headers = request_headers(record.request.request_headers)
    request_info = request_info(record)

    [request_info, request_headers] |> join_docs()
  end

  defp request_headers(headers) do
    base = @base_identation <> "+ Headers" <> @line_break

    headers_info =
      Enum.map(headers, fn {key, value} -> @base_identation_3 <> "#{String.capitalize(key)}: " <> value end)

    [base, headers_info] |> join_docs()
  end

  defp request_info(record) do
    {_, accept} = Enum.find(record.request.request_headers, fn {"accept", value} -> value end) || "text-plain"
    _base = "+ Request (#{accept})"
  end

  defp header(string, n \\ 1),
    do: @markdown_header |> List.duplicate(n) |> Enum.join() |> space() |> Kernel.<>(string)

  defp space(string, n \\ 1), do: string <> (@space |> List.duplicate(n) |> Enum.join())
end
