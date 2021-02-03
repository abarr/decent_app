defmodule DecentApp do
  alias DecentApp.Balance

  @valid_cmds ["DUP", "COINS", "+", "-", "POP", "NOTHING"]

  def call(%Balance{} = balance, commands) do
    cond do
      !is_valid_list?(commands, true) ->
        IO.puts(:invalid_list)
        -1
      true ->
        process(balance, [], commands)
    end
  end

  defp process(balance, result, []), do: {balance, result}
  defp process(balance, result, [head | tail]) when is_list(result) do
    case cmd(head, result, balance) do
      {result, balance} -> process(balance, result, tail)
      error ->
        IO.puts(error)
        -1
    end
  end

  # CMD Definitions
  defp cmd(number, result, balance) when is_integer(number) do
    {result ++ [number], balance}
  end

  defp cmd("DUP", result, balance) do
    cond do
      length(result) < 1 ->
        :invalid_dup
      true -> {result ++ [List.last(result)], balance}
    end
  end

  defp cmd("NOTHING", result, balance), do: {result, balance}
  defp cmd("COINS", result, balance), do: {result, balance}
  defp cmd("POP", result, balance) do
    cond do
      length(result) < 1 -> :invalid_pop
      true ->
        {_, result} = List.pop_at(result, length(result) - 1)
        {result, balance}
    end
  end
  defp cmd("+", result, balance) do
    cond do
      length(result) < 2 -> :invalid_add
      true ->
        [first, second | rest] = Enum.reverse(result)
        {Enum.reverse(rest) ++ [first + second], balance}
    end
  end
  defp cmd("-", result, balance) do
    cond do
      length(result) < 2 -> :invalid_minus
      true ->
        [first, second | rest] = Enum.reverse(result)
        {Enum.reverse(rest) ++ [first - second], balance}
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


  def call_old(%Balance{} = balance, commands) do
    {balance, result, error} =
      Enum.reduce(commands, {balance, [], false}, fn command, {bal, res, error} ->
        if error do
          {nil, nil, true}
        else
          is_error =
            cond do

              length(res) < 1 ->
                if command == "DUP" || command == "POP" || command == "+" || command == "-" do
                  true
                else
                  false
                end
              length(res) < 2 ->
                if command == "+" || command == "-" do
                  true
                else
                  false
                end

              is_integer(command) ->
                if command < 0 || command > 10 do
                  true
                else
                  false
                end

              command != "NOTHING" && command != "DUP" && command != "POP" && command != "+" &&
                command != "-" && command != "COINS" && !is_integer(command) ->
                true

              true ->
                false
            end
          if is_error do
            {nil, nil, true}
          else
            new_balance = %{bal | coins: bal.coins - 1}

            res =
              cond do
                command === "NOTHING" ->
                  res

                true ->
                  cond do
                    command == "DUP" ->
                      res ++ [List.last(res)]

                    true ->
                      if command == "POP" do
                        {_, res} = List.pop_at(res, length(res) - 1)
                        res
                      else
                        cond do
                          command == "+" ->
                            [first, second | rest] = Enum.reverse(res)
                            Enum.reverse(rest) ++ [first + second]

                          command == "-" ->
                            [first, second | rest] = Enum.reverse(res)
                            Enum.reverse(rest) ++ [first - second]

                          is_integer(command) ->
                            res ++ [command]

                          command == "COINS" ->
                            res
                        end
                      end
                  end
              end

            new_balance =
              if command == "COINS" do
                %{new_balance | coins: new_balance.coins + 6}
              else
                new_balance
              end

            new_balance =
              if command == "+" do
                %{new_balance | coins: new_balance.coins - 1}
              else
                new_balance
              end

            {new_balance, res, false}
          end
        end
      end)

    if error do
      -1
    else
      if balance.coins < 0 do
        -1
      else
        {balance, result}
      end
    end
  end
end
