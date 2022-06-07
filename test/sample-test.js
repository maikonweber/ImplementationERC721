var chai = require("chai");
const { ethers } = require("hardhat");
const expect = chai.expect;
const assert = chai.assert;

describe("ERC721 With royalties",()=>{
    let deployer
    let nft
    let instance
    let recipient
    beforeEach(async()=>{
        const [deployerOBJ, recipientOBJ] = await ethers.getSigners()
        deployer = deployerOBJ.address
        recipient = recipientOBJ.address
        nft = await ethers.getContractFactory("NFT")
        instance = await nft.deploy()
    })
    it("It's possible to mint tokens",async()=>{
      await instance.mint(recipient)
    })
    it("It's to set royalties",async()=>{
      await instance.setRoyalties(0, deployer, 1000)
      let royalties = await instance.getRaribleV2Royalties(0)
        assert.equal(royalties[0].value, "1000")
        assert.equal(royalties[0].account, deployer)
    })
    it("Works with ERC2981 royalties", async()=>{
        await instance.setRoyalties(0, deployer, 1000)
         let royalties = await instance.royaltyInfo(0,10000)
        assert.equal(royalties.royaltyAmount.toString(), "1000")
        assert.equal(royalties.receiver, deployer)
    })
})