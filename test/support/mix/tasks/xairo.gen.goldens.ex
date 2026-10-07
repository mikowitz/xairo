defmodule Mix.Tasks.Xairo.Gen.Goldens do
  use Mix.Task

  @doc """
  Generates golden images for end to end tests.
  """
  @impl Mix.Task
  def run(_) do
    Xairo.Goldens.generate(&Xairo.Goldens.shapes/0, "shapes.png")
  end
end
