// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// import "./MerchantManager.sol";
// import "./TokenManager.sol";
// import "./StoreManager.sol";
// import "./PaymentProcessor.sol";

// contract PaymentGateway is MerchantManager, TokenManager, StoreManager, PaymentProcessor {
//     address public btcTokenAddress;
//     uint256 public lastResetTimestamp;

//     constructor(address _btcTokenAddress) {
//         owner = msg.sender;
//         btcTokenAddress = _btcTokenAddress;
//         lastResetTimestamp = block.timestamp;
//     }
// }
