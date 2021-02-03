defmodule DecentApp do
  alias DecentApp.Balance

  @valid_cmds ["DUP", "COIN", "+", "-", "POP", "NOTHING"]

  def call(%Balance{} = balance, commands) do
    cond do
      !is_valid_list?(commands, true) -> -1 # Validate list of commands
      true ->
        proocess(balance, [], commands)
    end
  end

  defp proocess(_balance, _result, _commands) do
    
  end

  # Cycles through the commands list input to ensure commands
  # are valid or integers
  def is_valid_list?(_, false), do: false
  def is_valid_list?([], true), do: true
  def is_valid_list?([head | tail], true) do
    cond do
      !is_integer(head) ->
        if Enum.member?(@valid_cmds, head), do: is_valid_list?(tail, true), else: is_valid_list?(tail, false)
      true -> is_valid_list?(tail, true)
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
