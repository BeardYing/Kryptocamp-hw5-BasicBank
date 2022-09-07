// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingToken is ERC20 {
    constructor() ERC20("Staking Token", "ST") {
      mint(msg.sender, 50000);
    }

    function mint(address to, uint256 amount) public  {
        _mint(to, amount);
    }
}

contract RewardToken is ERC20 {
    constructor() ERC20("Reward Token", "ST") {
        _mint(msg.sender, 100 * 1e18);
    }
}