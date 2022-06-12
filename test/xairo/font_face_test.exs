defmodule Xairo.FontFaceTest do
  use ExUnit.Case, async: true

  alias Xairo.FontFace

  doctest FontFace

  describe "toy_create/3" do
    test "returns a FontFace struct" do
      face = FontFace.toy_create("serif", :italic, :normal)

      assert is_struct(face, FontFace)
    end

    test "raises an error when given an invalid slant" do
      assert_raise ErlangError, ~r/:invalid_variant/, fn ->
        FontFace.toy_create("serif", :italics, :normal)
      end
    end

    test "raises an error when given an invalid weight" do
      assert_raise ErlangError, ~r/:invalid_variant/, fn ->
        FontFace.toy_create("serif", :italic, :bolder)
      end
    end
  end

  describe "toy_get_family" do
    test "returns the font's family" do
      face = FontFace.toy_create("serif", :italic, :normal)

      assert FontFace.toy_get_family(face) == "serif"
    end
  end

  describe "toy_get_slant/1" do
    test "returns the font's slant value" do
      face = FontFace.toy_create("serif", :italic, :normal)

      assert FontFace.toy_get_slant(face) == :italic
    end
  end

  describe "toy_get_weight/1" do
    test "returns the font's weight value" do
      face = FontFace.toy_create("serif", :italic, :normal)

      assert FontFace.toy_get_weight(face) == :normal
    end
  end
end
