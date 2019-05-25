const Ethpain = artifacts.require("Ethpain")

contract("Ethpain", accounts => {
  describe("Ethpain test suite", () => {
    let ethpain
    before(async () => {
      ethpain = await Ethpain.deployed()
    })

    it("should salute (async)", async () => {
      assert.equal(await ethpain.name.call(), "ethpain")
      // assert.equal(await ethpain.election_wdr.call(), "winner_witnet_dr")
      assert.equal(await web3.eth.getBalance(ethpain.address), web3.utils.toWei("1", "ether"))
    })

    it("should test maps (async)", async () => {
      ethpain.create_party(accounts[0], "KAJA")
      assert.equal(await ethpain.read_party(accounts[0]), "KAJA")

      await ethpain.create_proposal("My new proposal")
      assert.equal(await ethpain.read_proposal.call(0), "My new proposal")
    })
  })
})
