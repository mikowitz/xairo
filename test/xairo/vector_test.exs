defmodule Xairo.VectorTest do
  use ExUnit.Case, async: true

  alias Xairo.Vector

  describe "new/2" do
    test "returns a vector struct with values converted to floats" do
      assert Vector.new(20, 30.5) == %Vector{x: 20.0, y: 30.5}
    end
  end

  describe "from/1" do
    test "returns a Vector from a Vector" do
      assert Vector.from(Vector.new(3, 4)) == Vector.new(3, 4)
    end

    test "returns a point from a 2-element tuple" do
      assert Vector.from({4, 5}) == Vector.new(4, 5)
    end
  end
end
