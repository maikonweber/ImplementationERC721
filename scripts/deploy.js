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
 
  console.log(await nft.owner() , "Dono")
    
  

}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
