pragma solidity ^0.5.0;

import "./Crowdsale.sol";
import "./CappedCrowdSale/CappedCrowdsale.sol";
import "./CappedCrowdSale/IndividuallyCappedCrowdsale.sol";
import "./Whitelist/WhitelistCrowdsale.sol";
import "./TimedCrowdsale.sol";
import "./Funds/WithdrawFunds.sol";

contract ICO is
    Crowdsale,
    CappedCrowdsale,
    IndividuallyCappedCrowdsale,
    WhitelistCrowdsale,
    WithdrawFunds,
    TimedCrowdsale
{
    /**@param wallet wallet address where funds are to be sent */
    /**@param cap hardcap */
    /**@param scap softcap */
    /**@param individualMin Inidividual Wallet Min Contribution */
    /**@param closingTime Time till ico closes */
    constructor(
        address payable wallet,
        uint256 cap,
        uint256 scap,
        uint256 individualMin,
        uint256 closingTime
    )
        public
        Crowdsale(wallet)
        WithdrawFunds()
        TimedCrowdsale(closingTime)
        WhitelistCrowdsale()
        CappedCrowdsale(cap, scap)
        IndividuallyCappedCrowdsale(individualMin)
    {}
}
