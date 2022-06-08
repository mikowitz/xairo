defmodule Xairo.PointTest do
  use ExUnit.Case, async: true

  alias Xairo.Point

  describe "new/2" do
    test "returns a point struct with values converted to floats" do
      assert Point.new(1, 3) == %Point{x: 1.0, y: 3.0}
    end
  end
end
