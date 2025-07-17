// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface ICommissionReader {
    function commission() external view returns (uint256);
}

struct CollectOutput {
    uint256 commission;
}

contract ValidatorCommissionTrap is ITrap {
    address public adapter = 0x-validator-adapter-contract-address;

    function collect() external view override returns (bytes memory) {
        uint256 commissionNow = ICommissionReader(adapter).commission();
        return abi.encode(CollectOutput({commission: commissionNow}));
    }

        function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, bytes("Insufficient samples"));

        // Compare all collect outputs
        CollectOutput memory base = abi.decode(data[0], (CollectOutput));

        for (uint256 i = 1; i < data.length; i++) {
            CollectOutput memory comparison = abi.decode(data[i], (CollectOutput));
            if (comparison.commission != base.commission) {
                return (true, abi.encode(base.commission));
            }
        }

        return (false, bytes(""));
    }
}
