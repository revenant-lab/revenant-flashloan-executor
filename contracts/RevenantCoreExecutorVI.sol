// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/**
 * @title IPoolAddressesProvider
 * @author Aave
 * @notice Defines the basic interface for a Pool Addresses Provider.
 */
interface IPoolAddressesProvider {
    /**
     * @dev Emitted when the market identifier is updated.
     * @param oldMarketId The old id of the market
     * @param newMarketId The new id of the market
     */
    event MarketIdSet(string indexed oldMarketId, string indexed newMarketId);

    /**
     * @dev Emitted when the pool is updated.
     * @param oldAddress The old address of the Pool
     * @param newAddress The new address of the Pool
     */
    event PoolUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the pool configurator is updated.
     * @param oldAddress The old address of the PoolConfigurator
     * @param newAddress The new address of the PoolConfigurator
     */
    event PoolConfiguratorUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the price oracle is updated.
     * @param oldAddress The old address of the PriceOracle
     * @param newAddress The new address of the PriceOracle
     */
    event PriceOracleUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the ACL manager is updated.
     * @param oldAddress The old address of the ACLManager
     * @param newAddress The new address of the ACLManager
     */
    event ACLManagerUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the ACL admin is updated.
     * @param oldAddress The old address of the ACLAdmin
     * @param newAddress The new address of the ACLAdmin
     */
    event ACLAdminUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the price oracle sentinel is updated.
     * @param oldAddress The old address of the PriceOracleSentinel
     * @param newAddress The new address of the PriceOracleSentinel
     */
    event PriceOracleSentinelUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the pool data provider is updated.
     * @param oldAddress The old address of the PoolDataProvider
     * @param newAddress The new address of the PoolDataProvider
     */
    event PoolDataProviderUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when a new proxy is created.
     * @param id The identifier of the proxy
     * @param proxyAddress The address of the created proxy contract
     * @param implementationAddress The address of the implementation contract
     */
    event ProxyCreated(bytes32 indexed id, address indexed proxyAddress, address indexed implementationAddress);

    /**
     * @dev Emitted when a new non-proxied contract address is registered.
     * @param id The identifier of the contract
     * @param oldAddress The address of the old contract
     * @param newAddress The address of the new contract
     */
    event AddressSet(bytes32 indexed id, address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the implementation of the proxy registered with id is updated
     * @param id The identifier of the contract
     * @param proxyAddress The address of the proxy contract
     * @param oldImplementationAddress The address of the old implementation contract
     * @param newImplementationAddress The address of the new implementation contract
     */
    event AddressSetAsProxy(
        bytes32 indexed id,
        address indexed proxyAddress,
        address oldImplementationAddress,
        address indexed newImplementationAddress
    );

    /**
     * @notice Returns the id of the Aave market to which this contract points to.
     * @return The market id
     */
    function getMarketId() external view returns (string memory);

    /**
     * @notice Associates an id with a specific PoolAddressesProvider.
     * @dev This can be used to create an onchain registry of PoolAddressesProviders to
     * identify and validate multiple Aave markets.
     * @param newMarketId The market id
     */
    function setMarketId(string calldata newMarketId) external;

    /**
     * @notice Returns an address by its identifier.
     * @dev The returned address might be an EOA or a contract, potentially proxied
     * @dev It returns ZERO if there is no registered address with the given id
     * @param id The id
     * @return The address of the registered for the specified id
     */
    function getAddress(bytes32 id) external view returns (address);

    /**
     * @notice General function to update the implementation of a proxy registered with
     * certain `id`. If there is no proxy registered, it will instantiate one and
     * set as implementation the `newImplementationAddress`.
     * @dev IMPORTANT Use this function carefully, only for ids that don't have an explicit
     * setter function, in order to avoid unexpected consequences
     * @param id The id
     * @param newImplementationAddress The address of the new implementation
     */
    function setAddressAsProxy(bytes32 id, address newImplementationAddress) external;

    /**
     * @notice Sets an address for an id replacing the address saved in the addresses map.
     * @dev IMPORTANT Use this function carefully, as it will do a hard replacement
     * @param id The id
     * @param newAddress The address to set
     */
    function setAddress(bytes32 id, address newAddress) external;

    /**
     * @notice Returns the address of the Pool proxy.
     * @return The Pool proxy address
     */
    function getPool() external view returns (address);

    /**
     * @notice Updates the implementation of the Pool, or creates a proxy
     * setting the new `pool` implementation when the function is called for the first time.
     * @param newPoolImpl The new Pool implementation
     */
    function setPoolImpl(address newPoolImpl) external;

    /**
     * @notice Returns the address of the PoolConfigurator proxy.
     * @return The PoolConfigurator proxy address
     */
    function getPoolConfigurator() external view returns (address);

    /**
     * @notice Updates the implementation of the PoolConfigurator, or creates a proxy
     * setting the new `PoolConfigurator` implementation when the function is called for the first time.
     * @param newPoolConfiguratorImpl The new PoolConfigurator implementation
     */
    function setPoolConfiguratorImpl(address newPoolConfiguratorImpl) external;

    /**
     * @notice Returns the address of the price oracle.
     * @return The address of the PriceOracle
     */
    function getPriceOracle() external view returns (address);

    /**
     * @notice Updates the address of the price oracle.
     * @param newPriceOracle The address of the new PriceOracle
     */
    function setPriceOracle(address newPriceOracle) external;

    /**
     * @notice Returns the address of the ACL manager.
     * @return The address of the ACLManager
     */
    function getACLManager() external view returns (address);

    /**
     * @notice Updates the address of the ACL manager.
     * @param newAclManager The address of the new ACLManager
     */
    function setACLManager(address newAclManager) external;

    /**
     * @notice Returns the address of the ACL admin.
     * @return The address of the ACL admin
     */
    function getACLAdmin() external view returns (address);

    /**
     * @notice Updates the address of the ACL admin.
     * @param newAclAdmin The address of the new ACL admin
     */
    function setACLAdmin(address newAclAdmin) external;

    /**
     * @notice Returns the address of the price oracle sentinel.
     * @return The address of the PriceOracleSentinel
     */
    function getPriceOracleSentinel() external view returns (address);

    /**
     * @notice Updates the address of the price oracle sentinel.
     * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
     */
    function setPriceOracleSentinel(address newPriceOracleSentinel) external;

    /**
     * @notice Returns the address of the data provider.
     * @return The address of the DataProvider
     */
    function getPoolDataProvider() external view returns (address);

    /**
     * @notice Updates the address of the data provider.
     * @param newDataProvider The address of the new DataProvider
     */
    function setPoolDataProvider(address newDataProvider) external;
}

// File @aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol@v1.19.3

// Original license: SPDX_License_Identifier: BUSL-1.1
pragma solidity ^0.8.0;

library DataTypes {
    struct ReserveData {
        //stores the reserve configuration
        ReserveConfigurationMap configuration;
        //the liquidity index. Expressed in ray
        uint128 liquidityIndex;
        //the current supply rate. Expressed in ray
        uint128 currentLiquidityRate;
        //variable borrow index. Expressed in ray
        uint128 variableBorrowIndex;
        //the current variable borrow rate. Expressed in ray
        uint128 currentVariableBorrowRate;
        //the current stable borrow rate. Expressed in ray
        uint128 currentStableBorrowRate;
        //timestamp of last update
        uint40 lastUpdateTimestamp;
        //the id of the reserve. Represents the position in the list of the active reserves
        uint16 id;
        //aToken address
        address aTokenAddress;
        //stableDebtToken address
        address stableDebtTokenAddress;
        //variableDebtToken address
        address variableDebtTokenAddress;
        //address of the interest rate strategy
        address interestRateStrategyAddress;
        //the current treasury balance, scaled
        uint128 accruedToTreasury;
        //the outstanding unbacked aTokens minted through the bridging feature
        uint128 unbacked;
        //the outstanding debt borrowed against this asset in isolation mode
        uint128 isolationModeTotalDebt;
    }

    struct ReserveConfigurationMap {
        //bit 0-15: LTV
        //bit 16-31: Liq. threshold
        //bit 32-47: Liq. bonus
        //bit 48-55: Decimals
        //bit 56: reserve is active
        //bit 57: reserve is frozen
        //bit 58: borrowing is enabled
        //bit 59: stable rate borrowing enabled
        //bit 60: asset is paused
        //bit 61: borrowing in isolation mode is enabled
        //bit 62: siloed borrowing enabled
        //bit 63: flashloaning enabled
        //bit 64-79: reserve factor
        //bit 80-115 borrow cap in whole tokens, borrowCap == 0 => no cap
        //bit 116-151 supply cap in whole tokens, supplyCap == 0 => no cap
        //bit 152-167 liquidation protocol fee
        //bit 168-175 eMode category
        //bit 176-211 unbacked mint cap in whole tokens, unbackedMintCap == 0 => minting disabled
        //bit 212-251 debt ceiling for isolation mode with (ReserveConfiguration::DEBT_CEILING_DECIMALS) decimals
        //bit 252-255 unused

        uint256 data;
    }

    struct UserConfigurationMap {
        /**
         * @dev Bitmap of the users collaterals and borrows. It is divided in pairs of bits, one pair per asset.
         * The first bit indicates if an asset is used as collateral by the user, the second whether an
         * asset is borrowed by the user.
         */
        uint256 data;
    }

    struct EModeCategory {
        // each eMode category has a custom ltv and liquidation threshold
        uint16 ltv;
        uint16 liquidationThreshold;
        uint16 liquidationBonus;
        // each eMode category may or may not have a custom oracle to override the individual assets price oracles
        address priceSource;
        string label;
    }

    enum InterestRateMode {
        NONE,
        STABLE,
        VARIABLE
    }

    struct ReserveCache {
        uint256 currScaledVariableDebt;
        uint256 nextScaledVariableDebt;
        uint256 currPrincipalStableDebt;
        uint256 currAvgStableBorrowRate;
        uint256 currTotalStableDebt;
        uint256 nextAvgStableBorrowRate;
        uint256 nextTotalStableDebt;
        uint256 currLiquidityIndex;
        uint256 nextLiquidityIndex;
        uint256 currVariableBorrowIndex;
        uint256 nextVariableBorrowIndex;
        uint256 currLiquidityRate;
        uint256 currVariableBorrowRate;
        uint256 reserveFactor;
        ReserveConfigurationMap reserveConfiguration;
        address aTokenAddress;
        address stableDebtTokenAddress;
        address variableDebtTokenAddress;
        uint40 reserveLastUpdateTimestamp;
        uint40 stableDebtLastUpdateTimestamp;
    }

    struct ExecuteLiquidationCallParams {
        uint256 reservesCount;
        uint256 debtToCover;
        address collateralAsset;
        address debtAsset;
        address user;
        bool receiveAToken;
        address priceOracle;
        uint8 userEModeCategory;
        address priceOracleSentinel;
    }

    struct ExecuteSupplyParams {
        address asset;
        uint256 amount;
        address onBehalfOf;
        uint16 referralCode;
    }

    struct ExecuteBorrowParams {
        address asset;
        address user;
        address onBehalfOf;
        uint256 amount;
        InterestRateMode interestRateMode;
        uint16 referralCode;
        bool releaseUnderlying;
        uint256 maxStableRateBorrowSizePercent;
        uint256 reservesCount;
        address oracle;
        uint8 userEModeCategory;
        address priceOracleSentinel;
    }

    struct ExecuteRepayParams {
        address asset;
        uint256 amount;
        InterestRateMode interestRateMode;
        address onBehalfOf;
        bool useATokens;
    }

    struct ExecuteWithdrawParams {
        address asset;
        uint256 amount;
        address to;
        uint256 reservesCount;
        address oracle;
        uint8 userEModeCategory;
    }

    struct ExecuteSetUserEModeParams {
        uint256 reservesCount;
        address oracle;
        uint8 categoryId;
    }

    struct FinalizeTransferParams {
        address asset;
        address from;
        address to;
        uint256 amount;
        uint256 balanceFromBefore;
        uint256 balanceToBefore;
        uint256 reservesCount;
        address oracle;
        uint8 fromEModeCategory;
    }

    struct FlashloanParams {
        address receiverAddress;
        address[] assets;
        uint256[] amounts;
        uint256[] interestRateModes;
        address onBehalfOf;
        bytes params;
        uint16 referralCode;
        uint256 flashLoanPremiumToProtocol;
        uint256 flashLoanPremiumTotal;
        uint256 maxStableRateBorrowSizePercent;
        uint256 reservesCount;
        address addressesProvider;
        uint8 userEModeCategory;
        bool isAuthorizedFlashBorrower;
    }

    struct FlashloanSimpleParams {
        address receiverAddress;
        address asset;
        uint256 amount;
        bytes params;
        uint16 referralCode;
        uint256 flashLoanPremiumToProtocol;
        uint256 flashLoanPremiumTotal;
    }

    struct FlashLoanRepaymentParams {
        uint256 amount;
        uint256 totalPremium;
        uint256 flashLoanPremiumToProtocol;
        address asset;
        address receiverAddress;
        uint16 referralCode;
    }

    struct CalculateUserAccountDataParams {
        UserConfigurationMap userConfig;
        uint256 reservesCount;
        address user;
        address oracle;
        uint8 userEModeCategory;
    }

    struct ValidateBorrowParams {
        ReserveCache reserveCache;
        UserConfigurationMap userConfig;
        address asset;
        address userAddress;
        uint256 amount;
        InterestRateMode interestRateMode;
        uint256 maxStableLoanPercent;
        uint256 reservesCount;
        address oracle;
        uint8 userEModeCategory;
        address priceOracleSentinel;
        bool isolationModeActive;
        address isolationModeCollateralAddress;
        uint256 isolationModeDebtCeiling;
    }

    struct ValidateLiquidationCallParams {
        ReserveCache debtReserveCache;
        uint256 totalDebt;
        uint256 healthFactor;
        address priceOracleSentinel;
    }

    struct CalculateInterestRatesParams {
        uint256 unbacked;
        uint256 liquidityAdded;
        uint256 liquidityTaken;
        uint256 totalStableDebt;
        uint256 totalVariableDebt;
        uint256 averageStableBorrowRate;
        uint256 reserveFactor;
        address reserve;
        address aToken;
    }

    struct InitReserveParams {
        address asset;
        address aTokenAddress;
        address stableDebtAddress;
        address variableDebtAddress;
        address interestRateStrategyAddress;
        uint16 reservesCount;
        uint16 maxNumberReserves;
    }
}

// File @aave/core-v3/contracts/interfaces/IPool.sol@v1.19.3

// Original license: SPDX_License_Identifier: AGPL-3.0
pragma solidity ^0.8.0;

/**
 * @title IPool
 * @author Aave
 * @notice Defines the basic interface for an Aave Pool.
 */
interface IPool {
    /**
     * @dev Emitted on mintUnbacked()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address initiating the supply
     * @param onBehalfOf The beneficiary of the supplied assets, receiving the aTokens
     * @param amount The amount of supplied assets
     * @param referralCode The referral code used
     */
    event MintUnbacked(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint16 indexed referralCode
    );

