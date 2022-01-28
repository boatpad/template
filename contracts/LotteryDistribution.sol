// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./LotterySurveyorAgencyBroker.sol";

abstract contract LotteryDistribution is LotterySurveyorAgencyBroker {

    using SafeMath for uint256;

    uint256 internal _yachtPrice;
    uint256 internal _1YearYachtExpenses;

    address internal _admin;
    address internal _yachtOwner;
    address[] internal _winners;
    uint256[] internal _winningTickets;

    function getYachtPrice() public view returns (uint) {
        return _yachtPrice;
    }

    function get1YearYachtExpenses() public view returns (uint) {
        return _1YearYachtExpenses;
    }

    function getAdmin() public view returns (address) {
        return _admin;
    }

    function getYachtOwner() public view returns (address) {
        return _yachtOwner;
    }

    function getWinners() public view returns (address[] memory) {
        return _winners;
    }

    function getWinningTickets() public view returns (uint256[] memory) {
        return _winningTickets;
    }

    function _transferAmountToAddress(address _address, uint256 _amount) internal {
        payable(_address).transfer(_amount);
    }

    function _transferYachtPriceToOwner() internal {
        _transferAmountToAddress(_yachtOwner, _yachtPrice.div(100).mul(97)); //yachtPrice %97 to yacht owner
    }

    function _transferYachtPriceToBroker() internal {
        _transferAmountToAddress(_broker,_yachtPrice.div(100).mul(3)); //yachtPrice %3 to broker
    }

    function _transferExpensesToWinner() internal {
        _transferAmountToAddress(msg.sender, _1YearYachtExpenses); //1YearYachtExpenses 100% awarded as an expense to the winner
    }

    function _distributeRaise(uint256 contractBalance) internal {
        uint256 raisedAmount = contractBalance.sub(_yachtPrice).sub(_1YearYachtExpenses);
        _transferAmountToAddress(_admin,raisedAmount.div(100).mul(60)); //raisedAmount %60 to manager
        _transferAmountToAddress(_yachtOwner,raisedAmount.div(100).mul(15)); //raisedAmount %15 to yachtOwner
        _transferAmountToAddress(_agency,raisedAmount.div(100).mul(10)); //raisedAmount %10 to agency
        _transferAmountToAddress(_surveyor,raisedAmount.div(100).mul(10)); //raisedAmount %10 to surveyor
        _transferAmountToAddress(_broker,raisedAmount.div(100).mul(5)); //raisedAmount %5 to broker
    }


}
