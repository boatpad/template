// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

abstract contract LotteryState {

    enum LOTTERY_STATE {
        COMING_SOON,//0
        OPEN_BUY_TICKET,//1
        OPEN_RAISE_BUY_TICKET,//2
        LOTTERY_TIME,//3
        OPEN_SALE_TRANSACTION,//4
        SOLD,//5
        LIMIT_NOT_REACHED,//6
        SALE_NOT_MADE//7
    }

    LOTTERY_STATE internal _lottery_state;

    function getLotteryState() public view returns (uint256) {
        return uint256(_lottery_state);
    }

    modifier lotteryOpen(){
        require(_lottery_state == LOTTERY_STATE.OPEN_BUY_TICKET
            || _lottery_state == LOTTERY_STATE.OPEN_RAISE_BUY_TICKET,
            "You can't buy ticket because lottery state is different");
        _;
    }
}
