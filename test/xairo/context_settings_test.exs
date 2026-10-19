defmodule Xairo.ContextSettingsTest do
  use ExUnit.Case, async: true

  import Xairo.TestHelpers

  setup :with_context

  test "defaults", %{ctx: ctx} do
    assert Xairo.get_antialias(ctx) == :default
    assert Xairo.get_dash(ctx) == {[], 0.0}
    assert Xairo.get_fill_rule(ctx) == :winding
    assert Xairo.get_line_cap(ctx) == :butt
    assert Xairo.get_line_join(ctx) == :miter
    assert Xairo.get_line_width(ctx) == 2.0
    assert Xairo.get_miter_limit(ctx) == 10.0
    assert Xairo.get_operator(ctx) == :over
    assert Xairo.get_tolerance(ctx) == 0.1
  end

  describe "setter and getter round trips" do
    test "antialias", %{ctx: ctx} do
      for antialias <- [:default, :none, :gray, :subpixel, :fast, :good, :best] do
        assert Xairo.set_antialias(ctx, antialias) |> Xairo.get_antialias() == antialias
      end
    end

    test "dash", %{ctx: ctx} do
      assert Xairo.set_dash(ctx, [6, 5, 4], 1) |> Xairo.get_dash() == {[6.0, 5.0, 4.0], 1}
    end

    test "fill_rule", %{ctx: ctx} do
      for rule <- [:winding, :even_odd] do
        assert Xairo.set_fill_rule(ctx, rule) |> Xairo.get_fill_rule() == rule
      end
    end

    test "line_cap", %{ctx: ctx} do
      for cap <- [:butt, :round, :square] do
        assert Xairo.set_line_cap(ctx, cap) |> Xairo.get_line_cap() == cap
      end
    end

    test "line_join", %{ctx: ctx} do
      for join <- [:miter, :round, :bevel] do
        assert Xairo.set_line_join(ctx, join) |> Xairo.get_line_join() == join
      end
    end

    test "line_width", %{ctx: ctx} do
      assert Xairo.set_line_width(ctx, 7) |> Xairo.get_line_width() == 7.0
    end

    test "miter_limit", %{ctx: ctx} do
      assert Xairo.set_miter_limit(ctx, 7) |> Xairo.get_miter_limit() == 7.0
    end

    test "operator", %{ctx: ctx} do
      for op <- [
            :clear,
            :source,
            :over,
            :in,
            :out,
            :atop,
            :dest,
            :dest_over,
            :dest_in,
            :dest_out,
            :dest_atop,
            :xor,
            :add,
            :saturate,
            :multiply,
            :screen,
            :overlay,
            :darken,
            :lighten,
            :color_dodge,
            :color_burn,
            :hard_light,
            :soft_light,
            :difference,
            :exclusion,
            :hsl_hue,
            :hsl_saturation,
            :hsl_color,
            :hsl_luminosity
          ] do
        assert Xairo.set_operator(ctx, op) |> Xairo.get_operator() == op
      end
    end

    test "tolerance", %{ctx: ctx} do
      assert Xairo.set_tolerance(ctx, 1) |> Xairo.get_tolerance() == 1.0
    end
  end

  describe "invalid enums raise errors" do
    test "antialias", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn -> apply(Xairo, :set_antialias, [ctx, :nonsense]) end
    end

    test "fill_rule", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn -> apply(Xairo, :set_fill_rule, [ctx, :nonsense]) end
    end

    test "line_cap", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn -> apply(Xairo, :set_line_cap, [ctx, :nonsense]) end
    end

    test "line_join", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn -> apply(Xairo, :set_line_join, [ctx, :nonsense]) end
    end

    test "operator", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn -> apply(Xairo, :set_operator, [ctx, :nonsense]) end
    end
  end

  describe "set_dash/3" do
    test "set_dash/3 returns the ctx when successful", %{ctx: ctx} do
      assert Xairo.set_dash(ctx, [5.5, 3], 1) == ctx
    end

    test "empty dashes is allowed", %{ctx: ctx} do
      assert Xairo.set_dash(ctx, [], 1) == ctx
    end

    test "returns an error with negative dash length", %{ctx: ctx} do
      assert {:error, :invalid_dash} = Xairo.set_dash(ctx, [-5.5, 3], 1)
    end

    test "returns an error with all 0 dash lengths", %{ctx: ctx} do
      assert {:error, :invalid_dash} = Xairo.set_dash(ctx, [0.0, 0.0], 1)
    end
  end
end
