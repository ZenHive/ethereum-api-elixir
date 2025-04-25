defmodule EthereumApi.Types.Transaction do
  @moduledoc """
  Represents an Ethereum transaction.
  """
  use Struct, {
    [Struct.FromTerm],
    block_hash: [
      type: {:option, EthereumApi.Types.Data32},
      "Struct.FromTerm": [keys: "blockHash"]
    ],
    block_number: [
      type: {:option, EthereumApi.Types.Quantity},
      "Struct.FromTerm": [keys: "blockNumber"]
    ],
    from: [type: EthereumApi.Types.Data20, "Struct.FromTerm": [keys: "from"]],
    gas: [type: EthereumApi.Types.Quantity, "Struct.FromTerm": [keys: "gas"]],
    gas_price: [type: EthereumApi.Types.Wei, "Struct.FromTerm": [keys: "gasPrice"]],
    hash: [type: EthereumApi.Types.Data32, "Struct.FromTerm": [keys: "hash"]],
    input: [type: EthereumApi.Types.Data, "Struct.FromTerm": [keys: "input"]],
    nonce: [type: EthereumApi.Types.Quantity, "Struct.FromTerm": [keys: "nonce"]],
    to: [type: {:option, EthereumApi.Types.Data20}, "Struct.FromTerm": [keys: "to"]],
    transaction_index: [
      type: {:option, EthereumApi.Types.Quantity},
      "Struct.FromTerm": [keys: "transactionIndex"]
    ],
    value: [type: EthereumApi.Types.Wei, "Struct.FromTerm": [keys: "value"]],
    v: [type: EthereumApi.Types.Quantity, "Struct.FromTerm": [keys: "v"]],
    r: [type: EthereumApi.Types.Quantity, "Struct.FromTerm": [keys: "r"]],
    s: [type: EthereumApi.Types.Quantity, "Struct.FromTerm": [keys: "s"]]
  }
end
