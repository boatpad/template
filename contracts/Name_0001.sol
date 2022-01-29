// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./LotteryRoles.sol";
import "./LotteryState.sol";
import "./LotteryAggregator.sol";
import "./LotteryVrfConfig.sol";
import "./LotteryDistribution.sol";

contract Name_0001 is VRFConsumerBase, AccessControl, Pausable,
LotteryState, LotteryRoles,
LotteryAggregator, LotteryVrfConfig,
LotteryDistribution {

    using SafeMath for uint256;

    mapping(address => uint[]) private _players;
    mapping(uint256 => address) private _tickets;
    uint256[] private _ticketsArray;
    uint256 private _totalPlayer;

    uint256 private _ticketPrice;
    uint256 private _ticketLimit = 100;

    uint8 private _winnerCount;
    uint8 private _activeWinnerIndex = 0; //Active winner index
    uint8 private _raiseRatio;

    event BuyTicket(address indexed from, address indexed to, uint256 value, bytes32 requestId);

    event ActivateFirstWinner(address indexed winnerAddress);
    event ActivateNextWinner(address indexed winnerAddress);
    event AgencyApproveForSale(bool agencyApproveForSale);
    event BrokerApproveForSale(bool brokerApproveForSale);
    event SurveyorApproveForSale(bool surveyorApproveForSale);
    event WinnerApproveForSale(bool winnerApproveForSale, LOTTERY_STATE lotteryState);
    event ChangeLotteryState(LOTTERY_STATE lotteryState);
    event PickWinners(address[] indexed winners);

    /*constructor(address yachtOwner_,address broker_, address agency_, address surveyor_,
            uint8 winnerCount_, uint256 yachtPrice_,uint256 _1YearYachtExpenses_, uint256 ticketPrice_, uint8 raiseRatio_) */
    constructor()
    VRFConsumerBase(_vrfCoordinatorAddres, _vrfLinkToken){

        _admin = _msgSender();
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());

        /*_yachtOwner=yachtOwner_;
        _broker=broker_;
        _agency=agency_;
        _surveyor=surveyor_;
        _winnerCount=winnerCount_;
        _yachtPrice=yachtPrice_ * (10**18);
        _1YearYachtExpenses=_1YearYachtExpenses_ * (10**18);
        _ticketPrice = ticketPrice_ * (10 ** 18);
        _raiseRatio=raiseRatio_;
        */

        _yachtOwner = address(0x90be451568D3a643DaA2e018A26a6C557576ed4f);
        _broker = address(0xdf9427E2B6a22a2E16BaC0e6AD4C479DAf98f0F5);
        _agency = address(0x3B56e9325Ddb5210B1F58D222c341C0D1FEF2111);
        _surveyor = address(0xe661447d46ef00A10785dec2cFDd21849aC34F34);
        _winnerCount = 3;
        _ticketPrice = 1 * (10 ** 18);
        _yachtPrice = 5 * (10 ** 18);
        _1YearYachtExpenses = 1 * (10 ** 18);
        _raiseRatio = 150;
        _grantRole(YACHT_OWNER_ROLE, _yachtOwner);
        _grantRole(BROKER_ROLE, _broker);
        _grantRole(AGENCY_ROLE, _agency);
        _grantRole(SURVEYOR_ROLE, _surveyor);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getBalanceUsd() public view returns (uint) {
        return getBalance().div(10 ** 18).mul(getMaticUsdPrice());
    }

    function getTotalTickets() public view returns (uint){
        return _ticketsArray.length;
    }

    function getPlayerTickets(address _address) public view returns (uint[] memory){
        return _players[_address];
    }

    function getTotalPlayers() public view returns (uint){
        return _totalPlayer;
    }

    function getTicketPrice() public view returns (uint){
        return _ticketPrice;
    }

    function buyTicket() public payable lotteryOpen buyRequire {
        uint256 ticketCount = msg.value.div(_ticketPrice);

        for (uint256 i = 0; i < ticketCount; i++) {
            bytes32 requestId = requestRandomness(_keyhash, _fee);
            requestIdToAddress[requestId] = _msgSender();
            emit BuyTicket(_msgSender(), address(this), msg.value, requestId);
        }
    }

    function pickWinners() public onlyRole(ADMIN_ROLE) {
        bytes32 requestId = requestRandomness(_keyhash, _fee);
        requestIdToAddress[requestId] = _admin;
    }

    function brokerApproveForSale() public onlyRole(BROKER_ROLE) {
        _brokerApproveForSale = true;
    }

    function agencyApproveForSale() public onlyRole(AGENCY_ROLE) {
        _agencyApproveForSale = true;
        emit AgencyApproveForSale(_agencyApproveForSale);
    }

    function surveyorApproveForSale() public onlyRole(SURVEYOR_ROLE) {
        _surveyorApproveForSale = true;
        emit SurveyorApproveForSale(_surveyorApproveForSale);
    }

    function winnerApproveForSale() public onlyRole(WINNER_ROLE) approveRequire {
        uint256 contractBalance = getBalance();

        _transferYachtPriceToOwner();
        //%97
        _transferYachtPriceToBroker();
        //%3
        _transferExpensesToWinner();
        //%100

        _distributeRaise(contractBalance);
        //%100 - %60 manager, %15 yachtowner, %10 agency, %10 surveyor, %5 broker
        _lottery_state = LOTTERY_STATE.SOLD;
        emit WinnerApproveForSale(true, LOTTERY_STATE.SOLD);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        require(randomness > 0, "random-not-found");

        address buyerAddress = requestIdToAddress[requestId];

        if (buyerAddress != _admin) {
            generateTicket(randomness, buyerAddress);
            return;
        }
        if (_lottery_state == LOTTERY_STATE.LOTTERY_TIME) {
            generateWinners(randomness);
        }
    }

    function generateTicket(uint256 randomness, address buyerAddress) private {
        if (_players[buyerAddress].length == 0) {
            _totalPlayer = _totalPlayer.add(1);
        }

        _ticketsArray.push(randomness);
        _tickets[randomness] = buyerAddress;
        _players[buyerAddress].push(randomness);

        if (_yachtPrice.add(_1YearYachtExpenses) < getBalance()) {
            _lottery_state = LOTTERY_STATE.OPEN_RAISE_BUY_TICKET;
        }
        if (_yachtPrice.add(_1YearYachtExpenses).mul(1 + (_raiseRatio / 100)) < getBalance()) {
            _lottery_state = LOTTERY_STATE.LOTTERY_TIME;
        }
    }

    function generateWinners(uint256 randomness) private {
        uint256[] memory winnerRandomness = expand(randomness, _winnerCount);
        for (uint256 i = 0; i < _winnerCount; i++) {
            uint256 winningTicket = _ticketsArray[winnerRandomness[i] % _ticketsArray.length];
            address winnerAddress = _tickets[winningTicket];
            _winningTickets.push(winningTicket);
            _winners.push(winnerAddress);
        }
        emit PickWinners(_winners);
    }

    function activateFirstWinner() public onlyRole(ADMIN_ROLE) {
        require(_lottery_state == LOTTERY_STATE.OPEN_SALE_TRANSACTION);
        _grantRole(WINNER_ROLE, _winners[_activeWinnerIndex]);
        _lottery_state == LOTTERY_STATE.OPEN_SALE_TRANSACTION;
        emit ActivateFirstWinner(_winners[_activeWinnerIndex]);
    }

    function activateNextWinner() public onlyRole(ADMIN_ROLE) {
        require(_lottery_state == LOTTERY_STATE.OPEN_SALE_TRANSACTION);
        _revokeRole(WINNER_ROLE, _winners[_activeWinnerIndex]);
        _activeWinnerIndex++;
        _grantRole(WINNER_ROLE, _winners[_activeWinnerIndex]);
        emit ActivateNextWinner(_winners[_activeWinnerIndex]);
    }

    function changeLotteryState(uint8 lottery_state_) public onlyRole(ADMIN_ROLE) {
        _lottery_state = LOTTERY_STATE(lottery_state_);

        if (_lottery_state == LOTTERY_STATE.LIMIT_NOT_REACHED) {
            resendMoneyToPlayers(90);
            //resend %90 money to player
            _transferAmountToAddress(_admin, address(this).balance);
        } else if (_lottery_state == LOTTERY_STATE.SALE_NOT_MADE) {
            resendMoneyToPlayers(80);
            //resend %80 money to player
            _transferAmountToAddress(_admin, address(this).balance);
        }
        emit ChangeLotteryState(LOTTERY_STATE(lottery_state_));
    }

    function resendMoneyToPlayers(uint8 percentage) private {
        for (uint256 i = 0; i < _ticketsArray.length; i++) {
            address resendAddress = _tickets[_ticketsArray[i]];
            _transferAmountToAddress(resendAddress, _ticketPrice.div(100).mul(percentage).div(100));
        }
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function withdrawLinkRemain() public onlyRole(ADMIN_ROLE) {
        LINK.transfer(msg.sender, LINK.balanceOf(address(this)));
    }

    function getSummary() public view returns (uint256, uint256, uint256, uint256, uint256) {
        return (
        getLotteryState(),
        getYachtPrice().div(10 ** 18),
        getBalance().div(10 ** 18),
        getTicketPrice().div(10 ** 18),
        getTotalPlayers()
        );
    }

    modifier buyRequire(){
        require(msg.value >= _ticketPrice, "Not enough MATIC");
        require(msg.value.mod(_ticketPrice, "MATIC should be multiples of ticket prices.") == 0);
        require(_players[_msgSender()].length.add(msg.value.div(_ticketPrice)) <= _ticketLimit, "An address can buy a maximum of 100 tickets.");
        _;
    }

    modifier approveRequire(){
        require(_agencyApproveForSale, "Agency must approve Sale");
        require(_surveyorApproveForSale, "Surveyor must approve Sale");
        require(_brokerApproveForSale, "Broker must approve Sale");
        require(_lottery_state == LOTTERY_STATE.OPEN_SALE_TRANSACTION);
        _;
    }

}
