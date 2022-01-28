// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

abstract contract LotteryAggregator {

    //todo change for prod
    AggregatorV3Interface internal maticUsdPriceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);//MATICUSD Aggregator

    function getMaticUsdPrice() public view returns (uint256) {
        (, int256 price, , , ) = maticUsdPriceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * 10**10; // 18 decimals
        return adjustedPrice;
    }
}
