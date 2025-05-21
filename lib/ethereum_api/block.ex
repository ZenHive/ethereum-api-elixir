defmodule EthereumApi.Block do
  @moduledoc """
  Represents an Ethereum block.
  """
  use Struct, {
    [Struct.FromTerm],
    number: [
      type: {:option, EthereumApi.Quantity},
      "Struct.FromTerm": [keys: "number"]
    ],
    hash: [
      type: {:option, EthereumApi.Data32},
      "Struct.FromTerm": [keys: "hash"]
    ],
    parent_hash: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "parentHash"]
    ],
    nonce: [
      type: {:option, EthereumApi.Data8},
      "Struct.FromTerm": [keys: "nonce"]
    ],
    sha3_uncles: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "sha3Uncles"]
    ],
    logs_bloom: [
      type: {:option, EthereumApi.Data256},
      "Struct.FromTerm": [keys: "logsBloom"]
    ],
    transactions_root: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "transactionsRoot"]
    ],
    state_root: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "stateRoot"]
    ],
    receipts_root: [
      type: EthereumApi.Data32,
      "Struct.FromTerm": [keys: "receiptsRoot"]
    ],
    miner: [
      type: EthereumApi.Data20,
      "Struct.FromTerm": [keys: "miner"]
    ],
    difficulty: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "difficulty"]
    ],
    extra_data: [
      type: EthereumApi.Data,
      "Struct.FromTerm": [keys: "extraData"]
    ],
    size: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "size"]
    ],
    gas_limit: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "gasLimit"]
    ],
    gas_used: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "gasUsed"]
    ],
    timestamp: [
      type: EthereumApi.Quantity,
      "Struct.FromTerm": [keys: "timestamp"]
    ],
    transactions: [
      type: {:list, EthereumApi.TransactionEnum},
      "Struct.FromTerm": [keys: "transactions", default: []]
    ],
    uncles: [
      type: {:list, EthereumApi.Data32},
      "Struct.FromTerm": [keys: "uncles"]
    ]
  }
end
