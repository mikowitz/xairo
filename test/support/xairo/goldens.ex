defmodule Xairo.Goldens do
  alias Xairo
  alias Xairo.{Context, Surface, Surface.Image}

  @golden_path Path.expand("../../fixtures", __DIR__)

  def golden_path, do: @golden_path

  def generate(golden_fn, filename) do
    {_ctx, surface} = golden_fn.()
    :ok = Surface.write_to_png(surface, Path.join(@golden_path, filename))
  end

  def shapes do
    {:ok, surface} = Image.create(:argb32, 160, 120)
    {:ok, ctx} = Context.create(surface)

    ctx
    |> Xairo.set_source_rgb(0.8, 0.2, 0.2)
    |> Xairo.rectangle(10, 10, 60, 40)
    |> Xairo.fill()
    |> Xairo.set_source_rgba(0.2, 0.4, 0.8, 0.6)
    |> Xairo.arc(100, 60, 35, 0, 2 * :math.pi())
    |> Xairo.fill_preserve()
    |> Xairo.set_source_rgb(0, 0, 0)
    |> Xairo.set_line_width(3)
    |> Xairo.stroke()
    |> Xairo.set_dash([6, 3], 0)
    |> Xairo.set_line_cap(:round)
    |> Xairo.move_to(10, 100)
    |> Xairo.curve_to(50, 70, 110, 130, 150, 100)
    |> Xairo.stroke()

    {ctx, surface}
  end
end
