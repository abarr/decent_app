defmodule DecentApp do
  @moduledoc """
    This module provides a function to process a list of list of cmd_configs, update a
    %Balance{} struct and return a results list.
  """
  alias DecentApp.{Balance, Processor}

  @doc """
  Returns a list of results after successfully  processing a list of list_of_cmds

  ## Examples

      iex> DecentApp.call(%DecentApp.Balance{ coins: 10}, [9, "DUP"])
      {%DecentApp.Balance{coins: 8}, [9, 9]}

  Unrecognised cmd_configs will result in a failure and a return value of -1

  ## Examples

    iex> DecentApp.call(%DecentApp.Balance{ coins: 10}, ["FAKE"])
    -1

  If the coins in %Balance{} falls below zero the call will fail and return -1

  ## Examples

    iex> DecentApp.call(%DecentApp.Balance{ coins: 1}, [9, 8, "+"])
    -1

  """

  def call(%Balance{} = balance, commands) when is_list(commands) do
    Processor.process(balance, [], commands, :valid)
  end

  def call(_balance, _commands), do: -1

end
