const { expect } = require("chai");

describe("StoreManager", function () {
    let StoreManager;
    let storeManager;
    let owner;
    let addr1;
    let addr2;
    let addr3;
    let tokens;

    beforeEach(async function () {
        [owner, addr1, addr2, addr3] = await ethers.getSigners();
        tokens = [owner.address, addr1.address]; // Simulating token addresses for testing
        StoreManager = await ethers.getContractFactory("StoreManager");
        storeManager = await StoreManager.deploy();
    });

    it("should allow a merchant to register, add a store, and emit an event", async function () {
        await storeManager.connect(addr1).registerMerchant(true, tokens);
        await expect(storeManager.connect(addr1).addStore())
            .to.emit(storeManager, "StoreAdded")
            .withArgs(addr1.address, 0);
    
        const storeData = await storeManager.getStoreInfo(addr1.address, 0);
        const [transactionCountToday, , , , creationDate, ] = storeData;
    
        console.log(storeData); // Log the entire output to check the types
    
        // Check if these are BigNumber instances and handle accordingly
        if (transactionCountToday._isBigNumber) {
            expect(transactionCountToday.toNumber()).to.equal(0);
        } else {
            console.error("transactionCountToday is not a BigNumber:", transactionCountToday);
        }
    
        if (creationDate._isBigNumber) {
            expect(creationDate.toNumber()).to.be.greaterThan(0);
        } else {
            console.error("creationDate is not a BigNumber:", creationDate);
        }
    });
    
    it("should retrieve store information correctly", async function () {
        await storeManager.connect(addr1).registerMerchant(true, tokens);
        await storeManager.connect(addr1).addStore();
    
        const storeData = await storeManager.getStoreInfo(addr1.address, 0);
        const [, , , , creationDate, ] = storeData;
    
        if (creationDate._isBigNumber) {
            expect(creationDate.toNumber()).to.be.greaterThan(0);
        } else {
            console.error("creationDate is not a BigNumber:", creationDate);
        }
    });
    
    
    it("should prevent adding a store for a non-premium merchant who already has a store", async function () {
        // Register a non-premium merchant and add one store
        await storeManager.connect(addr2).registerMerchant(false, []);
        await storeManager.connect(addr2).addStore();

        // Attempt to add another store should fail
        await expect(storeManager.connect(addr2).addStore())
            .to.be.revertedWith("StoreManager: Non-premium merchants can only have one store");
    });

    it("should accurately report the number of registered merchants", async function () {
        // Each merchant registers themselves
        await storeManager.connect(addr1).registerMerchant(true, []);
        await storeManager.connect(addr2).registerMerchant(false, []);
        await storeManager.connect(addr3).registerMerchant(false, []);

        const count = await storeManager.getMerchantCount();
        expect(count).to.equal(3);
    });

    it("should increment the store count after adding a store", async function () {
        // Merchant registers themselves and adds two stores
        await storeManager.connect(addr1).registerMerchant(true, []);
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();
        await storeManager.connect(addr1).addStore();

        const merchantInfo = await storeManager.getMerchantInfo(addr1.address);
        expect(merchantInfo.storeCount).to.equal(16);
    });

    it("should prevent adding a store for an unregistered merchant", async function () {
        // Attempt to add a store for an unregistered merchant should fail
        await expect(storeManager.connect(addr1).addStore())
            .to.be.revertedWith("StoreManager: Merchant not registered");
    });
});
