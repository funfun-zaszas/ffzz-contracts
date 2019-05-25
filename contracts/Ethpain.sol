pragma solidity ^0.5.0;

import "./WitnetBridgeInterface.sol";

contract Ethpain {

  WitnetBridgeInterface wbi;

  address owner;
  string public name;
  // bytes public election_wdr;

  struct Program {
    uint256[] percentage;
    uint256[] id_proposal;
  }

  uint256 proposal_counter;
  mapping (uint256 => string) proposal_map;
  mapping (address => string) party_map;
  mapping (address => Program) program_map;

  constructor (address _wbi, string memory _name) public payable {
    wbi = WitnetBridgeInterface(_wbi);
    owner = msg.sender;
    name = _name;
    // election_wdr = _election_wdr;
    // wbi.post_dr(election_wdr);
  }

  function create_party(address party_address, string memory party_name) public {
    party_map[party_address] = party_name;
  }

  function read_party(address party_address) public view returns(string memory party_name) {
    return party_map[party_address];
  }

  function create_proposal(string memory new_proposal) public returns(uint256 id) {
    id = proposal_counter++;
    proposal_map[id] = new_proposal;

    return id;
  }

  function read_proposal(uint256 id) public view returns(string memory proposal) {
    return proposal_map[id];
  }

  function create_program(uint256[] memory id_proposal, uint256[] memory percentage) public {
    program_map[msg.sender].id_proposal = id_proposal;
    program_map[msg.sender].percentage = percentage;
  }


}
