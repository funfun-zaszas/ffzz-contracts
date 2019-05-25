pragma solidity ^0.5.0;

import "./WitnetBridgeInterface.sol";

contract Ethpain {

  WitnetBridgeInterface wbi;

  address owner;
  string public name;
  // bytes public election_wdr;

  struct Program {
    uint[] percentages;
    uint256[] id_proposals;
  }

  address[] public parties;

  mapping (address => string) party_map;
  mapping (address => Program) program_map;

  mapping (uint256 => string) proposal_map;
  mapping (uint256 => bool) proposal_success;

  constructor (address _wbi, string memory _name) public payable {
    wbi = WitnetBridgeInterface(_wbi);
    owner = msg.sender;
    name = _name;
    // election_wdr = _election_wdr;
    // wbi.post_dr(election_wdr);
  }

  function create_party(string memory party_name) public {
    parties.push(msg.sender);
    party_map[msg.sender] = party_name;
  }

  function read_party(address party_address) public view returns(string memory party_name) {
    return party_map[party_address];
  }

  function create_proposal(string memory new_proposal) public returns(uint256 id) {
    uint256 dr_id = wbi.post_dr(new_proposal);
    proposal_map[dr_id] = new_proposal;
    return dr_id;
  }

  function read_proposal(uint256 id) public view returns(string memory proposal) {
    return proposal_map[id];
  }

  function create_program(uint256[] memory id_proposals, uint256[] memory percentages) public {
    program_map[msg.sender].id_proposals = id_proposals;
    program_map[msg.sender].percentages = percentages;
  }

  function list_parties() public view returns (address[] memory _parties) {
    return parties;
  }

  function read_program(address party_address) public view returns(uint256[] memory proposal_ids, uint[] memory percentages) {
    return (program_map[party_address].id_proposals, program_map[party_address].percentages);
  }

  function post_proposal_result(uint256 proposal_id, bool bool_result) public {
    proposal_success[proposal_id] = bool_result;
  }

  function read_proposal_result(uint256 id) public view returns(bool bool_result) {
    return proposal_success[id];
  }
}
