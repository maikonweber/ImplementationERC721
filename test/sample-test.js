var chai = require("chai");
const { ethers } = require("hardhat");
const expect = chai.expect;
const assert = chai.assert;

describe("NFT TEST ", function () {
  it("Should deploy NFT contract", async function () {
    const nftFactory = await ethers.getContractFactory("NFT");
    const nft = await nftFactory.deploy(
      "NFT_Test",
      "EST",
      "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/QmNQ961w7NG7rsBu6NnjyLcdTwhHNwdo9jTM8xt4ym2qg4",
      25,
      "0xdD2FD4581271e230360230F9337D5c0430Bf44C0")

    console.log(nft.address);
    assert.isOk(nft.address);
  });
});
