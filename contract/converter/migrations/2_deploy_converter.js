const Converter = artifacts.require("Converter");

module.exports = function(deployer) {
  deployer.deploy(Converter, "0xB5de6e68ce4Da88502Be00addd6F33Bc1B5A255b");
};
