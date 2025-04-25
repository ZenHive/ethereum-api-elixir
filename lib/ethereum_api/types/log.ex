defmodule EthereumApi.Types.Log do
  @moduledoc """
  Represents an Ethereum event log.
  """
  use Struct, {
    [Struct.FromTerm],
    removed: :boolean,
    log_index: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "logIndex"]
    ],
    transaction_index: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "transactionIndex"]
    ],
    transaction_hash: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "transactionHash"]
    ],
    block_hash: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "blockHash"]
    ],
    block_number: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "blockNumber"]
    ],
    address: EthereumApi.Types.Data20,
    data: EthereumApi.Types.Data,
    topics: {:list, EthereumApi.Types.Data32}
  }
end
