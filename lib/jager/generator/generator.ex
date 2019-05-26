defmodule Jager.Generator do
  alias Jager.Documentation
  alias Jager.Generator.ApiBlueprint

  @valid_generators %{apib: ApiBlueprint, custom: nil}
  @callback generate(Documentation.t()) :: {:ok, String.t()}

  def get_generator(atom) do
    case Map.fetch(@valid_generators, atom) do
      {:ok, nil} -> Application.get_env(:jager, :custom_generator)
      {:ok, module} -> module
      _ -> raise("Writer correctly specified, valid options are: #{Map.keys(@valid_generators)}")
    end
  end
end
