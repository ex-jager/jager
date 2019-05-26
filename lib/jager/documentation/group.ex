defmodule Jager.Documentation.Group do
  @moduledoc """
  A struct that represents a Group of api documentations.
  """
  alias Jager.Documentation.Connection

  use TypedStruct

  typedstruct do
    field(:controller, module())
    field(:name, String.t(), enforce: true)
    field(:documentation, String.t())
    field(:records, [Connection.t()], enforce: true)
  end

  @spec new(String.t(), module(), [Connection.t()], String.t()) :: Jager.Documentation.Group.t()
  def new(name, controller, records, documentation \\ "") do
    %__MODULE__{
      name: name,
      controller: controller,
      records: records,
      documentation: documentation
    }
  end
end
