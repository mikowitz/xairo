alias Xairo.{Image, Rgba}

import Xairo

scale = 10

:rand.seed(:exsplus, {1, 2, 3})

image =
  Image.new("examples/squiggles.png", 60 * scale, 60 * scale)
  |> scale(scale, scale)
  |> set_source(Rgba.new(0.6, 0.6, 0.6))
  |> paint()
  |> set_source(Rgba.new(0.1, 0.1, 0.2))
  |> set_line_width(0.1)
  |> move_to({0, 15 + :math.sin(0) * 2})

image = Enum.map(0..360, &(&1 / 3))
|> Enum.reduce(image, fn i, image ->
  move_to(image, {0, i})
  1..600
  |> Enum.map(&(&1 / 10))
  |> Enum.reduce(image, fn x, image ->
    x_tweak = (:rand.uniform() / 16 - 0.03125)
    y_tweak = (:rand.uniform() / 12 - 0.0625)
    if i > 15 && i < 40 && x > 25 && x < 35 do
      move_to(image, {x + x_tweak, i + y_tweak})
    else
      line_to(image, {x + x_tweak, i + y_tweak})
    end
  end)
  stroke(image)
end)

Image.save(image)
