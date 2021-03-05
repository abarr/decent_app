defmodule DecentApp.Validator do

  def valid?([], _result), do: true

  def valid?(rules, result) when is_list(rules) and is_list(result) do
    !Enum.member?(Enum.map(rules, &valid?(&1, &1.value, result)), false)
  end

  # Pattern match on type of validation
  defp valid?(%{type: "length"}, {">=", length}, list), do: length(list) >= length
  defp valid?(%{type: "length"}, {">", length}, list), do: length(list) > length

end
