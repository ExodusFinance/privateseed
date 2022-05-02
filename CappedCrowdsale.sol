pragma solidity ^0.5.0;

import "../library/SafeMath.sol";
import "../Crowdsale.sol";

/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */
contract CappedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _scap;   
    uint256 private _cap;

    /**
        * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
        * @param cap Max amount of wei to be contributed
        * @param scap is soft cap amount of wei to be contributed
     */
    constructor (uint256 cap, uint256 scap) public {
        require(cap > 0, "CappedCrowdsale: cap is 0");
        require(scap < cap, "CappedCrowdsale: scap is greater than hard cap");
        _cap = cap;
        _scap = scap;
    }

    /**
     * @return the cap of the crowdsale.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }
    /**
     * @return the scap of the crowdsale.
     */
    function scap() public view returns (uint256) {
        return _scap;
    }

    /**
     * @dev Checks whether the cap has been reached.
     * @return Whether the cap was reached
     */
    function capReached() public view returns (bool) {
        return weiRaised() >= _cap;
    }

    /**
     * @dev Extend parent behavior requiring purchase to respect the funding cap.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        super._preValidatePurchase(beneficiary, weiAmount);
        require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
    }
}
