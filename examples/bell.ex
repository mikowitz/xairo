alias Xairo.{Image, Rgba}

import Xairo

dot = fn image, x, y ->
  old_line_cap = line_cap(image)
  old_line_width = line_width(image)
  image
  |> set_line_cap(:round)
  |> set_line_width(0.1)
  |> move_to({x, y})
  |> line_to({x, y})
  |> stroke()
  |> set_line_width(old_line_width)
  |> set_line_cap(old_line_cap)
end

scale = 100

image =
  Image.new("examples/bell.png", 60 * scale, 60 * scale)
  |> scale(scale, scale)
  |> set_source(Rgba.new(0.9, 0.9, 0.9))
  |> paint()
  |> set_source(Rgba.new(0.1, 0.1, 0.5, 0.25))
  |> set_line_width(0.1)

:rand.seed(:exsplus, {1, 2, 3})

image = Enum.reduce(1..10_000, image, fn _, image ->
  x = (:rand.normal() + 1) * 30
  y = :rand.normal(0, 500)

  if x > 5 && x < 55 && y > 5 && y < 55 do
    dot.(image, x, y)
  else
    image
  end
end)

Image.save(image)


