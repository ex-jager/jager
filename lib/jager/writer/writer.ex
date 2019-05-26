defmodule Jager.Writer do
  alias Jager.Documentation
  alias Jager.Writer.ApiBlueprint

  @valid_writers %{apib: ApiBlueprint}

  @spec write(Jager.Documentation.t()) :: {:ok, File.posix()} | {:error, atom()}
  def write(documentation = %Documentation{writer: writer}) do
    documentation
    |> writer.generate()
    |> write_file()
  end

  @spec write_file(Jager.Documentation.t()) :: {:error, File.posix()}
  def write_file(documentation = %Documentation{text: text}) when is_bitstring(text) do
    with :ok <- File.mkdir_p(documentation.path),
         :ok <- documentation.path |> Path.join(documentation.file_name) |> File.write(text) do
      {:ok, text}
    end
  end

  def get_writer(atom) do
    case Map.fetch(@valid_writers, atom) do
      {:ok, module} -> module
      _ -> raise("Writer correctly specified, valid options are: #{Map.keys(@valid_writers)}")
    end
  end
end
