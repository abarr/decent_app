defmodule DecentApp do
  @moduledoc """
    This module provides a function to process a list of list of commands, update a
    %Balance{} struct and return a results list.
  """
  alias DecentApp.Balance
  alias DecentApp.Actions
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
        process(balance, [], commands, @cmds)
    end
  end

  defp process(balance, result, [], _rules), do: {balance, result}

  defp process(%{coins: coins} = balance, result, [head | tail], rules) when is_list(result) do
    cond do
      coins < 0 ->
        -1

      is_integer(head) ->
        rule = Enum.find(rules, fn cmd -> cmd.key == "PUSH" end)

        case cmd(head, result, balance, rule) do
          {result, balance} -> process(balance, result, tail, rules)
          _ -> -1
        end

      true ->
        rule = Enum.find(rules, fn cmd -> cmd.key == head end)

        case cmd(head, result, balance, rule) do
          {result, balance} -> process(balance, result, tail, rules)
          _ -> -1
        end
    end
  end

  # CMD Definitions
  defp cmd(cmd, result, balance, rule) when is_integer(cmd) do
    {Actions.action(rule.action, result, cmd), update_coins(balance, rule)}
  end

  defp cmd(_cmd, result, balance, rule) do
    cond do
      length(result) < rule.min_length -> :invalid
      true -> {Actions.action(rule.action, result), update_coins(balance, rule)}
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

  defp update_coins(balance, rule) do
    coins = balance.coins + rule.payment - rule.cost
    balance
    |> Map.put(:coins, coins)
  end
end
