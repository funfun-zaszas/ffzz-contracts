var WBI = artifacts.require("./WitnetBridgeInterface.sol")
var Ethpain = artifacts.require("./Ethpain.sol")

module.exports = function (deployer, network, accounts) {
  console.log("Network:", network)
  deployer.deploy(WBI)
  deployer.deploy(Ethpain, "ethpain", "winner_witnet_dr", { value: web3.utils.toWei("1", "ether") })
}
