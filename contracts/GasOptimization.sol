//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

contract GasOptimization {

        address owner;

    /* TECHNIQUE 1 */
    /* Prioritize the use of mappings over arrays => (less costly operations) */

            //Avoid this:
            string [] students; 
            //Do this instead
            mapping (uint => string) studentsGasOK;




    /* TECHNIQUE 2 */
    /* Order variables based on the bits they occupy */

            //Avoid this:
            uint128 a;
            uint256 b;
            uint128 c;

            //Do this instead
            uint128 a_gasOK;
            uint128 c_gasOK;
            uint256 b_gasOK;



    /* TECHNIQUE 3 */
    /* Enable the 'optimizer' in the configuration file */
    
           /* module.exports = {
             solidity: "0.8.28",
                settings: {
                 optimizer: {
                    enabled: true,
                    runs: 10000
                    }
                 }
              }; */




    /* TECHNIQUE 4 */ 
    /* Assignment of local variables */

            //Avoid this:
            function bucle () public {
                for(uint i=0 ;i<50 ;i++){

                 }
             }

            //Do this instead
            function blucle_gasOK () public {
                 uint256 len = 50;
                 for (uint i=0 ;i<len ;i++){
                  }
            }


            
       /* TECHNIQUE 5 */ 
       /* Try to perform operations by blocks/slots whenever possible */

                function batch (string[] memory _students) public {
                        //do something
                }




        /* TECHNIQUE 6 */ 
        /* Use of indexed Events */

        /* ATTENTION: the 'indexed' version of strings and bytes is more expensive than the non-'indexed' version. */
        /* Conclusion: Index addresses and numbers */
                event IndexedEvent (address indexed user, uint indexed id);




        /* TECHNIQUE 7 */ 
        /* Use immutable and constant variables whenever possible. */

                uint256 constant k = 10;
                uint256 immutable n;
                constructor()  {
                        owner = msg.sender;
                        n = 2;
                }

        

        
        /* TECHNIQUE 8 */ 
        /* Be careful with 'uint8' sometimes it is more expensive than larger-sized variables. */

                //uint8 x; // better for storage
                uint256 x; //better for loops




        /* TECHNIQUE 9 */ 
        /* Delete what is not going to be used. */

                //delete variable;




        /* TECHNIQUE 10 */
        /* Use the external modifier. */ 




        /* TECHNIQUE 11 */
        /* Make use of `unchecked` => When we are 100% sure that these are operations that will not overflow. */

                function suma (uint tam) external pure {
                        for (uint256 i = 0; i < tam; i++) {
                                unchecked {
                                i++;      
                                }
                        } 
                }




         /* TECHNIQUE 12 */
         /* Use custom errors. */

                //Avoid this
                function f (uint256 _amount) external view {
                        require (msg.sender != address(0), "ADDRESS 0x00");
                        _amount++;
                }


                //Do this instead
                error ADDRESS_0 (address caller);

                function f_gas (uint256 _amount) external view {
                        if (msg.sender == address(0)) {
                                revert ADDRESS_0(msg.sender);
                        }
                        _amount++;
                }




        /* TECHNIQUE 13 */
        /* Define in a function (whenever possible) what a modifier should check. */
        /* WHY? => The code of modifiers is "copied" into all instances. */

                /* Avoid tihs */
                modifier onlyOwner_KO () {
                        require(owner == msg.sender, "You are not the owner");
                        _;
                }

                //Do this instead
                modifier onlyOwner () {
                        checkOwner ();
                        _;
                }

                function checkOwner () internal view {
                        require(owner == msg.sender, "You are not the owner");
                }





        /* TECHNIQUE 14 */
        /* Prioritize the use of calldata over memory */

                //Avoid this
                function add1 (uint[] memory numbers) external pure returns (uint) {
                        uint result = 0;
                        for (uint i = 0; i < numbers.length; i++) {
                                result = result + numbers[i];
                        }
                        return result;
                }

                //Do this instead
                function add2 (uint[] calldata numbers) external pure returns (uint) {
                        uint result = 0;
                        for (uint i = 0; i < numbers.length; i++) {
                                result = result + numbers[i];
                        }
                        return result;
                }





        /* TECHNIQUE 15 */
        /* Whenever possible, group the parameters of a function into a struct */

        struct Signature {
                uint8 v;
                bytes32 r;
                bytes32 s;
        }

                //Avoid this
                function vote (uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) public {
                                //......
                }

                //Do this instead
                function voteOK (Signature [] calldata sig) public {
                                //.....
                }



        
        /* TECHNIQUE 16 */
        /* Use libraries whenever possible. */
  
  
        
        /* TECHNIQUE 17 */
        /* Avoid manipulating storage data. */

        uint public number = 3;

                //Avoid this
                function addNumber () external view returns (uint) {
                        uint result = 0;
                        for (uint i = 0; i< number; i++) {
                                result = result+number;
                        }

                        return result;
                }

                //Do this instead
                function addNumberOK () external view returns (uint) {
                        uint result = 0;
                        uint _number = number;
                        for (uint i = 0; i<_number; i++) {
                                result = result+_number;
                        }

                        return result;
                }

        
        /* TECHNIQUE 18 */
        /* Use logical expressions to our advantage. (||) (&&) */

                /* 
                 In the logical expression ||, if the first function resolves as true, the second one does not execute, so we save gas.

                 In the logical expression &&, if the first function evaluates as false, the next one is not evaluated, so we also save gas.

                 How do we implement this technique? => By ordering the logical expressions based on probability to reduce the need to evaluate the second function.
                */
  
  

        /* TECHNIQUE 19 */
        /* 
        Prioritize the use of fixed-size arrays; they are cheaper than dynamic ones.
        
        If the size of an array is known with certainty, leave it defined.
        */

  
  
        /* TECHNIQUE 20 */
        /* Use function selectors instead of full function signatures when calling other contracts */

                // Avoid this 
                function callExternalContract(address _contract, uint256 _amount) external {
                        (bool success, ) = _contract.call(
                        abi.encodeWithSignature("transfer(address,uint256)", msg.sender, _amount)
                        );
                        require(success, "Call failed");
                }

                // Do this instead (cheaper using function selector)
                function callExternalContractOptimized(address _contract, uint256 _amount) external {
                        (bool success, ) = _contract.call(
                        abi.encodeWithSelector(bytes4(keccak256("transfer(address,uint256)")), msg.sender, _amount)
                        );
                        require(success, "Call failed");
                }

     
}   
