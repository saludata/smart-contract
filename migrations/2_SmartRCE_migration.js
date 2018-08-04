var SmartRCE = artifacts.require("SmartRCE");

module.exports = function(deployer) {
  // In deploy prod, eliminate address ora 0x6f485c8bf6fc43ea212e93bbf8ce046c7f1cb475 localhost
  deployer.deploy(SmartRCE, "95104ab471534af08683aefa7d0935a3", 0x6f485c8bf6fc43ea212e93bbf8ce046c7f1cb475);
};

