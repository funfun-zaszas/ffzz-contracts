var WBI = artifacts.require("./WitnetBridgeInterface.sol")
var Ethpain = artifacts.require("./Ethpain.sol")

module.exports = function (deployer, network, accounts) {
  console.log("Network:", network)
  deployer.deploy(Ethpain, WBI.address, "ethpain",  web3.utils.fromAscii("winner_witnet_dr"), { value: web3.utils.toWei("1", "ether") })
}
