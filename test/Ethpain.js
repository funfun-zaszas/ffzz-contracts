const Ethpain = artifacts.require("Ethpain")

contract("Ethpain", accounts => {
  describe("Ethpain test suite", () => {
    let ethpain
    before(async () => {
      ethpain = await Ethpain.deployed()
    })

    it("should have some ETH", async () => {
      assert.equal(await ethpain.name.call(), "ethpain")
      // assert.equal(await ethpain.election_wdr.call(), "winner_witnet_dr")
      assert.equal(await web3.eth.getBalance(ethpain.address), web3.utils.toWei("1", "ether"))
    })

    it("should create party", async () => {
      await ethpain.create_party("KAJA")
      assert.equal(await ethpain.read_party(accounts[0]), "KAJA")
    })

    it("should list registered parties", async () => {
      await ethpain.create_party("WECAN", { from: accounts[1] })
      await ethpain.create_party("JOSE", { from: accounts[2] })
      await ethpain.create_party("ROSE", { from: accounts[3] })
      await ethpain.create_party("COKE", { from: accounts[4] })

      assert.equal(await ethpain.read_party(accounts[0]), "KAJA")
      assert.equal((await ethpain.list_parties.call()).length, 5)
    })

    it("should create proposal", async () => {
      await ethpain.create_proposal("My new proposal")
      assert.equal(await ethpain.read_proposal.call(0), "My new proposal")
    })

    it("should create program with proposals", async () => {
      let proposals = ["My new proposal 1", "My new proposal 2", "My new proposal 3"]
      let proposalIds = [0, 1, 2]
      let percentages = [50, 25, 25]
      await ethpain.create_proposal(proposals[0])
      await ethpain.create_proposal(proposals[1])
      await ethpain.create_proposal(proposals[2])

      await ethpain.create_party("KAJA")
      await ethpain.create_program(proposalIds, percentages)

      assert.equal(await ethpain.read_program_percentages(accounts[0]), percentages)
      assert.equal(await ethpain.read_program_proposals(accounts[0]), proposal_ids)
    })
  })
})
