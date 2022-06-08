defmodule Xairo.RgbaTest do
  use ExUnit.Case, async: true

  alias Xairo.Rgba

  describe "new/3" do
    test "sets the color to fully opaque" do
      assert Rgba.new(0, 1, 0.5) == %Rgba{
               red: 0.0,
               green: 1.0,
               blue: 0.5,
               alpha: 1.0
             }
    end

    test "clamps values to the range [0.0, 1.0]" do
      assert Rgba.new(-1, 1.5, 0) == %Rgba{
               red: 0.0,
               green: 1.0,
               blue: 0.0,
               alpha: 1.0
             }
    end
  end

  describe "new/4" do
    test "sets the alpha value of the color as well" do
      assert Rgba.new(1, 0.5, 0.3, 0.47) == %Rgba{
               red: 1.0,
               green: 0.5,
               blue: 0.3,
               alpha: 0.47
             }
    end
  end
end
