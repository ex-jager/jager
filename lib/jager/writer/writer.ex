defmodule Jager.Writer do
  alias Jager.Documentation
  alias Jager.Writer.ApiBlueprint

  @spec write(Jager.Documentation.t()) :: {:ok, File.posix()} | {:error, atom()}
  def write(documentation = %Documentation{}) do
    documentation
    |> ApiBlueprint.generate()
    |> write_file()
  end

  @spec write_file(Jager.Documentation.t()) :: {:error, File.posix()}
  def write_file(documentation = %Documentation{text: text}) when is_bitstring(text) do
    with :ok <- File.mkdir_p(documentation.path),
         :ok <- documentation.path |> Path.join(documentation.file_name) |> File.write(text) do
      {:ok, text}
    end
  end
end
