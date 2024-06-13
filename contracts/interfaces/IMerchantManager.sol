// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IMerchantManager {
    function registerMerchant(bool isPremium, address[] calldata acceptedTokens) external;
    function isMerchantRegistered(address walletAddress) external view returns (bool);
    function getMerchantInfo(address walletAddress) external view returns (bool isRegistered, bool isPremium, uint256 registrationDate, uint256 storeCount, address[] memory acceptedTokens);
    function getMerchantCount() external view returns (uint256);
    function updateAcceptedTokens(address walletAddress, address[] calldata newTokens) external;
}