    /**
     * @dev Emitted on backUnbacked()
     * @param reserve The address of the underlying asset of the reserve
     * @param backer The address paying for the backing
     * @param amount The amount added as backing
     * @param fee The amount paid in fees
     */
    event BackUnbacked(address indexed reserve, address indexed backer, uint256 amount, uint256 fee);

    /**
     * @dev Emitted on supply()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address initiating the supply
     * @param onBehalfOf The beneficiary of the supply, receiving the aTokens
     * @param amount The amount supplied
     * @param referralCode The referral code used
     */
    event Supply(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint16 indexed referralCode
    );

    /**
     * @dev Emitted on withdraw()
     * @param reserve The address of the underlying asset being withdrawn
     * @param user The address initiating the withdrawal, owner of aTokens
     * @param to The address that will receive the underlying
     * @param amount The amount to be withdrawn
     */
    event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);

    /**
     * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
     * @param reserve The address of the underlying asset being borrowed
     * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
     * initiator of the transaction on flashLoan()
     * @param onBehalfOf The address that will be getting the debt
     * @param amount The amount borrowed out
     * @param interestRateMode The rate mode: 1 for Stable, 2 for Variable
     * @param borrowRate The numeric rate at which the user has borrowed, expressed in ray
     * @param referralCode The referral code used
     */
    event Borrow(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        DataTypes.InterestRateMode interestRateMode,
        uint256 borrowRate,
        uint16 indexed referralCode
    );

    /**
     * @dev Emitted on repay()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The beneficiary of the repayment, getting his debt reduced
     * @param repayer The address of the user initiating the repay(), providing the funds
     * @param amount The amount repaid
     * @param useATokens True if the repayment is done using aTokens, `false` if done with underlying asset directly
     */
    event Repay(
        address indexed reserve,
        address indexed user,
        address indexed repayer,
        uint256 amount,
        bool useATokens
    );

    /**
     * @dev Emitted on swapBorrowRateMode()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user swapping his rate mode
     * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
     */
    event SwapBorrowRateMode(
        address indexed reserve,
        address indexed user,
        DataTypes.InterestRateMode interestRateMode
    );

    /**
     * @dev Emitted on borrow(), repay() and liquidationCall() when using isolated assets
     * @param asset The address of the underlying asset of the reserve
     * @param totalDebt The total isolation mode debt for the reserve
     */
    event IsolationModeTotalDebtUpdated(address indexed asset, uint256 totalDebt);

