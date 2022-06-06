const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const nft = await ethers.getContractFactory("nftRoyatics721");
    const recipients = '0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e'
    const nfts = await nft.deploy(17, 'https://royatics.com/');
    await nfts.deployed();
  });
});
