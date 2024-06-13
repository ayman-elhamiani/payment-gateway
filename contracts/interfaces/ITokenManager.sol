// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ITokenManager {
    function addAcceptedToken(address merchant, address token) external;
    function removeAcceptedToken(address merchant, address token) external;
    function isTokenAccepted(address merchant, address token) external view returns (bool);
    function viewAcceptedTokens(address merchant) external view returns (address[] memory);
}
