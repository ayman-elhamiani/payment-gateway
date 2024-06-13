// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// import "./StoreManager.sol";
// import "./interfaces/IPaymentProcessor.sol";

// contract PaymentProcessor is StoreManager, IPaymentProcessor {
//     uint256 public feePercentage = 1; // 1% fee
//     uint256 public basicTransactionLimit = 100; 


//     event PaymentProcessed(address indexed merchant, uint256 storeId, uint256 amount, uint256 fee);

//     function processPayment(address walletAddress, uint256 storeId, address tokenAddress, uint256 amount) public payable {
//         require(isMerchantAndStoreValid(walletAddress, storeId), "Merchant or store not registered.");
//         // require(isTokenAccepted(walletAddress, tokenAddress), "Token not accepted by merchant.");
//         require(amount > 0, "Payment amount must be zero.");

//         handleTransactionLimits(walletAddress, storeId);
//         updateTransactionMetrics(walletAddress, storeId, amount);

//         uint256 fee = calculateFee(amount);
//         transferFunds(walletAddress, fee, amount - fee);

//         emit PaymentProcessed(walletAddress, storeId, amount, fee);
//     }

//     function isMerchantAndStoreValid(address walletAddress, uint256 storeId) internal view returns (bool) {
//         return merchants[walletAddress].isRegistered && merchants[walletAddress].stores[storeId].creationDate > 0;
//     }

//     function handleTransactionLimits(address walletAddress, uint256 storeId) internal {
//         if (!merchants[walletAddress].isPremium) {
//             require(merchants[walletAddress].stores[storeId].transactionCountToday < basicTransactionLimit, "Daily transaction limit reached.");
//             merchants[walletAddress].stores[storeId].transactionCountToday++;
//         }
//     }

//     function updateTransactionMetrics(address walletAddress, uint256 storeId, uint256 amount) internal {
//         merchants[walletAddress].stores[storeId].transactionVolumeToday += amount;
//         merchants[walletAddress].stores[storeId].totalTransactionCount++;
//         merchants[walletAddress].stores[storeId].totalTransactionVolume += amount;
//         merchants[walletAddress].stores[storeId].lastTransactionDate = block.timestamp;
//     }

//     function calculateFee(uint256 amount) internal view returns (uint256) {
//         return (amount * feePercentage) / 100;
//     }

//     function transferFunds(address walletAddress, uint256 fee, uint256 paymentToMerchant) internal {
//         payable(owner).transfer(fee);
//         payable(walletAddress).transfer(paymentToMerchant);
//     }
// }
