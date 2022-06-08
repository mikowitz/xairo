defmodule Xairo.Vector do
  @moduledoc """
    Models a vector in user space.
  """

  defstruct [:x, :y]

  @type t :: %__MODULE__{
          x: number(),
          y: number()
        }

  def new(x, y) do
    %__MODULE__{
      x: x / 1,
      y: y / 1
    }
  end
end
