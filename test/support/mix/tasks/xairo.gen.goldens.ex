defmodule Mix.Tasks.Xairo.Gen.Goldens do
  @moduledoc """
  Mix task to generate golden images for end-to-end testing.
  """

  use Mix.Task

  @doc """
  Generates golden images for end to end tests.
  """
  @impl Mix.Task
  def run(_) do
    Xairo.Goldens.generate(&Xairo.Goldens.shapes/0, "shapes.png")
    Xairo.Goldens.generate(&Xairo.Goldens.transforms/0, "transforms.png")
    Xairo.Goldens.generate(&Xairo.Goldens.clipping/0, "clipping.png")
    Xairo.Goldens.generate(&Xairo.Goldens.lsystem_tree/0, "lsystem_tree.png")
    Xairo.Goldens.generate(&Xairo.Goldens.text/0, "text.png")
    Xairo.Goldens.generate(&Xairo.Goldens.surface_source/0, "surface_source.png")
    Xairo.Goldens.generate(&Xairo.Goldens.hairlines/0, "hairlines.png")
  end
end
