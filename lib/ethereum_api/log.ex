defmodule EthereumApi.Log do
  @moduledoc """
  Represents an Ethereum event log.
  """
  use Struct, {
    [Struct.FromTerm],
    removed: :boolean,
    log_index: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "logIndex"]
    ],
    transaction_index: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "transactionIndex"]
    ],
    transaction_hash: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "transactionHash"]
    ],
    block_hash: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "blockHash"]
    ],
    block_number: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "blockNumber"]
    ],
    address: EthereumApi.Data20,
    data: EthereumApi.Data,
    topics: {:list, EthereumApi.Data32}
  }
end
