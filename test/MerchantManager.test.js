const { expect } = require("chai");

describe("MerchantManager", function () {
    let MerchantManager;
    let merchantManager;
    let owner;
    let addr1;
    let addr2;
    let addr3;
    let tokens;

    beforeEach(async function () {
        [owner, addr1, addr2, addr3] = await ethers.getSigners();
        tokens = [owner.address, addr1.address]; 
        MerchantManager = await ethers.getContractFactory("MerchantManager");
        merchantManager = await MerchantManager.deploy();
    });

    it("should allow a merchant to self-register and emit an event", async function () {
        await expect(merchantManager.connect(addr1).registerMerchant(true, tokens))
            .to.emit(merchantManager, "MerchantRegistered")
            .withArgs(addr1.address, true);
    });

    it("should allow viewing registered merchant information", async function () {
        await merchantManager.connect(addr1).registerMerchant(true, tokens);
        const info = await merchantManager.getMerchantInfo(addr1.address);
        expect(info.isRegistered).to.equal(true);
        expect(info.isPremium).to.equal(true);
        expect(info.storeCount).to.equal(0);
        expect(info.acceptedTokens).to.deep.equal(tokens);
    });

    it("should accurately report the number of registered merchants", async function () {
        await merchantManager.connect(addr1).registerMerchant(true, []);
        await merchantManager.connect(addr2).registerMerchant(false, []);
        await merchantManager.connect(addr3).registerMerchant(false, []);

        const count = await merchantManager.getMerchantCount();
        expect(count).to.equal(3);
    });

    it("should prevent unauthorized actions", async function () {

        await expect(merchantManager.connect(addr1).registerMerchant(true, tokens))
            .to.emit(merchantManager, "MerchantRegistered")
            .withArgs(addr1.address, true);
        await expect(merchantManager.connect(addr1).registerMerchant(false, []))
            .to.be.revertedWith("Merchant already registered.");
    });

    it("should prevent duplicate registrations of the same merchant", async function () {
        await merchantManager.connect(addr1).registerMerchant(true, []);
        await expect(merchantManager.connect(addr1).registerMerchant(true, []))
            .to.be.revertedWith("Merchant already registered.");
    });
});
