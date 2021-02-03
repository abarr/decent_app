import Config

config :decent_app,
  commands: [
    %{ key: "DUP", cost: 1, action: "duplicate", number_of_list_items: 1},
    %{ key: "COINS", payment: 5 },
    %{ key: "POP", cost: 1, action: "delete"},
    %{ key: "PUSH", cost: 1, action: "insert"},
    %{ key: "NOTHING", cost: 1},
    %{ key: "+", cost: 2, action: "add", number_of_list_items: 2},
    %{ key: "-", cost: 1, action: "subtract", number_of_list_items: 2}
  ]
