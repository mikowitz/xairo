defmodule Xairo.Matrix do
  @moduledoc """
  Models an affine transformation matrix.

  A matrix's transformations are used to convert points on an image between
  userspace (the coordinates the user has defined for the image) and the
  imagespace (the coordinates that are rendered to the visible surface).

  ## Examples

  If a user prints a point at {10, 10} onto a surface whose current transformation
  matrix (CTM) with a horizontal translation of 20 pixels and a vertical translation
  of 30 pixels would print the point onto the surface at {30, 40}

  If a user prints a point at {10, 15} onto a surface whose CTM scales the X-axis
  by 2 and the Y-axis by 3, the point would appear on the surface at {20, 45}
  """

  defstruct [:matrix]

  @typedoc """
  The Elixir model of a transformation matrix. Stores a reference to the in-memory
  native representation of the matrix.
  """
  @type t :: %__MODULE__{
          matrix: reference()
        }

  alias Xairo.Native, as: N
  alias Xairo.{Point, Vector}

  @doc """
  Initializes a new transformation matrix.

  The arguments passed to this function, in order, are:

    * `xx` - factor along the X-axis
    * `yx` - vertical shear
    * `xy` - horizontal shear
    * `yy` - scale factor along the Y-axis
    * `tx` - translation distance along the X-axis
    * `ty` - translation distance along the Y-axis

  """
  @spec new(number(), number(), number(), number(), number(), number()) :: t()
  def new(xx, yx, xy, yy, tx, ty) do
    %__MODULE__{
      matrix: N.matrix_new(xx / 1, yx / 1, xy / 1, yy / 1, tx / 1, ty / 1)
    }
  end

  @doc """
  Returns an identity matrix, a matrix whose transformation output is always
  the same as its input.

  This is equivalent to calling `Matrix.new/6` with the following arguments

  ```
  Matrix.new(1, 0, 0, 1, 0, 0)
  ```
  """
  @spec identity :: t()
  def identity do
    %__MODULE__{
      matrix: N.matrix_identity()
    }
  end

  @doc """
  Returns the current values of the matrix as a 6-element tuple.

  The elements of this tuple are returned in the same order as they are
  passed to `Matrix.new/6`.

  ## Example

      iex> Matrix.identity() |> Matrix.to_tuple()
      {1.0, 0.0, 0.0, 1.0, 0.0, 0.0}
  """
  @spec to_tuple(t()) :: {number(), number(), number(), number(), number(), number()}
  def to_tuple(%__MODULE__{matrix: matrix}) do
    N.matrix_to_tuple(matrix)
  end

  @doc """
  Multiplies one matrix by another, applying the transformations of the second matrix
  to the end of the transformations of the first.

  Because matrix multiplication is not commutative, the order of the two matrix arguments
  is significant for the resulting matrix.
  """
  @spec multiply(t(), t()) :: t()
  def multiply(%__MODULE__{matrix: m1}, %__MODULE__{matrix: m2}) do
    %__MODULE__{
      matrix: N.matrix_multiply(m1, m2)
    }
  end

  @doc """
  Transforms a `Xairo.Vector` from userspace to imagespace according to the given matrix.
  """
  @spec transform_distance(t(), Vector.t()) :: Vector.t()
  def transform_distance(%__MODULE__{matrix: matrix}, %Vector{} = vec) do
    N.matrix_transform_distance(matrix, vec)
  end

  @doc """
  Converts a `Xairo.Point` from userspace to imagespace according to the given matrix.
  """
  @spec transform_point(t(), Point.t()) :: Point.t()
  def transform_point(%__MODULE__{matrix: matrix}, %Point{} = point) do
    N.matrix_transform_point(matrix, point)
  end

  @doc """
  Applies the given translation distances to the matrix after its existing transformations.

  Returns a `Matrix` struct for easier chaining.
  """
  @spec translate(t(), number(), number()) :: t()
  def translate(%__MODULE__{matrix: m} = matrix, dx, dy) do
    %{matrix | matrix: N.matrix_translate(m, dx / 1, dy / 1)}
  end

  @doc """
  Applies the given scale factors to the matrix after its existing transformations.

  Returns a `Matrix` struct for easier chaining.
  """
  @spec scale(t(), number(), number()) :: t()
  def scale(%__MODULE__{matrix: m} = matrix, sx, sy) do
    %{matrix | matrix: N.matrix_scale(m, sx / 1, sy / 1)}
  end

  @doc """
  Applies the given rotation (in radians) to the matrix after its existing transformations.

  Returns a `Matrix` struct for easier chaining.
  """
  @spec rotate(t(), number()) :: t()
  def rotate(%__MODULE__{matrix: m} = matrix, radians) do
    %{matrix | matrix: N.matrix_rotate(m, radians / 1)}
  end

  @doc """
  Attempts to invert the matrix. Will return an error tuple if the matrix is not invertible.
  """
  @spec invert(t()) :: Xairo.or_error(t())
  def invert(%__MODULE__{matrix: m} = matrix) do
    with {:ok, m} <- N.matrix_invert(m), do: %{matrix | matrix: m}
  end
end
