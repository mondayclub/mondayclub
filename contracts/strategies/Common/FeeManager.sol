// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "./StratManager.sol";

abstract contract FeeManager is StratManager {
    uint constant public MAX_FEE = 1500;
    uint constant public MAX_CALL_FEE = 150;
    uint constant public MAX_INTENSIVE_POOL_FEE = 1350;

    uint constant public WITHDRAWAL_FEE_CAP = 50;
    uint constant public WITHDRAWAL_MAX = 10000;

    uint public withdrawalFee = 10;

    uint public callFee = 150;
    uint public intensivePoolFee = 800;
    uint public mondayFee = MAX_FEE - intensivePoolFee - callFee;

    event SetCallFee(uint256 _fee);
    event SetWithdrawalFee(uint256 _fee);
    event SetIntensivePoolFee(uint256 _fee);

    function setCallFee(uint256 _fee) external onlyManager {
        require(_fee <= MAX_CALL_FEE, "!cap");
        
        callFee = _fee;
        mondayFee = MAX_FEE - intensivePoolFee - callFee;
        
        emit SetCallFee(_fee);
    }

    function setIntensivePoolFee(uint256 _fee) external onlyManager {
        require(_fee <= MAX_INTENSIVE_POOL_FEE, "!cap");
        
        intensivePoolFee = _fee;
        mondayFee = MAX_FEE - intensivePoolFee - callFee;
        
        emit SetIntensivePoolFee(_fee);
    }

    function setWithdrawalFee(uint256 _fee) public onlyManager {
        require(_fee <= WITHDRAWAL_FEE_CAP, "!cap");

        withdrawalFee = _fee;

        emit SetWithdrawalFee(_fee);
    }
}