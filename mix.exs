defmodule Jager.MixProject do
  use Mix.Project

  def project do
    [
      app: :jager,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [
      mod: {Jager.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.4"},
      {:typed_struct, "~> 0.1.4"}
    ]
  end
end
