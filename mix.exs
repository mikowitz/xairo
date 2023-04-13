defmodule Xairo.MixProject do
  use Mix.Project

  def project do
    [
      app: :xairo,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      docs: docs()
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
      {:benchee, "~> 1.0", only: :dev},
      {:credo, "~> 1.6.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:rustler, "~> 0.25.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support"] ++ elixirc_paths(:prod)
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: Xairo,
      groups_for_modules: [
        Drawing: [
          Xairo.Context,
          Xairo.Matrix,
          Xairo.Path
        ],
        Surfaces: [
          Xairo.ImageSurface,
          Xairo.PdfSurface,
          Xairo.PsSurface,
          Xairo.SvgSurface
        ],
        Patterns: [
          Xairo.LinearGradient,
          Xairo.Mesh,
          Xairo.SolidPattern,
          Xairo.SurfacePattern,
          Xairo.RadialGradient
        ],
        Text: [
          Xairo.TextExtents,
          Xairo.FontExtents,
          Xairo.FontFace
        ],
        Utility: [
          Xairo.Point,
          Xairo.Vector,
          Xairo.Rgba
        ]
      ],
      groups_for_functions: [
        Initialization: &(&1[:section] == :init),
        Drawing: &(&1[:section] == :drawing),
        Text: &(&1[:section] == :text),
        "Clipping and Masking": &(&1[:section] in [:clip, :mask]),
        Configuration: &(&1[:section] == :config),
        Transformation: &(&1[:section] == :transform),
        Calculations: &(&1[:section] == :calc)
      ]
    ]
  end
end
