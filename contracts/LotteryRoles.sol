// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

abstract contract LotteryRoles {
    bytes32 internal constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 internal constant YACHT_OWNER_ROLE = keccak256("YACHT_OWNER_ROLE");
    bytes32 internal constant WINNER_ROLE = keccak256("WINNER_ROLE");
    bytes32 internal constant BROKER_ROLE = keccak256("BROKERAGE_ROLE");
    bytes32 internal constant AGENCY_ROLE = keccak256("AGENCY_ROLE");
    bytes32 internal constant SURVEYOR_ROLE = keccak256("SURVEYOR_ROLE");
}
