pragma solidity ^0.5.0;

import "./WitnetBridgeInterface.sol";

contract Ethpain {

  WitnetBridgeInterface wbi;

  address owner;
  string public name;
  uint total_seats;
  // bytes public election_wdr;

  struct Party {
    bytes32 label;
    string fake_name;
    string emoji;
    string description;
    uint seats;
  }

  struct Program {
    uint[] percentages;
    uint256[] id_proposals;
  }

  address[] public parties;
  mapping (bytes32 => address) party_addresses;

  mapping (address => Party) party_map;
  mapping (address => Program) program_map;

  mapping (uint256 => string) proposal_map;
  mapping (uint256 => bool) proposal_success;

  constructor (address _wbi, string memory _name, uint _seats) public payable {
    total_seats = _seats;
    wbi = WitnetBridgeInterface(_wbi);
    owner = msg.sender;
    name = _name;
    // election_wdr = _election_wdr;
    // wbi.post_dr(election_wdr);
  }

  function create_party(bytes32 _label, string memory _emoji, string memory _description, string memory _fake_name) public {
    parties.push(msg.sender);
    party_map[msg.sender].label = _label;
    party_map[msg.sender].emoji = _emoji;
    party_map[msg.sender].description = _description;
    party_map[msg.sender].fake_name = _fake_name;
    party_map[msg.sender].seats = 0;
    party_addresses[_label] = msg.sender;
  }

  function read_party(address party_address) public view returns(bytes32 label, string memory emoji, string memory description, string memory fake_name, uint seats) {
    return (party_map[msg.sender].label, party_map[msg.sender].emoji, party_map[msg.sender].description, party_map[party_address].fake_name, party_map[party_address].seats);
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

  function post_seats(bytes32[] memory _labels, uint[] memory _seats) public {
    uint len = _labels.length;
    for (uint i = 0; i < len; i++) {
      address party_address = party_addresses[_labels[i]];

      party_map[party_address].seats = _seats[i];
    }
  }
}
