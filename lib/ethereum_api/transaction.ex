defmodule EthereumApi.Transaction do
  @moduledoc """
  Represents an Ethereum transaction.
  """
  use Struct, {
    [Struct.FromTerm],
    block_hash: [
      type: {:option, EthereumApi.Data32},
      "Struct.FromTerm": [keys: "blockHash"]
    ],
    block_number: [
      type: {:option, EthereumApi.Quantity},
      "Struct.FromTerm": [keys: "blockNumber"]
    ],
    from: [type: EthereumApi.Data20, "Struct.FromTerm": [keys: "from"]],
    gas: [type: EthereumApi.Quantity, "Struct.FromTerm": [keys: "gas"]],
    gas_price: [type: EthereumApi.Wei, "Struct.FromTerm": [keys: "gasPrice"]],
    hash: [type: EthereumApi.Data32, "Struct.FromTerm": [keys: "hash"]],
    input: [type: EthereumApi.Data, "Struct.FromTerm": [keys: "input"]],
    nonce: [type: EthereumApi.Quantity, "Struct.FromTerm": [keys: "nonce"]],
    to: [type: {:option, EthereumApi.Data20}, "Struct.FromTerm": [keys: "to"]],
    transaction_index: [
      type: {:option, EthereumApi.Quantity},
      "Struct.FromTerm": [keys: "transactionIndex"]
    ],
    value: [type: EthereumApi.Wei, "Struct.FromTerm": [keys: "value"]],
    v: [type: EthereumApi.Quantity, "Struct.FromTerm": [keys: "v"]],
    r: [type: EthereumApi.Quantity, "Struct.FromTerm": [keys: "r"]],
    s: [type: EthereumApi.Quantity, "Struct.FromTerm": [keys: "s"]]
  }
end
