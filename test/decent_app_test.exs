defmodule DecentAppTest do
  use ExUnit.Case
  doctest DecentApp

  alias DecentApp.Balance

  describe "Awesome tests" do
    test "success" do
      balance = %Balance{coins: 10}

      {new_balance, result} =
        DecentApp.call(balance, [3, "DUP", "COINS", 5, "+", "NOTHING", "POP", 7, "-", 9])

      assert DecentApp.call(balance, [3, "DUP", "COINS", 5, "+", "NOTHING", "POP", 7, "-", 9]) ==
               {%DecentApp.Balance{coins: 5}, [4, 9]}

      assert new_balance.coins == 5
      assert length(result) > 1
    end

    test "success - new" do
      balance = %Balance{coins: 10}

      assert DecentApp.call(balance, [3, "DUP", "COINS", 5, "+", "NOTHING", "POP", 7, "-", 9, "*"]) ==
               -1

      assert DecentApp.call(balance, [
               3,
               "DUP",
               "COINS",
               5,
               "+",
               "NOTHING",
               "POP",
               7,
               "-",
               9,
               9,
               "*"
             ]) ==
               {%DecentApp.Balance{coins: 1}, [324]}
    end

    test "success multiply" do
      balance = %Balance{coins: 50}

      assert DecentApp.call(balance, [
               3,
               "DUP",
               "COINS",
               5,
               "+",
               "NOTHING",
               "POP",
               7,
               "-",
               9,
               9,
               "*",
               "DUP",
               "+"
             ]) ==
               {%DecentApp.Balance{coins: 38}, [648]}
    end

    test "failed" do
      balance = %Balance{coins: 10}

      assert DecentApp.call(%Balance{coins: 10}, [
               3,
               "DUP",
               "FALSE",
               5,
               "+",
               "NOTHING",
               "POP",
               7,
               "-",
               9
             ]) == -1

      assert DecentApp.call(balance, ["COINS", 5, "+", "NOTHING", "POP", 7, "-", 9, "*"]) ==
               -1

      assert DecentApp.call(%Balance{coins: 1}, [10, 5, 6]) == -1
      assert DecentApp.call(%Balance{coins: 1}, [3, 5, 6]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["+"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["-"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["DUP"]) == -1
      assert DecentApp.call(%Balance{coins: 10}, ["POP"]) == -1
    end
  end
end
