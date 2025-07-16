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
        for (uint256 i = 0; i < data.length; i++) {
            CollectOutput memory output = abi.decode(data[i], (CollectOutput));
            for (uint256 j = i + 1; j < data.length; j++) {
                CollectOutput memory other = abi.decode(data[j], (CollectOutput));
                if (output.commission != other.commission) {
                    return (true, abi.encode(output.commission));
                }
            }
        }
        return (false, bytes(""));
    }
}
