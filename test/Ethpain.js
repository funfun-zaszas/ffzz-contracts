const Ethpain = artifacts.require("Ethpain")

contract("Ethpain", _accounts => {
  describe("Ethpain test suite", () => {
    let ethpain
    before(async () => {
      ethpain = await Ethpain.deployed()
    })

    it("should salute (async)", async () => {
      assert.equal(await ethpain.name.call(), "ethpain")
      assert.equal(await ethpain.election_wdr.call(), "winner_witnet_dr")

      assert.equal(await web3.eth.getBalance(ethpain.address), web3.utils.toWei("1", "ether"))
    })
  })
})
