const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const TSquirrelNFT = artifacts.require("TSquirrelNFT");

module.exports = async function (deployer) {
  const metadata = [];
  const instance = await deployProxy(TSquirrelNFT,["TSquirrelNFT","TSQRLNFT","49000000000000000000",150, metadata],{deployer});
};
