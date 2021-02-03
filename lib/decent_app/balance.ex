defmodule DecentApp.Balance do
  defstruct coins: 0

  def update_coins(balance, rule) do
    coins = balance.coins + rule.payment - rule.cost
    balance
    |> Map.put(:coins, coins)
  end

end
