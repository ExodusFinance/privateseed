pragma solidity ^0.5.0;

import "./library/SafeMath.sol";
import "./Crowdsale.sol";
import "./Context.sol";

/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _closingTime;

    /**
     * @dev Constructor, takes crowdsale opening and closing times.
     * @param closingTime Crowdsale closing time
     */
    constructor(uint256 closingTime) public {
        // solhint-disable-next-line max-line-length
        require(
            closingTime > block.timestamp,
            "TimedCrowdsale: closing time is before current time"
        );
        _closingTime = closingTime;
    }

    /**
     * @return the crowdsale closing time.
     */
    function closingTime() public view returns (uint256) {
        return _closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp > _closingTime;
    }

    /**
     * @dev withdraw after crowsale has ended.
     */
    function _preValidateWithdraw() internal view {
        require(hasClosed(), "Please wait for buffer time to complete");
        super._preValidateWithdraw();
    }
   
}
