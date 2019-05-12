defmodule Jager.Recorder do
  use GenServer

  @moduledoc """
  This module is used to store information regarding the controller tests that are running within the application.
  Whenever someone pipes the conn (with all parameters) to a `Jager.doc` function, it will arrive here and we will add
  information of the current connection to this module state.
  """

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @spec record(Plug.Conn.t(), any()) :: any()
  def record(item = %Plug.Conn{}, opts \\ []), do: GenServer.call(__MODULE__, {:record, item, opts})

  @spec get_records() :: [{Plug.Conn.t(), keyword()}]
  def get_records(), do: GenServer.call(__MODULE__, :get_records)

  def init(state), do: {:ok, state}

  def handle_call({:record, item, opts}, _from, recording_state), do: {:reply, item, [{item, opts} | recording_state]}

  def handle_call(:get_records, _from, recording_state), do: {:reply, recording_state, recording_state}
end
