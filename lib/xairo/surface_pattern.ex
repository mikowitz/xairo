defmodule Xairo.SurfacePattern do
  defstruct [:pattern, :surface]

  def create(%Xairo.ImageSurface{surface: surface} = sfc) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_image_surface(surface),
      surface: sfc
    }
  end

  def create(%Xairo.PdfSurface{surface: surface} = sfc) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_pdf_surface(surface),
      surface: sfc
    }
  end

  def create(%Xairo.PsSurface{surface: surface} = sfc) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_ps_surface(surface),
      surface: sfc
    }
  end

  def create(%Xairo.SvgSurface{surface: surface} = sfc) do
    %__MODULE__{
      pattern: Xairo.Native.surface_pattern_create_from_svg_surface(surface),
      surface: sfc
    }
  end

  def surface(%__MODULE__{surface: surface}), do: surface
end
