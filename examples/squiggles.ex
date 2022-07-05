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

for i <- Enum.map(0..240, &(&1 / 4)) do
  move_to(context, {0, i})
  1..600
  |> Enum.map(&(&1 / 10))
  |> Enum.reduce(context, fn x, context ->
    x_tweak = (:rand.uniform() / 16 - 0.03125)
    y_tweak = (:rand.uniform() / 12 - 0.0625)
    if i > 10 && i < 40 && x > 10 && x < 50 do
      move_to(context, {x + x_tweak, i + y_tweak})
    else
      line_to(context, {x + x_tweak, i + y_tweak})
    end
  end)
  stroke(context)
end

ImageSurface.write_to_png(surface, "examples/squiggle.png")
