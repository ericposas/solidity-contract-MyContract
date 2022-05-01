// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./GameToken.sol"; // import ERC20 token to be used as in-game currency

contract Game {

    GameToken tokens;
    address payable gameContract;
    string constant name = "Death Doll"; // ragdoll toss game
    uint constant defaultCoinAmount = 100 * 1000000000000000000; // 100 DETH tokens

    constructor()
    {
        gameContract = payable(msg.sender);
        tokens = new GameToken("DeathSandwich Token", "DETH");
        // calling GameToken constructor here, makes the Game contract the owner of the token supply
        // if we have a game, we can then set up COIN distribution methods within Game contract
    }

    // modifier gameOwnerOnly()
    // {
    //     require(msg.sender == 'deathsandwich.eth');
    //     _;
    // }

    // function moveCoins() // only allow 'deathsandwich.eth' aka '0xf8...' to transfer eth out of the contract
    // {
    // }

    function getUserBal()
        public
        view
        returns(uint256)
    {
        return tokens.balanceOf(msg.sender);
    }

    event GameApprovedForSpending(address indexed user_, address indexed contract_, uint amount_);
    event GameApprovalReset(address indexed user_, address indexed contrac_, uint amount_);
    
    function approveSpend()
        public
    {
        tokens.approveGameContract(msg.sender, defaultCoinAmount);
        emit GameApprovedForSpending(msg.sender, gameContract, defaultCoinAmount);
    }

    function resetSpendApproval()
        private
    {
        tokens.approveGameContract(msg.sender, 0);
        emit GameApprovalReset(msg.sender, gameContract, 0);
    }

    event UserSpentCoins(address indexed user, uint amount);

    function spendCoins(uint coins)
        public
    {
        tokens.transferFromContractInitiated(msg.sender, coins);
        emit UserSpentCoins(msg.sender, coins);
        resetSpendApproval();
    }

    event UserPurchasedCoins(address indexed user, uint amount);
    
    function buyCoins()
        public
        payable
    { // "payable" keyword allows a user to send along a { value } object containing Ether
        // calculate exchange rate of $20 of ether on client and send here
        gameContract.transfer(msg.value);
        tokens.transfer(msg.sender, defaultCoinAmount); // send 100 DETH
        emit UserPurchasedCoins(msg.sender, defaultCoinAmount);
    }

}