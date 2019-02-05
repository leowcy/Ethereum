var Phonebookbyname = artifacts.require("./Phonebookbyname.sol");

module.exports = function(deployer) {
  deployer.deploy(Phonebookbyname);
};
