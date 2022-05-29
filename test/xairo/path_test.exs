defmodule Xairo.PathTest do
  use ExUnit.Case, async: true

  alias Xairo.{Context, ImageSurface}

  setup do
    surface = ImageSurface.create(:argb32, 100, 100)
    context = Context.new(surface)

    {:ok, context: context}
  end

  describe "Enum.count/1" do
    test "returns 0 for an empty path", %{context: ctx} do
      path = Context.copy_path(ctx)

      assert Enum.count(path) == 0
    end

    test "returns the length for a non-empty path", %{context: ctx} do
      path =
        ctx
        |> Context.move_to(10, 10)
        |> Context.line_to(50, 50)
        |> Context.rel_curve_to(20, 20, 30, 40, 15, 45)
        |> Context.close_path()
        |> Context.copy_path()

      assert Enum.count(path) == 5
    end
  end

  describe "Enum.at/2" do
    test "returns nil for an empty path", %{context: ctx} do
      path = Context.copy_path(ctx)

      refute Enum.at(path, 0)
      refute Enum.at(path, 3)
    end

    test "returns the segment for a non-empty path", %{context: ctx} do
      path =
        ctx
        |> Context.move_to(10, 10)
        |> Context.line_to(50, 50)
        |> Context.rel_curve_to(20, 20, 30, 40, 15, 45)
        |> Context.close_path()
        |> Context.copy_path()

      assert Enum.at(path, 0) == {:move_to, {10.0, 10.0}}
      assert Enum.at(path, -1) == {:move_to, {10.0, 10.0}}
    end
  end

  describe "Enum.reduce/3" do
    test "returns a list of the path segment commands", %{context: ctx} do
      path =
        ctx
        |> Context.move_to(10, 10)
        |> Context.line_to(50, 50)
        |> Context.rel_curve_to(20, 20, 30, 40, 15, 45)
        |> Context.close_path()
        |> Context.copy_path()

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
    test "returns the correct result for whether a step is part of the path", %{context: ctx} do
      path =
        ctx
        |> Context.move_to(10, 10)
        |> Context.line_to(50, 50)
        |> Context.rel_curve_to(20, 20, 30, 40, 15, 45)
        |> Context.close_path()
        |> Context.copy_path()

      refute Enum.member?(path, {:curve_to, {20.0, 20.0}, {30.0, 40.0}, {15.0, 45.0}})
      assert Enum.member?(path, {:curve_to, {70.0, 70.0}, {80.0, 90.0}, {65.0, 95.0}})
    end
  end
end
