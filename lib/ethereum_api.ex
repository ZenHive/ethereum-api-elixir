defmodule EthereumApi do
  use JsonRpc.ApiCreator

  require EthereumApi.Support

  EthereumApi.Support.def_data_module(8)
  EthereumApi.Support.def_data_module(20)
  EthereumApi.Support.def_data_module(32)
  EthereumApi.Support.def_data_module(256)

  methods do
    method "web3_clientVersion" do
      doc "Returns the current client version."
      response_type String.t()
      parsing_error_type String.t()
      response_parser &parse_string_response/1
    end

    method "web3_sha3" do
      doc """
        Returns Keccak-256 (not the standardized SHA3-256) of the given data.

        # Parameters
        - data: The data to convert into a SHA3 hash
      """

      args {data, EthereumApi.Data.t()}
      args_transformer! &EthereumApi.Data.from_term!/1
      response_type String.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "net_version" do
      doc "Returns the current network id."
      response_type String.t()
      parsing_error_type String.t()
      response_parser &parse_string_response/1
    end

    method "net_listening" do
      doc "Returns true if client is actively listening for network connections."
      response_type boolean()
      parsing_error_type String.t()
      response_parser &parse_boolean_response/1
    end

    method "net_peerCount" do
      doc "Returns number of peers currently connected to the client."
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_protocolVersion" do
      doc """
        Returns the current Ethereum protocol version.

        Note that this method is not available in Geth
        (see https://github.com/ethereum/go-ethereum/pull/22064#issuecomment-788682924).
      """

      response_type String.t()
      parsing_error_type String.t()
      response_parser &parse_string_response/1
    end

    method "eth_syncing" do
      doc "Returns an object with data about the sync status or false."
      response_type false | EthereumApi.Syncing.t()
      parsing_error_type String.t()

      response_parser fn
        false -> {:ok, false}
        response -> EthereumApi.Syncing.from_term(response)
      end
    end

    method "eth_chainId" do
      doc "Returns the chain ID used for signing replay-protected transactions."
      response_type EthereumApi.Data.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "eth_mining" do
      doc """
        Returns true if client is actively mining new blocks.
        This can only return true for proof-of-work networks and may not be available in some
        clients since The Merge.
      """

      response_type boolean()
      parsing_error_type String.t()
      response_parser &parse_boolean_response/1
    end

    method "eth_hashrate" do
      doc """
        Returns the number of hashes per second that the node is mining with.
        This can only return true for proof-of-work networks and may not be available in some
        clients since The Merge.
      """

      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_gasPrice" do
      doc """
        Returns an estimate of the current price per gas in wei.
        For example, the Besu client examines the last 100 blocks and returns the median gas unit
        price by default.
      """

      response_type EthereumApi.Wei.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Wei.from_term/1
    end

    method "eth_accounts" do
      doc "Returns a list of addresses owned by client."
      response_type [EthereumApi.Data20.t()]
      parsing_error_type String.t()

      response_parser fn
        list when is_list(list) ->
          result =
            Enum.reduce_while(list, {:ok, []}, fn elem, acc ->
              case EthereumApi.Data20.from_term(elem) do
                {:ok, data} ->
                  {:cont, {:ok, [data | elem(acc, 1)]}}

                {:error, reason} ->
                  {:halt, {:error, "Invalid data in list: #{inspect(reason)}"}}
              end
            end)

          with {:ok, result} <- result,
               do: {:ok, Enum.reverse(result)}

        response ->
          {:error,
           "Invalid response, expect list(EthereumApi.Data20.t()) found #{inspect(response)}"}
      end
    end

    method "eth_blockNumber" do
      doc "Returns the number of the most recent block."
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_getBalance" do
      doc """
        Returns the balance of the account of given address.

        # Parameters
        - address: The address to check for balance
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
      """

      args [
        {address, EthereumApi.Data20.t()},
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      ]

      args_transformer! fn address, block_number_or_tag ->
        [
          EthereumApi.Data20.from_term!(address),
          quantity_or_tag_from_term!(block_number_or_tag)
        ]
      end

      response_type EthereumApi.Wei.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Wei.from_term/1
    end

    method "eth_getStorageAt" do
      doc """
        Returns the value from a storage position at a given address.
        For more details, see:
        https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_getstorageat

        # Parameters
        - address: The address of the storage
        - position: Integer of the position in the storage
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
      """

      args [
        {address, EthereumApi.Data20.t()},
        {position, EthereumApi.Quantity.t()},
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      ]

      args_transformer! fn address, position, block_number_or_tag ->
        [
          EthereumApi.Data20.from_term!(address),
          EthereumApi.Quantity.from_term!(position),
          quantity_or_tag_from_term!(block_number_or_tag)
        ]
      end

      response_type EthereumApi.Data.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "eth_getTransactionCount" do
      doc """
        Returns the number of transactions sent from an address.

        # Parameters
        - address: The address to check for transaction count
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
      """

      args [
        {address, EthereumApi.Data20.t()},
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      ]

      args_transformer! fn address, block_number_or_tag ->
        [
          EthereumApi.Data20.from_term!(address),
          quantity_or_tag_from_term!(block_number_or_tag)
        ]
      end

      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_getBlockTransactionCountByHash" do
      doc """
        Returns the number of transactions in a block from a block matching the given block hash.

        # Parameters
        - block_hash: The block hash
      """

      args {block_hash, EthereumApi.Data32.t()}
      args_transformer! &EthereumApi.Data32.from_term!/1
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_getBlockTransactionCountByNumber" do
      doc """
        Returns the number of transactions in a block matching the given block number.

        # Parameters
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
      """

      args {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      args_transformer! &quantity_or_tag_from_term!/1
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_getUncleCountByBlockHash" do
      doc """
        Returns the number of uncles in a block from a block matching the given block hash.

        # Parameters
        - block_hash: The block hash
      """

      args {block_hash, EthereumApi.Data32.t()}
      args_transformer! &EthereumApi.Data32.from_term!/1
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_getUncleCountByBlockNumber" do
      doc """
        Returns the number of uncles in a block from a block matching the given block number.

        # Parameters
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
      """

      args {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      args_transformer! &quantity_or_tag_from_term!/1
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_getCode" do
      doc """
        Returns code at a given address.

        # Parameters
        - address: The address to check for code
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
      """

      args [
        {address, EthereumApi.Data20.t()},
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      ]

      args_transformer! fn address, block_number_or_tag ->
        [
          EthereumApi.Data20.from_term!(address),
          quantity_or_tag_from_term!(block_number_or_tag)
        ]
      end

      response_type EthereumApi.Data.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "eth_sign" do
      doc """
        The sign method calculates an Ethereum specific signature with:
        sign(keccak256("\x19Ethereum Signed Message:\n" + len(message) + message))).

        By adding a prefix to the message makes the calculated signature recognizable as an
        Ethereum specific signature. This prevents misuse where a malicious dapp can sign
        arbitrary data (e.g. transaction) and use the signature to impersonate the victim.

        Note: the address to sign with must be unlocked.

        # Parameters
        - address: The address to sign with
        - data: The data to sign
      """

      args [
        {address, EthereumApi.Data20.t()},
        {data, EthereumApi.Data.t()}
      ]

      args_transformer! fn address, data ->
        [
          EthereumApi.Data20.from_term!(address),
          EthereumApi.Data.from_term!(data)
        ]
      end

      response_type EthereumApi.Data.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "eth_signTransaction" do
      doc """
        Signs a transaction that can be submitted to the network at a later time using with
        eth_sendRawTransaction.

        # Parameters
        - from: The address the transaction is sent from.
        - data: The compiled code of a contract OR the hash of the invoked method signature and
          encoded parameters.
        - opts: A keyword list with the following optional values:
          - to: The address the transaction is directed to.
          - gas: Integer of the gas provided for the transaction execution. It will return unused
            gas.
          - gas_price: Integer of the gasPrice used for each paid gas, in Wei.
          - value: Integer of the value sent with this transaction, in Wei.
          - nonce: Integer of a nonce. This allows to overwrite your own pending transactions
            that use the same nonce.

        # Returns
        - Data - The RLP-encoded transaction object signed by the specified account.
      """

      args [
        {from, EthereumApi.Data20.t()},
        {data, EthereumApi.Data.t()},
        {opts,
         [
           {:to, EthereumApi.Data20.t()},
           {:gas, EthereumApi.Quantity.t()},
           {:gas_price, EthereumApi.Wei.t()},
           {:value, EthereumApi.Wei.t()},
           {:nonce, EthereumApi.Quantity.t()}
         ]}
      ]

      args_transformer! fn from, data, opts ->
        create_transaction_object!(
          [
            from: EthereumApi.Data20.from_term!(from),
            data: EthereumApi.Data.from_term!(data)
          ],
          opts
        )
      end

      response_type EthereumApi.Data.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "eth_sendTransaction" do
      doc """
        Creates new message call transaction or a contract creation, if the data field contains
        code, and signs it using the account specified in from.

        # Parameters
        - from: The address the transaction is sent from.
        - data: The compiled code of a contract OR the hash of the invoked method signature and
          encoded parameters.
        - opts: A keyword list with the following optional values:
          - to: The address the transaction is directed to.
          - gas: Integer of the gas provided for the transaction execution. It will return unused
            gas.
          - gas_price: Integer of the gasPrice used for each paid gas, in Wei.
          - value: Integer of the value sent with this transaction, in Wei.
          - nonce: Integer of a nonce. This allows to overwrite your own pending transactions
            that use the same nonce.

        # Returns
        - Data32 - the transaction hash, or the zero hash if the transaction is not yet available.
          Use eth_getTransactionReceipt to get the contract address, after the transaction was
          proposed in a block, when you created a contract.
      """

      args [
        {from, EthereumApi.Data20.t()},
        {data, EthereumApi.Data.t()},
        {opts,
         [
           {:to, EthereumApi.Data20.t()},
           {:gas, EthereumApi.Quantity.t()},
           {:gas_price, EthereumApi.Wei.t()},
           {:value, EthereumApi.Wei.t()},
           {:nonce, EthereumApi.Quantity.t()}
         ]}
      ]

      args_transformer! fn from, data, opts ->
        create_transaction_object!(
          [
            from: EthereumApi.Data20.from_term!(from),
            data: EthereumApi.Data.from_term!(data)
          ],
          opts
        )
      end

      response_type EthereumApi.Data32.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data32.from_term/1
    end

    method "eth_sendRawTransaction" do
      doc """
        Creates new message call transaction or a contract creation for signed transactions.

        # Parameters
        - signed_transaction_data: The signed transaction data.

        # Returns
        - Data32 - the transaction hash, or the zero hash if the transaction is not yet available.
          Use eth_getTransactionReceipt to get the contract address, after the transaction was
          proposed in a block, when you created a contract.
      """

      args {signed_transaction_data, EthereumApi.Data.t()}
      args_transformer! &EthereumApi.Data.from_term!/1
      response_type EthereumApi.Data32.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data32.from_term/1
    end

    method "eth_call" do
      doc """
        Executes a new message call immediately without creating a transaction on the blockchain.
        Often used for executing read-only smart contract functions, for example the balanceOf for
        an ERC-20 contract.

        # Parameters
        - transaction: The transaction call object.
          - to: The address the transaction is directed to.
          - opts: A keyword list with the following optional values:
            - from: The address the transaction is sent from.
            - gas: Integer of the gas provided for the transaction execution. eth_call consumes
              zero gas, but this parameter may be needed by some executions.
            - gas_price: Integer of the gasPrice used for each paid gas, in Wei.
            - value: Integer of the value sent with this transaction, in Wei.
            - data: Hash of the method signature and encoded parameters. For details see
              Ethereum Contract ABI in the Solidity documentation.
              https://docs.soliditylang.org/en/latest/abi-spec.html

        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}

        # Returns
        - Data - the return value of the executed contract.
      """

      args [
        {transaction,
         {{:to, EthereumApi.Data20.t()},
          opts :: [
            {:from, EthereumApi.Data20.t()},
            {:gas, EthereumApi.Quantity.t()},
            {:gas_price, EthereumApi.Wei.t()},
            {:value, EthereumApi.Wei.t()},
            {:data, EthereumApi.Data.t()}
          ]}},
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()}
      ]

      args_transformer! fn {{:to, to}, opts}, block_number_or_tag ->
        [
          create_transaction_object!([to: to], opts),
          quantity_or_tag_from_term!(block_number_or_tag)
        ]
      end

      response_type EthereumApi.Data.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Data.from_term/1
    end

    method "eth_estimateGas" do
      doc """
        Generates and returns an estimate of how much gas is necessary to allow the transaction
        to complete. The transaction will not be added to the blockchain. Note that the estimate
        may be significantly more than the amount of gas actually used by the transaction, for a
        variety of reasons including EVM mechanics and node performance.

        # Parameters
        - transaction: A keyword list with the following optional values:
          - to: The address the transaction is directed to.
          - from: The address the transaction is sent from.
          - gas: Integer of the gas provided for the transaction execution.
          - gas_price: Integer of the gasPrice used for each paid gas, in Wei.
          - value: Integer of the value sent with this transaction, in Wei.
          - data: The compiled code of a contract OR the hash of the invoked method signature and
            encoded parameters.

        - block_number_or_tag: nil, or an Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}

        # Returns
        - Wei - the amount of gas used.
      """

      args [
        {transaction,
         [
           {:to, EthereumApi.Data20.t()},
           {:from, EthereumApi.Data20.t()},
           {:gas, EthereumApi.Quantity.t()},
           {:gas_price, EthereumApi.Wei.t()},
           {:value, EthereumApi.Wei.t()},
           {:data, EthereumApi.Data.t()}
         ]},
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t() | nil}
      ]

      args_transformer! fn transaction, block_number_or_tag ->
        transaction = create_transaction_object!([], transaction)

        if block_number_or_tag do
          [transaction, quantity_or_tag_from_term!(block_number_or_tag)]
        else
          [transaction]
        end
      end

      response_type EthereumApi.Wei.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Wei.from_term/1
    end

    method "eth_getBlockByHash" do
      doc """
        Returns information about a block by hash.

        # Parameters
        - block_hash: The hash of the block to retrieve
        - full_transaction_objects?: If true, returns the full transaction objects, if false only the transaction hashes
      """

      args [
        {block_hash, EthereumApi.Data32.t()},
        {full_transaction_objects?, boolean()}
      ]

      args_transformer! fn block_hash, full_transaction_objects? ->
        [
          EthereumApi.Data32.from_term!(block_hash),
          if is_boolean(full_transaction_objects?) do
            full_transaction_objects?
          else
            raise ArgumentError, "Expected a boolean, got #{inspect(full_transaction_objects?)}"
          end
        ]
      end

      response_type nil | EthereumApi.Block.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Block.from_term_optional/1
    end

    method "eth_getBlockByNumber" do
      doc """
        Returns information about a block by block number.

        # Parameters
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
        - full_transaction_objects?: If true, returns the full transaction objects, if false only the transaction hashes
      """

      args [
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
        {full_transaction_objects?, boolean()}
      ]

      args_transformer! fn block_number_or_tag, full_transaction_objects? ->
        [
          quantity_or_tag_from_term!(block_number_or_tag),
          if is_boolean(full_transaction_objects?) do
            full_transaction_objects?
          else
            raise ArgumentError, "Expected a boolean, got #{inspect(full_transaction_objects?)}"
          end
        ]
      end

      response_type nil | EthereumApi.Block.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Block.from_term_optional/1
    end

    method "eth_getTransactionByHash" do
      doc """
        Returns the information about a transaction requested by transaction hash.

        # Parameters
        - transaction_hash: Hash of a transaction
      """

      args {transaction_hash, EthereumApi.Data32.t()}
      args_transformer! &EthereumApi.Data32.from_term!/1
      response_type nil | EthereumApi.Transaction.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Transaction.from_term_optional/1
    end

    method "eth_getTransactionByBlockHashAndIndex" do
      doc """
        Returns information about a transaction by block hash and transaction index position.

        # Parameters
        - block_hash: Hash of a block
        - transaction_index: Integer of the transaction index position
      """

      args [
        {block_hash, EthereumApi.Data32.t()},
        {transaction_index, EthereumApi.Quantity.t()}
      ]

      args_transformer! fn block_hash, transaction_index ->
        [
          EthereumApi.Data32.from_term!(block_hash),
          EthereumApi.Quantity.from_term!(transaction_index)
        ]
      end

      response_type nil | EthereumApi.Transaction.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Transaction.from_term_optional/1
    end

    method "eth_getTransactionByBlockNumberAndIndex" do
      doc """
        Returns information about a transaction by block number and transaction index position.

        # Parameters
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
        - transaction_index: Integer of the transaction index position
      """

      args [
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
        {transaction_index, EthereumApi.Quantity.t()}
      ]

      args_transformer! fn block_number_or_tag, transaction_index ->
        [
          quantity_or_tag_from_term!(block_number_or_tag),
          EthereumApi.Quantity.from_term!(transaction_index)
        ]
      end

      response_type nil | EthereumApi.Transaction.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Transaction.from_term_optional/1
    end

    method "eth_getTransactionReceipt" do
      doc """
        Returns the receipt of a transaction by transaction hash.

        Note that the receipt is not available for pending transactions.

        # Parameters
        - transaction_hash: Hash of a transaction

        # Returns
        - nil | TransactionReceipt.t() - A transaction receipt object, or nil when no receipt was found
      """

      args {transaction_hash, EthereumApi.Data32.t()}
      args_transformer! &EthereumApi.Data32.from_term!/1
      response_type nil | EthereumApi.TransactionReceipt.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.TransactionReceipt.from_term_optional/1
    end

    method "eth_getUncleByBlockHashAndIndex" do
      doc """
        Returns information about an uncle of a block by hash and uncle index position.

        # Parameters
        - block_hash: Hash of a block
        - uncle_index: Uncle index position

        # Returns
        - nil | Block.t() - An uncle block object, or nil when no uncle was found
      """

      args [
        {block_hash, EthereumApi.Data32.t()},
        {uncle_index, EthereumApi.Quantity.t()}
      ]

      args_transformer! fn block_hash, uncle_index ->
        [
          EthereumApi.Data32.from_term!(block_hash),
          EthereumApi.Quantity.from_term!(uncle_index)
        ]
      end

      response_type nil | EthereumApi.Block.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Block.from_term_optional/1
    end

    method "eth_getUncleByBlockNumberAndIndex" do
      doc """
        Returns information about an uncle of a block by block number and uncle index position.

        # Parameters
        - block_number_or_tag: Integer block number, or one of the following strings
          #{inspect(EthereumApi.Tag.tags())}
        - uncle_index: Uncle index position

        # Returns
        - nil | Block.t() - An uncle block object, or nil when no uncle was found
      """

      args [
        {block_number_or_tag, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
        {uncle_index, EthereumApi.Quantity.t()}
      ]

      args_transformer! fn block_number_or_tag, uncle_index ->
        [
          quantity_or_tag_from_term!(block_number_or_tag),
          EthereumApi.Quantity.from_term!(uncle_index)
        ]
      end

      response_type nil | EthereumApi.Block.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Block.from_term_optional/1
    end

    method "eth_newFilter" do
      doc """
        Creates a filter object, based on filter options, to notify when the state changes (logs).
        To check if the state has changed, call eth_getFilterChanges.

        A note on specifying topic filters: Topics are order-dependent. A transaction with a log
        with topics [A, B] will be matched by the following topic filters:
        - []: anything
        - [A]: A in first position (and anything after)
        - [null, B]: anything in first position AND B in second position (and anything after)
        - [A, B]: A in first position AND B in second position (and anything after)
        - [[A, B], [A, B]]: (A OR B) in first position AND (A OR B) in second position (and anything after)

        # Parameters
        - filter_options: A map with the following optional fields:
          - from_block: Integer block number, or one of the following strings
            #{inspect(EthereumApi.Tag.tags())}
          - to_block: Integer block number, or one of the following strings
            #{inspect(EthereumApi.Tag.tags())}
          - address: Contract address or a list of addresses from which logs should originate
          - topics: Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with "or" options.

        # Returns
        - Quantity - A filter id
      """

      args {filter_options,
            [
              {:from_block, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
              {:to_block, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
              {:address, EthereumApi.Data20.t() | [EthereumApi.Data20.t()]},
              {:topics, [EthereumApi.Data32.t() | [EthereumApi.Data32.t()]]}
            ]}

      args_transformer! &create_filter_options_object!(&1, false)
      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_newBlockFilter" do
      doc """
        Creates a filter in the node, to notify when a new block arrives.
        To check if the state has changed, call eth_getFilterChanges.

        # Returns
        - Quantity - A filter id
      """

      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_newPendingTransactionFilter" do
      doc """
        Creates a filter in the node, to notify when new pending transactions arrive.
        To check if the state has changed, call eth_getFilterChanges.

        # Returns
        - Quantity - A filter id
      """

      response_type EthereumApi.Quantity.t()
      parsing_error_type String.t()
      response_parser &EthereumApi.Quantity.from_term/1
    end

    method "eth_uninstallFilter" do
      doc """
        Uninstalls a filter with given id. Should always be called when watch is no longer needed.
        Additionally, filters timeout when they aren't requested with eth_getFilterChanges for a period of time.

        # Parameters
        - filter_id: The filter id to uninstall

        # Returns
        - Boolean - true if the filter was successfully uninstalled, otherwise false
      """

      args {filter_id, EthereumApi.Quantity.t()}
      parsing_error_type String.t()

      args_transformer! &EthereumApi.Quantity.from_term!/1
      response_type boolean()

      response_parser &parse_boolean_response/1
    end

    method "eth_getFilterChanges" do
      doc """
        Polling method for a filter, which returns an array of logs which occurred since last poll.

        # Parameters
        - filter_id: The filter id to get changes for

        # Returns
        - The response type depends on the type of filter:
          - For eth_newFilter: Array of Log objects
          - For eth_newBlockFilter: Array of block hashes (Data32)
          - For eth_newPendingTransactionFilter: Array of transaction hashes (Data32)
          - nil when the response is empty
      """

      args {filter_id, EthereumApi.Quantity.t()}
      args_transformer! &EthereumApi.Quantity.from_term!/1

      response_type nil
                    | {:log, [EthereumApi.Log.t()]}
                    | {:hash, [EthereumApi.Data32.t()]}

      parsing_error_type String.t()
      response_parser &parse_filer_result/1
    end

    method "eth_getFilterLogs" do
      doc """
        Returns an array of all logs matching filter with given id.

        # Parameters
        - filter_id: The filter id to get logs for (must be created with eth_newFilter)

        # Returns
        - Array of Log objects
      """

      args {filter_id, EthereumApi.Quantity.t()}
      args_transformer! &EthereumApi.Quantity.from_term!/1
      response_type [EthereumApi.Log.t()]
      parsing_error_type String.t()
      response_parser &EthereumApi.Log.from_term_list/1
    end

    method "eth_getLogs" do
      doc """
        Returns an array of all logs matching a given filter object.

        A note on specifying topic filters: Topics are order-dependent. A transaction with a log
        with topics [A, B] will be matched by the following topic filters:
        - []: anything
        - [A]: A in first position (and anything after)
        - [null, B]: anything in first position AND B in second position (and anything after)
        - [A, B]: A in first position AND B in second position (and anything after)
        - [[A, B], [A, B]]: (A OR B) in first position AND (A OR B) in second position (and anything after)

        # Parameters
        - filter_options: A map with the following optional fields:
          - from_block: Integer block number, or one of the following strings
            #{inspect(EthereumApi.Tag.tags())}
          - to_block: Integer block number, or one of the following strings
            #{inspect(EthereumApi.Tag.tags())}
          - block_hash: Hash of the block to get logs from (mutually exclusive with from_block/to_block)
          - address: Contract address or a list of addresses from which logs should originate
          - topics: Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with "or" options.

        # Returns
        - [Log.t()] - Array of log objects
      """

      args {filter_options,
            [
              {:from_block, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
              {:to_block, EthereumApi.Quantity.t() | EthereumApi.Tag.t()},
              {:block_hash, EthereumApi.Data32.t()},
              {:address, EthereumApi.Data20.t() | [EthereumApi.Data20.t()]},
              {:topics, [EthereumApi.Data32.t() | [EthereumApi.Data32.t()]]}
            ]}

      args_transformer! &create_filter_options_object!(&1, true)

      response_type [EthereumApi.Log.t()]
      parsing_error_type String.t()

      response_parser &EthereumApi.Log.from_term_list/1
    end
  end

  defp create_transaction_object!(transaction, opts) do
    check_elem_and_add_it_to_acc = fn {key, value}, acc ->
      {key, value} =
        cond do
          key in [:gas, :nonce] ->
            {Atom.to_string(key), EthereumApi.Quantity.from_term!(value)}

          key == :gas_price ->
            {"gasPrice", EthereumApi.Wei.from_term!(value)}

          key == :value ->
            {"value", EthereumApi.Wei.from_term!(value)}

          key in [:to, :from] ->
            {Atom.to_string(key), EthereumApi.Data20.from_term!(value)}

          key == :data ->
            {Atom.to_string(key), EthereumApi.Data.from_term!(value)}

          true ->
            raise ArgumentError, "Invalid option: #{inspect(key)}"
        end

      Map.get_and_update(acc, key, fn
        nil -> {nil, value}
        _ -> raise ArgumentError, "Duplicate option: #{inspect(key)}"
      end)
      |> elem(1)
    end

    # Check validity of transaction elems
    transaction = Enum.reduce(transaction, %{}, check_elem_and_add_it_to_acc)

    # Check validity of opts elems and add them to transaction
    Enum.reduce(opts, transaction, check_elem_and_add_it_to_acc)
  end

  defp create_filter_options_object!(opts, allow_block_hash?) do
    opts
    |> validate_filter_options!(allow_block_hash?)
    |> transform_filter_options!()
  end

  defp validate_filter_options!(opts, allow_block_hash?) do
    has_block_hash? = Keyword.has_key?(opts, :block_hash)
    has_from_or_to? = Keyword.has_key?(opts, :from_block) || Keyword.has_key?(opts, :to_block)

    if has_block_hash? && has_from_or_to? do
      raise ArgumentError, "Block hash and from/to block options are mutually exclusive"
    end

    if has_block_hash? && !allow_block_hash? do
      raise(ArgumentError, "Invalid filter option: :block_hash")
    end

    opts
  end

  defp transform_filter_options!(opts) do
    Enum.reduce(opts, %{}, fn {key, value}, acc ->
      {transformed_key, transformed_value} = transform_filter_option!(key, value)

      Map.get_and_update(acc, transformed_key, fn
        nil -> {nil, transformed_value}
        _ -> raise ArgumentError, "Duplicate filter option: #{inspect(key)}"
      end)
      |> elem(1)
    end)
  end

  defp transform_filter_option!(:from_block, value),
    do: {"fromBlock", quantity_or_tag_from_term!(value)}

  defp transform_filter_option!(:to_block, value),
    do: {"toBlock", quantity_or_tag_from_term!(value)}

  defp transform_filter_option!(:block_hash, value),
    do: {"blockHash", EthereumApi.Data32.from_term!(value)}

  defp transform_filter_option!(:address, value) do
    transformed_value =
      if is_list(value) do
        Enum.map(value, &EthereumApi.Data20.from_term!/1)
      else
        EthereumApi.Data20.from_term!(value)
      end

    {"address", transformed_value}
  end

  defp transform_filter_option!(:topics, value) do
    transformed_value =
      Enum.map(value, fn topic ->
        if is_list(topic) do
          Enum.map(topic, &EthereumApi.Data32.from_term!/1)
        else
          EthereumApi.Data32.from_term!(topic)
        end
      end)

    {"topics", transformed_value}
  end

  defp transform_filter_option!(key, _value),
    do: raise(ArgumentError, "Invalid filter option: #{inspect(key)}")

  defp parse_filer_result(response) do
    case response do
      [] ->
        {:ok, nil}

      [first | _] = list ->
        if is_map(first) do
          try_reduce_log_list(list, [])
          |> case do
            {:error, reason} -> {:error, reason}
            {:ok, logs} -> {:ok, {:log, Enum.reverse(logs)}}
          end
        else
          try_reduce_hash_list(list, [])
          |> case do
            {:error, reason} -> {:error, reason}
            {:ok, hashes} -> {:ok, {:hash, Enum.reverse(hashes)}}
          end
        end

      response ->
        {:error, "Invalid response, expected list found #{inspect(response)}"}
    end
  end

  defp try_reduce_log_list(list, acc) do
    Enum.reduce_while(list, {:ok, acc}, fn elem, {:ok, acc} ->
      case EthereumApi.Log.from_term(elem) do
        {:ok, log} -> {:cont, {:ok, [log | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp try_reduce_hash_list(list, acc) do
    Enum.reduce_while(list, {:ok, acc}, fn elem, {:ok, acc} ->
      case EthereumApi.Data32.from_term(elem) do
        {:ok, hash} -> {:cont, {:ok, [hash | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp quantity_or_tag_from_term!(value) do
    case EthereumApi.Quantity.from_term(value) do
      {:ok, quantity} ->
        quantity

      {:error, _} ->
        case EthereumApi.Tag.from_term(value) do
          {:ok, tag} ->
            tag

          {:error, _} ->
            raise ArgumentError, "Expected a quantity or tag, found #{inspect(value)}"
        end
    end
  end

  @spec parse_boolean_response(any) :: {:ok, boolean()} | {:error, String.t()}
  defp parse_boolean_response(response) do
    if is_boolean(response) do
      {:ok, response}
    else
      {:error, "Expected a boolean, got #{inspect(response)}"}
    end
  end

  @spec parse_boolean_response(any) :: {:ok, String.t()} | {:error, String.t()}
  defp parse_string_response(response) do
    error = fn value -> {:error, "Expected a string got #{value}"} end

    if is_binary(response) do
      if String.valid?(response) do
        {:ok, response}
      else
        error.(response)
      end
    else
      error.(response)
    end
  end
end
