defmodule Xairo.Api.CalcTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, Point, Vector}

  import Xairo

  describe "has_current_point/1" do
    test "returns false before any drawing has been done" do
      image = Image.new("test.png", 100, 100)

      refute has_current_point(image)
    end

    test "returns false after stroke has been called" do
      image =
        Image.new("test.png", 100, 100)
        |> line_to(Point.new(50, 50))
        |> stroke()

      refute has_current_point(image)
    end

    test "returns true after any addition to the path" do
      image =
        Image.new("test.png", 100, 100)
        |> line_to(Point.new(50, 50))

      assert has_current_point(image)
    end

    test "returns false after new_path is called" do
      image =
        Image.new("test.png", 100, 100)
        |> line_to(Point.new(50, 50))
        |> new_path()

      refute has_current_point(image)
    end

    test "returns false after new_sub_path is called" do
      image =
        Image.new("test.png", 100, 100)
        |> line_to(Point.new(50, 50))
        |> new_sub_path()

      refute has_current_point(image)
    end
  end

  describe "current_point/1" do
    test "returns the current point when it exists" do
      image =
        Image.new("test.png", 100, 100)
        |> line_to(Point.new(50, 50))

      assert current_point(image) == Point.new(50, 50)
    end

    test "returns {0.0, 0.0} when there is no current point" do
      image = Image.new("test.png", 100, 100)

      assert current_point(image) == Point.new(0, 0)
    end
  end

  describe "in_stroke/3" do
    test "returns true if the given point falls in the region that would be inked by a call to `stroke`" do
      image =
        Image.new("test.png", 100, 100)
        |> rectangle(Point.new(10, 10), 50, 50)

      assert in_stroke(image, Point.new(10, 10))
      assert in_stroke(image, Point.new(60, 60))
      refute in_stroke(image, Point.new(30, 30))
      refute in_stroke(image, Point.new(5, 10))
    end

    test "takes line width into account" do
      image =
        Image.new("test.png", 100, 100)
        |> rectangle(Point.new(10, 10), 50, 50)
        |> set_line_width(10)

      assert in_stroke(image, Point.new(5, 10))
    end
  end

  describe "in_fill/3" do
    test "returns true if the given point falls in the region that would be inked by a call to `fill`" do
      image =
        Image.new("test.png", 100, 100)
        |> rectangle(Point.new(10, 10), 50, 50)

      assert in_fill(image, Point.new(10, 10))
      assert in_fill(image, Point.new(50, 50))
      assert in_fill(image, Point.new(30, 30))
      refute in_fill(image, Point.new(5, 10))
    end
  end

  describe "user_to_device/2 passing a point" do
    test "translates a coordinate from user space to device space using the CTM" do
      image =
        Image.new("test.png", 100, 100)
        |> scale(3, 4)
        |> translate(10, 20)

      assert user_to_device(image, Point.new(10, 10)) == Point.new(60.0, 120.0)
    end

    test "transformation order affects the end result" do
      image =
        Image.new("test.png", 100, 100)
        |> translate(10, 20)
        |> scale(3, 4)

      assert user_to_device(image, Point.new(10, 10)) == Point.new(40.0, 60.0)
    end
  end

  describe "user_to_device/2 passing a vector" do
    test "translates a distance from user space to device space using the CTM" do
      image =
        Image.new("test.png", 100, 100)
        |> scale(3, 4)
        |> translate(10, 20)

      assert user_to_device(image, Vector.new(10, 10)) == Vector.new(30.0, 40.0)
    end

    test "transformation order affects the end result" do
      image =
        Image.new("test.png", 100, 100)
        |> translate(10, 20)
        |> scale(3, 4)

      assert user_to_device(image, Vector.new(10, 10)) == Vector.new(30.0, 40.0)
    end
  end

  describe "device_to_user/2 passing a point" do
    test "translates a coordinate from user space to device space using the CTM" do
      image =
        Image.new("test.png", 100, 100)
        |> scale(3, 4)
        |> translate(10, 20)

      %Point{x: x, y: y} = device_to_user(image, Point.new(10, 10))
      assert_in_delta x, -6.66666, 0.0001
      assert y == -17.5
    end

    test "transformation order affects the end result" do
      image =
        Image.new("test.png", 100, 100)
        |> translate(10, 20)
        |> scale(3, 4)

      assert device_to_user(image, Point.new(10, 10)) == Point.new(0.0, -2.5)
    end
  end

  describe "device_to_user/2 passing a vector" do
    test "translates a distance from user space to device space using the CTM" do
      image =
        Image.new("test.png", 100, 100)
        |> scale(3, 4)
        |> translate(10, 20)

      %Vector{x: x, y: y} = device_to_user(image, Vector.new(10, 10))
      assert_in_delta x, 3.3333, 0.0001
      assert y == 2.5
    end

    test "transformation order affects the end result" do
      image =
        Image.new("test.png", 100, 100)
        |> translate(10, 20)
        |> scale(3, 4)

      %Vector{x: x, y: y} = device_to_user(image, Vector.new(10, 10))
      assert_in_delta x, 3.3333, 0.0001
      assert y == 2.5
    end
  end
end
