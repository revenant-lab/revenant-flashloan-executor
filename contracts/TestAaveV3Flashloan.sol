// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Aave-compatible interfaces and ERC20
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPool} from "./interfaces/IPool.sol";
import {IPoolAddressesProvider} from "./interfaces/IPoolAddressesProvider.sol";
import {IFlashLoanSimpleReceiver} from "./interfaces/IFlashLoanSimpleReceiver.sol";

/// @title TestAaveV3Flashloan
/// @notice A simple Aave V3 flashloan test contract using IPool.flashLoanSimple
contract TestAaveV3Flashloan is IFlashLoanSimpleReceiver {
    IPoolAddressesProvider public immutable override ADDRESSES_PROVIDER;
    IPool public immutable override POOL;

    event ReceivedLoan(address asset, uint256 amount, uint256 premium, uint256 balance);

    /// @param provider The Aave PoolAddressesProvider address
    constructor(IPoolAddressesProvider provider) {
        ADDRESSES_PROVIDER = provider;
        POOL = IPool(provider.getPool());
    }

    /// @notice Initiates a flashloan from Aave V3
    /// @param asset The address of the token to borrow
    /// @param amount The amount to borrow
    function startFlashLoan(address asset, uint256 amount) external {
        POOL.flashLoanSimple(
            address(this), // receiver
            asset,
            amount,
            bytes(""),      // params (not used in this test)
            0               // referralCode
        );
    }

    /// @notice Aave calls this after lending the flashloan
    /// @dev You must return the borrowed amount + premium before function ends
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata /* params */
    ) external override returns (bool) {
        require(msg.sender == address(POOL), "Not pool");
        require(initiator == address(this), "Not self");

        uint256 balance = IERC20(asset).balanceOf(address(this));
        emit ReceivedLoan(asset, amount, premium, balance);

        require(balance >= amount, "Loan not received");

        // Approve Aave to pull the owed amount
        IERC20(asset).approve(address(POOL), amount + premium);
        return true;
    }
}

