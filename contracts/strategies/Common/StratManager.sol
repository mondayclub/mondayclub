// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract StratManager is Ownable, Pausable {
    /**
     * @dev Contracts:
     * {keeper} - Address to manage a few lower risk features of the strat
     * {vault} - Address of the vault that controls the strategy's funds.
     * {unirouter} - Address of exchange to execute swaps.
     */
    address public keeper;
    address public unirouter;
    address public vault;
    address public mondayFeeRecipient;
    address public incentivePoolFeeRecipient;

    event SetKeeper(address addr);
    event SetUnirouter(address addr);
    event SetVault(address addr);
    event SetMondayFeeRecipient(address addr);

    /**
     * @dev Initializes the base strategy.
     * @param _keeper address to use as alternative owner.
     * @param _unirouter router to use for swaps
     * @param _vault address of parent vault.
     * @param _mondayFeeRecipient address where to send monday's fees.
     * @param _incentivePoolFeeRecipient address where to send incentive pool's fees.
     */
    constructor(
        address _keeper,
        address _unirouter,
        address _vault,
        address _mondayFeeRecipient,
        address _incentivePoolFeeRecipient
    ) {
        keeper = _keeper;
        unirouter = _unirouter;
        vault = _vault;
        mondayFeeRecipient = _mondayFeeRecipient;
        incentivePoolFeeRecipient = _incentivePoolFeeRecipient;
    }

    // checks that caller is either owner or keeper.
    modifier onlyManager() {
        require(msg.sender == owner() || msg.sender == keeper, "!manager");
        _;
    }

    /**
     * @dev Updates address of the strat keeper.
     * @param _keeper new keeper address.
     */
    function setKeeper(address _keeper) external onlyManager {
        keeper = _keeper;

        emit SetKeeper(_keeper);
    }

    /**
     * @dev Updates router that will be used for swaps.
     * @param _unirouter new unirouter address.
     */
    function setUnirouter(address _unirouter) external onlyOwner {
        unirouter = _unirouter;

        emit SetUnirouter(_unirouter);
    }

    /**
     * @dev Updates parent vault.
     * @param _vault new vault address.
     */
    function setVault(address _vault) external onlyOwner {
        vault = _vault;

        emit SetVault(_vault);
    }

    /**
     * @dev Updates monday fee recipient.
     * @param _mondayFeeRecipient new monday fee recipient address.
     */
    function setMondayFeeRecipient(address _mondayFeeRecipient) external onlyOwner {
        mondayFeeRecipient = _mondayFeeRecipient;

        emit SetMondayFeeRecipient(_mondayFeeRecipient);
    }

    /**
     * @dev Function to synchronize balances before new user deposit.
     * Can be overridden in the strategy.
     */
    function beforeDeposit() external virtual {}
}