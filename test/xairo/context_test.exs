defmodule Xairo.ContextTest do
  use ExUnit.Case, async: true
  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface, PdfSurface, PsSurface, SvgSurface}
  alias Xairo.{LinearGradient, Mesh, RadialGradient, SolidPattern, SurfacePattern}
  alias Xairo.FontFace

  setup do
    surface = ImageSurface.create(:argb32, 100, 100)
    context = Context.new(surface)

    {:ok, surface: surface, context: context}
  end

  describe "new/1" do
    test "returns a Context built from an ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert is_struct(context, Context)
    end
  end

  describe "set_source_rgb/4" do
    test "sets the source color to an opaque RGB-defined color", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgb(0.5, 0, 1)
      |> Context.paint()

      assert_image(sfc, "set_source_rgb.png")
    end
  end

  describe "set_source_rgba/5" do
    test "sets the source color to an RGBA-defined color", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgba(0, 0.5, 1.0, 0.35)
      |> Context.paint()

      assert_image(sfc, "set_source_rgba.png")
    end
  end

  describe "arc/6" do
    test "draws a clockwise arc using the given coordinates", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.arc(50, 50, 25, 0, 1.5)
      |> Context.stroke()

      assert_image(sfc, "arc.png")
    end
  end

  describe "arc_negative/6" do
    test "draws a counter-clockwise arc using the given coordinates", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.arc_negative(50, 50, 25, 0, 1.5)
      |> Context.stroke()

      assert_image(sfc, "arc_negative.png")
    end
  end

  describe "(rel_)curve_to/7" do
    test "draws a curve with either absolute or relative coordinates from the origin", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(0, 0, 1)
      |> Context.curve_to(10, 30, 50, 5, 80, 20)
      |> Context.move_to(10, 50)
      |> Context.rel_curve_to(15, -5, 40, 20, 60, -20)
      |> Context.stroke()

      assert_image(sfc, "curve_to.png")
    end
  end

  describe "(rel_)line_to/3" do
    test "draws lines to absolute or relative coordinates from the origin", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(1, 1, 0)
      |> Context.move_to(10, 10)
      |> Context.line_to(50, 60)
      |> Context.rel_line_to(-20, -10)
      |> Context.stroke()

      assert_image(sfc, "line_to.png")
    end
  end

  describe "rectangle/5" do
    test "draws a rectangle from the given coordinate and dimensions", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(0, 1, 1)
      |> Context.paint_with_alpha(0.2)
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.rectangle(10, 10, 60, 40)
      |> Context.stroke_preserve()
      |> Context.set_source_rgba(0, 0, 1, 0.4)
      |> Context.fill()

      assert_image(sfc, "rectangle.png")
    end
  end

  describe "close_path/1" do
    test "connects the current point to the point of the most recent move_to", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(1, 0, 1)
      |> Context.move_to(10, 10)
      |> Context.line_to(40, 15)
      |> Context.line_to(60, 40)
      |> Context.rel_move_to(-20, -10)
      |> Context.line_to(5, 80)
      |> Context.line_to(20, 90)
      |> Context.close_path()
      |> Context.stroke()

      assert_image(sfc, "close_path.png")
    end
  end

  describe "new_path/1" do
    test "begins a new path and removes any existing path components", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(1, 0, 1)
      |> Context.move_to(10, 10)
      |> Context.line_to(15, 80)
      |> Context.new_path()
      |> Context.arc(60, 40, 20, 0, 4)
      |> Context.stroke()

      assert_image(sfc, "new_path.png")
    end
  end

  describe "new_sub_path/1" do
    test "begins a new path but retains existing path components", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgb(1, 0, 1)
      |> Context.move_to(10, 10)
      |> Context.line_to(15, 80)
      |> Context.new_sub_path()
      |> Context.arc(60, 40, 20, 0, 4)
      |> Context.stroke()

      assert_image(sfc, "new_sub_path.png")
    end
  end

  describe "target/1" do
    test "returns the correct surface stsruct for a PNG image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      target = Context.target(context)

      assert is_struct(target, ImageSurface)
    end

    test "returns the correct surface stsruct for a PDF image" do
      surface = PdfSurface.new(100, 100, "pdf.pdf")
      context = Context.new(surface)

      target = Context.target(context)
      assert is_struct(target, PdfSurface)

      File.rm("pdf.pdf")
    end

    test "returns the correct surface stsruct for a PS image" do
      surface = PsSurface.new(100, 100, "ps.ps")
      context = Context.new(surface)

      target = Context.target(context)
      assert is_struct(target, PsSurface)

      File.rm("ps.ps")
    end

    test "returns the correct surface stsruct for an SVG image" do
      surface = SvgSurface.new(100, 100, "svg.svg")
      context = Context.new(surface)

      target = Context.target(context)
      assert is_struct(target, SvgSurface)

      File.rm("svg.svg")
    end
  end

  describe "copy_path/1" do
    test "returns a Path struct" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      path = Context.copy_path(context)

      assert is_struct(path, Xairo.Path)
    end
  end

  describe "copy_path_flat/1" do
    test "returns a Path struct" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      path = Context.copy_path_flat(context)

      assert is_struct(path, Xairo.Path)
    end
  end

  describe "append_path/2" do
    test "appends the given path to the context's path" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.set_source_rgb(0, 1, 0)
        |> Context.move_to(10, 10)
        |> Context.line_to(50, 50)
        |> Context.line_to(20, 70)
        |> Context.close_path()

      path = Context.copy_path(context)

      Context.new_path(context)

      assert_image(surface, "before_append_path.png")

      context
      |> Context.append_path(path)
      |> Context.fill()

      assert_image(surface, "after_append_path.png")
    end

    test "copy_flat_path copies the path, replacing curves with approximations of straight lines" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.set_source_rgb(0, 0, 0)
        |> Context.paint()
        |> Context.set_source_rgb(1, 1, 1)
        |> Context.arc(50, 50, 40, 0, 3.5)
        |> Context.set_tolerance(10)

      path = Context.copy_path_flat(context)

      context
      |> Context.set_tolerance(0.1)
      |> Context.stroke()
      |> Context.append_path(path)
      |> Context.stroke()

      assert_image(surface, "copy_path_flat.png")
    end
  end

  describe "tolerance/1" do
    test "returns the current path tolerance of the context" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert Context.tolerance(context) == 0.1
    end
  end

  describe "set_tolerance/2" do
    test "sets the current path tolerance for the context" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.set_tolerance(10)

      assert Context.tolerance(context) == 10.0
    end
  end

  describe "has_current_point/1" do
    test "returns false before any drawing has been done" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context = Context.new(surface)

      refute Context.has_current_point(context)
    end

    test "returns false after stroke has been called" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.line_to(50, 50)
        |> Context.stroke()

      refute Context.has_current_point(context)
    end

    test "returns true after any addition to the path" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.line_to(50, 50)

      assert Context.has_current_point(context)
    end

    test "returns false after new_path is called" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.line_to(50, 50)
        |> Context.new_path()

      refute Context.has_current_point(context)
    end

    test "returns false after new_sub_path is called" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.line_to(50, 50)
        |> Context.new_sub_path()

      refute Context.has_current_point(context)
    end
  end

  describe "current_point/1" do
    test "returns the current point when it exists" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.line_to(50, 50)

      assert Context.current_point(context) == {50.0, 50.0}
    end

    test "returns {0.0, 0.0} when there is no current point" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context = Context.new(surface)

      assert Context.current_point(context) == {0.0, 0.0}
    end
  end

  describe "set_source/2" do
    test "sets a linear gradient as the color source for an image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      lg =
        LinearGradient.new(0, 0, 100, 50)
        |> LinearGradient.add_color_stop_rgb(0.2, 1, 0, 0)
        |> LinearGradient.add_color_stop_rgb(0.8, 0.5, 0, 1)

      context =
        context
        |> Context.set_source(lg)
        |> Context.paint()

      assert_image(surface, "linear_gradient.png")

      assert Context.source(context) == lg
    end

    test "sets a radial gradient as the color source for an image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      rg =
        RadialGradient.new(50, 50, 10, 50, 50, 50)
        |> RadialGradient.add_color_stop_rgb(0.2, 1, 0, 0)
        |> RadialGradient.add_color_stop_rgb(1, 0.5, 0, 1)

      context =
        context
        |> Context.set_source(rg)
        |> Context.paint()

      assert_image(surface, "radial_gradient.png")

      assert Context.source(context) == rg
    end

    test "sets a solid pattern as the color source for an image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      sp = SolidPattern.from_rgb(0.3, 0.5, 1.0)

      context =
        context
        |> Context.set_source(sp)
        |> Context.paint()

      assert_image(surface, "solid_pattern.png")

      assert Context.source(context) == sp
    end

    test "sets a surface pattern as the color source for an image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      pattern_surface = ImageSurface.create(:argb32, 100, 100)
      pattern_context = Context.new(pattern_surface)

      pattern_context
      |> Context.set_source_rgb(1, 1, 1)
      |> Context.paint()
      |> Context.set_source_rgb(1, 0.5, 0)
      |> Context.move_to(0, 0)
      |> Context.line_to(100, 100)
      |> Context.stroke()
      |> Context.set_source_rgba(0, 1, 1, 0.5)
      |> Context.move_to(100, 0)
      |> Context.line_to(0, 100)
      |> Context.stroke()

      sp = SurfacePattern.create(pattern_surface)

      context =
        context
        |> Context.set_source(sp)
        |> Context.rectangle(20, 20, 60, 70)
        |> Context.fill()

      assert_image(surface, "surface_pattern.png")

      assert Context.source(context) == sp
    end

    test "sets a mesh as the color source for an image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(10, 10)
        |> Mesh.curve_to(20, 20, 50, -10, 130, -30)
        |> Mesh.curve_to(80, 20, 90, 30, 100, 100)
        |> Mesh.curve_to(20, 100, 10, 130, -10, 80)
        |> Mesh.curve_to(0, 70, 10, 50, -10, -10)
        |> Mesh.set_corner_color_rgb(0, 1, 0, 0)
        |> Mesh.set_corner_color_rgb(1, 1, 0.5, 0)
        |> Mesh.set_corner_color_rgb(2, 1, 1, 0)
        |> Mesh.set_corner_color_rgb(3, 0.5, 1, 0)
        |> Mesh.end_patch()
        |> Mesh.begin_patch()
        |> Mesh.move_to(0, 0)
        |> Mesh.line_to(90, 30)
        |> Mesh.line_to(30, 90)
        |> Mesh.line_to(0, 0)
        |> Mesh.set_corner_color_rgba(0, 0, 1, 0, 0.5)
        |> Mesh.set_corner_color_rgba(1, 0, 1, 0.5, 0.5)
        |> Mesh.set_corner_color_rgba(2, 0, 0.5, 1, 0.5)
        |> Mesh.end_patch()

      context
      |> Context.set_source_rgb(1, 1, 1)
      |> Context.paint()
      |> Context.set_source(mesh)
      |> Context.rectangle(10, 20, 70, 50)
      |> Context.fill()

      assert_image(surface, "mesh.png")
    end
  end

  describe "show_text/2" do
    @tag :macos
    test "displays the text on the image" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      context
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.move_to(20, 20)
      |> Context.show_text("hello")
      |> Context.stroke()

      assert_image(surface, "show_text.png")
    end
  end

  describe "text_path/2" do
    @tag :macos
    test "adds closed segments of path to the current path that outline the text" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      context
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.move_to(10, 80)
      |> Context.set_font_size(40)
      |> Context.text_path("hello")
      |> Context.stroke()

      assert_image(surface, "text_path.png")
    end
  end

  describe "set_font_face/2" do
    test "sets the font face for the image" do
      ff = FontFace.toy_create("serif", :normal, :bold)

      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.set_font_face(ff)

      assert Context.font_face(context) == ff
    end
  end

  describe "select_font_face/4" do
    test "sets the font face from its component parts" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.select_font_face("sans", :oblique, :normal)

      ff = Context.font_face(context)

      assert FontFace.toy_get_family(ff) == "sans"
      assert FontFace.toy_get_slant(ff) == :oblique
      assert FontFace.toy_get_weight(ff) == :normal
    end
  end
end
