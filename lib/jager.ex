defmodule Jager do
  alias Jager.Recorder

  @doc """
  Adds the passed argument `conn` to the recorder.
  Accept opts that are a keyworded list of extra information regarding the tested route.

  Returns the received connection as argument.
  """
  @spec doc(Plug.Conn.t(), List.t()) :: Plug.Conn.t()
  def doc(conn = %Plug.Conn{}, opts \\ []), do: Recorder.record(conn, opts)
end
