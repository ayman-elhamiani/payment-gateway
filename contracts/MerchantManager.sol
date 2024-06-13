// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IMerchantManager.sol";

contract MerchantManager is IMerchantManager {
    address public owner;

    struct Store {
        uint256 transactionCountToday;
        uint256 transactionVolumeToday;
        uint256 totalTransactionCount;
        uint256 totalTransactionVolume;
        uint256 creationDate;
        uint256 lastTransactionDate;
    }

    struct Merchant {
        bool isRegistered;
        address walletAddress;
        bool isPremium;
        uint256 registrationDate;
        address[] acceptedTokens; 
        uint256 storeCount;
        mapping(uint256 => Store) stores; // Stores mapping
    }

    mapping(address => Merchant) public merchants;
    address[] public merchantAddresses;

    constructor() {
        owner = msg.sender;
    }

    event MerchantRegistered(address indexed merchant, bool isPremium);

  function registerMerchant(bool isPremium, address[] calldata acceptedTokens) external override {
        require(!merchants[msg.sender].isRegistered, "Merchant already registered.");
        
        Merchant storage merchant = merchants[msg.sender];
        merchant.isRegistered = true;
        merchant.walletAddress = msg.sender;
        merchant.isPremium = isPremium;
        merchant.registrationDate = block.timestamp;
        merchant.storeCount = 0;
        delete merchant.acceptedTokens;
        for (uint i = 0; i < acceptedTokens.length; i++) {
            merchant.acceptedTokens.push(acceptedTokens[i]);
        }

        merchantAddresses.push(msg.sender);
        emit MerchantRegistered(msg.sender, isPremium);
    }
    // function isMerchantRegistered(address walletAddress) external view returns (bool) {
    //     return merchants[walletAddress].isRegistered;
    // }
    function isMerchantRegistered(address merchant) public view returns (bool) {
    return merchants[merchant].isRegistered;
}

    function getMerchantInfo(address walletAddress) external view returns (bool isRegistered, bool isPremium, uint256 registrationDate, uint256 storeCount, address[] memory acceptedTokens) {
        Merchant storage merchant = merchants[walletAddress];
        return (merchant.isRegistered, merchant.isPremium, merchant.registrationDate, merchant.storeCount, merchant.acceptedTokens);
    }

    function getMerchantCount() external view returns (uint256) {
        return merchantAddresses.length;
    }

    function updateAcceptedTokens(address walletAddress, address[] calldata newTokens) external {
        require(msg.sender == walletAddress, "Unauthorized: can only update your own tokens");
        require(merchants[walletAddress].isRegistered, "Merchant not registered.");
        merchants[walletAddress].acceptedTokens = newTokens;
    }
}
