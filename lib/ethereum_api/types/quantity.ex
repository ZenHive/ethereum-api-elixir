defmodule EthereumApi.Types.Quantity do
  @moduledoc """
  Represents a numeric quantity in Ethereum.
  """
  @type t :: String.t()

  @doc """
  Converts a term to Quantity format.

  Returns `{:ok, value}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> EthereumApi.Types.Quantity.from_term("0x1234")
      {:ok, "0x1234"}

      iex> EthereumApi.Types.Quantity.from_term("0x0")
      {:ok, "0x0"}

      iex> EthereumApi.Types.Quantity.from_term("0x")
      {:error, "Invalid quantity: \\"0x\\""}

      iex> EthereumApi.Types.Quantity.from_term("1234")
      {:error, "Invalid quantity: \\"1234\\""}

      iex> EthereumApi.Types.Quantity.from_term(1234)
      {:error, "Invalid quantity: 1234"}

      iex> EthereumApi.Types.Quantity.from_term(:atom)
      {:error, "Invalid quantity: :atom"}

      iex> EthereumApi.Types.Quantity.from_term([1, 2, 3])
      {:error, "Invalid quantity: [1, 2, 3]"}

      iex> EthereumApi.Types.Quantity.from_term(%{key: "value"})
      {:error, "Invalid quantity: %{key: \\"value\\"}"}
  """
  @spec from_term(any()) :: {:ok, t()} | {:error, String.t()}
  def from_term(value) when is_binary(value) do
    if is_quantity?(value) do
      {:ok, value}
    else
      from_term_error(value)
    end
  end

  def from_term(value), do: from_term_error(value)

  @spec from_term_error(any()) :: {:error, String.t()}
  defp from_term_error(value), do: {:error, "Invalid quantity: #{inspect(value)}"}

  @doc """
  Checks if a value is valid Quantity format.

  ## Examples

      iex> EthereumApi.Types.Quantity.is_quantity?("0x1234")
      true

      iex> EthereumApi.Types.Quantity.is_quantity?("0x0")
      true

      iex> EthereumApi.Types.Quantity.is_quantity?("0x")
      false

      iex> EthereumApi.Types.Quantity.is_quantity?("1234")
      false

      iex> EthereumApi.Types.Quantity.is_quantity?(1234)
      false
  """
  @spec is_quantity?(any()) :: boolean()
  def is_quantity?(value) when is_binary(value) do
    String.match?(value, ~r/^0x[0-9a-fA-F]+$/)
  end

  def is_quantity?(_), do: false

  @doc """
  Converts a term to Quantity format.

  Raises `ArgumentError` if the conversion fails.

  ## Examples

      iex> EthereumApi.Types.Quantity.from_term!("0x1234")
      "0x1234"

      iex> EthereumApi.Types.Quantity.from_term!("0x0")
      "0x0"

      iex> EthereumApi.Types.Quantity.from_term!("0x")
      ** (ArgumentError) Expected a quantity, found "0x"

      iex> EthereumApi.Types.Quantity.from_term!("1234")
      ** (ArgumentError) Expected a quantity, found "1234"

      iex> EthereumApi.Types.Quantity.from_term!(1234)
      ** (ArgumentError) Expected a quantity, found 1234

      iex> EthereumApi.Types.Quantity.from_term!(:atom)
      ** (ArgumentError) Expected a quantity, found :atom

      iex> EthereumApi.Types.Quantity.from_term!([1, 2, 3])
      ** (ArgumentError) Expected a quantity, found [1, 2, 3]

      iex> EthereumApi.Types.Quantity.from_term!(%{key: "value"})
      ** (ArgumentError) Expected a quantity, found %{key: "value"}
  """
  @spec from_term!(any()) :: t()
  def from_term!(value) do
    case from_term(value) do
      {:ok, value} -> value
      {:error, _} -> raise ArgumentError, "Expected a quantity, found #{inspect(value)}"
    end
  end
end
