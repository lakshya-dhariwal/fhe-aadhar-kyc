// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Deploy the AnonAadhaar verifier contract
  const AnonAadhaarVerifier = await hre.ethers.getContractFactory("AnonAadhaarVerifier");
  const anonAadhaarVerifier = await AnonAadhaarVerifier.deploy();

  await anonAadhaarVerifier.waitForDeployment();
  const anonAadhaarVerifierAddress = await anonAadhaarVerifier.getAddress();

  console.log("AnonAadhaarVerifier deployed to:", anonAadhaarVerifierAddress);


  // Deploy the KYCAMLData contract
  const KYCAMLData = await hre.ethers.getContractFactory("KYCAMLData");
  const kycAMLData = await KYCAMLData.deploy(anonAadhaarVerifierAddress);

  await kycAMLData.waitForDeployment();
  const kycAMLDataAddress = await kycAMLData.getAddress();

  console.log("KYCAMLData deployed to:", kycAMLDataAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});