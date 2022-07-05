defmodule Xairo.SurfacePattern do
  @moduledoc """
  Models a color source for a drawing surface that draws its data from
  an associated surface.

  A `Xairo.SurfacePattern` can be created from any supported type of surface:

  * `Xairo.ImageSurface`
  * `Xairo.PdfSurface`
  * `Xairo.PsSurface`
  * `Xairo.SvgSurface`

  though using a `Xairo.ImageSurface` has the advantage that the underlying surface
  will not be written to the file system.

  ## Example

  This code creates a surface painted red with a diagonal blue line

  ```
  pattern = ImageSurface.create(:argb32, 100, 100)
  context = Context.new(pattern)
  |> Context.set_source(Rgba.new(1, 0, 0))
  |> Context.paint()
  |> Context.set_color(Rgba.new(0, 0, 1))
  |> Context.move_to({0, 0})
  |> Context.line_to({100, 100})
  |> Context.stroke()
  ```

  Then it can be set as the source for another image and used to render
  color data onto the image

  ```
  surface = ImageSurface.create(:argb32, 100, 100)
  Context.new(surface)
  |> Context.set_source(pattern)
  |> Context.rectangle({20, 20}, 30, 40)
  |> Context.fill()
  ```

  Because Xairo surfaces and surface patterns are references to mutable, in-memory
  Rust structs, it is possible to create a Surface pattern, assign it as a source,
  and *then* set its contents, as long as it is inked via calls to `paint`, `fill`,
  and `stroke` before the image it is set as the source for uses it.

  To illustrate, the code below will return the same final image as the code above

  ```
  pattern = ImageSurface.create(:argb32, 100, 100)
  pattern_context = Context.new(pattern)

  image = ImageSurface.create(:argb32, 100, 100)
  context = Context.new(image)
  |> Context.set_source(pattern)

  pattern_context
  |> Context.set_source(Rgba.new(1, 0, 0))
  |> Context.paint()
  |> Context.set_color(Rgba.new(0, 0, 1))
  |> Context.move_to({0, 0})
  |> Context.line_to({100, 100})
  |> Context.stroke()

  context
  |> Context.rectangle({20, 20}, 30, 40)
  |> Context.fill()
  ```

  """
  defstruct [:pattern, :surface]

  @typedoc """
  The Elixir model of the pattern. Stores a reference to the in-memory representation
  of the pattern, as well as the Elixir surface struct from which it was constructed.
  """
  @type t :: %__MODULE__{
          pattern: reference(),
          surface: Xairo.surface()
        }

  @spec create(Xairo.surface()) :: t()

  def create(%Xairo.ImageSurface{surface: s} = surface) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_image_surface(s),
      surface: surface
    }
  end

  def create(%Xairo.PdfSurface{surface: s} = surface) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_pdf_surface(s),
      surface: surface
    }
  end

  def create(%Xairo.PsSurface{surface: s} = surface) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_ps_surface(s),
      surface: surface
    }
  end

  def create(%Xairo.SvgSurface{surface: s} = surface) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_svg_surface(s),
      surface: surface
    }
  end

  @spec surface(t()) :: Xairo.surface()
  def surface(%__MODULE__{surface: surface}), do: surface
end
