pragma solidity ^0.5.0;

import "../library/SafeMath.sol";
import "../Crowdsale.sol";

/**
 * @title IndividuallyCappedCrowdsale
 * @dev Crowdsale with per-beneficiary caps.
 */
contract IndividuallyCappedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _individualMin;
    mapping(address => uint256) private _contributions;

    /**
     * @dev Constructor, takes Minimum and Maximum contribution amount of wei per beneficiary
     * @param individualMin Min amount of wei to be contributed per beneficiary
     */
    constructor(uint256 individualMin) public {
        require(
            individualMin > 0,
            "IndividuallyCappedCrowdsale: Minimum contribution is zero"
        );
        _individualMin = individualMin;
    }


    /**
     * @return the cap of the crowdsale.
     */
    function minContribution() public view returns (uint256) {
        return _individualMin;
    }

    /**
     * @dev Returns the amount contributed so far by a specific beneficiary.
     * @param beneficiary Address of contributor
     * @return Beneficiary contribution so far
     */
    function getContribution(address beneficiary)
        public
        view
        returns (uint256)
    {
        return _contributions[beneficiary];
    }

    /**
     * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
        internal
        view
    {
        super._preValidatePurchase(beneficiary, weiAmount);
        // solhint-disable-next-line max-line-length
        require(
            weiAmount >= _individualMin,
            "IndividuallyCappedCrowdsale: beneficiary's contribution too low"
        );
    }

    /**
     * @dev Extend parent behavior to update beneficiary contributions.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _updatePurchasingState(address beneficiary, uint256 weiAmount)
        internal
    {
        super._updatePurchasingState(beneficiary, weiAmount);
        _contributions[beneficiary] = _contributions[beneficiary].add(
            weiAmount
        );
    }
}
