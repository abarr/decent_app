defmodule DecentApp.Actions do
  def action(:nothing, list), do: list

  def action(:duplicate, list), do: list ++ [List.last(list)]

  def action(:delete, list) do
    {_, list} = List.pop_at(list, length(list) - 1)
    list
  end

  def action(:add, list) do
    [first, second | rest] = Enum.reverse(list)
    Enum.reverse(rest) ++ [first + second]
  end

  def action(:subtract, list) do
    [first, second | rest] = Enum.reverse(list)
    Enum.reverse(rest) ++ [first - second]
  end

  def action(:multiply, list) do
    [first, second | rest] = Enum.reverse(list)
    rest ++ [Integer.to_string(first * second )]
  end

  def action(:insert, list, item), do: list ++ [item]
end
