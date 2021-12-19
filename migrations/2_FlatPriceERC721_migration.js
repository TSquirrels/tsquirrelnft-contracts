const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const FlatPriceERC721 = artifacts.require("FlatPriceERC721");

module.exports = async function (deployer) {
  const instance = await deployProxy(FlatPriceERC721, ["TSquirrel NFT", "TSQRNFT", "30000000000000000000", 2500], { deployer });
};
