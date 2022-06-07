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

    var nftAddress = await nft.address;
      
    console.log("NFT Address: " + nftAddress);
    console.log(nft.address);
    assert.isOk(nft.address);
  
    })
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
  
    })
  it('returns the royality Fee', async () => {
    const nftFactory = await ethers.getContractFactory("NFT");
    const nft = await nftFactory.deploy(
      "NFT_Test",
      "EST",
      "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/QmNQ961w7NG7rsBu6NnjyLcdTwhHNwdo9jTM8xt4ym2qg4",
      25,
      "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
      )
      const royalityFee = await nft.royalityFee()
      assert.equal(royalityFee, 25)
 
    })

  it('sets the royality fee',  async () => {
    const newRoyalityFee = 50
    const nftFactory = await ethers.getContractFactory("NFT");
    const nft = await nftFactory.deploy(
      "NFT_Test",
      "EST",
      "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/QmNQ961w7NG7rsBu6NnjyLcdTwhHNwdo9jTM8xt4ym2qg4",
      25,
      "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
      )

      await nft.setRoyalityFee(newRoyalityFee)

      const royalityFee = await nft.royalityFee()

      assert.equal(royalityFee, newRoyalityFee)

    })
  })

  describe('mint nft', async () => {
    it('returns royalties', async () => {
      const nftFactory = await ethers.getContractFactory("NFT");

      const account = "0xdD2FD4581271e230360230F9337D5c0430Bf44C0"

      const salePrice = ethers.utils.parseEther('1')

      const nft = await nftFactory.deploy(
        "NFT_Test",
        "EST",
        "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/QmNQ961w7NG7rsBu6NnjyLcdTwhHNwdo9jTM8xt4ym2qg4",
        25,
        "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
        )

         console.log(await nft.mint())

      })
      

       

    })