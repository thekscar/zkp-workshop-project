pragma solidity 0.5.0; 

/*
 * @title Operator
 * Contract that would be deployed by the operator (BP, Exxon, Shell) 
   to manage bidding process for a certain field. 
   venues and artists.
*/

import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract operator is Ownable {

//============================================================================
// LIBRARIES
//============================================================================

//============================================================================
// GLOBAL VARIABLES
//============================================================================

    //Struct of all the information that will be held in the bid
    struct Bid {
        uint256 bidStart; 
        uint256 fieldId;
        uint256 durationOfBid;
        uint256 durationOfProject;
    }

    /* Each bid will be mapped to a hash of its original information for reference, easier than keeping track
    of an array */
    mapping (bytes32 => Bid) bid;

//============================================================================
// EVENTS
//============================================================================


//============================================================================
// MODIFIERS
//============================================================================

//============================================================================
// CONSTRUCTOR
//============================================================================
    /*
     * @dev Constructor function to initiate the Operator 
     * @param 
    */
    
    //Probably need to include the verifier contract at some point
    constructor() public {}

//============================================================================
// REQUEST TO BID
//============================================================================

//How do we approve bidders to be verified in zk

//============================================================================
// BID PROCESS START
//============================================================================

    /*
     * @dev Constructor function to initiate the Operator 
     * @param fieldID, identifies what field this bid is for
     * @param duraation, tells how long this project will last
     * @returns hash identifier of bid (fieldId & duration)
    */
    function createBid(
        uint256 _fieldId, 
        uint256 _durationOfBid,
        uint256 _durationOfProject
    )
    onlyOwner 
    public
    returns (bytes32)
    {
        Bid memory _bid = Bid({
        bidStart: now,
        fieldId: _fieldId,
        durationOfBid: _durationOfBid,
        durationOfProject: _durationOfProject 
        });
        bytes memory temp = abi.encodePacked(_fieldId, _durationOfBid, _durationOfProject);
        bytes32 res = keccak256(temp);
        bid[res] = _bid; 
        return res; 
    }

    // How to have suppliers submit bids? Off chain signing hash of bid, verifying sender? Then verified by operator
    // on chain? How to make sure bids are submitted within a certain time? 

}