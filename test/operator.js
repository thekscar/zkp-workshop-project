const Operator = artifacts.require("./operator");
const Verifier = artifacts.require("./Verifier");

contract('Operator', function(accounts){
  
    let verifierContract; //Instance of verifier contract deployed
    let operatorContract; //Instance of operator contract deployed

    //Addresses to save
    let operator =  accounts[0]; //Operator who deploys contract
    let supplierA = accounts[1]; 
    let supplierB = accounts[2];
    let supplierC = accounts[3];

    //Hard coded for now
    // let proofInput = ["0x23d4128db53f926569ec022d30fa2c00c81a12f02f7a9524a008c30601079c51","0x283c2931c59a12ebfcfc04d8c91bb859c09a51972762caaf8a17bf80d0283406"],[["0x1b6e8460f12f514c0d40744445520880e17bbca2939e3b124978435865383b44","0x0f2420e1cac637e431ab39d14e9ea7ac0519da088313e977178abbd735917575"],["0x252a82cae268bab28736e4609c6ef92c5056d4a40f9f10c474d70ef5874efe56","0x0a5d65697fb2ebf631750a1a42dfa3101c8e0bcaed2cf70e4ea680fffa839678"]],["0x0d64512e56be3d819adb405a80a61b59f8214b2f005c31654579d3c9ac74636a","0x0d4b69f12f3afd4a55a0b6af12b1b5cc4c630ab4145e3f3a01e390c949e05059"],["0x20efac506a3d21dc3882103a7a727ad821f2422988783ee8b2f1762ecd0dbb03","0x24da398ed1996eae6dafb3a687806e3a49c3add6949774d6017b30a66b2503ce","0x20efac506a3d21dc3882103a7a727ad821f2422988783ee8b2f1762ecd0dbb03","0x24da398ed1996eae6dafb3a687806e3a49c3add6949774d6017b30a66b2503ce","0x20efac506a3d21dc3882103a7a727ad821f2422988783ee8b2f1762ecd0dbb03","0x24da398ed1996eae6dafb3a687806e3a49c3add6949774d6017b30a66b2503ce","0x0e486aae1862912e365f5b241e69312c4b7829a95e331f170d06f9cab57f6928","0x11d3b0541d16a4571c60cd677bad8dd0c880e57a65c322a7b3f153bc1f347702","0x2fa422b12d3f147df48ad42173db3f2ca22ff71fa941434925e10dff1219d5a1","0x000000000000000000000000000000006bdcea1cffdac0358af7f5e82f074410","0x000000000000000000000000000000003c2db71bf00ac5c846bf23743bc675ec"];
  
    let a = ["0x23d4128db53f926569ec022d30fa2c00c81a12f02f7a9524a008c30601079c51","0x283c2931c59a12ebfcfc04d8c91bb859c09a51972762caaf8a17bf80d0283406"];
    let b =  [["0x1b6e8460f12f514c0d40744445520880e17bbca2939e3b124978435865383b44","0x0f2420e1cac637e431ab39d14e9ea7ac0519da088313e977178abbd735917575"],["0x252a82cae268bab28736e4609c6ef92c5056d4a40f9f10c474d70ef5874efe56","0x0a5d65697fb2ebf631750a1a42dfa3101c8e0bcaed2cf70e4ea680fffa839678"]];
    let c = ["0x0d64512e56be3d819adb405a80a61b59f8214b2f005c31654579d3c9ac74636a","0x0d4b69f12f3afd4a55a0b6af12b1b5cc4c630ab4145e3f3a01e390c949e05059"]
    let input = ["0x20efac506a3d21dc3882103a7a727ad821f2422988783ee8b2f1762ecd0dbb03", "0x24da398ed1996eae6dafb3a687806e3a49c3add6949774d6017b30a66b2503ce","0x20efac506a3d21dc3882103a7a727ad821f2422988783ee8b2f1762ecd0dbb03","0x24da398ed1996eae6dafb3a687806e3a49c3add6949774d6017b30a66b2503ce","0x20efac506a3d21dc3882103a7a727ad821f2422988783ee8b2f1762ecd0dbb03","0x24da398ed1996eae6dafb3a687806e3a49c3add6949774d6017b30a66b2503ce","0x0e486aae1862912e365f5b241e69312c4b7829a95e331f170d06f9cab57f6928","0x11d3b0541d16a4571c60cd677bad8dd0c880e57a65c322a7b3f153bc1f347702","0x2fa422b12d3f147df48ad42173db3f2ca22ff71fa941434925e10dff1219d5a1","0x000000000000000000000000000000006bdcea1cffdac0358af7f5e82f074410","0x000000000000000000000000000000003c2db71bf00ac5c846bf23743bc675ec"]

    /* Steps to take before each test run, deploy contract each time to start
    at same base case. */
    beforeEach(async function(){
      verifierContract = await Verifier.new({gas: 6000000}); 
      operatorContract = await Operator.new(verifierContract.address, {gas: 6000000});
    });
  
    describe("Valid signature", async function() {
      it("Should verify valid signatures.", async function(){
          let result = await operatorContract.verifyBidding(a, b, c, input);
          let arg = result.logs[0].args._result;
          assert.isTrue(arg, "Valid value did not set."); 
      });
    });
  
})