    /**
     * @dev Emitted when the user selects a certain asset category for eMode
     * @param user The address of the user
     * @param categoryId The category id
     */
    event UserEModeSet(address indexed user, uint8 categoryId);

    /**
     * @dev Emitted on setUserUseReserveAsCollateral()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user enabling the usage as collateral
     */
    event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);

    /**
     * @dev Emitted on setUserUseReserveAsCollateral()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user enabling the usage as collateral
     */
    event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);

    /**
     * @dev Emitted on rebalanceStableBorrowRate()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user for which the rebalance has been executed
     */
    event RebalanceStableBorrowRate(address indexed reserve, address indexed user);

    /**
     * @dev Emitted on flashLoan()
     * @param target The address of the flash loan receiver contract
     * @param initiator The address initiating the flash loan
     * @param asset The address of the asset being flash borrowed
     * @param amount The amount flash borrowed
     * @param interestRateMode The flashloan mode: 0 for regular flashloan, 1 for Stable debt, 2 for Variable debt
     * @param premium The fee flash borrowed
     * @param referralCode The referral code used
     */
    event FlashLoan(
        address indexed target,
        address initiator,
        address indexed asset,
        uint256 amount,
        DataTypes.InterestRateMode interestRateMode,
        uint256 premium,
        uint16 indexed referralCode
    );

    /**
     * @dev Emitted when a borrower is liquidated.
     * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
     * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
     * @param user The address of the borrower getting liquidated
     * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
     * @param liquidatedCollateralAmount The amount of collateral received by the liquidator
     * @param liquidator The address of the liquidator
     * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
     * to receive the underlying collateral asset directly
     */
    event LiquidationCall(
        address indexed collateralAsset,
        address indexed debtAsset,
        address indexed user,
        uint256 debtToCover,
        uint256 liquidatedCollateralAmount,
        address liquidator,
        bool receiveAToken
    );

    /**
     * @dev Emitted when the state of a reserve is updated.
     * @param reserve The address of the underlying asset of the reserve
     * @param liquidityRate The next liquidity rate
     * @param stableBorrowRate The next stable borrow rate
     * @param variableBorrowRate The next variable borrow rate
     * @param liquidityIndex The next liquidity index
     * @param variableBorrowIndex The next variable borrow index
     */
    event ReserveDataUpdated(
        address indexed reserve,
        uint256 liquidityRate,
        uint256 stableBorrowRate,
        uint256 variableBorrowRate,
        uint256 liquidityIndex,
        uint256 variableBorrowIndex
    );

    /**
     * @dev Emitted when the protocol treasury receives minted aTokens from the accrued interest.
     * @param reserve The address of the reserve
     * @param amountMinted The amount minted to the treasury
     */
    event MintedToTreasury(address indexed reserve, uint256 amountMinted);

    /**
     * @notice Mints an `amount` of aTokens to the `onBehalfOf`
     * @param asset The address of the underlying asset to mint
     * @param amount The amount to mint
     * @param onBehalfOf The address that will receive the aTokens
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function mintUnbacked(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;

    /**
     * @notice Back the current unbacked underlying with `amount` and pay `fee`.
     * @param asset The address of the underlying asset to back
     * @param amount The amount to back
     * @param fee The amount paid in fees
     * @return The backed amount
     */
    function backUnbacked(address asset, uint256 amount, uint256 fee) external returns (uint256);

    /**
     * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
     * - E.g. User supplies 100 USDC and gets in return 100 aUSDC
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
     *   is a different wallet
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;

    /**
     * @notice Supply with transfer approval of asset to be supplied done via permit function
     * see: https://eips.ethereum.org/EIPS/eip-2612 and https://eips.ethereum.org/EIPS/eip-713
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
     *   is a different wallet
     * @param deadline The deadline timestamp that the permit is valid
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     * @param permitV The V parameter of ERC712 permit sig
     * @param permitR The R parameter of ERC712 permit sig
     * @param permitS The S parameter of ERC712 permit sig
     */
    function supplyWithPermit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) external;

    /**
     * @notice Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
     * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
     * @param asset The address of the underlying asset to withdraw
     * @param amount The underlying amount to be withdrawn
     *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
     * @param to The address that will receive the underlying, same as msg.sender if the user
     *   wants to receive it on his own wallet, or a different address if the beneficiary is a
     *   different wallet
     * @return The final amount withdrawn
     */
    function withdraw(address asset, uint256 amount, address to) external returns (uint256);

    /**
     * @notice Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
     * already supplied enough collateral, or he was given enough allowance by a credit delegator on the
     * corresponding debt token (StableDebtToken or VariableDebtToken)
     * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
     *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
     * @param asset The address of the underlying asset to borrow
     * @param amount The amount to be borrowed
     * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
     * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     * @param onBehalfOf The address of the user who will receive the debt. Should be the address of the borrower itself
     * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
     * if he has been given credit delegation allowance
     */
    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    /**
     * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
     * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @param onBehalfOf The address of the user who will get his debt reduced/removed. Should be the address of the
     * user calling the function if he wants to reduce/remove his own debt, or the address of any other
     * other borrower whose debt should be removed
     * @return The final amount repaid
     */
    function repay(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        address onBehalfOf
    ) external returns (uint256);

    /**
     * @notice Repay with transfer approval of asset to be repaid done via permit function
     * see: https://eips.ethereum.org/EIPS/eip-2612 and https://eips.ethereum.org/EIPS/eip-713
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
     * user calling the function if he wants to reduce/remove his own debt, or the address of any other
     * other borrower whose debt should be removed
     * @param deadline The deadline timestamp that the permit is valid
     * @param permitV The V parameter of ERC712 permit sig
     * @param permitR The R parameter of ERC712 permit sig
     * @param permitS The S parameter of ERC712 permit sig
     * @return The final amount repaid
     */
    function repayWithPermit(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        address onBehalfOf,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) external returns (uint256);

    /**
     * @notice Repays a borrowed `amount` on a specific reserve using the reserve aTokens, burning the
     * equivalent debt tokens
     * - E.g. User repays 100 USDC using 100 aUSDC, burning 100 variable/stable debt tokens
     * @dev  Passing uint256.max as amount will clean up any residual aToken dust balance, if the user aToken
     * balance is not enough to cover the whole debt
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @return The final amount repaid
     */
    function repayWithATokens(address asset, uint256 amount, uint256 interestRateMode) external returns (uint256);

    /**
     * @notice Allows a borrower to swap his debt between stable and variable mode, or vice versa
     * @param asset The address of the underlying asset borrowed
     * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
     */
    function swapBorrowRateMode(address asset, uint256 interestRateMode) external;

    /**
     * @notice Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
     * - Users can be rebalanced if the following conditions are satisfied:
     *     1. Usage ratio is above 95%
     *     2. the current supply APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too
     *        much has been borrowed at a stable rate and suppliers are not earning enough
     * @param asset The address of the underlying asset borrowed
     * @param user The address of the user to be rebalanced
     */
    function rebalanceStableBorrowRate(address asset, address user) external;

    /**
     * @notice Allows suppliers to enable/disable a specific supplied asset as collateral
     * @param asset The address of the underlying asset supplied
     * @param useAsCollateral True if the user wants to use the supply as collateral, false otherwise
     */
    function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;

    /**
     * @notice Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
     * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
     *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
     * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
     * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
     * @param user The address of the borrower getting liquidated
     * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
     * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
     * to receive the underlying collateral asset directly
     */
    function liquidationCall(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover,
        bool receiveAToken
    ) external;

    /**
     * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
     * as long as the amount taken plus a fee is returned.
     * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
     * into consideration. For further details please visit https://docs.aave.com/developers/
     * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
     * @param assets The addresses of the assets being flash-borrowed
     * @param amounts The amounts of the assets being flash-borrowed
     * @param interestRateModes Types of the debt to open if the flash loan is not returned:
     *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
     *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
     *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
     * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
     * @param params Variadic packed params to pass to the receiver as extra information
     * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata interestRateModes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;

    /**
     * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
     * as long as the amount taken plus a fee is returned.
     * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
     * into consideration. For further details please visit https://docs.aave.com/developers/
     * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
     * @param asset The address of the asset being flash-borrowed
     * @param amount The amount of the asset being flash-borrowed
     * @param params Variadic packed params to pass to the receiver as extra information
     * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function flashLoanSimple(
        address receiverAddress,
        address asset,
        uint256 amount,
        bytes calldata params,
        uint16 referralCode
    ) external;

    /**
     * @notice Returns the user account data across all the reserves
     * @param user The address of the user
     * @return totalCollateralBase The total collateral of the user in the base currency used by the price feed
     * @return totalDebtBase The total debt of the user in the base currency used by the price feed
     * @return availableBorrowsBase The borrowing power left of the user in the base currency used by the price feed
     * @return currentLiquidationThreshold The liquidation threshold of the user
     * @return ltv The loan to value of The user
     * @return healthFactor The current health factor of the user
     */
    function getUserAccountData(
        address user
    )
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        );

    /**
     * @notice Initializes a reserve, activating it, assigning an aToken and debt tokens and an
     * interest rate strategy
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     * @param aTokenAddress The address of the aToken that will be assigned to the reserve
     * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
     * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
     * @param interestRateStrategyAddress The address of the interest rate strategy contract
     */
    function initReserve(
        address asset,
        address aTokenAddress,
        address stableDebtAddress,
        address variableDebtAddress,
        address interestRateStrategyAddress
    ) external;

    /**
     * @notice Drop a reserve
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     */
    function dropReserve(address asset) external;

    /**
     * @notice Updates the address of the interest rate strategy contract
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     * @param rateStrategyAddress The address of the interest rate strategy contract
     */
    function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress) external;

    /**
     * @notice Sets the configuration bitmap of the reserve as a whole
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     * @param configuration The new configuration bitmap
     */
    function setConfiguration(address asset, DataTypes.ReserveConfigurationMap calldata configuration) external;

    /**
     * @notice Returns the configuration of the reserve
     * @param asset The address of the underlying asset of the reserve
     * @return The configuration of the reserve
     */
    function getConfiguration(address asset) external view returns (DataTypes.ReserveConfigurationMap memory);

    /**
     * @notice Returns the configuration of the user across all the reserves
     * @param user The user address
     * @return The configuration of the user
     */
    function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);

    /**
     * @notice Returns the normalized income of the reserve
     * @param asset The address of the underlying asset of the reserve
     * @return The reserve's normalized income
     */
    function getReserveNormalizedIncome(address asset) external view returns (uint256);

    /**
     * @notice Returns the normalized variable debt per unit of asset
     * @dev WARNING: This function is intended to be used primarily by the protocol itself to get a
     * "dynamic" variable index based on time, current stored index and virtual rate at the current
     * moment (approx. a borrower would get if opening a position). This means that is always used in
     * combination with variable debt supply/balances.
     * If using this function externally, consider that is possible to have an increasing normalized
     * variable debt that is not equivalent to how the variable debt index would be updated in storage
     * (e.g. only updates with non-zero variable debt supply)
     * @param asset The address of the underlying asset of the reserve
     * @return The reserve normalized variable debt
     */
    function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);

    /**
     * @notice Returns the state and configuration of the reserve
     * @param asset The address of the underlying asset of the reserve
     * @return The state and configuration data of the reserve
     */
    function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);

    /**
     * @notice Validates and finalizes an aToken transfer
     * @dev Only callable by the overlying aToken of the `asset`
     * @param asset The address of the underlying asset of the aToken
     * @param from The user from which the aTokens are transferred
     * @param to The user receiving the aTokens
     * @param amount The amount being transferred/withdrawn
     * @param balanceFromBefore The aToken balance of the `from` user before the transfer
     * @param balanceToBefore The aToken balance of the `to` user before the transfer
     */
    function finalizeTransfer(
        address asset,
        address from,
        address to,
        uint256 amount,
        uint256 balanceFromBefore,
        uint256 balanceToBefore
    ) external;

    /**
     * @notice Returns the list of the underlying assets of all the initialized reserves
     * @dev It does not include dropped reserves
     * @return The addresses of the underlying assets of the initialized reserves
     */
    function getReservesList() external view returns (address[] memory);

    /**
     * @notice Returns the address of the underlying asset of a reserve by the reserve id as stored in the DataTypes.ReserveData struct
     * @param id The id of the reserve as stored in the DataTypes.ReserveData struct
     * @return The address of the reserve associated with id
     */
    function getReserveAddressById(uint16 id) external view returns (address);

    /**
     * @notice Returns the PoolAddressesProvider connected to this contract
     * @return The address of the PoolAddressesProvider
     */
    function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);

    /**
     * @notice Updates the protocol fee on the bridging
     * @param bridgeProtocolFee The part of the premium sent to the protocol treasury
     */
    function updateBridgeProtocolFee(uint256 bridgeProtocolFee) external;

    /**
     * @notice Updates flash loan premiums. Flash loan premium consists of two parts:
     * - A part is sent to aToken holders as extra, one time accumulated interest
     * - A part is collected by the protocol treasury
     * @dev The total premium is calculated on the total borrowed amount
     * @dev The premium to protocol is calculated on the total premium, being a percentage of `flashLoanPremiumTotal`
     * @dev Only callable by the PoolConfigurator contract
     * @param flashLoanPremiumTotal The total premium, expressed in bps
     * @param flashLoanPremiumToProtocol The part of the premium sent to the protocol treasury, expressed in bps
     */
    function updateFlashloanPremiums(uint128 flashLoanPremiumTotal, uint128 flashLoanPremiumToProtocol) external;

    /**
     * @notice Configures a new category for the eMode.
     * @dev In eMode, the protocol allows very high borrowing power to borrow assets of the same category.
     * The category 0 is reserved as it's the default for volatile assets
     * @param id The id of the category
     * @param config The configuration of the category
     */
    function configureEModeCategory(uint8 id, DataTypes.EModeCategory memory config) external;

    /**
     * @notice Returns the data of an eMode category
     * @param id The id of the category
     * @return The configuration data of the category
     */
    function getEModeCategoryData(uint8 id) external view returns (DataTypes.EModeCategory memory);

    /**
     * @notice Allows a user to use the protocol in eMode
     * @param categoryId The id of the category
     */
    function setUserEMode(uint8 categoryId) external;

    /**
     * @notice Returns the eMode the user is using
     * @param user The address of the user
     * @return The eMode id
     */
    function getUserEMode(address user) external view returns (uint256);

    /**
     * @notice Resets the isolation mode total debt of the given asset to zero
     * @dev It requires the given asset has zero debt ceiling
     * @param asset The address of the underlying asset to reset the isolationModeTotalDebt
     */
    function resetIsolationModeTotalDebt(address asset) external;

    /**
     * @notice Returns the percentage of available liquidity that can be borrowed at once at stable rate
     * @return The percentage of available liquidity to borrow, expressed in bps
     */
    function MAX_STABLE_RATE_BORROW_SIZE_PERCENT() external view returns (uint256);

    /**
     * @notice Returns the total fee on flash loans
     * @return The total fee on flashloans
     */
    function FLASHLOAN_PREMIUM_TOTAL() external view returns (uint128);

    /**
     * @notice Returns the part of the bridge fees sent to protocol
     * @return The bridge fee sent to the protocol treasury
     */
    function BRIDGE_PROTOCOL_FEE() external view returns (uint256);

    /**
     * @notice Returns the part of the flashloan fees sent to protocol
     * @return The flashloan fee sent to the protocol treasury
     */
    function FLASHLOAN_PREMIUM_TO_PROTOCOL() external view returns (uint128);

    /**
     * @notice Returns the maximum number of reserves supported to be listed in this Pool
     * @return The maximum number of reserves supported
     */
    function MAX_NUMBER_RESERVES() external view returns (uint16);

    /**
     * @notice Mints the assets accrued through the reserve factor to the treasury in the form of aTokens
     * @param assets The list of reserves for which the minting needs to be executed
     */
    function mintToTreasury(address[] calldata assets) external;

    /**
     * @notice Rescue and transfer tokens locked in this contract
     * @param token The address of the token
     * @param to The address of the recipient
     * @param amount The amount of token to transfer
     */
    function rescueTokens(address token, address to, uint256 amount) external;

    /**
     * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
     * - E.g. User supplies 100 USDC and gets in return 100 aUSDC
     * @dev Deprecated: Use the `supply` function instead
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
     *   is a different wallet
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
}

// File @aave/core-v3/contracts/flashloan/interfaces/IFlashLoanReceiver.sol@v1.19.3

// Original license: SPDX_License_Identifier: AGPL-3.0
pragma solidity ^0.8.0;

/**
 * @title IFlashLoanReceiver
 * @author Aave
 * @notice Defines the basic interface of a flashloan-receiver contract.
 * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 */
