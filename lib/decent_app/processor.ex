defmodule DecentApp.Processor do
  alias DecentApp.{Balance, Config, Validator}


  def process(_, _, _, :invalid), do: -1
  def process(balance, result, [], _valid), do: {balance, result}

  def process(balance, result, [cmd | tail], :valid) do
         # Get the cmd_config config
    with %{} = cmd_config <- find_cmd_config_config(cmd),
         # Run list of validation rules
         true <- Validator.valid?(cmd_config.validation_rules, result),
         # Run cmd_config perform function in config
         result <- cmd_config.perform.(result, cmd),
         # Update balance
         %Balance{} = balance <- Balance.update_coins(balance, cmd_config.price) do
      # Continue to process list of cmd_configs
      process(balance, result, tail, :valid)
    else
      _error ->
        # If any function fails mark process invalid
        process(balance, result, tail, :invalid)
    end
  end

  defp find_cmd_config_config(cmd_config) do
    Enum.find(Config.get(), fn
      %{criteria: criteria} -> cmd_config in criteria
      %{name: name} -> cmd_config == name
    end)
  end
end
