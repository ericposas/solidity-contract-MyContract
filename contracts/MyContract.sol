// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyContract {

  address private owner;

  uint uniqueUsers;
  
  struct User {
    address address_;
    uint id;
    uint count;
    bool accessedFlag;
  }

  mapping (address => User) users;
  mapping (uint => User) usersById;
  
  constructor() {
    owner = msg.sender;
    uniqueUsers = 0;
  }

  modifier hasAccessedPrior() {
    require(users[msg.sender].accessedFlag, 'no interaction recorded for this address');
    _;
  }

  function hitContract() public {
    if (!users[msg.sender].accessedFlag) {
      User memory user = User(msg.sender, uniqueUsers, 1, true);
      users[msg.sender] = user;
      usersById[uniqueUsers] = user;
      uniqueUsers++;
    } else {
      users[msg.sender].count++;
      usersById[users[msg.sender].id].count++;
    }
  }

  function getUserData() public view hasAccessedPrior returns (User memory) {
    return users[msg.sender];
  }

  function getAllInteractions() public view returns (User[] memory) {
    User[] memory users_ = new User[](uniqueUsers);
    for (uint i = 0; i < uniqueUsers; i++) {
      users_[i] = usersById[i];
    }
    return users_;
  }

}
