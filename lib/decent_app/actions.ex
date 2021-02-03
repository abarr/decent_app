defmodule DecentApp.Actions do
  def action(:nothing, list, _cmd), do: list

  def action(:duplicate, list, _cmd), do: list ++ [List.last(list)]

  def action(:delete, list, _cmd) do
    {_, list} = List.pop_at(list, length(list) - 1)
    list
  end

  def action(:add, list, _cmd) do
    [first, second | rest] = Enum.reverse(list)
    Enum.reverse(rest) ++ [first + second]
  end

  def action(:subtract, list, _cmd) do
    [first, second | rest] = Enum.reverse(list)
    Enum.reverse(rest) ++ [first - second]
  end

  def action(:multiply, list, _cmd) do
    [first, second | rest] = Enum.reverse(list)
    rest ++ [Integer.to_string(first * second )]
  end

  def action(:insert, list, cmd), do: list ++ [cmd]
end
