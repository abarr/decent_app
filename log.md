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

 ## Update Balance

    Each CMD has a potential cost or payment
    Update CMD functions to apply both   

    Add in check to make sure that teh coin balance does not go below zero, if it does throw and error - return -1


## Extensibility

    Goal: add a new feature through confguration

    Definition of a Command:

    A command has a key that is valid
    It has an action: add, subtract, duplicate, multiply, delete and insert (Maybe add divide for future proofing)
    The action is always taken on the end of the results list i.e. addition is always the last 2 items, which are then replaced (However, this may change in the future??)
    It has a cost or a payment: it cost 'x' coins to run or its pays 'x' coins

    A command has validation rules:
    - minimum length for some actions i.e. addition: min len of result must be >= the number of items for the action
    - When command is an integer it must be between 0..9

    Potential command defnition:

    ```
    %{
        key: "DUP",
        action: :duplication,
        min_length: 1,
        # validation: %{range: 0..9},
        cost: 1,
        payment: 0
    }
    ```

    * I don't think it worth having configurable validation for range ... given the nature of the application I will leave it as a hard coded rule. 
    The number of items can be used as a min_length validation
 
    ** Min_length is the requirment and multiple actions should be represented in teh list of CMDS

    


