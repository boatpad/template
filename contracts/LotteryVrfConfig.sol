// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

abstract contract LotteryVrfConfig {
    //todo change for prod
    address internal _vrfCoordinatorAddres = 0x8C7382F9D8f56b33781fE506E897a4F1e2d17255; //MATICTEST VRF Coordinator
    address internal _vrfLinkToken = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB; //MATICTEST VRF LINK Token
    uint256 internal _fee = 0.0001 * 10 ** 18; //MATICTEST VRF FEE 0.0001 LINK
    bytes32 internal _keyhash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4; //MATICTEST VRF Key Hash

    mapping(bytes32 => address) internal requestIdToAddress;

    function expand(uint256 randomValue, uint256 n) public pure returns (uint256[] memory expandedValues) {
        expandedValues = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            expandedValues[i] = uint256(keccak256(abi.encode(randomValue, i)));
        }
        return expandedValues;
    }

}
