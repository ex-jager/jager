defmodule Jager.Application do
  use Application
  alias Jager.Recorder

  def start(_type, _args), do: Supervisor.start_link([Recorder], strategy: :one_for_one, name: Jager.Supervisor)
end
