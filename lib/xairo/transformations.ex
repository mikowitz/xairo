# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
defmodule Xairo.Transformations do
  @moduledoc false

  alias Xairo.{Context, Matrix, NIF}

  defmacro __using__(_) do
    quote location: :keep do
      alias Xairo.Transformations, as: T

      @doc """
      Modifies the current transformation matrix (CTM) by translating the
      user-space origin by `(tx, ty)`.

      This offset is interpreted as a user-space coordinate according to the
      CTM in place before the new call to `translate/3`. In other words, the
      translation of the user-space origin takes place after any existing
      transformation.
      """
      @doc group: "Transformations"
      @spec translate(context :: Context.t(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate translate(context, tx, ty), to: T

      @doc """
      Modifies the current transformation matrix (CTM) by scaling the X and Y
      user-space axes by `sx` and `sy` respectively. The scaling of the axes
      takes place after any existing transformation of user space.
      """
      @doc group: "Transformations"
      @spec scale(Context.t(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate scale(context, sx, sy), to: T

      @doc """
      Modifies the current transformation matrix (CTM) by rotating the
      user-space axes by `angle` radians. The rotation of the axes takes place
      after any existing transformation of user space. The rotation direction
      for positive angles is from the positive X axis toward the positive Y axis.
      """
      @doc group: "Transformations"
      @spec rotate(Context.t(), number()) :: Xairo.maybe_ctx()
      defdelegate rotate(context, angle), to: T

      @doc """
      Modifies the current transformation matrix (CTM) by applying `matrix` as
      an additional transformation. The new transformation of user space takes
      place after any existing transformation.
      """
      @doc group: "Transformations"
      @spec transform(Context.t(), Matrix.t()) :: Xairo.maybe_ctx()
      defdelegate transform(context, matrix), to: T

      @doc """
      Modifies the current transformation matrix (CTM) by setting it equal to `matrix`.
      """
      @doc group: "Transformations"
      @spec set_matrix(Context.t(), Matrix.t()) :: Xairo.maybe_ctx()
      defdelegate set_matrix(context, matrix), to: T

      @doc """
      Returns the current transformation matrix (CTM).
      """
      @doc group: "Transformations"
      @spec get_matrix(Context.t()) :: Matrix.t()
      defdelegate get_matrix(context), to: T

      @doc """
      Resets the current transformation matrix (CTM) by setting it equal to
      the identity matrix.

      That is, the user-space and device-space axes will be aligned and one
      user-space unit will transform to one device-space unit.
      """
      @doc group: "Transformations"
      @spec identity_matrix(Context.t()) :: Xairo.maybe_ctx()
      defdelegate identity_matrix(ctx), to: T

      @doc """
      Transform a coordinate from user space to device space by multiplying
      the given point by the current transformation matrix (CTM).
      """
      @doc group: "Transformations"
      @spec user_to_device(Context.t(), number(), number()) :: {float(), float()}
      defdelegate user_to_device(ctx, x, y), to: T

      @doc """
      Transform a distance vector from user space to device space.

      This function is similar to `user_to_device/3` except that the
      translation components of the CTM will be ignored when
      transforming `(dx, dy)`.
      """
      @doc group: "Transformations"
      @spec user_to_device_distance(Context.t(), number(), number()) :: {float(), float()}
      defdelegate user_to_device_distance(ctx, dx, dy), to: T

      @doc """
      Transform a coordinate from device space to user space by multiplying
      the given point by the inverse of the current transformation matrix (CTM).
      """
      @doc group: "Transformations"
      @spec device_to_user(Context.t(), number(), number()) :: {float(), float()}
      defdelegate device_to_user(ctx, x, y), to: T

      @doc """
      Transform a distance vector from device space to user space.

      This function is similar to `device_to_user/3` except that the
      translation components of the inverse CTM will be ignored when
      transforming `(dx, dy)`.
      """
      @doc group: "Transformations"
      @spec device_to_user_distance(Context.t(), number(), number()) :: {float(), float()}
      defdelegate device_to_user_distance(ctx, dx, dy), to: T
    end
  end

  def translate(ctx, tx, ty), do: NIF.context_translate(ctx, f(tx), f(ty))

  def scale(ctx, sx, sy), do: NIF.context_scale(ctx, f(sx), f(sy))

  def rotate(ctx, theta), do: NIF.context_rotate(ctx, f(theta))

  def transform(ctx, matrix), do: NIF.context_transform(ctx, matrix)

  def set_matrix(ctx, m), do: NIF.context_set_matrix(ctx, m)

  def get_matrix(ctx), do: NIF.context_get_matrix(ctx) |> Matrix.from_nif()

  def identity_matrix(ctx), do: NIF.context_identity_matrix(ctx)

  def user_to_device(ctx, x, y), do: NIF.user_to_device(ctx, f(x), f(y))

  def user_to_device_distance(ctx, dx, dy), do: NIF.user_to_device_distance(ctx, f(dx), f(dy))

  def device_to_user(ctx, x, y), do: NIF.device_to_user(ctx, f(x), f(y))

  def device_to_user_distance(ctx, dx, dy), do: NIF.device_to_user_distance(ctx, f(dx), f(dy))

  defp f(x), do: :erlang.float(x)
end
