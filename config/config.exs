import Config

config :decent_app,
  commands: [
    %{key: "DUP", cost: 1, payment: 0, action: :duplicate, min_length: 1},
    %{key: "COINS", cost: 0, payment: 5, action: :nothing, min_length: 0},
    %{key: "POP", cost: 1, payment: 0, action: :delete, min_length: 1},
    %{key: "PUSH", cost: 1, payment: 0, action: :insert, min_length: 1},
    %{key: "NOTHING", cost: 1, payment: 0, action: :nothing, min_length: 1},
    %{key: "+", cost: 2, payment: 0, action: :add, min_length: 2},
    %{key: "-", cost: 1, payment: 0, action: :subtract, min_length: 2}
  ]
