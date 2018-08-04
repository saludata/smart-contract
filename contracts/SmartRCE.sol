pragma solidity ^0.4.2;

import "../installed_contracts/oraclize-api/contracts/usingOraclize.sol";
import "../contracts/SafeMath.sol";
import "../contracts/Owner.sol";
import "../contracts/SafeMath.sol";

contract SmartRCE is usingOraclize, Owned {
    using SafeMath for uint;
    address public owner;

    uint public date;
    string public tokenUnica;
    bytes32 public hashDataUnica;

    string public urlApiEventDeclare = "https://gitlab.com/hackathonDicenio/SmartBSL/raw/master/data/";
    //https://www.claveunica.gob.cl/openid/userinfo/

    mapping(bytes32 => bool) validIds;

    event newOraclizeQuery(string description);

    constructor(string token, address ora) public {       

        UpdateToken(token);

        if(ora != address(0)){
            OAR = OraclizeAddrResolverI(ora);
        }

        owner = msg.sender; 
    }
   
    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () public payable {
        revert();
    }

    function kill() public {
        require(msg.sender != owner);
        selfdestruct(owner);
    }

    function __callback(bytes32 myid, string result) public  {
        // Validar respuesta!
        
        if (!validIds[myid]) revert();

        require(msg.sender == oraclize_cbAddress());
        
        require((bytes(result)).length != 0);

        if(date != 0x0) {
            date = block.timestamp;
            hashDataUnica = keccak256(result);
            emit newOraclizeQuery("The validation claveunica.gob.cl. ");
        }
        else {
            if(hashDataUnica == keccak256(result)){
                date = block.timestamp;
                emit newOraclizeQuery("The updated validation claveunica.gob.cl. ");
            }
            else{               
                emit newOraclizeQuery("The string received does not match. ");
            }
        }
        delete validIds[myid];
    }
      

    function UpdateToken(string token) payable public onlyOwner {
        require((bytes(token)).length != 0, "Token Required parameters");

        tokenUnica = strConcat(token, ".json");

        // Update(); // Me quedo sin gas
    }

    function UpdateClaveUnica() payable public {
        string memory urlApi;

        if (oraclize_getPrice("URL") > address(this).balance) {
            emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            bytes32 queryId;
            urlApi = strConcat(urlApiEventDeclare, tokenUnica);
            
            queryId = oraclize_query("URL", urlApi);
            validIds[queryId] = true;

            emit newOraclizeQuery("Oraclize The query was sent to claveunica.gob.cl, wait for the entity response.");
        }
    }

}