import Config

"""
The configurable list of valid commands below must follow the listed rules
  1. All values must be included (See list below)
  2. If you remove a command and it is included in teh input to DecentApp.call/2 it will return -1
  3. Adding new features will require using teh actions listed below. If the feature is not supported
  by and existing action you will need to update the DecentApp.Actions Module

  **NOTE:
  - If a command includes a cost and a payment the payment will be added before the cost is subtracted
  - All actions are processed on the end of the results list
  **


  List of required keys:
  - key: is the shorthand for the action and is provided in a list to DecentApp.call/2
  - cost: must be 0 or higher value and will be taken from the DecentApp.Balance.coins each time the
    command is processed
  - payment: must be 0 or higher value and will be added to DecentApp.Balance.coins each time the
    command is processed
  - action: is a predefined lits of actions in the DecentApp.Actions Module (See below)
  - min_length: is used to ensure a command is valid beforre processing
    (e.g. "+" requires adding the last 2 items in the results list)

  Action definitions:

  :duplicate - duplicates the last item in the results list
  :delete - removes teh last item in the results list
  :insert - inserts a provided item to the results list (Must be an INT)
  :add - adds the last two items in the result list together and replaces
  them with the result
  :subtract - subtracts the last item from the second last item in the result
  list and replaces them with the result
  :multiply - multiplies the last two items in the result list and replaces them with the result


"""
config :decent_app,
  commands: [
    %{key: "DUP", cost: 1, payment: 0, action: :duplicate, min_length: 1},
    %{key: "COINS", cost: 0, payment: 5, action: :nothing, min_length: 0},
    %{key: "POP", cost: 1, payment: 0, action: :delete, min_length: 1},
    %{key: "PUSH", cost: 1, payment: 0, action: :insert, min_length: 1},
    %{key: "NOTHING", cost: 1, payment: 0, action: :nothing, min_length: 1},
    %{key: "+", cost: 2, payment: 0, action: :add, min_length: 2},
    %{key: "-", cost: 1, payment: 0, action: :subtract, min_length: 2},
    %{key: "*", cost: 3, payment: 0, action: :multiply, min_length: 2}
  ]
