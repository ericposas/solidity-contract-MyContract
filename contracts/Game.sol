// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./GameToken.sol"; // import ERC20 token to be used as in-game currency

contract Game {

    GameToken tokens;
    address contract_;

    constructor()
    {
        contract_ = msg.sender;
        tokens = new GameToken();
        // calling GameToken constructor here, makes the Factory contract the owner of the token supply
        // if we have a game, we can then set up COIN distribution methods within Factory
    }

    function getTokenBal(address address_)
        public
        view
        returns(uint256)
    {
        return tokens.balanceOf(address_);
    }

    function getTokenSupply()
        public
        view
        returns(uint256)
    {
        return tokens.totalSupply();   
    }

    function transfer(address receiver, uint256 numTokens)
        external
    {
        tokens.transfer(receiver, numTokens);
    }

    function checkBal(address address_)
        public
        view
        returns(bool)
    {
        if (getTokenBal(address_) < 1000000 ether) {
            return false;
        }
        return true;
    }

    function userBuysCoins(address user, uint n)
        public
    {
        // write methods that handle the transfer of ETH
        // after ETH is transferred, distribute the COINs
        // to the buyer to use in-game

        tokens.transfer(user, n);
    }

}