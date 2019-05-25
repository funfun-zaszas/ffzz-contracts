const Ethpain = artifacts.require("Ethpain")
const WBI = artifacts.require("WitnetBridgeInterface")

contract("Ethpain", accounts => {
  describe("Ethpain test suite", () => {
    let ethpain
    let wbi
    before(async () => {
      wbi = await WBI.deployed()
      ethpain = await Ethpain.deployed()
    })

    it("should have some ETH", async () => {
      assert.equal(await ethpain.name.call(), "ethpain")
      // assert.equal(await ethpain.election_wdr.call(), "winner_witnet_dr")
      assert.equal(await web3.eth.getBalance(ethpain.address), web3.utils.toWei("1", "ether"))
    })

    it("should create party", async () => {
      await ethpain.create_party(web3.utils.utf8ToHex("VOX"), "📦", "El partido de las cajas", "KAJA", "dr_kaja")
      let party = await ethpain.read_party(accounts[0])
      assert.equal(party.fake_name, "KAJA")
    })

    it("should list registered parties", async () => {
      await ethpain.create_party(web3.utils.utf8ToHex("Cs"), "🍊", "Vaaaaaamoooos!", "COKE", "dr_coke", { from: accounts[1] })

      assert.equal((await ethpain.read_party(accounts[0])).fake_name, "KAJA")
      assert.equal((await ethpain.list_parties.call()).length, 2)
    })

    it("should create proposal", async () => {
      await ethpain.create_proposal("My new proposal", "My new dr 1")
      let proposal = await ethpain.read_proposal(0)
      assert.equal(proposal.description, "My new proposal")
      assert.equal(proposal.dr, "My new dr 1")
    })

    it("should create program with proposals", async () => {
      let proposals = ["My new proposal 1", "My new proposal 2", "My new proposal 3"]
      let data_requests = ["My new dr 1", "My new dr 2", "My new dr 3"]
      let proposalIds = [0, 1, 2]
      let percentages = [50, 25, 25]
      await ethpain.create_proposal(proposals[0], data_requests[0])
      await ethpain.create_proposal(proposals[1], data_requests[1])
      await ethpain.create_proposal(proposals[2], data_requests[2])

      await ethpain.create_program(proposalIds, percentages)

      let program = await ethpain.read_program.call(accounts[0])
      assert.equal(program.proposal_ids.length, program.percentages.length)
      for (let i = 0; i < program.proposal_ids.length; i++) {
        assert.equal(program.proposal_ids[i].toNumber(), proposalIds[i])
        assert.equal(program.percentages[i].toNumber(), percentages[i])
      }
    })

    it("create a proposal and post result", async () => {
      await ethpain.create_proposal("My new proposal", "My new dr 1")
      await wbi.report_result(0, true)
      assert.equal(await ethpain.read_proposal_result(0), true)
    })

    it("post an election seat results", async () => {
      assert.equal((await ethpain.read_party(accounts[0])).seats, 0)
      assert.equal((await ethpain.read_party(accounts[1])).seats, 0)
      await ethpain.create_elections()
      await wbi.report_result_election(5, 175)
      await wbi.report_result_election(6, 56)
      await ethpain.update_seats()
      assert.equal((await ethpain.read_party(accounts[0])).seats, 175)
      assert.equal((await ethpain.read_party(accounts[1])).seats, 56)
    })

    it("claims funds for a complete proposal", async () => {
      var account1 = accounts[0]
      let prevBalance = await web3.eth.getBalance(account1)

      let txHash = await waitForHash(ethpain.claim_funds(0))
      await web3.eth.getTransactionReceipt(txHash)

      let postBalance = await web3.eth.getBalance(account1)
      assert(postBalance > prevBalance)
    })
  })
})

const waitForHash = txQ =>
  new Promise((resolve, reject) =>
    txQ.on("transactionHash", resolve).catch(reject)
  )
