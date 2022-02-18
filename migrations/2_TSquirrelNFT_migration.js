const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const TSquirrelNFT = artifacts.require("TSquirrelNFT");

module.exports = async function (deployer) {
  const metadata = []; // HIDE IN REPO
  const instance = await deployProxy(TSquirrelNFT, ["TSquirrel NFT", "TSQRLNFT", "30000000000000000000", 150, metadata], { deployer });
};
