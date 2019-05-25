const Ethpain = artifacts.require("Ethpain")
const WBI = artifacts.require("./WitnetBridgeInterface.sol")

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
      await ethpain.create_party("VOX", "📦", "El partido de las cajas", "KAJA")
      let party = await ethpain.read_party(accounts[0])
      assert.equal(party.fake_name, "KAJA")
    })

    it("should list registered parties", async () => {
      await ethpain.create_party("Cs", "🍊", "Vaaaaaamoooos!", "COKE", { from: accounts[1] })

      assert.equal((await ethpain.read_party(accounts[0])).fake_name, "KAJA")
      assert.equal((await ethpain.list_parties.call()).length, 2)
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

      await ethpain.create_program(proposalIds, percentages)

      let program = await ethpain.read_program.call(accounts[0])
      assert.equal(program.proposal_ids.length, program.percentages.length)
      for (i = 0; i < program.proposal_ids.length; i++) {
        assert.equal(program.proposal_ids[i].toNumber(), proposalIds[i])
        assert.equal(program.percentages[i].toNumber(), percentages[i])
      }
    })

    it("create a proposal and post result", async ()=> {
      let proposal = "My new proposal";
      await ethpain.create_proposal(proposal)

      let bool_result = true
      await ethpain.post_proposal_result(0, bool_result)

      assert.equal(await ethpain.read_proposal_result(0), true)

    })

    it("post an election seat results", async ()=> {
      let parties = ["Cs", "VOX"]
      let seats = ["56", "20"]

      assert.equal((await ethpain.read_party(accounts[0])).seats, "0")
      assert.equal((await ethpain.read_party(accounts[1])).seats, "0")

      await.ethpain.post_seats(parties, seats)

      assert.equal((await ethpain.read_party(accounts[0])).seats, "20")
      assert.equal((await ethpain.read_party(accounts[1])).seats, "56")

    })


  })
})
