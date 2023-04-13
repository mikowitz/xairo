alias Xairo.{Image, Rgba}

import Xairo

scale = 50

rando = fn -> :rand.uniform() / 4 - 0.125 end

add_square = fn image, x, y -> rectangle(image, {x, y}, 1.5 + rando.(), 1.5 + rando.()) end

image =
  Image.new("examples/squares.png", 60 * scale, 60 * scale)
  |> scale(scale, scale)
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

colors = [
  Rgba.new(0.1, 0.1, 0.2),
  Rgba.new(0.5, 0.2, 0.6),
  Rgba.new(0.3, 0.5, 0.6),
]

image =
  Enum.reduce(points, image, fn {x, y}, image ->
    image = add_square.(image, x, y)
      |> set_source(Enum.random(colors))
    case :rand.uniform() > 0.6 do
      false -> fill(image)
      true -> stroke(image)
    end
  end)

Image.save(image)
