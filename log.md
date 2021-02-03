# Modified Decent App 

1. Simplify the call function by splitting out responsibilities
    a. Validate Input
    b. Process commands
    c. Update balance

## Validate Input

Validate list of commands - Ensure all values in list exist as defined commands, if not CMDS is invalid and DecentApp.call returns -1.

## Process Commands

Creat recursive functions to process each command.

Each command must be assessed for validity to enforce business rules:

1. Commands that require a min length of results list must be validated
2. Coins balance will be validated to ensure cost is covered

[TODO: Extensibility ... cost and payments should be a part of cmd definition]
[TODO: Extensibility ... List min length should be a part of cmd definition]

    
