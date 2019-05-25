pragma solidity ^0.5.0;

contract Ethpain {

  address owner;
  string public name;
  string public election_wdr;


  constructor (string memory _name, string memory _election_wdr) public payable {
    owner = msg.sender;
    name = _name;
    election_wdr = _election_wdr;
  }
}
