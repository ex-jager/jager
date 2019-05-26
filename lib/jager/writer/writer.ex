defmodule Jager.Writer do
  alias Jager.Documentation

  @spec write(Jager.Documentation.t()) :: {:ok, String.t()} | {:error, atom()}
  def write(documentation = %Documentation{generator: generator}) do
    with {:ok, text} <- generator.generate(documentation),
         {:ok, written} <- write_file(text, documentation.path, documentation.file_name) do
      {:ok, written}
    end
  end

  @spec write_file(String.t(), String.t(), String.t()) :: {:error, atom} | {:ok, String.t()}
  def write_file(text, path, file_name) do
    with :ok <- File.mkdir_p(path),
         :ok <- path |> Path.join(file_name) |> File.write(text) do
      {:ok, text}
    end
  end
end
