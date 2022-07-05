alias Xairo.{ImageSurface, Context, Rgba}

import Context

scale = 50

rando = fn -> :rand.uniform() / 4 - 0.125 end

add_square = fn context, x, y -> rectangle(context, {x, y}, 1.5 + rando.(), 1.5 + rando.()) end

surface = ImageSurface.create(:argb32, 60 * scale, 60 * scale)

context = Context.new(surface)

context =
  context
  |> scale(scale, scale)
  # |> set_source(Rgba.new(0.7, 0.8, 0.6))
  |> set_source(Rgba.new(0.6, 0.6, 0.6))
  |> paint()
  |> set_source(Rgba.new(0.1, 0.1, 0.2))
  |> set_line_width(0.1)

:rand.seed(:exsplus, {1, 2, 3})

points =
  for _ <- 1..800 do
    x = :rand.uniform(round(60 / 2 - 6)) + 2
    y = :rand.uniform(round(60 / 2 - 6)) + 2
    {x * 2, y * 2}
  end
  |> Enum.uniq()

Enum.map(points, &elem(&1, 0)) |> Enum.min_max() |> IO.inspect()
Enum.map(points, &elem(&1, 1)) |> Enum.min_max() |> IO.inspect()

colors = [
  Rgba.new(0.1, 0.1, 0.2),
  Rgba.new(0.5, 0.2, 0.6),
  Rgba.new(0.3, 0.5, 0.6),
]

context =
  Enum.reduce(points, context, fn {x, y}, context ->
    context = add_square.(context, x, y)
      |> set_source(Enum.random(colors))
    case :rand.uniform() > 0.6 do
      false -> fill(context)
      true -> stroke(context)
    end
  end)

ImageSurface.write_to_png(surface, "examples/squares.png")
