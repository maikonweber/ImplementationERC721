// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.


  const nftFactory = await hre.ethers.getContractFactory("NFT");
  const nft = await nftFactory.deploy(
    "NFT",
    "NFT",
    
  )
 
  
    
  

}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
