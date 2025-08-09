// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IPool {
    function flashLoanSimple(
        address receiver,
        address asset,
        uint256 amount,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

