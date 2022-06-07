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
      "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/QmNQ961w7NG7rsBu6NnjyLcdTwhHNwdo9jTM8xt4ym2qg4", //IPFS
      25,
      "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"  // Artist Address
      )



    console.log(nft.address);
    assert.isOk(nft.address);
  });
  it("Account Deploy Artist is Equal a Account Constructor", async function () {
    const nftFactory = await ethers.getContractFactory("NFT");
    const account = '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199' // Artist
    const nft = await nftFactory.deploy(
      "NFT_Test",
      "EST",
      "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/QmNQ961w7NG7rsBu6NnjyLcdTwhHNwdo9jTM8xt4ym2qg4",
      25,
      account
      )
      const Artist = await nft.artist()
      assert.equal(Artist, account)
    
  
  });
});
