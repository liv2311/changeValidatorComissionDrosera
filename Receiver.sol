
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

contract Receiver {
    event CommissionChanged(uint256 newCommission);

    // This is the function that the trap calls when triggered.
    function onCommissionChanged(uint256 newCommission) external {
        emit CommissionChanged(newCommission);
    }
}
