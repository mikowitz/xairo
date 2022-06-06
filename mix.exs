defmodule Xairo.MixProject do
  use Mix.Project

  def project do
    [
      app: :xairo,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6.0", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:rustler, "~> 0.25.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support"] ++ elixirc_paths(:prod)
  defp elixirc_paths(_), do: ["lib"]
end
