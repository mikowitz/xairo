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

  def transforms do
    {:ok, surface} = Image.create(:argb32, 160, 160)
    {:ok, ctx} = Context.create(surface)

    ctx = Xairo.translate(ctx, 80, 80)

    ctx =
      Enum.reduce(0..11, ctx, fn i, ctx ->
        ctx
        |> Xairo.save()
        |> Xairo.rotate(i * :math.pi() / 6)
        |> Xairo.set_source_rgba(i / 12, 0.3, 1 - i / 12, 0.8)
        |> Xairo.rectangle(20, -5, 50, 10)
        |> Xairo.fill()
        |> Xairo.restore()
      end)

    {ctx, surface}
  end

  def clipping do
    {:ok, surface} = Image.create(:argb32, 120, 120)
    {:ok, ctx} = Context.create(surface)

    ctx
    |> Xairo.arc(60, 60, 45, 0, 2 * :math.pi())
    |> Xairo.clip()
    |> Xairo.set_source_rgb(0.1, 0.6, 0.3)
    |> Xairo.set_line_width(6)
    |> then(fn ctx ->
      Enum.reduce(0..12, ctx, fn i, ctx ->
        ctx
        |> Xairo.move_to(i * 10, 0)
        |> Xairo.line_to(i * 10 - 60, 120)
        |> Xairo.stroke()
      end)
    end)
    |> Xairo.reset_clip()
    |> Xairo.set_source_rgb(0, 0, 0)
    |> Xairo.set_line_width(2)
    |> Xairo.arc(60, 60, 45, 0, 2 * :math.pi())
    |> Xairo.stroke()

    {ctx, surface}
  end

  def lsystem_tree do
    {:ok, surface} = Image.create(:argb32, 200, 200)
    {:ok, ctx} = Context.create(surface)

    ctx
    |> Xairo.set_source_rgb(0.35, 0.2, 0.1)
    |> Xairo.set_line_cap(:round)
    |> Xairo.translate(100, 190)
    |> branch(50, 7)

    {ctx, surface}
  end

  defp branch(ctx, _length, 0), do: ctx

  defp branch(ctx, length, depth) do
    ctx
    |> Xairo.set_line_width(depth)
    |> Xairo.move_to(0, 0)
    |> Xairo.line_to(0, -length)
    |> Xairo.stroke()
    |> Xairo.translate(0, -length)
    |> Xairo.save()
    |> Xairo.rotate(-0.45)
    |> branch(length * 0.72, depth - 1)
    |> Xairo.restore()
    |> Xairo.save()
    |> Xairo.rotate(0.35)
    |> branch(length * 0.72, depth - 1)
    |> Xairo.restore()
  end

  def text do
    {:ok, surface} = Image.create(:argb32, 240, 80)
    {:ok, ctx} = Context.create(surface)

    ctx
    |> Xairo.set_source_rgb(0.1, 0.1, 0.1)
    |> Xairo.select_font_face("sans-serif", :normal, :bold)
    |> Xairo.set_font_size(28)
    |> Xairo.move_to(12, 50)
    |> Xairo.show_text("Xairo!")

    {ctx, surface}
  end
end
