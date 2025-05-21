defmodule EthereumApi.Support do
  @moduledoc false

  defmacro def_data_module(size, debug \\ false) do
    if !is_integer(size) do
      raise ArgumentError, "Expected an integer, found #{inspect(size)}"
    end

    if size < 1 do
      raise ArgumentError, "Expected a positive integer, found #{inspect(size)}"
    end

    module_name =
      String.to_atom("Data#{size}") |> (fn arg -> Module.concat([__CALLER__.module, arg]) end).()

    # 2 hex characters per byte
    # + 2 for the 0x prefix
    expected_string_len = size * 2 + 2

    ast =
      quote do
        defmodule unquote(module_name) do
          @type t :: String.t()

          def from_term(value) when is_binary(value) do
            if is_data?(value) do
              {:ok, value}
            else
              from_term_error(value)
            end
          end

          def from_term(value), do: from_term_error(value)

          defp from_term_error(value),
            do: {:error, "Invalid Data#{unquote(size)}: #{inspect(value)}"}

          def is_data?(value) when is_binary(value) do
            if String.length(value) == unquote(expected_string_len) do
              EthereumApi.Data.is_data?(value)
            else
              false
            end
          end

          def is_data?(_), do: false

          @spec from_term!(any()) :: t()
          def from_term!(value) do
            case from_term(value) do
              {:ok, value} ->
                value

              {:error, _} ->
                raise ArgumentError, "Expected a Data#{unquote(size)}, found #{inspect(value)}"
            end
          end

          def from_term_list(list) when is_list(list) do
            Enum.reduce_while(list, {:ok, []}, fn value, {_, acc} ->
              case from_term(value) do
                {:ok, value} ->
                  {:cont, {:ok, [value | acc]}}

                {:error, _} ->
                  {:halt, {:error, "Expected a list of Data#{unquote(size)}"}}
              end
            end)
            |> Result.map(&Enum.reverse/1)
          end

          def from_term_list(_), do: {:error, "Expected a list of Data#{unquote(size)}"}
        end
      end

    if debug do
      readable_code = ast |> Macro.to_string() |> Code.format_string!() |> IO.iodata_to_binary()
      IO.puts("Generated code for module #{module_name}\n#{readable_code}")
    end

    ast
  end
end
