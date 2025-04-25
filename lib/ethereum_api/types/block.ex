defmodule EthereumApi.Types.Block do
  @moduledoc """
  Represents an Ethereum block.
  """
  use Struct, {
    [Struct.FromTerm],
    number: [
      type: {:option, EthereumApi.Types.Quantity},
      "Struct.FromTerm": [keys: "number"]
    ],
    hash: [
      type: {:option, EthereumApi.Types.Data32},
      "Struct.FromTerm": [keys: "hash"]
    ],
    parent_hash: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "parentHash"]
    ],
    nonce: [
      type: {:option, EthereumApi.Types.Data8},
      "Struct.FromTerm": [keys: "nonce"]
    ],
    sha3_uncles: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "sha3Uncles"]
    ],
    logs_bloom: [
      type: {:option, EthereumApi.Types.Data256},
      "Struct.FromTerm": [keys: "logsBloom"]
    ],
    transactions_root: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "transactionsRoot"]
    ],
    state_root: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "stateRoot"]
    ],
    receipts_root: [
      type: EthereumApi.Types.Data32,
      "Struct.FromTerm": [keys: "receiptsRoot"]
    ],
    miner: [
      type: EthereumApi.Types.Data20,
      "Struct.FromTerm": [keys: "miner"]
    ],
    difficulty: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "difficulty"]
    ],
    extra_data: [
      type: EthereumApi.Types.Data,
      "Struct.FromTerm": [keys: "extraData"]
    ],
    size: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "size"]
    ],
    gas_limit: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "gasLimit"]
    ],
    gas_used: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "gasUsed"]
    ],
    timestamp: [
      type: EthereumApi.Types.Quantity,
      "Struct.FromTerm": [keys: "timestamp"]
    ],
    transactions: [
      type: {:list, EthereumApi.Types.TransactionEnum},
      "Struct.FromTerm": [keys: "transactions", default: []]
    ],
    uncles: [
      type: {:list, EthereumApi.Types.Data32},
      "Struct.FromTerm": [keys: "uncles"]
    ]
  }
end
