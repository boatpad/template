// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;


abstract contract LotterySurveyorAgencyBroker {

    address internal _broker;
    address internal _agency;
    address internal _surveyor;
    bool internal _agencyApproveForSale = false;
    bool internal _brokerApproveForSale = false;
    bool internal _surveyorApproveForSale = false;

    function getBroker() public view returns (address) {
        return _broker;
    }

    function getAgency() public view returns (address) {
        return _agency;
    }

    function getSurveyor() public view returns (address) {
        return _surveyor;
    }

    function getBrokerApproveForSale() public view returns (bool) {
        return _brokerApproveForSale;
    }

    function getAgencyApproveForSale() public view returns (bool) {
        return _agencyApproveForSale;
    }

    function getSurveyorApproveForSale() public view returns (bool) {
        return _surveyorApproveForSale;
    }
}
