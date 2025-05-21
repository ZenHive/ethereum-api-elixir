defmodule EthereumApi.Syncing do
  @moduledoc """
  Represents the syncing status of an Ethereum node.

  Contains information about the current block synchronization progress.
  """
  @enforce_keys [:starting_block, :current_block, :highest_block, :additional_data]
  defstruct [:starting_block, :current_block, :highest_block, :additional_data]

  @type t :: %__MODULE__{
          starting_block: EthereumApi.Quantity.t(),
          current_block: EthereumApi.Quantity.t(),
          highest_block: EthereumApi.Quantity.t(),
          additional_data: map()
        }

  @doc """
  Converts a term to Syncing struct.

  Returns `{:ok, value}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> EthereumApi.Syncing.from_term(%{
      ...>   "startingBlock" => "0x1234",
      ...>   "currentBlock" => "0x5678",
      ...>   "highestBlock" => "0x9abc"
      ...> })
      {:ok, %EthereumApi.Syncing{
        starting_block: "0x1234",
        current_block: "0x5678",
        highest_block: "0x9abc",
        additional_data: %{}
      }}

      iex> EthereumApi.Syncing.from_term(%{
      ...>   "startingBlock" => "invalid",
      ...>   "currentBlock" => "0x5678",
      ...>   "highestBlock" => "0x9abc"
      ...> })
      {:error, "Invalid Syncing: %{\\"currentBlock\\" => \\"0x5678\\", \\"highestBlock\\" => \\"0x9abc\\", \\"startingBlock\\" => \\"invalid\\"}"}

      iex> EthereumApi.Syncing.from_term("not a map")
      {:error, "Invalid Syncing: \\"not a map\\""}

      iex> EthereumApi.Syncing.from_term(123)
      {:error, "Invalid Syncing: 123"}

      iex> EthereumApi.Syncing.from_term(:atom)
      {:error, "Invalid Syncing: :atom"}

      iex> EthereumApi.Syncing.from_term([1, 2, 3])
      {:error, "Invalid Syncing: [1, 2, 3]"}
  """
  @spec from_term(term()) :: {:ok, t()} | {:error, String.t()}
  def from_term(
        %{
          "startingBlock" => starting_block,
          "currentBlock" => current_block,
          "highestBlock" => highest_block
        } = map
      ) do
    with {:ok, starting_block} <- EthereumApi.Quantity.from_term(starting_block),
         {:ok, current_block} <- EthereumApi.Quantity.from_term(current_block),
         {:ok, highest_block} <- EthereumApi.Quantity.from_term(highest_block) do
      {:ok,
       %__MODULE__{
         starting_block: starting_block,
         current_block: current_block,
         highest_block: highest_block,
         additional_data: Map.drop(map, ["startingBlock", "currentBlock", "highestBlock"])
       }}
    else
      _ -> {:error, "Invalid Syncing: #{inspect(map)}"}
    end
  end

  def from_term(value), do: {:error, "Invalid Syncing: #{inspect(value)}"}
end
