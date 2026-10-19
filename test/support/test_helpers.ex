defmodule Xairo.TestHelpers do
  @moduledoc false

  alias Xairo.{Context, Surface.Image}

  def with_context(setup) do
    {:ok, surface} = Image.create(:argb32, 100, 100)
    {:ok, ctx} = Context.create(surface)

    Map.put(setup, :ctx, ctx)
    |> Map.put(:surface, surface)
  end
end
