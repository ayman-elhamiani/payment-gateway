const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenManager", function () {
    let TokenManager;
    let tokenManager;
    let owner;
    let merchant;
    let otherAccount;
    let tokenAddress;

    beforeEach(async function () {
        // Deploy the contract
        [owner, merchant, otherAccount] = await ethers.getSigners();
        TokenManager = await ethers.getContractFactory("TokenManager");
        tokenManager = await TokenManager.deploy();
        tokenAddress = ethers.Wallet.createRandom().address;  // Mock token address
    });

    async function registerMerchant(merchantAddress) {
        await tokenManager.connect(merchantAddress.Wallet).registerMerchant(true, [], {from: merchantAddress});
    }

    // 2. Tests for Token Support Management

    it("should allow the owner to support a new token", async function () {
        await expect(tokenManager.connect(owner).supportNewToken(tokenAddress))
            .to.emit(tokenManager, "TokenSupported")
            .withArgs(tokenAddress);
        expect(await tokenManager.supportedTokens(tokenAddress)).to.equal(true);
    });

    it("should prevent non-owners from supporting a new token", async function () {
        await expect(tokenManager.connect(otherAccount).supportNewToken(tokenAddress))
            .to.be.revertedWith("Only the owner can perform this action");
    });

    it("should allow the owner to stop supporting a token", async function () {
        await tokenManager.connect(owner).supportNewToken(tokenAddress);
        await expect(tokenManager.connect(owner).stopSupportingToken(tokenAddress))
            .to.emit(tokenManager, "TokenUnsupported")
            .withArgs(tokenAddress);
        expect(await tokenManager.supportedTokens(tokenAddress)).to.equal(false);
    });

    // 3. Tests for Managing Merchant Accepted Tokens

    it("should allow registered merchants to add an accepted token", async function () {
        console.log("Contract owner address:", await tokenManager.owner());
        console.log("Merchant address:", merchant.address);
        await registerMerchant(merchant.address,true);
        console.log("3333Merchant address:", merchant.address);
        await tokenManager.connect(owner).supportNewToken(tokenAddress);
        console.log("4444Merchant address:", merchant.address);
        await expect(tokenManager.connect(merchant).addAcceptedToken(merchant.address, tokenAddress))
            .to.emit(tokenManager, "TokenAdded")
            .withArgs(merchant.address, tokenAddress);
    });
    

    it("should prevent unregistered merchants from adding a token", async function () {
        await tokenManager.connect(owner).supportNewToken(tokenAddress);
        await expect(tokenManager.connect(merchant).addAcceptedToken(merchant.address, tokenAddress))
            .to.be.revertedWith("Merchant not registered.");
    });

    it("should prevent adding unsupported tokens", async function () {
        await registerMerchant(merchant.address);
        await expect(tokenManager.connect(merchant).addAcceptedToken(merchant.address, tokenAddress))
            .to.be.revertedWith("Token not supported by the platform");
    });
    it("should allow removing an accepted token", async function () {
        await registerMerchant(merchant.address);
        await tokenManager.connect(owner).supportNewToken(tokenAddress);
        await tokenManager.connect(merchant).addAcceptedToken(merchant.address, tokenAddress);
        await expect(tokenManager.connect(merchant).removeAcceptedToken(merchant.address, tokenAddress))
            .to.emit(tokenManager, "TokenRemoved")
            .withArgs(merchant.address, tokenAddress);
        expect(await tokenManager.isTokenAccepted(merchant.address, tokenAddress)).to.equal(false);
    });


});