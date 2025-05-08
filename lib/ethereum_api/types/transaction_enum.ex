defmodule EthereumApi.Types.TransactionEnum do
  @moduledoc """
  Represents a transaction reference that can be either a hash or a full transaction.
  """
  @type t :: {:hash, EthereumApi.Types.Data32.t()} | {:full, EthereumApi.Types.Transaction.t()}

  @doc """
  Converts a term to TransactionEnum format.

  Returns `{:ok, value}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> EthereumApi.Types.TransactionEnum.from_term(
      ...> "0x0000000000000000000000000000000000000000000000000000000000000000"
      ...> )
      {:ok, {:hash, "0x0000000000000000000000000000000000000000000000000000000000000000"}}

      iex> EthereumApi.Types.TransactionEnum.from_term(%{
      ...>   "from" => "0x0000000000000000000000000000000000000000",
      ...>   "gas" => "0x1234",
      ...>   "gasPrice" => "0x1234",
      ...>   "hash" => "0x0000000000000000000000000000000000000000000000000000000000000000",
      ...>   "input" => "0xffffffacb",
      ...>   "nonce" => "0x1234",
      ...>   "value" => "0x1234",
      ...>   "v" => "0x1234",
      ...>   "r" => "0x1234",
      ...>   "s" => "0x1234"
      ...> })
      {:ok, {:full, %EthereumApi.Types.Transaction{
        block_hash: nil,
        block_number: nil,
        from: "0x0000000000000000000000000000000000000000",
        gas: "0x1234",
        gas_price: "0x1234",
        hash: "0x0000000000000000000000000000000000000000000000000000000000000000",
        input: "0xffffffacb",
        nonce: "0x1234",
        to: nil,
        transaction_index: nil,
        value: "0x1234",
        v: "0x1234",
        r: "0x1234",
        s: "0x1234"
      }}}

      iex> EthereumApi.Types.TransactionEnum.from_term("invalid")
      {:error, "Invalid TransactionEnum: Invalid Data32: \\"invalid\\""}

      iex> EthereumApi.Types.TransactionEnum.from_term(%{})
      {
        :error,
        "Invalid TransactionEnum: Failed to parse field from of Elixir.EthereumApi.Types.Transaction: Invalid Data20: nil"
      }

      iex> EthereumApi.Types.TransactionEnum.from_term(123)
      {:error, "Invalid TransactionEnum: 123"}

      iex> EthereumApi.Types.TransactionEnum.from_term(:atom)
      {:error, "Invalid TransactionEnum: :atom"}

      iex> EthereumApi.Types.TransactionEnum.from_term([1, 2, 3])
      {:error, "Invalid TransactionEnum: [1, 2, 3]"}

      iex> EthereumApi.Types.TransactionEnum.from_term(%{key: "value"})
      {
        :error,
        "Invalid TransactionEnum: Failed to parse field from of Elixir.EthereumApi.Types.Transaction: Invalid Data20: nil"
      }
  """
  @spec from_term(any()) :: {:ok, t()} | {:error, String.t()}
  def from_term(value) when is_map(value) do
    case EthereumApi.Types.Transaction.from_term(value) do
      {:ok, transaction} -> {:ok, {:full, transaction}}
      {:error, reason} -> {:error, "Invalid TransactionEnum: #{reason}"}
    end
  end

  def from_term(value) when is_binary(value) do
    case EthereumApi.Types.Data32.from_term(value) do
      {:ok, transaction} -> {:ok, {:hash, transaction}}
      {:error, reason} -> {:error, "Invalid TransactionEnum: #{reason}"}
    end
  end

  def from_term(value), do: {:error, "Invalid TransactionEnum: #{inspect(value)}"}
end