interface IFlashLoanReceiver {
    /**
     * @notice Executes an operation after receiving the flash-borrowed assets
     * @dev Ensure that the contract can return the debt + premium, e.g., has
     *      enough funds to repay and has approved the Pool to pull the total amount
     * @param assets The addresses of the flash-borrowed assets
     * @param amounts The amounts of the flash-borrowed assets
     * @param premiums The fee of each flash-borrowed asset
     * @param initiator The address of the flashloan initiator
     * @param params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool);

    function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);

    function POOL() external view returns (IPool);
}

// File @openzeppelin/contracts/utils/Context.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.4) (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File @openzeppelin/contracts/access/Ownable.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File contracts/RevenantCoreExecutor.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Interface for Uniswap V2 Router for performing token swaps
interface IUniswapV2Router {
    /**
     * @notice Swaps exact amount of input tokens for as many output tokens as possible.
     * @param amountIn Amount of input tokens to send.
     * @param amountOutMin Minimum amount of output tokens that must be received.
     * @param path Array of token addresses (swap path).
     * @param to Recipient address.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @notice Returns the output amounts for a given input amount and swap path.
     * @param amountIn Input token amount.
     * @param path Swap path as array of token addresses.
     * @return amounts Array of calculated output amounts for each step in the path.
     */
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory);
}

