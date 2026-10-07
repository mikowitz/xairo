defmodule Mix.Tasks.Xairo.Gen.Goldens do
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
  end
end
