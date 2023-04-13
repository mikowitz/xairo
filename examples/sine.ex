alias Xairo.{Image, Rgba}

import Xairo

scale = 50

image =
  Image.new("examples/sine.png", 60 * scale, 60 * scale)
  |> scale(scale, scale)
  |> set_source(Rgba.new(0.6, 0.6, 0.6))
  |> paint()
  |> set_source(Rgba.new(0.1, 0.1, 0.2))
  |> set_line_width(0.1)
  |> move_to({0, 15 + :math.sin(0) * 2})

:rand.seed(:exsplus, {1, 2, 3})

1..600
|> Enum.map(&(&1 / 10))
|> Enum.reduce(image, fn x, image ->
  image
  |> line_to({x, 15 + :math.sin(x) * 2 + (:rand.uniform() / 4 - 0.125)})
end)

move_to(image, {0, 35 + :math.cos(0) * 2})

1..600
|> Enum.map(&(&1 / 10))
|> Enum.reduce(image, fn x, image ->
  image
  |> line_to({x, 35 + :math.cos(x) * 2 + (:rand.uniform() / 4 - 0.125)})
end)

stroke(image)


Image.save(image)

