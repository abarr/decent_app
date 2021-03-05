defmodule DecentApp do
  @moduledoc """
    This module provides a function to process a list of list of commands, update a
    %Balance{} struct and return a results list.
  """
  alias DecentApp.{Balance, Config}

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
    process(balance, [], commands, true)
  end

  def process(_, _, _, false), do: -1
  def process(balance, result, [], _valid), do: {balance, result}

  def process(balance, result, [cmd | tail], true) do
    with %{} = command <- find_command_config(cmd),
         true <- valid?(command.validation_rules, result),
         result <- command.perform.(result, cmd),
         %Balance{} = balance <- Balance.update_coins(balance, command.price) do
      process(balance, result, tail, true)
    else
      _error ->
        process(balance, result, tail, false)
    end
  end

  def valid?([], _result), do: true
  def valid?(rules, result) when is_list(rules) and is_list(result) do
    !Enum.member?(Enum.map(rules, &valid?(&1, &1.value, result)), false)
  end
  def valid?(%{type: "length"}, {">=", length}, list), do: length(list) >= length

  def update_result(cmd, result, fun) do
    fun.(result, cmd) |> IO.inspect()
  end

  def find_command_config(command) do
    Enum.find(Config.get(), fn
      %{criteria: criteria} -> command in criteria
      %{name: name} -> command == name
    end)
  end
end
