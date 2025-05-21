defmodule EthereumApi.Tag do
  @moduledoc """
  Represents block tags used in Ethereum API calls.

  Valid tags include: "latest", "earliest", "pending", "safe", and "finalized".
  """
  @type t :: String.t()

  @doc """
  Returns a list of all valid block tags.

  ## Examples

      iex> EthereumApi.Tag.tags()
      ["latest", "earliest", "pending", "safe", "finalized"]
  """
  @spec tags() :: [String.t()]
  def tags(), do: ["latest", "earliest", "pending", "safe", "finalized"]

  @doc """
  Converts a term to a valid block tag.

  Returns `{:ok, tag}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> EthereumApi.Tag.from_term("latest")
      {:ok, "latest"}

      iex> EthereumApi.Tag.from_term("earliest")
      {:ok, "earliest"}

      iex> EthereumApi.Tag.from_term("pending")
      {:ok, "pending"}

      iex> EthereumApi.Tag.from_term("safe")
      {:ok, "safe"}

      iex> EthereumApi.Tag.from_term("finalized")
      {:ok, "finalized"}

      iex> EthereumApi.Tag.from_term("invalid")
      {:error, "Invalid tag: \\"invalid\\""}

      iex> EthereumApi.Tag.from_term(123)
      {:error, "Invalid tag: 123"}

      iex> EthereumApi.Tag.from_term(:atom)
      {:error, "Invalid tag: :atom"}

      iex> EthereumApi.Tag.from_term([1, 2, 3])
      {:error, "Invalid tag: [1, 2, 3]"}

      iex> EthereumApi.Tag.from_term(%{key: "value"})
      {:error, "Invalid tag: %{key: \\"value\\"}"}
  """
  @spec from_term(any()) :: {:ok, t()} | {:error, String.t()}
  def from_term(value) do
    if value in tags() do
      {:ok, value}
    else
      {:error, "Invalid tag: #{inspect(value)}"}
    end
  end

  @doc """
  Converts a term to a valid block tag.

  Raises `ArgumentError` if the conversion fails.

  ## Examples

      iex> EthereumApi.Tag.from_term!("latest")
      "latest"

      iex> EthereumApi.Tag.from_term!("earliest")
      "earliest"

      iex> EthereumApi.Tag.from_term!("pending")
      "pending"

      iex> EthereumApi.Tag.from_term!("safe")
      "safe"

      iex> EthereumApi.Tag.from_term!("finalized")
      "finalized"

      iex> EthereumApi.Tag.from_term!("invalid")
      ** (ArgumentError) Expected a tag, found "invalid"

      iex> EthereumApi.Tag.from_term!(123)
      ** (ArgumentError) Expected a tag, found 123

      iex> EthereumApi.Tag.from_term!(:atom)
      ** (ArgumentError) Expected a tag, found :atom

      iex> EthereumApi.Tag.from_term!([1, 2, 3])
      ** (ArgumentError) Expected a tag, found [1, 2, 3]

      iex> EthereumApi.Tag.from_term!(%{key: "value"})
      ** (ArgumentError) Expected a tag, found %{key: "value"}
  """
  @spec from_term!(any()) :: t()
  def from_term!(value) do
    case from_term(value) do
      {:ok, value} -> value
      {:error, _} -> raise ArgumentError, "Expected a tag, found #{inspect(value)}"
    end
  end

  @doc """
  Checks if a value is a valid block tag.

  ## Examples

      iex> EthereumApi.Tag.is_tag?("latest")
      true

      iex> EthereumApi.Tag.is_tag?("earliest")
      true

      iex> EthereumApi.Tag.is_tag?("pending")
      true

      iex> EthereumApi.Tag.is_tag?("safe")
      true

      iex> EthereumApi.Tag.is_tag?("finalized")
      true

      iex> EthereumApi.Tag.is_tag?("invalid")
      false

      iex> EthereumApi.Tag.is_tag?(123)
      false
  """
  @spec is_tag?(any()) :: boolean()
  def is_tag?(value) do
    case from_term(value) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
