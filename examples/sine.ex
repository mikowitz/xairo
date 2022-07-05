alias Xairo.{ImageSurface, Context, Rgba}

import Context

scale = 50

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
  |> move_to({0, 15 + :math.sin(0) * 2})


:rand.seed(:exsplus, {1, 2, 3})

1..600
|> Enum.map(&(&1 / 10))
|> Enum.reduce(context, fn x, context ->
  context
  |> line_to({x, 15 + :math.sin(x) * 2 + (:rand.uniform() / 4 - 0.125)})
end)

move_to(context, {0, 35 + :math.cos(0) * 2})

1..600
|> Enum.map(&(&1 / 10))
|> Enum.reduce(context, fn x, context ->
  context
  |> line_to({x, 35 + :math.cos(x) * 2 + (:rand.uniform() / 4 - 0.125)})
end)

stroke(context)


ImageSurface.write_to_png(surface, "examples/sine.png")

