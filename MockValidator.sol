// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

contract MockValidator {
    uint256 public commission;
    uint256 public minStake;

    constructor(uint256 _commission, uint256 _minStake) {
        commission = _commission;
        minStake = _minStake;
    }

    function setCommission(uint256 _new) external {
        commission = _new;
    }

    function getConfig() external view returns (uint256, uint256) {
        return (commission, minStake);
    }
}
