// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IPaymentProcessor {
    function processPayment(address walletAddress, uint256 storeId, address tokenAddress, uint256 amount) external payable;
}