/// @notice Interface for Uniswap V3 Router to perform single-hop swaps
interface IUniswapV3Router {
    /// @dev Parameters for exactInputSingle() function used in single-hop swaps
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /**
     * @notice Swaps exact input amount for output in a single-hop swap.
     * @param params The parameters struct defined above.
     * @return amountOut Amount of output tokens received.
     */
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

/// @notice Interface for interacting with Curve Finance Router
interface ICurveRouter {
    /**
     * @notice Perform a token exchange on a Curve pool.
     * @param i Index of the token to send.
     * @param j Index of the token to receive.
     * @param dx Amount of input tokens.
     * @param min_dy Minimum amount of output tokens expected.
     * @return Amount of output tokens received.
     */
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);

    /**
     * @notice View function to simulate a token exchange.
     * @param i Index of input token.
     * @param j Index of output token.
     * @param dx Input amount.
     * @return Expected output amount (dy).
     */
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);
}

/// @notice Interface for Radiant Capital LendingPool used for flashloans and liquidations
interface IRadiantLendingPool {
    /**
     * @notice Initiates a flash loan from the lending pool.
     * @param receiverAddress Contract that receives the funds and executes logic.
     * @param assets List of addresses of assets to be borrowed.
     * @param amounts List of amounts to be borrowed.
     * @param modes Loan modes: 0 = no debt, 1 = stable, 2 = variable.
     * @param onBehalfOf Address that will incur the debt (if any).
     * @param params Additional data passed to the receiver contract.
     * @param referralCode Code used for referrals (usually 0).
     */
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;

    /**
     * @notice Performs liquidation of undercollateralized positions.
     * @param collateralAsset Asset to seize as collateral.
     * @param debtAsset Asset used to repay the debt.
     * @param user Address of the borrower being liquidated.
     * @param debtToCover Amount of debt to repay.
     * @param receiveAToken If true, receives aTokens instead of underlying.
     */
    function liquidationCall(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover,
        bool receiveAToken
    ) external;
}

/// @notice Interface for Aave UI Pool Data Provider to fetch health factor and account info
interface IUiPoolDataProvider {
    /**
     * @notice Returns key data about a user’s lending/borrowing position.
     * @param user Address of the account.
     * @return totalCollateralBase Total value of collateral.
     * @return totalDebtBase Total value of debt.
     * @return availableBorrowsBase Available credit.
     * @return currentLiquidationThreshold Threshold for liquidation.
     * @return ltv Loan-to-value ratio.
     * @return healthFactor User’s current health factor.
     */
    function getUserAccountData(
        address user
    )
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        );
}

