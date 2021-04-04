// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Token.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Curve {
    IERC20 internal collateral;
    Token internal token;

    constructor(address _collateralToken, address _bondedToken) {
        collateral = IERC20(_collateralToken);
        token = Token(_bondedToken);
    }

    function buyPrice(uint256 _amount) public view returns (uint256) {
        return calcIntegral(token.totalSupply(), token.totalSupply()+_amount);
    }

    function sellReward(uint256 _amount) public view returns (uint256) {
        return calcIntegral(token.totalSupply()-_amount, token.totalSupply());
    }

    function collateralToken() public view returns (address) {
        return address(collateral);
    }

    function bondedToken() public view returns (address) {
        return address(token);
    }

    function mint(uint256 _amount) public returns(bool){
        uint256 cost = buyPrice(_amount);

        require(
            collateral.allowance(msg.sender, address(this)) >= cost,
            "Not approved to spend CLT"
        );

        // Take buyer's collateral
        require(
            collateral.transferFrom(msg.sender, address(this), cost),
            "Collateral transfer failed."
        );

        // Send buyer newly minted tokens
        token.mint(msg.sender, _amount);
    }

    function burn(uint256 _amount) public returns(bool){
        uint256 payout = sellReward(_amount);

        // Take buyer's bonded token - and burn
        token.burn(msg.sender, _amount);
        // Send buyer collateral token from curve's balance
        collateral.transfer(msg.sender, payout);
    }

    function calcIntegral(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a < b, "a must be < b");
        uint256 res = (b**2 - a**2) + 40 * (b - a);
        return res / 200; //ASK - why not do this calc in 1 line?
    }
}
