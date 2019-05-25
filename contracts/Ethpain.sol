pragma solidity ^0.5.0;

import "./WitnetBridgeInterface.sol";

contract Ethpain {

  WitnetBridgeInterface wbi;

  address owner;
  string public name;
  // bytes public election_wdr;

  constructor (address _wbi, string memory _name) public payable {
    wbi = WitnetBridgeInterface(_wbi);
    owner = msg.sender;
    name = _name;
    // election_wdr = _election_wdr;
    // wbi.post_dr(election_wdr);
  }


}
