# changeValidatorComissionDrosera
Trap for Drosera triggered by validator fee change

# MockValidator

A contract that simulates a validator with the following parameters:

- commission — current commission.  
- minStake — minimum stake (not used here but returned).

Returns (commission, minStake) via getConfig().

---

# ValidatorAdapter

Purpose: allows interacting with a non-standard validator through a wrapper with a known interface.

- Stores the validator’s address. When deploying, you need to specify the validator’s address; in our example, this is MockValidator for flexibility, as the commission fetching function may vary.  
- Calls getConfig() and returns commission.  
- This is necessary because the ICommissionReader interface requires commission(), but the validator has no such method — only getConfig().

---

# ValidatorCommissionTrap (trap)

A contract that implements the ITrap interface. It works in two steps:

- collect():  
  - Drosera calls collect() on each operator node.  
  - The contract calls adapter.commission(), which calls getConfig() on the validator.  
  - Gets the commission value.  
  - Packs the result into the CollectOutput struct and returns it via abi.encode(...).

- shouldRespond(...):  
  - Drosera collects collect() results from different operators.  
  - All values are passed to shouldRespond(...) for analysis.  
  - The function compares all pairs of values.  
  - If at least two values differ — returns true and passes the new commission value.  
  - If all values are equal — returns false.

Note: the adapter address 0x-validator-adapter-contract-address is hardcoded here and should be obtained when deploying ValidatorAdapter. It can be parameterized if needed.

---

# Receiver (response_contract)

Used as the recipient of notifications from the trap: when the trap triggers, its function onCommissionChanged(uint256) is called.

Inside it, you can:  
- log an event (emit),  
- send data to an external system (for example, via an oracle or relay),  
- initiate actions (such as enabling protection, redistributing funds),  
- or connect it to an external backend which then sends notifications to Telegram, email, or other channels.

---

# drosera.toml

- response_contract — the address of the contract that the trap will call upon triggering (from Receiver.sol).
