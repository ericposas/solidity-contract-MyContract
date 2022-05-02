// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./GameToken.sol"; // import ERC20 token to be used as in-game currency

contract Game {

    GameToken tokens;
    address payable gameContractOwner;
    string constant name = "Game Contract";
    uint constant defaultTokenAmount = 100 * 1000000000000000000; // 100 tokens

    constructor()
    {
        gameContractOwner = payable(msg.sender);
        // need to set the owner in GameToken to msg.sender here...
        tokens = new GameToken(gameContractOwner, "ZozoCoin", "ZOZO");
        // calling GameToken constructor here, makes the Game contract the owner of the token supply
        // if we have a game, we can then set up COIN distribution methods within Game contract
    }

    function getUserBal()
        public
        view
        returns(uint256)
    {
        return tokens.balanceOf(msg.sender);
    }

    event UserSpentTokens(address indexed user, uint amount);

    function spendTokens(uint tokens_)
        public
    {
        tokens.directTransferFromUser(msg.sender, tokens_);
        emit UserSpentTokens(msg.sender, tokens_);
    }

    event UserPurchasedCoins(address indexed user, uint amount);
    
    function buyTokens()
        public
        payable
    { // "payable" keyword allows a user to send along a { value } object containing Ether
        // calculate exchange rate of $20 of ether on client and send here
        gameContractOwner.transfer(msg.value);
        // tokens.transfer(msg.sender, defaultTokenAmount); // send 100 Tokens
        tokens.transferFromContractOwner(msg.sender, defaultTokenAmount); // send 100 Tokens
        emit UserPurchasedCoins(msg.sender, defaultTokenAmount);
    }

}