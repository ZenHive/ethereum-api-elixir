defmodule EthereumApi.Wei do
  @moduledoc """
  Represents Wei, the smallest unit of Ether.
  """
  @type t :: String.t()

  @doc """
  Converts a term to Wei format.

  Returns `{:ok, value}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> EthereumApi.Wei.from_term("0x1234")
      {:ok, "0x1234"}

      iex> EthereumApi.Wei.from_term("1234")
      {:error, "Invalid quantity: \\"1234\\""}

      iex> EthereumApi.Wei.from_term(1234)
      {:error, "Invalid quantity: 1234"}

      iex> EthereumApi.Wei.from_term(:atom)
      {:error, "Invalid quantity: :atom"}

      iex> EthereumApi.Wei.from_term([1, 2, 3])
      {:error, "Invalid quantity: [1, 2, 3]"}

      iex> EthereumApi.Wei.from_term(%{key: "value"})
      {:error, "Invalid quantity: %{key: \\"value\\"}"}
  """
  @spec from_term(any()) :: {:ok, t()} | {:error, String.t()}
  def from_term(value), do: EthereumApi.Quantity.from_term(value)

  @doc """
  Converts a term to Wei format.

  Raises `ArgumentError` if the conversion fails.

  ## Examples

      iex> EthereumApi.Wei.from_term!("0x1234")
      "0x1234"

      iex> EthereumApi.Wei.from_term!("1234")
      ** (ArgumentError) Expected a quantity, found "1234"

      iex> EthereumApi.Wei.from_term!(1234)
      ** (ArgumentError) Expected a quantity, found 1234

      iex> EthereumApi.Wei.from_term!(:atom)
      ** (ArgumentError) Expected a quantity, found :atom

      iex> EthereumApi.Wei.from_term!([1, 2, 3])
      ** (ArgumentError) Expected a quantity, found [1, 2, 3]

      iex> EthereumApi.Wei.from_term!(%{key: "value"})
      ** (ArgumentError) Expected a quantity, found %{key: "value"}
  """
  @spec from_term!(any()) :: t()
  def from_term!(value), do: EthereumApi.Quantity.from_term!(value)

  @doc """
  Checks if a value is a valid Wei amount.

  ## Examples

      iex> EthereumApi.Wei.is_wei?("0x1234")
      true

      iex> EthereumApi.Wei.is_wei?("1234")
      false

      iex> EthereumApi.Wei.is_wei?(1234)
      false
  """
  @spec is_wei?(any()) :: boolean()
  def is_wei?(value), do: EthereumApi.Quantity.is_quantity?(value)
end
