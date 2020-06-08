const YeeCoin = artifacts.require("YeeCoin");

module.exports = function(deployer) {
  deployer.deploy(YeeCoin);
};
