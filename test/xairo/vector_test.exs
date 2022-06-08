defmodule Xairo.VectorTest do
  use ExUnit.Case, async: true

  alias Xairo.Vector

  describe "new/2" do
    test "returns a vector struct with values converted to floats" do
      assert Vector.new(20, 30.5) == %Vector{x: 20.0, y: 30.5}
    end
  end
end
