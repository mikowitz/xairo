defmodule Xairo.Api.TextTest do
  use ExUnit.Case, async: true

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{FontFace, Image, Point, Rgba}
  import Xairo

  describe "show_text/2" do
    @tag macos: false
    test "displays the text on the image" do
      Image.new("show_text.png", 100, 100)
      |> set_source(Rgba.new(0, 0, 0))
      |> move_to(Point.new(20, 20))
      |> show_text("hello")
      |> stroke()
      |> assert_image()
    end
  end

  describe "text_path/2" do
    @tag macos: false
    test "adds closed segments of path to the current path that outline the text" do
      Image.new("text_path.png", 100, 100)
      |> set_source(Rgba.new(0, 0, 0))
      |> move_to(Point.new(10, 80))
      |> set_font_size(40)
      |> text_path("hello")
      |> stroke()
      |> assert_image()
    end
  end

  describe "set_font_face/2" do
    test "sets the font face for the image" do
      ff = FontFace.toy_create("serif", :normal, :bold)

      image =
        Image.new("test.png", 100, 100)
        |> set_font_face(ff)

      assert font_face(image) == ff
    end
  end

  describe "select_font_face/4" do
    test "sets the font face from its component parts" do
      image =
        Image.new("test.png", 100, 100)
        |> select_font_face("sans", :oblique, :normal)

      ff = font_face(image)

      assert FontFace.toy_get_family(ff) == "sans"
      assert FontFace.toy_get_slant(ff) == :oblique
      assert FontFace.toy_get_weight(ff) == :normal
    end
  end
end
