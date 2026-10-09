defmodule Xairo.Matrix do
  alias Xairo.NIF

  defstruct xx: 1.0, yx: 0.0, xy: 0.0, yy: 1.0, x0: 0.0, y0: 0.0

  @type t :: %__MODULE__{
          xx: number(),
          yx: number(),
          xy: number(),
          yy: number(),
          x0: number(),
          y0: number()
        }

  @spec init_identity() :: t()
  def init_identity(), do: %__MODULE__{}

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

  @spec init_translate(number(), number()) :: t()
  def init_translate(tx, ty) do
    %__MODULE__{x0: f(tx), y0: f(ty)}
  end

  @spec init_scale(number(), number()) :: t()
  def init_scale(sx, sy) do
    %__MODULE__{xx: f(sx), yy: f(sy)}
  end

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

  @spec translate(t(), number(), number()) :: t()
  def translate(matrix, tx, ty), do: NIF.matrix_translate(matrix, f(tx), f(ty)) |> from_nif()

  @spec scale(t(), number(), number()) :: t()
  def scale(matrix, sx, sy), do: NIF.matrix_scale(matrix, f(sx), f(sy)) |> from_nif()

  @spec rotate(t(), number()) :: t()
  def rotate(matrix, theta), do: NIF.matrix_rotate(matrix, f(theta)) |> from_nif()

  @spec invert(t()) :: {:ok, t()} | {:error, atom()}
  def invert(matrix) do
    case NIF.matrix_invert(matrix) do
      {:error, _} = error -> error
      {:ok, m} when is_map(m) -> {:ok, from_nif(m)}
    end
  end

  @spec multiply(t(), t()) :: t()
  def multiply(m, n), do: NIF.matrix_multiply(m, n) |> from_nif()

  @spec transform_distance(t(), number(), number()) :: {float(), float()}
  def transform_distance(matrix, dx, dy), do: NIF.matrix_transform_distance(matrix, f(dx), f(dy))

  @spec transform_point(t(), number(), number()) :: {float(), float()}
  def transform_point(matrix, x, y), do: NIF.matrix_transform_point(matrix, f(x), f(y))

  def from_nif(data), do: struct(__MODULE__, data)

  defp f(x), do: :erlang.float(x)
end
