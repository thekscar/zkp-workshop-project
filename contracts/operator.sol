pragma solidity 0.5.0; 

/*
 * @title Operator
 * Contract that would be deployed by the operator (BP, Exxon, Shell) 
   to manage bidding process for a certain field. 
   venues and artists.
*/

import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import "./Interfaces/verifierI.sol"; 

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
    mapping (bytes32 => Bid) public bid;

    //Approved verifier contract
    address public approved_verifier; 

    //Approved suppliers to bid
    mapping (address => bool) approved_supplier; 
    mapping (address => uint256) supplier_eddsa_pk;

    //Verifier interface
    verifierI v;
//============================================================================
// EVENTS
//============================================================================

    event BiddingVerified(bool _result);

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
    constructor(address _verifier) 
        public 
        {
            approved_verifier = _verifier;
            v = verifierI(_verifier);
        }

//============================================================================
// REQUEST TO BID
//============================================================================

//How do we approve bidders to be verified in zk?

//============================================================================
// BID PROCESS START
//============================================================================

    /*
     * @dev approveSupplier function to approve a supplier to bid on the project
     * @param _supplier, address of supplier to approve 
     * @returns none
     * Future Thoughts: Could we instead publish proofs that allow a supplier to bid? 
     * Like a 'proof of approval'? 
    */
    function approveSupplier(address _supplier)
    onlyOwner
    public
    {
        approved_supplier[_supplier] = true; 
    }

    /*
     * @dev supplierEddsa function to map supplier's Ethereum pk to their Eddsa pk
     * Only an approved supplier can map their Ethereum pk to their Eddsa pk 
     * @param _supplierPk, Eddsa address of supplier 
     * @returns none
    */
    function supplierEddsa(uint256 _supplierPK)
    public
    {
        require(approved_supplier[msg.sender]);
        supplier_eddsa_pk[msg.sender] = _supplierPK; 
    }
    
    /*
     * @dev createBid function to create a bid 
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

    /*
     * @dev verifyBidding function to verify the bidding process & ensure it was fair
     * should be executed by the regulator or any third party that is looking to prove that 
     * a bidding process was done fairly
     * @param fieldID, identifies what field this bid is for
     * @param duraation, tells how long this project will last
     * @returns hash identifier of bid (fieldId & duration)
    */
    function verifyBidding(
        uint[2] memory a, 
        uint[2][2] memory b, 
        uint[2] memory c, 
        uint[11] memory input) 
    public 
    returns (bool r)
    {
        bool result = v.verifyTx(a, b, c, input);
        emit BiddingVerified(result);
        return result;
    }



 

}