// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CollateralToken is ERC20 {
    constructor() 
    ERC20(
        "Collateral Token",
        "CLT"
    ) {

    }

    // ASK - Should mint and burn be here at all?
    // Bonding curve wouldn't have ability to burn/mint collateral as well as issued token

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }
}