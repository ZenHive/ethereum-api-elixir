defmodule EthereumApi.Data do
  @moduledoc """
  Represents arbitrary data in Ethereum. (Represented as a hexadecimal string prefixed with "0x")
  """
  @type t :: String.t()

  @doc """
  Converts a term to Data format.

  Returns `{:ok, value}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> EthereumApi.Data.from_term("0xfffabc")
      {:ok, "0xfffabc"}

      iex> EthereumApi.Data.from_term("string")
      {:error, "Invalid data: \\"string\\""}

      iex> EthereumApi.Data.from_term("0x1234")
      {:ok, "0x1234"}

      iex> EthereumApi.Data.from_term("1234")
      {:error, "Invalid data: \\"1234\\""}

      iex> EthereumApi.Data.from_term("0x")
      {:ok, "0x"}

      iex> EthereumApi.Data.from_term("")
      {:error, "Invalid data: \\"\\""}

      iex> EthereumApi.Data.from_term(123)
      {:error, "Invalid data: 123"}

      iex> EthereumApi.Data.from_term(:atom)
      {:error, "Invalid data: :atom"}

      iex> EthereumApi.Data.from_term([1, 2, 3])
      {:error, "Invalid data: [1, 2, 3]"}

      iex> EthereumApi.Data.from_term(%{key: "value"})
      {:error, "Invalid data: %{key: \\"value\\"}"}
  """
  @spec from_term(any()) :: {:ok, t()} | {:error, String.t()}
  def from_term(value) when is_binary(value) do
    if is_data?(value) do
      {:ok, value}
    else
      from_term_error(value)
    end
  end

  def from_term(value), do: from_term_error(value)

  @spec from_term_error(any()) :: {:error, String.t()}
  defp from_term_error(value), do: {:error, "Invalid data: #{inspect(value)}"}

  @doc """
  Checks if a value is valid Data format.

  ## Examples

      iex> EthereumApi.Data.is_data?("0xfffabc")
      true

      iex> EthereumApi.Data.is_data?("string")
      false

      iex> EthereumApi.Data.is_data?("0x1234")
      true

      iex> EthereumApi.Data.is_data?("1234")
      false

      iex> EthereumApi.Data.is_data?("0x")
      true

      iex> EthereumApi.Data.is_data?("")
      false

      iex> EthereumApi.Data.is_data?(123)
      false
  """
  @spec is_data?(any()) :: boolean()
  def is_data?(value) when is_binary(value) do
    String.match?(value, ~r/^0x[0-9a-fA-F]*$/)
  end

  def is_data?(_), do: false

  @doc """
  Converts a term to Data format.

  Raises `ArgumentError` if the conversion fails.

  ## Examples

      iex> EthereumApi.Data.from_term!("0xfffabc")
      "0xfffabc"

      iex> EthereumApi.Data.from_term!("string")
      ** (ArgumentError) Expected a Data, found "string"

      iex> EthereumApi.Data.from_term!("0x1234")
      "0x1234"

      iex> EthereumApi.Data.from_term!("1234")
      ** (ArgumentError) Expected a Data, found "1234"

      iex> EthereumApi.Data.from_term!("0x")
      "0x"

      iex> EthereumApi.Data.from_term!("")
      ** (ArgumentError) Expected a Data, found ""

      iex> EthereumApi.Data.from_term!(123)
      ** (ArgumentError) Expected a Data, found 123

      iex> EthereumApi.Data.from_term!(:atom)
      ** (ArgumentError) Expected a Data, found :atom

      iex> EthereumApi.Data.from_term!([1, 2, 3])
      ** (ArgumentError) Expected a Data, found [1, 2, 3]

      iex> EthereumApi.Data.from_term!(%{key: "value"})
      ** (ArgumentError) Expected a Data, found %{key: "value"}
  """
  @spec from_term!(any()) :: t()
  def from_term!(value) do
    case from_term(value) do
      {:ok, value} -> value
      {:error, _} -> raise ArgumentError, "Expected a Data, found #{inspect(value)}"
    end
  end
end
