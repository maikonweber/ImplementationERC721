// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  const accounts = await hre.ethers.getSigners();
  const deployer = accounts[0].address;
  console.log(deployer)
 

  const nftFactory = await hre.ethers.getContractFactory("NFT");
  const nft = await nftFactory.deploy(
    "NFT",
    "NFT",
    "https://dweb.link/ipns/gateway.pinata.cloud/ipfs/",
    25,
    deployer
  )

  const deployed  =  await nft.deployed();
  console.log(nft.address)

  const nftAddress = nft.address;
  console.log(nftAddress)
  const mint = await nft.mint(deployer, 50);
  console.log(mint, "mint")
  const balance = await nft.balanceOf(deployer)
  console.log(balance, "balance")
  const owner = await nft.ownerOf(1)
  console.log(owner, "owner")
  const transfer = await nft.safeTransferFrom(deployer, accounts[1].address, 1)
  console.log(transfer, "transfer")
  const balance2 = await nft.balanceOf(accounts[1].address)
  console.log(balance2, "balance2")

  console.log(await nft.owner() , "Dono")
    
  

}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
