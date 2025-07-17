// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

/// @notice An adapter that extracts fees from a custom validator contract
contract ValidatorAdapter {
    address public validator;

    bytes4 constant GET_CONFIG_SIG = bytes4(keccak256("getConfig()"));

    constructor(address _validator) {
        validator = _validator;
    }

    /// @notice Return validator comission
    function commission() external view returns (uint256) {
        // Let's say the validator has a non-standard function:
        // function getConfig() external view returns (uint256 commission, uint256 minStake);
        (bool success, bytes memory result) = validator.staticcall(
            abi.encode(GET_CONFIG_SIG)
        );

        require(success, "call failed");

        (uint256 extractedCommission, ) = abi.decode(result, (uint256, uint256));
        return extractedCommission;
    }
}
