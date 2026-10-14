defmodule Xairo.Matrix do
  @moduledoc """
  `Xairo.Matrix` is used to convert between different coordinate spaces. A
  [`Matrix`](`Xairo.Matrix`) struct holds an affine transformation, such as a scale, rotation,
  shear, or a combination of these. The transformation of a point `(x,y)` is
  given by:

  ```
  x_new = xx * x + xy * y + x0
  y_new = yx * x + yy * y + y0
  ```

  The current transformation matrix of a `Xairo.Context`, represented as a
  [`Matrix`](`Xairo.Matrix`), defines the transformation from user-space coordinates to
  device-space coordinates. See `Xairo.get_matrix/1` and `Xairo.set_matrix/2`.

  ## Members

  * `xx`: xx component of the affine transformation
  * `yx`: yx component of the affine transformation
  * `xy`: xy component of the affine transformation
  * `yy`: yy component of the affine transformation
  * `x0`: X translation component of the affine transformation
  * `y0`: Y translation component of the affine transformation

  """

  alias Xairo.NIF

  defstruct xx: 1.0, yx: 0.0, xy: 0.0, yy: 1.0, x0: 0.0, y0: 0.0

  @type t :: %__MODULE__{
          xx: float(),
          yx: float(),
          xy: float(),
          yy: float(),
          x0: float(),
          y0: float()
        }

  @doc """
  Returns a matrix representing the identity transformation.
  """
  @spec init_identity() :: t()
  def init_identity, do: %__MODULE__{}

  @doc """
  Returns a matrix representing the affine transformation given by `xx`, `yx`,
  `xy`, `yy`, `x0`, `y0`.
  """
  @spec init(number(), number(), number(), number(), number(), number()) :: t()
  def init(xx, yx, xy, yy, x0, y0) do
    %__MODULE__{
      xx: f(xx),
      yx: f(yx),
      xy: f(xy),
      yy: f(yy),
      x0: f(x0),
      y0: f(y0)
    }
  end

  @doc """
  Returns a matrix representing a transformation that translates by `tx` and
  `ty` in the X and Y dimensions, respectively.
  """
  @spec init_translate(number(), number()) :: t()
  def init_translate(tx, ty) do
    %__MODULE__{x0: f(tx), y0: f(ty)}
  end

  @doc """
  Returns a matrix representing a transformation that scales by `sx` and `sy`
  in the X and Y dimensions, respectively.
  """
  @spec init_scale(number(), number()) :: t()
  def init_scale(sx, sy) do
    %__MODULE__{xx: f(sx), yy: f(sy)}
  end

  @doc """
  Returns a matrix representing a transformation that rotates by `theta`
  radians.

  In Xairo, the direction of rotation is defined such that positive angles
  rotate in the direction from the positive X axis toward the positive Y axis.
  """
  @spec init_rotate(number()) :: t()
  def init_rotate(theta) do
    theta = f(theta)

    %__MODULE__{
      xx: :math.cos(theta),
      xy: -:math.sin(theta),
      yx: :math.sin(theta),
      yy: :math.cos(theta)
    }
  end

  @doc """
  Applies a translation by `tx`, `ty` to the transformation in `matrix`.

  The effect of the new transformation is to first translate the coordinates
  by `tx` and `ty`, then apply the original transformation to the coordinates.
  """
  @spec translate(t(), number(), number()) :: t()
  def translate(matrix, tx, ty), do: NIF.matrix_translate(matrix, f(tx), f(ty)) |> from_nif()

  @doc """
  Applies scaling by `sx`, `sy` to the transformation in `matrix`.

  The effect of the new transformation is to first scale the coordinates
  by `sx` and `sy`, then apply the original transformation to the coordinates.
  """
  @spec scale(t(), number(), number()) :: t()
  def scale(matrix, sx, sy), do: NIF.matrix_scale(matrix, f(sx), f(sy)) |> from_nif()

  @doc """
  Applies rotation by `theta` to the transformation in `matrix`.

  The effect of the new transformation is to first rotate the coordinates
  by `theta`, then apply the original transformation to the coordinates.
  """
  @spec rotate(t(), number()) :: t()
  def rotate(matrix, theta), do: NIF.matrix_rotate(matrix, f(theta)) |> from_nif()

  @doc """
  Returns the inverse of `matrix`.

  Not all transformation matrices have inverses; if the matrix collapses points
  together (it is _degenerate_) then it has no inverse and this function will
  return an error tuple.
  """
  @spec invert(t()) :: {:ok, t()} | {:error, atom()}
  def invert(matrix) do
    case NIF.matrix_invert(matrix) do
      {:error, _} = error -> error
      {:ok, m} when is_map(m) -> {:ok, from_nif(m)}
    end
  end

  @doc """
  Multiplies the affine transformations in `a` and `b` together and returns
  the result.

  The effect of the resulting transformation is to first apply the
  transformation in `a` to the coordinates and then apply the
  transformation in `b` to the coordinates.
  """
  @spec multiply(t(), t()) :: t()
  def multiply(a, b), do: NIF.matrix_multiply(a, b) |> from_nif()

  @doc """
  Transforms the distance vector `(dx ,dy)` by `matrix`.

  This is similar to `transform_point/3` except that the translation
  components of the transformation are ignored. The calculation of the
  returned vector is as follows:

  ```
  dx_new = xx * dx + xy * dy
  dy_new = yx * dx + yy * dy
  ```
  """
  @spec transform_distance(t(), number(), number()) :: {float(), float()}
  def transform_distance(matrix, dx, dy), do: NIF.matrix_transform_distance(matrix, f(dx), f(dy))

  @doc """
  Transforms the point `(x, y)` by `matrix`.
  """
  @spec transform_point(t(), number(), number()) :: {float(), float()}
  def transform_point(matrix, x, y), do: NIF.matrix_transform_point(matrix, f(x), f(y))

  @doc false
  def from_nif(data), do: struct(__MODULE__, data)

  defp f(x), do: :erlang.float(x)
end
