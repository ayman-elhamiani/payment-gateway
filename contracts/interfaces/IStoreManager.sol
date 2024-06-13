// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IStoreManager {
    function addStore(address walletAddress) external;
    function getStoreInfo(address walletAddress, uint256 storeId) external view returns (uint256 transactionCountToday, uint256 transactionVolumeToday, uint256 totalTransactionCount, uint256 totalTransactionVolume, uint256 creationDate, uint256 lastTransactionDate);
    function getAllStoresInfo(address walletAddress) external view returns (uint256 totalTransactionCount, uint256 totalTransactionVolume, uint256 totalTransactionCountToday, uint256 totalTransactionVolumeToday);
}
