pragma solidity ^0.5.0;

import "./SafeMath.sol";
import "./WitnetBridgeInterface.sol";

contract Ethpain {

  using SafeMath for uint256;

  WitnetBridgeInterface wbi;

  address owner;
  string public name;
  uint total_seats;
  uint256 total_funding;
  // bytes public election_wdr;

  struct Party {
    bytes32 label;
    string fake_name;
    string emoji;
    string description;
    uint seats;
  }

  struct Program {
    uint256[] id_proposals;
    uint[] percentages;
    bool[] claimed;
  }

  address[] public parties;
  mapping (bytes32 => address) party_addresses;

  mapping (address => Party) party_map;
  mapping (address => Program) program_map;

  mapping (uint256 => string) proposal_map;
  mapping (uint256 => bool) proposal_success;

  constructor (address _wbi, string memory _name, uint _seats) public payable {
    total_funding = msg.value;
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

    uint len = id_proposals.length;
    bool[] memory _claimed = new bool[](len);

    program_map[msg.sender].claimed = _claimed;
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

  function claim_funds(uint256 _proposal_id) public returns(uint256 funds) {
    require(proposal_success[_proposal_id]);

    uint _seats = party_map[msg.sender].seats;

    uint _len = program_map[msg.sender].id_proposals.length;
    uint256 _percent = 0;
    uint index = 0;
    for (uint i = 0; i < _len; i++) {
      if (program_map[msg.sender].id_proposals[i] == _proposal_id) {
        require(!program_map[msg.sender].claimed[i]);
        _percent = program_map[msg.sender].percentages[i];
        index = i;
        break;
      }
    }
    uint256 claimed_funds = total_funding.mul(_seats).mul(_percent).div(total_seats).div(100);
    msg.sender.transfer(claimed_funds);

    program_map[msg.sender].claimed[index] = true;

    return claimed_funds;
  }
}
