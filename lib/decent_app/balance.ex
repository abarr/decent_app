defmodule DecentApp.Balance do
  defstruct coins: 0

  def update_coins(balance, price) do
    cond do
       balance.coins - price >= 0 -> %{balance | coins: balance.coins - price}
       true -> -1
    end
  end
end
