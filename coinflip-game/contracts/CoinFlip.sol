// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract CoinFlip is Ownable {
    IERC20 public token;
    
    enum Side { Heads, Tails }
    
    struct Bet {
        uint256 amount;
        Side side;
        address user;
        bool settled;
    }
    
    Bet[] public bets;
    
    event BetPlaced(uint256 indexed betId, address indexed user, uint256 amount, Side side);
    event BetSettled(uint256 indexed betId, address indexed user, bool won, uint256 payout);
    
    constructor(address _token, address _initialOwner) Ownable(_initialOwner) {
    token = IERC20(_token);
}
    
    function placeBet(uint256 _amount, Side _side) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        uint256 betId = bets.length;
        bets.push(Bet({
            amount: _amount,
            side: _side,
            user: msg.sender,
            settled: false
        }));
        
        emit BetPlaced(betId, msg.sender, _amount, _side);
        
        // Pseudo-randomness, replace with secure method like Chainlink VRF
uint256 outcome = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 2;
        bool won = (outcome == uint256(_side));
        
        if (won) {
            uint256 payout = _amount * 2;
            require(token.transfer(msg.sender, payout), "Payout failed");
            emit BetSettled(betId, msg.sender, won, payout);
        } else {
            emit BetSettled(betId, msg.sender, won, 0);
        }
        
        bets[betId].settled = true;
    }
    
    // Allow the contract owner to withdraw tokens
    function withdrawTokens(uint256 _amount) external onlyOwner {
        require(token.transfer(msg.sender, _amount), "Withdrawal failed");
    }
}
