defmodule DecentApp.Config do
  def get do
    [
      %{
        name: "DUP",
        price: 1,
        validation_rules: [%{type: "length", value: {">=", 1}}],
        perform: fn list, _ -> list ++ [List.last(list)] end
      },
      %{
        name: "POP",
        price: 1,
        validation_rules: [%{type: "length", value: {">=", 1}}],
        perform: fn list, _ -> list |> List.pop_at(length(list) - 1) |> elem(1) end
      },
      %{
        name: "PUSH",
        criteria: [1, 2, 3, 4, 5, 6, 7, 8, 9],
        price: 1,
        validation_rules: [],
        perform: fn list, command -> list ++ [command] end
      },
      %{
        name: "NOTHING",
        price: 1,
        validation_rules: [],
        perform: fn list, _ -> list end
      },
      %{
        name: "COINS",
        price: -5,
        validation_rules: [],
        perform: fn list, _ -> list end
      },
      %{
        name: "+",
        price: 2,
        validation_rules: [%{type: "length", value: {">=", 2}}],
        perform: fn list, _ ->
          {head, [last1, last2]} = Enum.split(list, -2)
          head ++ [last1 + last2]
        end
      },
      %{
        name: "-",
        price: 1,
        validation_rules: [%{type: "length", value: {">=", 2}}],
        perform: fn list, _ ->
          {head, [last1, last2]} = Enum.split(list, -2)
          head ++ [last2 - last1]
        end
      },
      %{
        name: "*",
        price: 3,
        validation_rules: [%{type: "length", value: {">=", 3}}],
        perform: fn list, _ ->
          {head, [last1, last2, last3]} = Enum.split(list, -3)
          head ++ [last1 * last2 * last3]
        end
      }
    ]
  end
end
