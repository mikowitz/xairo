defmodule Xairo.Matrix do
  defstruct [:matrix]

  alias Xairo.Native, as: N

  def new(xx, yx, xy, yy, tx, ty) do
    %__MODULE__{
      matrix: N.matrix_new(xx / 1, yx / 1, xy / 1, yy / 1, tx / 1, ty / 1)
    }
  end

  def identity do
    %__MODULE__{
      matrix: N.matrix_identity()
    }
  end

  def to_tuple(%__MODULE__{matrix: matrix}) do
    N.matrix_to_tuple(matrix)
  end

  def multiply(%__MODULE__{matrix: m1}, %__MODULE__{matrix: m2}) do
    %__MODULE__{
      matrix: N.matrix_multiply(m1, m2)
    }
  end

  def transform_distance(%__MODULE__{matrix: matrix}, x, y) do
    N.matrix_transform_distance(matrix, x / 1, y / 1)
  end

  def transform_point(%__MODULE__{matrix: matrix}, x, y) do
    N.matrix_transform_point(matrix, x / 1, y / 1)
  end

  def translate(%__MODULE__{matrix: matrix} = this, dx, dy) do
    %{this | matrix: N.matrix_translate(matrix, dx / 1, dy / 1)}
  end

  def scale(%__MODULE__{matrix: matrix} = this, dx, dy) do
    %{this | matrix: N.matrix_scale(matrix, dx / 1, dy / 1)}
  end

  def rotate(%__MODULE__{matrix: matrix} = this, radians) do
    %{this | matrix: N.matrix_rotate(matrix, radians / 1)}
  end

  def invert(%__MODULE__{matrix: matrix} = this) do
    with {:ok, matrix} <- N.matrix_invert(matrix), do: %{this | matrix: matrix}
  end
end
