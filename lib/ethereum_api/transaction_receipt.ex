defmodule EthereumApi.TransactionReceipt do
  @moduledoc """
  Represents the receipt of an executed transaction.
  """
  defmodule Status do
    @moduledoc """
    Represents the status of a transaction execution.
    """
    @type t :: :success | :failure | {:pre_byzantium, EthereumApi.Data32.t()}

    @doc """
    Converts a term to TransactionStatus format.

    Returns `{:ok, value}` if successful, `{:error, reason}` otherwise.

    ## Examples

        iex> EthereumApi.TransactionReceipt.Status.from_term("0x1")
        {:ok, :success}

        iex> EthereumApi.TransactionReceipt.Status.from_term("0x0")
        {:ok, :failure}

        iex> EthereumApi.TransactionReceipt.Status.from_term("0x0000000000000000000000000000000000000000000000000000000000000000")
        {:ok, {:pre_byzantium, "0x0000000000000000000000000000000000000000000000000000000000000000"}}

        iex> EthereumApi.TransactionReceipt.Status.from_term("invalid")
        {:error, "Invalid TransactionStatus: \\"invalid\\""}

        iex> EthereumApi.TransactionReceipt.Status.from_term(123)
        {:error, "Invalid TransactionStatus: 123"}

        iex> EthereumApi.TransactionReceipt.Status.from_term(:atom)
        {:error, "Invalid TransactionStatus: :atom"}

        iex> EthereumApi.TransactionReceipt.Status.from_term([1, 2, 3])
        {:error, "Invalid TransactionStatus: [1, 2, 3]"}

        iex> EthereumApi.TransactionReceipt.Status.from_term(%{key: "value"})
        {:error, "Invalid TransactionStatus: %{key: \\"value\\"}"}
    """
    @spec from_term(String.t()) :: {:ok, t()} | {:error, String.t()}
    def from_term(status) do
      case status do
        "0x1" ->
          {:ok, :success}

        "0x0" ->
          {:ok, :failure}

        root ->
          case EthereumApi.Data32.from_term(root) do
            {:ok, data} -> {:ok, {:pre_byzantium, data}}
            {:error, _reason} -> {:error, "Invalid TransactionStatus: #{inspect(status)}"}
          end
      end
    end
  end

  use Struct, {
    [Struct.FromTerm],
    transaction_hash: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "transactionHash"]
    ],
    transaction_index: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "transactionIndex"]
    ],
    block_hash: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "blockHash"]
    ],
    block_number: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "blockNumber"]
    ],
    from: EthereumApi.Data20,
    to: {:option, EthereumApi.Data20},
    cumulative_gas_used: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "cumulativeGasUsed"]
    ],
    effective_gas_price: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "effectiveGasPrice"]
    ],
    gas_used: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "gasUsed"]
    ],
    contract_address: [
      type: {:option, EthereumApi.Data20},
      "Struct.FromTerm": [keys: "contractAddress"]
    ],
    logs: {:list, EthereumApi.Log},
    logs_bloom: [
      type: EthereumApi.Data256,
      "Struct.FromTerm": [keys: "logsBloom"]
    ],
    type: EthereumApi.Quantity,
    status: [
      type: EthereumApi.TransactionReceipt.Status,
      "Struct.FromTerm": [keys: ["status", "root"]]
    ]
  }
end
