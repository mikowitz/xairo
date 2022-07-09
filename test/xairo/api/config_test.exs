defmodule Xairo.Api.ConfigTest do
  use ExUnit.Case

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Image, Point, Rgba}

  import Xairo

  describe "tolerance/1" do
    test "returns the current path tolerance of the context" do
      image = Image.new("test.png", 100, 100)

      assert tolerance(image) == 0.1
    end
  end

  describe "set_tolerance/2" do
    test "sets the current path tolerance for the context" do
      image =
        Image.new("test.png", 100, 100)
        |> set_tolerance(10)

      assert tolerance(image) == 10.0
    end
  end

  describe "line_width/1" do
    test "returns the currently set line_width" do
      image = Image.new("test.png", 100, 100)

      assert line_width(image) == 2.0

      image = set_line_width(image, 0.1)

      assert line_width(image) == 0.1
    end
  end

  describe "set_antialias/2" do
    test "determines the antialiasing option for drawing" do
      draw = fn image, radius ->
        image
        |> arc_negative(Point.new(50, 50), radius, 0, 1.5)
        |> stroke()
      end

      Image.new("antialias.png", 100, 100)
      |> set_source(Rgba.new(0, 0, 0))
      |> draw.(25)
      |> set_antialias(:none)
      |> draw.(20)
      |> set_antialias(:gray)
      |> draw.(30)
      |> set_antialias(:subpixel)
      |> draw.(35)
      |> set_antialias(:fast)
      |> draw.(40)
      |> set_antialias(:good)
      |> draw.(45)
      |> set_antialias(:best)
      |> draw.(50)
      |> assert_image()
    end
  end

  describe "antialias/1" do
    test "returns the context's current antialias setting" do
      image =
        Image.new("test.png", 100, 100)
        |> set_antialias(:none)

      assert antialias(image) == :none

      image = set_antialias(image, :good)

      assert antialias(image) == :good
    end
  end

  describe "set_fill_rule/2" do
    test "determines the fill rule for the next drawn portion of the image" do
      Image.new("fill_rule.png", 100, 100)
      |> rectangle(Point.new(10, 10), 50, 20)
      |> new_sub_path()
      |> arc(Point.new(20, 20), 15, 0, 2 * :math.pi())
      |> set_fill_rule(:even_odd)
      |> set_source(Rgba.new(0, 0.5, 0))
      |> fill_preserve()
      |> set_source(Rgba.new(0, 0, 0))
      |> stroke()
      |> translate(25, 50)
      |> rectangle(Point.new(10, 10), 50, 20)
      |> new_sub_path()
      |> arc(Point.new(20, 20), 15, 0, 2 * :math.pi())
      |> set_fill_rule(:winding)
      |> set_source(Rgba.new(0, 0, 1))
      |> fill_preserve()
      |> set_source(Rgba.new(0, 0, 0))
      |> stroke()
      |> assert_image()
    end
  end

  describe "fill_rule/1" do
    test "returns the current fill rule for the context" do
      image = Image.new("test.png", 100, 100)
      assert fill_rule(image) == :winding
    end
  end

  describe "set_line_cap/2" do
    test "determines how line ends are displayed" do
      Image.new("line_cap.png", 100, 100)
      |> set_line_width(10)
      |> set_line_cap(:butt)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(90, 10))
      |> stroke()
      |> translate(0, 30)
      |> set_line_cap(:round)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(90, 10))
      |> stroke()
      |> translate(0, 30)
      |> set_line_cap(:square)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(90, 10))
      |> stroke()
      |> assert_image()
    end
  end

  describe "line_cap/1" do
    test "returns the current setting for the line cap" do
      image = Image.new("test.png", 100, 100)

      assert line_cap(image) == :butt
    end
  end

  describe "set_line_join/2" do
    test "sets the style for line join" do
      Image.new("line_join.png", 100, 100)
      |> set_line_width(10)
      |> set_line_join(:miter)
      |> rectangle(Point.new(10, 10), 30, 30)
      |> stroke()
      |> translate(50, 0)
      |> set_line_join(:round)
      |> rectangle(Point.new(10, 10), 30, 30)
      |> stroke()
      |> translate(0, 50)
      |> set_line_join(:bevel)
      |> rectangle(Point.new(10, 10), 30, 30)
      |> stroke()
      |> translate(-50, 0)
      |> set_miter_limit(1)
      |> set_line_join(:miter)
      |> rectangle(Point.new(10, 10), 30, 30)
      |> stroke()
      |> assert_image()
    end
  end

  describe "line_join/1" do
    test "returns the current line join setting for the context" do
      image = Image.new("test.png", 100, 100)

      assert line_join(image) == :miter
    end
  end

  describe "miter_limit/1" do
    test "returns the currently set miter limit" do
      image = Image.new("test.png", 100, 100)

      assert miter_limit(image) == 10.0
    end
  end

  describe "document_unit/1" do
    test "returns the correct value for an SVG image" do
      image = Image.new("test.svg", 100, 100)

      assert document_unit(image) == :pt

      :ok = File.rm("test.svg")
    end

    test "raises an error for a non-SVG image" do
      image = Image.new("test.png", 100, 100)

      assert document_unit(image) ==
               {:error, :cannot_get_document_unit_for_non_svg_image}
    end
  end

  describe "set_document_unit/1" do
    test "returns the correct value for an SVG image" do
      image =
        Image.new("test.svg", 100, 100)
        |> set_document_unit(:mm)

      assert document_unit(image) == :mm

      :ok = File.rm("test.svg")
    end

    test "raises an error for an invalid variant" do
      image = Image.new("test.svg", 100, 100)

      assert_raise ErlangError, ~r/:invalid_variant/, fn ->
        set_document_unit(image, :hello)
      end

      :ok = File.rm("test.svg")
    end

    test "returns an error for a non-SVG image" do
      image = Image.new("test.png", 100, 100)

      assert set_document_unit(image, :mm) ==
               {:error, :cannot_set_document_unit_for_non_svg_image}
    end
  end
end
