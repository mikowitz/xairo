defmodule Xairo.Image do
  @moduledoc """
  Struct wrapping a `t:Xairo.surface/0` and its associated `Xairo.Context`
  """

  defstruct [:surface, :context, :filename]

  @type t :: %__MODULE__{
          surface: Xairo.surface(),
          context: Xairo.Context.t(),
          filename: String.t()
        }

  alias Xairo.{Context, ImageSurface, PdfSurface, PsSurface, SvgSurface}

  @doc """
  Creates a new `Xairo.Image` with the given settings.

  Based on the given `filename`, the correct underlying `t:Xairo.surface/0` struct
  will be used.

  """
  @spec new(String.t(), number(), number(), Keyword.t() | nil) :: t()
  def new(filename, width, height, opts \\ []) do
    with {:ok, surface} <- surface_from_filename(filename, width, height, opts) do
      %__MODULE__{
        surface: surface,
        context: Context.new(surface),
        filename: filename
      }
    end
  end

  defp surface_from_filename(filename, width, height, opts) do
    case Path.extname(filename) do
      ".png" -> new_png(filename, width, height, Keyword.get(opts, :format, :argb32))
      ".pdf" -> new_pdf(filename, width, height)
      ".ps" -> new_ps(filename, width, height)
      ".svg" -> new_svg(filename, width, height)
      _ -> {:error, "Xairo.Image.new/4 only supports PDF, PNG, PS, and SVG file formats"}
    end
  end

  @doc """
  Finalizes the image to the filesystem.

  In the case of .png images, this writes context and surface to the
  filesystem. For other image types, where creating the surface creates
  the file on the system, this calls `finish/1` on the surface to let the
  cairo library know that that image is complete.

  For more detail, see the documentation for the specific surface struct.
  """
  @spec save(t()) :: :ok
  def save(%__MODULE__{surface: surface = %ImageSurface{}, filename: filename}) do
    ImageSurface.write_to_png(surface, filename)
  end

  def save(%__MODULE__{surface: surface} = image) do
    surface.__struct__.finish(surface)
    image
  end

  defp new_png(_filename, width, height, format) do
    {:ok, ImageSurface.create(format, width, height)}
  end

  defp new_pdf(filename, width, height) do
    {:ok, PdfSurface.new(width, height, filename)}
  end

  defp new_ps(filename, width, height) do
    {:ok, PsSurface.new(width, height, filename)}
  end

  defp new_svg(filename, width, height) do
    {:ok, SvgSurface.new(width, height, filename)}
  end
end
