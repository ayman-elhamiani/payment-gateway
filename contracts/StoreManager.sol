// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MerchantManager.sol";

contract StoreManager is MerchantManager {
    event StoreAdded(address indexed merchant, uint256 storeId);

    // Allows any registered merchant to add a store. Non-premium merchants can only have one store.
    function addStore() public {
        require(merchants[msg.sender].isRegistered, "StoreManager: Merchant not registered");
        if (!merchants[msg.sender].isPremium) {
            require(merchants[msg.sender].storeCount == 0, "StoreManager: Non-premium merchants can only have one store");
        }

        uint256 storeId = merchants[msg.sender].storeCount;
        Store storage store = merchants[msg.sender].stores[storeId];
        store.transactionCountToday = 0;
        store.transactionVolumeToday = 0;
        store.totalTransactionCount = 0;
        store.totalTransactionVolume = 0;
        store.creationDate = block.timestamp;
        store.lastTransactionDate = 0;

        merchants[msg.sender].storeCount++;
        emit StoreAdded(msg.sender, storeId);
    }

    // Function to retrieve information about a store
   function getStoreInfo(address walletAddress, uint256 storeId) public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
    Store storage store = merchants[walletAddress].stores[storeId];
    return (
        store.transactionCountToday,
        store.transactionVolumeToday,
        store.totalTransactionCount,
        store.totalTransactionVolume,
        store.creationDate,
        store.lastTransactionDate
    );
}

}
