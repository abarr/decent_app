defmodule DecentApp do
  alias DecentApp.Balance

  @valid_cmds ["DUP", "COINS", "+", "-", "POP", "NOTHING"]

  def call(%Balance{} = balance, commands) do
    cond do
      !is_valid_list?(commands, true) ->
        -1

      true ->
        process(balance, [], commands)
    end
  end

  defp process(balance, result, []), do: {balance, result}

  defp process(%{coins: coins} = balance, result, [head | tail]) when is_list(result) do
    cond do
      coins < 0 ->
        -1

      true ->
        case cmd(head, result, balance) do
          {result, balance} -> process(balance, result, tail)
          _ -> -1
        end
    end
  end

  # CMD Definitions
  defp cmd(number, result, balance) when is_integer(number) do
    {result ++ [number], %{balance | coins: balance.coins - 1}}
  end

  defp cmd("DUP", result, balance) do
    cond do
      length(result) < 1 ->
        :invalid_dup

      true ->
        {result ++ [List.last(result)], %{balance | coins: balance.coins - 1}}
    end
  end

  defp cmd("NOTHING", result, balance), do: {result, %{balance | coins: balance.coins - 1}}
  defp cmd("COINS", result, balance), do: {result, %{balance | coins: balance.coins + 5}}

  defp cmd("POP", result, balance) do
    cond do
      length(result) < 1 ->
        :invalid_pop

      true ->
        {_, result} = List.pop_at(result, length(result) - 1)
        {result, %{balance | coins: balance.coins - 1}}
    end
  end

  defp cmd("+", result, balance) do
    cond do
      length(result) < 2 ->
        :invalid_add

      true ->
        [first, second | rest] = Enum.reverse(result)
        {Enum.reverse(rest) ++ [first + second], %{balance | coins: balance.coins - 2}}
    end
  end

  defp cmd("-", result, balance) do
    cond do
      length(result) < 2 ->
        :invalid_minus

      true ->
        [first, second | rest] = Enum.reverse(result)
        {Enum.reverse(rest) ++ [first - second], %{balance | coins: balance.coins - 1}}
    end
  end

  # Command List Validation
  def is_valid_list?(_, false), do: false
  def is_valid_list?([], true), do: true

  def is_valid_list?([head | tail], true) do
    cond do
      !is_integer(head) ->
        if Enum.member?(@valid_cmds, head) do
          is_valid_list?(tail, true)
        else
          is_valid_list?(tail, false)
        end

      true ->
        if Enum.member?(0..10, head) do
          is_valid_list?(tail, true)
        else
          is_valid_list?(tail, false)
        end
    end
  end

end
