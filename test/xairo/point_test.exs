defmodule Xairo.PointTest do
  use ExUnit.Case, async: true

  alias Xairo.Point

  doctest Point

  describe "new/2" do
    test "returns a point struct with values converted to floats" do
      assert Point.new(1, 3) == %Point{x: 1.0, y: 3.0}
    end
  end

  describe "from/1" do
    test "returns a Point from a Point" do
      assert Point.from(Point.new(3, 4)) == Point.new(3, 4)
    end

    test "returns a point from a 2-element tuple" do
      assert Point.from({4, 5}) == Point.new(4, 5)
    end
  end
end
