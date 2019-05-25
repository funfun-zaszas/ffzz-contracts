pragma solidity ^0.5.0;

contract WitnetBridgeInterface {

  struct DataRequest {
    string script;
    bool result;
    uint256 reward;
  }

  uint256 counter;
  mapping (uint256 => DataRequest) public requests;

  event PostDataRequest(address indexed _from, uint256 id);
  event PostResult(address indexed _from, uint256 id);

  constructor () public
  {
    counter = 0;
  }

  function post_dr (string memory dr) public payable returns(uint256 id) {
    id = counter++;
    requests[id].script = dr;
    // requests[id].result = "";
    requests[id].reward = msg.value;
    emit PostDataRequest(msg.sender, id);
    return id;
  }

  function read_dr (uint256 id) public view returns(string memory dr) {
    return requests[id].script;
  }

  function report_result (uint256 id, bool result) public {
    requests[id].result = result;
    msg.sender.transfer(requests[id].reward);
    emit PostResult(msg.sender, id);
  }

  function read_result (uint256 id) public view returns(bool result){
    return requests[id].result;
  }
}
