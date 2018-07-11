defmodule ElixirMixGen.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_mix_gen,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.9.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.1"}
    ]
  end
end
