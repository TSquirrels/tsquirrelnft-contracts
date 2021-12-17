const FlatPriceERC721 = artifacts.require("FlatPriceERC721");

module.exports = function (deployer) {
  deployer.deploy(FlatPriceERC721, "TSquirrel NFT", "TSQRNFT", "2500");
};
