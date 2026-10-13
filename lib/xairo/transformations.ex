defmodule Xairo.Transformations do
  @moduledoc false

  alias Xairo.{Context, Matrix, NIF}

  defmacro __using__(_) do
    quote do
      alias Xairo.Transformations, as: T

      defdelegate translate(ctx, tx, ty), to: T
      defdelegate scale(ctx, sx, sy), to: T
      defdelegate rotate(ctx, a), to: T
      defdelegate transform(ctx, m), to: T
      defdelegate set_matrix(ctx, m), to: T
      defdelegate get_matrix(ctx), to: T
      defdelegate identity_matrix(ctx), to: T
      defdelegate user_to_device(ctx, x, y), to: T
      defdelegate user_to_device_distance(ctx, dx, dy), to: T
      defdelegate device_to_user(ctx, x, y), to: T
      defdelegate device_to_user_distance(ctx, dx, dy), to: T
    end
  end

  @spec translate(Context.t(), number(), number()) :: Xairo.maybe_ctx()
  def translate(ctx, tx, ty), do: NIF.context_translate(ctx, f(tx), f(ty))

  @spec scale(Context.t(), number(), number()) :: Xairo.maybe_ctx()
  def scale(ctx, sx, sy), do: NIF.context_scale(ctx, f(sx), f(sy))

  @spec rotate(Context.t(), number()) :: Xairo.maybe_ctx()
  def rotate(ctx, theta), do: NIF.context_rotate(ctx, f(theta))

  @spec transform(Context.t(), Matrix.t()) :: Xairo.maybe_ctx()
  def transform(ctx, matrix), do: NIF.context_transform(ctx, matrix)

  @spec set_matrix(Context.t(), Matrix.t()) :: Xairo.maybe_ctx()
  def set_matrix(ctx, m), do: NIF.context_set_matrix(ctx, m)

  @spec get_matrix(Context.t()) :: Matrix.t()
  def get_matrix(ctx), do: NIF.context_get_matrix(ctx) |> Matrix.from_nif()

  @spec identity_matrix(Context.t()) :: Xairo.maybe_ctx()
  def identity_matrix(ctx), do: NIF.context_identity_matrix(ctx)

  @spec user_to_device(Context.t(), number(), number()) :: {float(), float()}
  def user_to_device(ctx, x, y), do: NIF.user_to_device(ctx, f(x), f(y))

  @spec user_to_device_distance(Context.t(), number(), number()) :: {float(), float()}
  def user_to_device_distance(ctx, dx, dy), do: NIF.user_to_device_distance(ctx, f(dx), f(dy))

  @spec device_to_user(Context.t(), number(), number()) :: {float(), float()}
  def device_to_user(ctx, x, y), do: NIF.device_to_user(ctx, f(x), f(y))

  @spec device_to_user_distance(Context.t(), number(), number()) :: {float(), float()}
  def device_to_user_distance(ctx, dx, dy), do: NIF.device_to_user_distance(ctx, f(dx), f(dy))

  defp f(x), do: :erlang.float(x)
end
