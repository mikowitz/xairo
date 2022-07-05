defmodule Xairo.PathTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, Point, Vector}

  import Xairo

  describe "Enum.empty?/1" do
    test "returns true for an empty path" do
      image = Image.new("test.png", 100, 100)

      path = copy_path(image)

      assert Enum.empty?(path)
    end

    test "returns the length for a non-empty path" do
      path =
        Image.new("test.png", 100, 100)
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(50, 50))
        |> rel_curve_to(Vector.new(20, 20), Vector.new(30, 40), Vector.new(15, 45))
        |> close_path()
        |> copy_path()

      assert Enum.count(path) == 5
    end
  end

  describe "Enum.at/2" do
    test "returns nil for an empty path" do
      image = Image.new("test.png", 100, 100)
      path = copy_path(image)

      refute Enum.at(path, 0)
      refute Enum.at(path, 3)
    end

    test "returns the segment for a non-empty path" do
      path =
        Image.new("test.png", 100, 100)
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(50, 50))
        |> rel_curve_to(Vector.new(20, 20), Vector.new(30, 40), Vector.new(15, 45))
        |> close_path()
        |> close_path()
        |> copy_path()

      assert Enum.at(path, 0) == {:move_to, Point.new(10.0, 10.0)}
      assert Enum.at(path, -1) == {:move_to, Point.new(10.0, 10.0)}
    end
  end

  describe "Enum.reduce/3" do
    test "returns a list of the path segment commands" do
      path =
        Image.new("test.png", 100, 100)
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(50, 50))
        |> rel_curve_to(Vector.new(20, 20), Vector.new(30, 40), Vector.new(15, 45))
        |> close_path()
        |> copy_path()

      assert Enum.reduce(path, [], fn segment, acc ->
               command =
                 case segment do
                   :close_path -> :close_path
                   segment -> elem(segment, 0)
                 end

               acc ++ [command]
             end) == [:move_to, :line_to, :curve_to, :close_path, :move_to]
    end
  end

  describe "Enum.member?/2" do
    test "returns the correct result for whether a step is part of the path" do
      path =
        Image.new("test.png", 100, 100)
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(50, 50))
        |> rel_curve_to({20, 20}, {30, 40}, {15, 45})
        |> close_path()
        |> copy_path()

      refute Enum.member?(
               path,
               {:curve_to, Point.new(20.0, 20.0), Point.new(30.0, 40.0), Point.new(15.0, 45.0)}
             )

      assert Enum.member?(
               path,
               {:curve_to, Point.new(70.0, 70.0), Point.new(80.0, 90.0), Point.new(65.0, 95.0)}
             )
    end
  end
end
