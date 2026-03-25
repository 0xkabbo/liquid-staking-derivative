// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./lsdToken.sol";

contract StakingPool is ReentrancyGuard {
    lsdToken public immutable token;
    uint256 public totalUnderlying;

    event Staked(address indexed user, uint256 ethAmount, uint256 lsdAmount);
    event Unstaked(address indexed user, uint256 lsdAmount, uint256 ethAmount);

    constructor() {
        token = new lsdToken();
    }

    /**
     * @dev Returns the current exchange rate (ETH per 1 lsETH) scaled by 1e18.
     */
    function getExchangeRate() public view returns (uint256) {
        uint256 supply = token.totalSupply();
        if (supply == 0) return 1e18; 
        return (totalUnderlying * 1e18) / supply;
    }

    function stake() external payable nonReentrant {
        require(msg.value > 0, "Cannot stake 0");
        
        uint256 lsdToMint = (msg.value * 1e18) / getExchangeRate();
        
        totalUnderlying += msg.value;
        token.mint(msg.sender, lsdToMint);
        
        emit Staked(msg.sender, msg.value, lsdToMint);
    }

    function unstake(uint256 _lsdAmount) external nonReentrant {
        require(token.balanceOf(msg.sender) >= _lsdAmount, "Insufficient balance");
        
        uint256 ethToReturn = (_lsdAmount * getExchangeRate()) / 1e18;
        
        totalUnderlying -= ethToReturn;
        token.burn(msg.sender, _lsdAmount);
        
        (bool success, ) = payable(msg.sender).call{value: ethToReturn}("");
        require(success, "ETH transfer failed");

        emit Unstaked(msg.sender, _lsdAmount, ethToReturn);
    }

    /**
     * @dev Simulates rewards being added by validators. 
     * In production, this would be restricted to a specific bridge or oracle.
     */
    function addRewards() external payable {
        totalUnderlying += msg.value;
    }

    receive() external payable {
        totalUnderlying += msg.value;
    }
}
