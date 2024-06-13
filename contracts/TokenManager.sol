// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "hardhat/console.sol";  // Add this line
import "./MerchantManager.sol";
import "./interfaces/ITokenManager.sol";

contract TokenManager is MerchantManager, ITokenManager {
    mapping(address => bool) public supportedTokens; // Global list of supported tokens
    mapping(address => address[]) public merchantAcceptedTokens; // Tokens accepted by each merchant

    event TokenSupported(address token);
    event TokenUnsupported(address token);
    event TokenAdded(address indexed merchant, address token);
    event TokenRemoved(address indexed merchant, address token);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function supportNewToken(address token) public onlyOwner {
        require(!supportedTokens[token], "Token already supported");
        supportedTokens[token] = true;
        emit TokenSupported(token);
    }

    function stopSupportingToken(address token) public onlyOwner {
        require(supportedTokens[token], "Token not supported");
        supportedTokens[token] = false;
        emit TokenUnsupported(token);
    }

    function addAcceptedToken(address merchant, address token) public {
        console.log("Owner:", owner);
        console.log("Sender:", msg.sender);
        require(isMerchantRegistered(merchant), "Merchant not registered.");
        require(msg.sender == merchant || msg.sender == owner, "Unauthorized");
        require(supportedTokens[token], "Token not supported by the platform");
        require(!isTokenAccepted(merchant, token), "Token already accepted.");

        merchantAcceptedTokens[merchant].push(token);
        emit TokenAdded(merchant, token);
    }

    function removeAcceptedToken(address merchant, address token) public {
        require(isMerchantRegistered(merchant), "Merchant not registered.");
        require(msg.sender == merchant || msg.sender == owner, "Unauthorized");
        require(isTokenAccepted(merchant, token), "Token not accepted.");

        address[] storage tokens = merchantAcceptedTokens[merchant];
        for (uint i = 0; i < tokens.length; i++) {
            if (tokens[i] == token) {
                tokens[i] = tokens[tokens.length - 1];
                tokens.pop();
                emit TokenRemoved(merchant, token);
                break;
            }
        }
    }

    function isTokenAccepted(address merchant, address token) public view returns (bool) {
        address[] memory tokens = merchantAcceptedTokens[merchant];
        for (uint i = 0; i < tokens.length; i++) {
            if (tokens[i] == token) {
                return true;
            }
        }
        return false;
    }

    function viewAcceptedTokens(address merchant) public view returns (address[] memory) {
        require(isMerchantRegistered(merchant), "Merchant not registered.");
        return merchantAcceptedTokens[merchant];
    }
}
