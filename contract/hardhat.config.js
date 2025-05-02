/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox")
require('hardhat-dependency-compiler');

module.exports = {
  solidity: '0.8.24',
  dependencyCompiler: {
    paths: [
      '@anon-aadhaar/contracts/src/AnonAadhaar.sol'
    ],
  },
};
