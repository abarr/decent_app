defmodule DecentApp do
  @moduledoc """
    This module provides a function to process a list of list of commands, update a
    %Balance{} struct and return a results list.
  """
  alias DecentApp.Balance
  @cmds Application.fetch_env!(:decent_app, :commands)

  @doc """
  Returns a list of results after successfully  processing a list of list_of_cmds

  ## Examples

      iex> DecentApp.call(%DecentApp.Balance{ coins: 10}, [9, "DUP"])
      {%DecentApp.Balance{coins: 8}, [9, 9]}

  Unrecognised commands will result in a failure and a return value of -1

  ## Examples

    iex> DecentApp.call(%DecentApp.Balance{ coins: 10}, ["FAKE"])
    -1

  If the coins in %Balance{} falls below zero the call will fail and return -1

  ## Examples

    iex> DecentApp.call(%DecentApp.Balance{ coins: 1}, [9, 8, "+"])
    -1

  """
  def call(%Balance{} = balance, commands) do
    valid_cmds = Enum.map(@cmds, fn c -> c.key end)
    cond do
      !is_valid_list?(commands, valid_cmds, true) ->
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
  def is_valid_list?(_, _, false), do: false
  def is_valid_list?([], _, true), do: true

  def is_valid_list?([head | tail], valid_cmds, true) do
    cond do
      !is_integer(head) ->
        if Enum.member?(valid_cmds, head) do
          is_valid_list?(tail, valid_cmds, true)
        else
          is_valid_list?(tail, valid_cmds, false)
        end

      true ->
        if Enum.member?(0..9, head) do
          is_valid_list?(tail, valid_cmds, true)
        else
          is_valid_list?(tail, valid_cmds, false)
        end
    end
  end
end
