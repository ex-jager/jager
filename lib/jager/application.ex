defmodule Jager.Application do
  use Application
  alias Jager.Recorder

  def start(_type, _args) do
    children = [Recorder]
    opts = [strategy: :one_for_one, name: Jager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
