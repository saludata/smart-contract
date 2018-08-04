const SmartRCE = artifacts.require("SmartRCE");

function hobToWei(){
  return 1024 * Math.pow(10, 18);
}

contract('SmartRCE', function(accounts) {

  it("SmartRCE Update claveunica", function(done) {
    var smartRCE;
    setTimeout(function () {
      return SmartRCE.deployed().then(function(instance) {
        smartRCE = instance;
        return smartRCE.UpdateClaveUnica({ from: accounts[0], value: web3.toWei('1', 'ether') });
      }).then(function(result){         
        assert.equal(result.logs[0].args.description, 'Oraclize The query was sent to claveunica.gob.cl, wait for the entity response.', 'IntanceEventBet Return event correct');
        //console.log("Result", result.logs[0]);
        //Valido evento post oracle.
        setTimeout(function () {
          smartRCE.newOraclizeQuery().watch ( (err, response) => {  //set up listener for the AuctionClosed Event
            //once the event has been detected, take actions as desired
            //console.log("Result", response);
            if(response.args.description == 'The string received does not match. '){
              smartRCE.newOraclizeQuery().stopWatching();
              done();
            }
          });          
        }, 1000);        
      });  
    }, 2000);     
  }) 

  //it("SmartRCE event oracle post claveunica") {

 
  //}

});