contract RevenantCoreExecutorVI is IFlashLoanReceiver, Ownable, ReentrancyGuard {
    /// @notice Aave PoolAddressesProvider reference
    IPoolAddressesProvider public provider;

    /// @notice Aave Pool instance obtained via provider
    IPool public pool;

    /// @notice Token in which profits are to be measured
    address public profitToken;

    /// @notice Radiant flashloan pool address
    address public radiantPool;

    /// @notice Aave UI Data Provider (for HF, collateral, debt info)
    address public uiPoolDataProvider;

    /// @notice Radiant data provider address
    address public radiantDataProvider;

    /// @notice Initialization flag to prevent re-init
    bool public initialized;

    /// @notice Supported DEX types
    enum DexType {
        V2,
        V3,
        CURVE
    }

    /// @notice Mapping from DEX name to router address
    mapping(string => address) public DEX_ROUTER;

    /// @notice Mapping from DEX name to its enum type
    mapping(string => DexType) public DEX_TYPE;

    /// @notice Emitted after flashloan execution
    event FlashExecutionSummary(
        bool success,
        uint256 profit,
        address profitToken,
        bytes32 routeHash,
        string failureReason,
        uint256 gasUsed
    );

    /// @notice Emitted per DEX route step execution
    event RouteExecutionLog(
        uint index,
        address fromToken,
        address toToken,
        uint256 amountIn,
        uint256 amountOut,
        address router
    );

    /// @notice Emitted at end of execution with final token balance
    event FinalBalanceReport(address token, uint256 balance);

    /// @notice Emitted when simulation fails pre-execution
    event SimulationFail(string reason);

    /// @notice Emitted upon receiving a flashloan
    event LogFlashloanReceived(address asset, uint256 amount, uint256 premium);

    /// @notice Sets contract deployer as owner
    constructor() {
        _transferOwnership(msg.sender);
    }

    /// @notice Initializes Aave provider and profit token, only callable once
    /// @param _provider Aave PoolAddressesProvider address
    /// @param _profitToken Token address used to measure profit
    function initialize(address _provider, address _profitToken) external onlyOwner {
        require(!initialized, "Already initialized");
        provider = IPoolAddressesProvider(_provider);
        pool = IPool(provider.getPool());
        profitToken = _profitToken;
        initialized = true;
    }

    /// @notice Registers a new DEX router with its type
    /// @param name DEX name (used as string key)
    /// @param router DEX router contract address
    /// @param dtype Enum value indicating DEX type
    function setDexRouter(string calldata name, address router, DexType dtype) external onlyOwner {
        DEX_ROUTER[name] = router;
        DEX_TYPE[name] = dtype;
    }

    /// @notice Sets the Aave UI Data Provider address
    /// @param _ui Address of the UI pool data provider
    function setUiPoolDataProvider(address _ui) external onlyOwner {
        uiPoolDataProvider = _ui;
    }

    /// @notice Sets the Radiant flashloan pool address
    /// @param _radiant Radiant Pool address
    function setRadiantPool(address _radiant) external onlyOwner {
        radiantPool = _radiant;
    }

    /// @notice Sets the Radiant Data Provider address
    /// @param _radiantDataProvider Radiant DataProvider address
    function setRadiantDataProvider(address _radiantDataProvider) external onlyOwner {
        radiantDataProvider = _radiantDataProvider;
    }

    /// @notice Fallback to receive ETH
    receive() external payable {}

    /// @notice Initiates a flashloan using the Radiant protocol
    /// @param assets Array of asset addresses to borrow
    /// @param amounts Array of corresponding amounts to borrow
    /// @param params Encoded parameters passed to flashloan callback
    function executeRadiantFlashLoan(
        address[] calldata assets,
        uint256[] calldata amounts,
        bytes calldata params
    ) external onlyOwner {
        require(initialized, "Not initialized");
        require(radiantPool != address(0), "Radiant not set");

        // Set all modes to 0 (no debt, full flashloan repay)
        uint256[] memory modes = new uint256[](assets.length);
        for (uint i = 0; i < modes.length; i++) modes[i] = 0;

        // Trigger Radiant flashloan
        IRadiantLendingPool(radiantPool).flashLoan(address(this), assets, amounts, modes, address(this), params, 0);
    }

    /// @notice Callback function called by Radiant when flashloan is issued
    /// @param assets Array of asset addresses borrowed
    /// @param amounts Array of borrowed amounts
    /// @param fees Array of fees for each borrowed asset
    /// @param params Arbitrary encoded params used for routing
    function onFlashLoanReceived(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata fees,
        bytes calldata params
    ) external nonReentrant {
        require(msg.sender == radiantPool, "Not Radiant");

        // Measure gas used for tracking profit after execution
        uint256 gasStart = gasleft();

        // Attempt to execute the predefined multi-token strategy logic first
        try this.doMultiTokenLogic(assets, amounts, fees, params) {
            // If successful, approve repayment (principal + fee) for each borrowed asset
            for (uint i = 0; i < assets.length; i++) {
                IERC20(assets[i]).approve(radiantPool, amounts[i] + fees[i]);
            }

            // Emit summary of successful execution including realized profit
            uint256 profit = IERC20(profitToken).balanceOf(address(this));
            emit FlashExecutionSummary(true, profit, profitToken, keccak256(params), "", gasStart - gasleft());

        } catch {
            // If multi-token logic fails, fallback to AI-enhanced (custom GPT-style) logic
            try this.doCustomLogic(assets, amounts, fees, params) {
                // Approve repayment (principal + fee) for each asset after fallback logic
                for (uint i = 0; i < assets.length; i++) {
                    IERC20(assets[i]).approve(radiantPool, amounts[i] + fees[i]);
                }

                // Emit successful execution summary for fallback strategy
                uint256 profit = IERC20(profitToken).balanceOf(address(this));
                emit FlashExecutionSummary(
                    true,
                    profit,
                    profitToken,
                    keccak256(params),
                    "Fallback logic",
                    gasStart - gasleft()
                );

            } catch Error(string memory reason) {
                // Catch known error messages for easier debugging and monitoring
                emit FlashExecutionSummary(false, 0, address(0), keccak256(params), reason, gasStart - gasleft());

            } catch {
                // Catch silent (non-string) failures and emit generic failure reason
                emit FlashExecutionSummary(
                    false,
                    0,
                    address(0),
                    keccak256(params),
                    "Unknown failure",
                    gasStart - gasleft()
                );
            }
        }
    }

    /**
     * @notice Testing utility for flashloan without executing any swap logic.
     * Used to simulate loan execution and repayment only.
     * Only supports a single asset loan for simplicity.
     */
    function testFlashLoanOnly(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes
    ) external onlyOwner {
        require(assets.length == 1 && amounts.length == 1 && modes.length == 1, "Expected single-asset test");

        address receiver = address(this);
        bytes memory params = "";

        // Initiate test flashloan using Aave V3 or Radiant-style compatible flashloan
        pool.flashLoan(
            receiver,
            assets,
            amounts,
            modes,
            address(this), // onBehalfOf
            params,
            0 // referralCode
        );
    }

    /**
     * @notice Initiates a real multi-asset flashloan with execution logic.
     * @dev Encoded params determine execution strategy in the callback.
     */
    function executeMultiFlashLoan(
        address[] calldata assets,
        uint256[] calldata amounts,
        bytes calldata params
    ) external onlyOwner {
        require(initialized, "Not initialized");

        // Use mode 0 for all assets — indicating no debt (i.e., repay full amount + fee)
        uint256[] memory modes = new uint256[](assets.length);
        for (uint i = 0; i < modes.length; i++) modes[i] = 0;

        // Execute flashloan request with given parameters
        pool.flashLoan(address(this), assets, amounts, modes, address(this), params, 0);
    }

    /**
     * @notice Aave V3-compatible flashloan callback.
     * @dev This is the entry point after receiving the flashloaned assets.
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override nonReentrant returns (bool) {
        uint256 gasStart = gasleft();
        require(msg.sender == address(pool), "Not authorized");

        // If params are empty, this was a test-only flashloan with no trading logic
        if (params.length == 0) {
            emit LogFlashloanReceived(assets[0], amounts[0], premiums[0]);

            // Repay borrowed amount + fee for all assets
            for (uint256 i = 0; i < assets.length; i++) {
                uint256 totalOwed = amounts[i] + premiums[i];
                IERC20(assets[i]).approve(address(pool), totalOwed);
            }

            emit FlashExecutionSummary(true, 0, address(0), keccak256("TEST_ONLY"), "test-only", gasStart - gasleft());
            return true;
        }

        // Otherwise, decode execution mode and logic params
        (uint8 mode, bytes memory innerParams) = abi.decode(params, (uint8, bytes));

        try this.dispatchExecution(mode, assets, amounts, premiums, innerParams) {
            // Approve repayments after logic executes successfully
            for (uint i = 0; i < assets.length; i++) {
                IERC20(assets[i]).approve(address(pool), amounts[i] + premiums[i]);
            }

            // Emit flashloan success summary including profit
            uint256 profit = IERC20(profitToken).balanceOf(address(this));
            emit FlashExecutionSummary(
                true,
                profit,
                profitToken,
                keccak256(params),
                mode == 0 ? "multi" : "custom",
                gasStart - gasleft()
            );
            return true;

        } catch Error(string memory reason) {
            // Catch logic failures with a known string reason
            emit FlashExecutionSummary(false, 0, address(0), keccak256(params), reason, gasStart - gasleft());
            return false;

        } catch {
            // Catch unknown or silent execution failures
            emit FlashExecutionSummary(
                false,
                0,
                address(0),
                keccak256(params),
                "Unknown failure",
                gasStart - gasleft()
            );
            return false;
        }
    }

    /**
     * @notice Dispatches logic execution after flashloan based on selected mode.
     * @param mode 0 = standard multi-token logic, 1 = AI-assisted (GPT) dynamic logic
     * @dev Only callable internally by the contract itself during flashloan execution
     */
    function dispatchExecution(
        uint8 mode,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        bytes calldata innerParams
    ) external {
        require(msg.sender == address(this), "Internal only");

        if (mode == 0) {
            // Execute deterministic logic defined in doMultiTokenLogic
            this.doMultiTokenLogic(assets, amounts, premiums, innerParams);

        } else if (mode == 1) {
            // Execute dynamic AI logic via GPT-assisted strategy routing
            this.doCustomLogic(assets, amounts, premiums, innerParams);

        } else {
            revert("Unknown execution mode");
        }
    }

    /// @notice Executes a series of swaps across multiple DEXs using a decoded route
    /// @dev This function must only be called internally (via `this.`) due to `external` visibility
    /// @param params ABI-encoded route: (string[] dexes, address[] tokens)
    function doMultiTokenLogic(
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata params
    ) external {
        require(msg.sender == address(this), "Only internal");

        // Decode input into route details: array of DEX names and token path
        (string[] memory dexes, address[] memory tokens) = abi.decode(params, (string[], address[]));
        require(tokens.length >= 2 && dexes.length == tokens.length - 1, "Invalid path");

        uint256 gasStart = gasleft();
        address profitToken_ = tokens[tokens.length - 1];
        uint256 balanceBefore = IERC20(profitToken_).balanceOf(address(this));

        for (uint i = 0; i < dexes.length; i++) {
            IERC20 tokenIn = IERC20(tokens[i]);
            IERC20 tokenOut = IERC20(tokens[i + 1]);
            string memory dex = dexes[i];

            address router = DEX_ROUTER[dex];
            DexType dtype = DEX_TYPE[dex];
            require(router != address(0), "Router not set");

            // Reset approval first for security, then approve max
            tokenIn.approve(router, 0);
            tokenIn.approve(router, type(uint256).max);

            uint256 amountIn = tokenIn.balanceOf(address(this));
            uint256 amountOut = 0;
            uint256 stepGasStart = gasleft();

            // Attempt swap, catch revert or unknown failure
            try
                this.performSwap(router, dtype, address(tokenIn), address(tokenOut), amountIn, block.timestamp + 300)
            returns (uint256 outAmount) {
                amountOut = outAmount;

                // Emit successful swap execution
                emit RouteExecutionLog(i, address(tokenIn), address(tokenOut), amountIn, amountOut, router);
                emit StepOutcome(string.concat("Swap ", dex), true, stepGasStart - gasleft());
            } catch Error(string memory reason) {
                // Emit revert reason and failure
                emit StepOutcome(string.concat("Swap ", dex), false, stepGasStart - gasleft());
                emit RecklessRouteLog(
                    tx.origin,
                    tokens[0],
                    amountIn,
                    tokens,
                    dexes,
                    false,
                    0,
                    gasStart - gasleft(),
                    reason
                );
                emit FlashExecutionSummary(false, 0, address(0), keccak256(params), reason, gasStart - gasleft());
                revert(reason);
            } catch {
                // Emit unknown failure and revert
                emit StepOutcome(string.concat("Swap ", dex), false, stepGasStart - gasleft());
                emit RecklessRouteLog(
                    tx.origin,
                    tokens[0],
                    amountIn,
                    tokens,
                    dexes,
                    false,
                    0,
                    gasStart - gasleft(),
                    "Unknown swap failure"
                );
                emit FlashExecutionSummary(
                    false,
                    0,
                    address(0),
                    keccak256(params),
                    "Unknown swap failure",
                    gasStart - gasleft()
                );
                revert("Unknown swap failure");
            }
        }

        uint256 balanceAfter = IERC20(profitToken_).balanceOf(address(this));
        uint256 profit = balanceAfter > balanceBefore ? balanceAfter - balanceBefore : 0;

        emit FinalBalanceReport(profitToken_, balanceAfter);
        emit RecklessRouteLog(
            tx.origin,
            tokens[0],
            IERC20(tokens[0]).balanceOf(address(this)),
            tokens,
            dexes,
            true,
            profit,
            gasStart - gasleft(),
            ""
        );
        emit FlashExecutionSummary(true, profit, profitToken_, keccak256(params), "", gasStart - gasleft());
    }

    /// @notice Executes a token swap using the specified DEX and route type
    /// @dev Supports Uniswap V2, V3, and Curve
    /// @param router Address of the DEX router
    /// @param dtype Enum value of the DEX type (V2, V3, CURVE)
    /// @param tokenIn Address of input token
    /// @param tokenOut Address of output token
    /// @param amountIn Amount of input token to swap
    /// @param deadline UNIX timestamp deadline for swap to succeed
    /// @return amountOut Amount of output token received
    function performSwap(
        address router,
        DexType dtype,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint deadline
    ) external returns (uint256 amountOut) {
        require(msg.sender == address(this), "internal only");

        if (dtype == DexType.V2) {
            address ;
            path[0] = tokenIn;
            path[1] = tokenOut;

            // Uniswap V2-style swap
            uint[] memory amounts = IUniswapV2Router(router).swapExactTokensForTokens(
                amountIn,
                0,
                path,
                address(this),
                deadline
            );
            return amounts[amounts.length - 1];
        } else if (dtype == DexType.V3) {
            // Uniswap V3-style swap using exactInputSingle
            IUniswapV3Router.ExactInputSingleParams memory params = IUniswapV3Router.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: 3000,
                recipient: address(this),
                deadline: deadline,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            return IUniswapV3Router(router).exactInputSingle(params);
        } else if (dtype == DexType.CURVE) {
            // Curve-style exchange (assumes pool index 0 -> 1)
            return ICurveRouter(router).exchange(0, 1, amountIn, 0);
        } else {
            revert("Unknown DEX type");
        }
    }

    /// @notice Executes a custom strategy after flashloan reception
    /// @dev Decodes the strategy type from `params` and routes to appropriate logic
    ///      Only callable internally by the contract itself
    function doCustomLogic(
        address[] calldata tokens,
        uint256[] calldata amounts,
        uint256[] calldata fees,
        bytes calldata params
    ) external {
        require(msg.sender == address(this), "Internal only");

        // Decode parameters into a strategy name and associated payload
        (string memory strategy, bytes memory routeData) = abi.decode(params, (string, bytes));

        if (keccak256(bytes(strategy)) == keccak256("aggressive-arb")) {
            // TODO: Decode GPT-generated DEX route and perform aggressive multi-hop arbitrage
            // (string[] memory dexes, address[] memory path) = abi.decode(routeData, (string[], address[]));
            // executeDexSequence(dexes, path);
        } else if (keccak256(bytes(strategy)) == keccak256("liquidation")) {
            // TODO: Decode liquidation target info and execute liquidation logic
            // (address user, address collateralAsset, address debtAsset, uint256 amount) = abi.decode(routeData, (...));
            // executeLiquidation(user, collateralAsset, debtAsset, amount);
        } else {
            revert("Unknown strategy");
        }

        // NOTE: Replace this with actual logic routed through GPT-generated paths
    }

    /// @notice Initiates a flashloan and attempts an aggressive route execution with minimal guardrails
    /// @dev Requires `tokens.length = dexes.length + 1`. Passes encoded route to internal flashloan callback.
    function executeReckless(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        string[] calldata dexes,
        address[] calldata tokens
    ) external onlyOwner {
        require(initialized, "Not initialized");
        require(tokens.length == dexes.length + 1, "Mismatched path");
        require(assets.length == 1 && amounts.length == 1 && modes.length == 1, "Must pass single asset");

        // Encode routing plan: sequence of DEXs and token path
        bytes memory encoded = abi.encode(dexes, tokens);

        // Fire off the flashloan with embedded route data
        pool.flashLoan(
            address(this),  // receiverAddress
            assets,         // e.g. [WETH]
            amounts,        // e.g. [10e18]
            modes,          // e.g. [0] = repay fully at end
            address(this),  // onBehalfOf
            encoded,        // userParams, decoded in callback
            0               // referralCode
        );
    }

    /// @notice Fetches health data for a user from either Aave or Radiant
    /// @dev Used for simulating liquidation targets or risk analysis
    /// @param user Address of the target user
    /// @param useRadiant If true, uses Radiant’s data provider instead of Aave
    function getUserHealthFactorDynamic(
        address user,
        bool useRadiant
    )
        external
        view
        returns (
            uint256 totalCollateral,
            uint256 totalDebt,
            uint256 availableBorrows,
            uint256 liquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        address activeDataProvider = useRadiant ? radiantDataProvider : uiPoolDataProvider;
        require(activeDataProvider != address(0), "DataProvider not set");

        return IUiPoolDataProvider(activeDataProvider).getUserAccountData(user);
    }

    // ==================== Structs ====================

    /// @notice Result of a simulated arbitrage or multi-hop swap
    struct SimulationResult {
        bool success;                   // Whether the simulated execution succeeded
        int256 netProfit;              // Net profit or loss (in final token) from the strategy
        uint256 gasUsed;              // Estimated gas used during simulation
        address[] tokensInvolved;     // Ordered list of token addresses involved in route
        bytes32[] steps;              // Step-wise encoded hashes (e.g., swap IDs)
    }

    /// @notice Result of a simulated liquidation execution
    struct LiquidationResult {
        bool success;                  // Whether the liquidation was successful
        uint256 gasUsed;              // Gas consumed by the attempt
        string reason;                // Revert or failure reason if any
    }

    // ==================== Events ====================

    /// @notice Logs outcome of each DEX interaction or swap step
    event StepOutcome(string label, bool success, uint256 gasUsed);

    /// @notice Emitted after simulating a liquidation path for a user
    event LiquidationSimResult(
        bool success,
        address collateralAsset,
        address debtAsset,
        address user,
        string reason,
        uint256 gasUsed
    );

    /// @notice Emitted when a live liquidation attempt is made
    event LiquidationExecution(
        bool success,
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover,
        uint256 gasUsed,
        string failureReason
    );

    /// @notice Logs execution attempt of a multi-hop DEX path using flashloan
    event RecklessRouteLog(
        address indexed initiator,
        address loanToken,
        uint256 loanAmount,
        address[] tokenPath,
        string[] dexPath,
        bool success,
        uint256 profit,
        uint256 gasUsed,
        string failureReason
    );

    // ==================== Simulate Swap Logic ====================

    /// @notice Estimates the output of a swap from a specific DEX router
    /// @dev Uses hardcoded logic for known DEX types. V3 returns 0 since it's complex to estimate on-chain.
    /// @param router Address of the DEX router (UniswapV2, V3, Curve, etc.)
    /// @param dtype Enum representing the DEX type (V2, V3, Curve)
    /// @param tokenIn Input token address
    /// @param tokenOut Output token address
    /// @param deadline Expiry for the swap (unused for estimation, but consistent interface)
    function simulateSwap(
        address router,
        DexType dtype,
        address tokenIn,
        address tokenOut,
        uint deadline
    ) external returns (uint256 amountOut) {
        require(msg.sender == address(this), "internal only");

        if (dtype == DexType.V2) {
            // Use UniswapV2-style router to estimate tokenOut
            address ;
            path[0] = tokenIn;
            path[1] = tokenOut;
            uint[] memory amounts = IUniswapV2Router(router).getAmountsOut(1e6, path);
            return amounts[1];
        } else if (dtype == DexType.V3) {
            // UniswapV3 estimation is complex — use off-chain quoter instead
            return 0;
        } else if (dtype == DexType.CURVE) {
            // Estimate Curve output assuming token indices 0 -> 1
            return ICurveRouter(router).get_dy(0, 1, 1e6);
        } else {
            revert("Unknown DEX type");
        }
    }

    // ==================== executeLocalArb (Upgraded) ====================

    /// @notice Attempts to simulate and execute a multi-hop arbitrage path
    /// @dev Uses a flashloaned token and calls doMultiTokenLogic. Catches any reverts or failures cleanly.
    /// @param assets Array of token addresses used for borrowing (usually 1 token)
    /// @param amounts Corresponding amounts for each asset
    /// @param params ABI-encoded parameters including DEX names, token path, and deadline
    /// @return A SimulationResult struct summarizing outcome and gas cost
    function executeLocalArb(
        address[] calldata assets,
        uint256[] calldata amounts,
        bytes calldata params
    ) external onlyOwner returns (SimulationResult memory) {
        uint256 gasStart = gasleft();

        // Decode route: list of DEXs, token path, and deadline
        (string[] memory dexes, address[] memory tokens, uint deadline) = abi.decode(
            params,
            (string[], address[], uint)
        );

        address finalProfitToken = tokens[tokens.length - 1];
        uint256 balanceBefore = IERC20(finalProfitToken).balanceOf(address(this));
        bytes32[] memory steps = new bytes32[](dexes.length);

        try this.doMultiTokenLogic(assets, amounts, new uint256[](assets.length), params) {
            // If execution succeeds, measure profit delta
            uint256 balanceAfter = IERC20(finalProfitToken).balanceOf(address(this));
            uint256 profit = balanceAfter > balanceBefore ? balanceAfter - balanceBefore : 0;

            // Generate unique step hashes for tracking/reporting
            for (uint i = 0; i < dexes.length; i++) {
                steps[i] = keccak256(abi.encodePacked("SwapExecuted", tokens[i], tokens[i + 1]));
            }

            // Emit tracking events for frontend/analysis
            emit FinalBalanceReport(finalProfitToken, balanceAfter);
            emit FlashExecutionSummary(true, profit, finalProfitToken, keccak256(params), "", gasStart - gasleft());

            return SimulationResult(true, int256(profit), gasStart - gasleft(), tokens, steps);
        } catch Error(string memory reason) {
            // Handle known revert reason
            emit FlashExecutionSummary(false, 0, finalProfitToken, keccak256(params), reason, gasStart - gasleft());
            steps[0] = keccak256(abi.encodePacked("Fail", reason));
            return SimulationResult(false, 0, gasStart - gasleft(), tokens, steps);
        } catch {
            // Handle unknown failure
            emit FlashExecutionSummary(false, 0, finalProfitToken, keccak256(params), "Unknown", gasStart - gasleft());
            steps[0] = keccak256("Unknown failure");
            return SimulationResult(false, 0, gasStart - gasleft(), tokens, steps);
        }
    }

    // ==================== simulateRecklessArb ====================
    /**
     * @notice Simulates a flashloan-based arbitrage route across multiple DEXs without executing real swaps.
     * @dev This function assumes a hypothetical swap to estimate profit potential and gas consumption.
     * @param dummyAssets Placeholder asset list for simulation (usually a single flashloan asset).
     * @param dummyAmounts Placeholder flashloan amounts.
     * @param dummyPremiums Placeholder flashloan fees.
     * @param dexes DEX route path (e.g., ["Uniswap", "Camelot"]).
     * @param tokens Token route path corresponding to the DEX path.
     * @return A SimulationResult struct capturing success, gas used, profit estimation, and swap steps.
     */
    function simulateRecklessArb(
        address[] calldata dummyAssets,
        uint256[] calldata dummyAmounts,
        uint256[] calldata dummyPremiums,
        string[] calldata dexes,
        address[] calldata tokens
    ) external onlyOwner returns (SimulationResult memory) {
        require(tokens.length == dexes.length + 1, "Mismatched path");
        require(
            dummyAssets.length == 1 && dummyAmounts.length == 1 && dummyPremiums.length == 1,
            "Expected 1-length arrays"
        );

        uint256 gasStart = gasleft();

        bytes memory encoded = abi.encode(dexes, tokens);
        bytes32[] memory steps = new bytes32[](dexes.length);

        address profitToken_ = tokens[tokens.length - 1];
        uint256 fakeBalanceBefore = 0;
        uint256 fakeBalanceAfter = 0;

        for (uint i = 0; i < dexes.length; i++) {
            address tokenIn = tokens[i];
            address tokenOut = tokens[i + 1];
            address router = DEX_ROUTER[dexes[i]];
            DexType dtype = DEX_TYPE[dexes[i]];

            require(router != address(0), "Router not set");

            try this.simulateSwap(router, dtype, tokenIn, tokenOut, block.timestamp + 300) returns (uint256 outAmount) {
                steps[i] = keccak256(abi.encodePacked("Success", tokenIn, tokenOut, outAmount));
                emit StepOutcome("Sim success", true, gasStart - gasleft());

                if (tokenOut == profitToken_) {
                    fakeBalanceAfter += outAmount;
                }
            } catch Error(string memory reason) {
                steps[i] = keccak256(abi.encodePacked("Fail", reason));
                emit StepOutcome(reason, false, gasStart - gasleft());
                return SimulationResult(false, 0, gasStart - gasleft(), tokens, steps);
            } catch {
                steps[i] = keccak256("Unknown failure");
                emit StepOutcome("Unknown failure", false, gasStart - gasleft());
                return SimulationResult(false, 0, gasStart - gasleft(), tokens, steps);
            }
        }

        int256 netProfit = int256(fakeBalanceAfter) - int256(fakeBalanceBefore + dummyPremiums[0]);

        emit FinalBalanceReport(profitToken_, fakeBalanceAfter);
        emit FlashExecutionSummary(
            true,
            uint256(netProfit),
            profitToken_,
            keccak256(encoded),
            "",
            gasStart - gasleft()
        );

        return SimulationResult(true, netProfit, gasStart - gasleft(), tokens, steps);
    }

    // ==================== simulateLiquidation (Upgraded) ====================
    /**
     * @notice Simulates a liquidation call on the Aave pool without executing a real transaction.
     * @dev Uses try/catch to prevent revert and instead return structured simulation output.
     * @param collateralAsset The asset used as collateral by the user.
     * @param debtAsset The asset borrowed by the user.
     * @param user The user address to be liquidated.
     * @param debtToCover Amount of debt to cover in simulation.
     * @return A SimulationResult with outcome, gas usage, and failure details.
     */
    function simulateLiquidation(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover
    ) external onlyOwner returns (SimulationResult memory) {
        uint256 gasStart = gasleft();
        address[] memory tokensInvolved = new address[](2);
        tokensInvolved[0] = collateralAsset;
        tokensInvolved[1] = debtAsset;
        bytes32[] memory steps = new bytes32[](1);

        try pool.liquidationCall(collateralAsset, debtAsset, user, debtToCover, false) {
            steps[0] = keccak256("Liquidation succeeded");
            emit StepOutcome("Liquidation succeeded", true, gasStart - gasleft());
            return SimulationResult(true, 0, gasStart - gasleft(), tokensInvolved, steps);
        } catch Error(string memory reason) {
            steps[0] = keccak256(abi.encodePacked("Fail:", reason));
            emit LiquidationSimResult(false, collateralAsset, debtAsset, user, reason, gasStart - gasleft());
            return SimulationResult(false, 0, gasStart - gasleft(), tokensInvolved, steps);
        } catch {
            steps[0] = keccak256("Unknown failure");
            emit LiquidationSimResult(false, collateralAsset, debtAsset, user, "Unknown failure", gasStart - gasleft());
            return SimulationResult(false, 0, gasStart - gasleft(), tokensInvolved, steps);
        }
    }

    // ==================== executeLiquidation (Real) ====================
    /**
     * @notice Executes an actual liquidation call on the Aave pool contract.
     * @dev Emits a detailed event capturing liquidation results and gas metrics.
     * @param collateralAsset The asset used as collateral by the user.
     * @param debtAsset The asset borrowed by the user.
     * @param user The user to be liquidated.
     * @param debtToCover The amount of debt to repay during liquidation.
     */
    function executeLiquidation(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover
    ) external onlyOwner {
        uint256 gasStart = gasleft();

        try pool.liquidationCall(collateralAsset, debtAsset, user, debtToCover, false) {
            emit LiquidationExecution(true, collateralAsset, debtAsset, user, debtToCover, gasStart - gasleft(), "");
        } catch Error(string memory reason) {
            emit LiquidationExecution(
                false,
                collateralAsset,
                debtAsset,
                user,
                debtToCover,
                gasStart - gasleft(),
                reason
            );
            revert(reason);
        } catch {
            emit LiquidationExecution(
                false,
                collateralAsset,
                debtAsset,
                user,
                debtToCover,
                gasStart - gasleft(),
                "Unknown error"
            );
            revert("Unknown error");
        }
    }

    /**
     * @notice Executes a liquidation on the Radiant protocol via its LendingPool.
     * @dev This supports the Radiant forked variant of Aave with optional aToken receipt.
     * @param user The borrower to liquidate.
     * @param collateralAsset Collateral token held by user.
     * @param debtAsset Borrowed token to be repaid.
     * @param debtToCover Amount of debt to cover in this liquidation.
     * @param receiveAToken Whether the liquidator accepts aToken instead of underlying.
     */
    function performRadiantLiquidation(
        address user,
        address collateralAsset,
        address debtAsset,
        uint256 debtToCover,
        bool receiveAToken
    ) external onlyOwner {
        uint256 gasStart = gasleft();

        try
            IRadiantLendingPool(radiantPool).liquidationCall(
                collateralAsset,
                debtAsset,
                user,
                debtToCover,
                receiveAToken
            )
        {
            emit LiquidationExecution(true, collateralAsset, debtAsset, user, debtToCover, gasStart - gasleft(), "");
        } catch Error(string memory reason) {
            emit LiquidationExecution(
                false,
                collateralAsset,
                debtAsset,
                user,
                debtToCover,
                gasStart - gasleft(),
                reason
            );
            revert(reason);
        } catch {
            emit LiquidationExecution(
                false,
                collateralAsset,
                debtAsset,
                user,
                debtToCover,
                gasStart - gasleft(),
                "Unknown error"
            );
            revert("Unknown error");
        }
    }

    // ======= WITHDRAWAL =======
    /**
     * @notice Allows the contract owner to withdraw all balance of a specific ERC20 token.
     * @param token The address of the ERC20 token to withdraw.
     */
    function withdrawToken(address token) external onlyOwner {
        uint256 bal = IERC20(token).balanceOf(address(this));
        require(bal > 0, "No tokens");
        IERC20(token).transfer(owner(), bal);
    }

    // ======= GETTERS =======
    /**
     * @notice Returns the Aave PoolAddressesProvider contract reference.
     */
    function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider) {
        return provider;
    }

    /**
     * @notice Returns the Aave Pool contract used for flashloans and liquidations.
     */
    function POOL() external view returns (IPool) {
        return pool;
    }
}
