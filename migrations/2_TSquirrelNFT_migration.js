const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const TSquirrelNFT = artifacts.require("TSquirrelNFT");

module.exports = async function (deployer) {
  const instance = await deployProxy(TSquirrelNFT, ["TSquirrel NFT", "TSQRNFT", "30000000000000000000", 2500], { deployer });
};
