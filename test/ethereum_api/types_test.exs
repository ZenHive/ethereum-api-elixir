defmodule EthereumApi.TypesTest do
  use ExUnit.Case, async: true
  doctest EthereumApi.Wei
  doctest EthereumApi.Tag
  doctest EthereumApi.Data
  doctest EthereumApi.Data8
  doctest EthereumApi.Data20
  doctest EthereumApi.Data32
  doctest EthereumApi.Data256
  doctest EthereumApi.Syncing
  doctest EthereumApi.Quantity
  doctest EthereumApi.Block
  doctest EthereumApi.TransactionEnum
  doctest EthereumApi.Transaction
  doctest EthereumApi.Log
  doctest EthereumApi.TransactionReceipt
  doctest EthereumApi.TransactionReceipt.Status
end
