// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This is the Caller contract which uses delegate-call to call the function from another contrcat.
contract Caller{
    uint[] public data = [1,2,3,4];

    // Function to update the values in the data array. It uses delegateCall to get function
    // from anoother contract.
    function set(address _calledAddress, uint[] memory _array) external returns (uint[] memory){
        (bool success, bytes memory returndata) = _calledAddress.delegatecall(
            abi.encodeWithSelector(
                Target.updateData.selector,
                _array
            )
        );

        // if the function call reverted
        if (success == false) {
            // if there is a return reason string
            if (returndata.length > 0) {
                // bubble up any reason for revert
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert("Function call reverted");
            }
        }
        return data;
    }
}

// Traget Contrcat. Functions in this contract are used by other contracts. 
contract Target{

    uint[] public data = [0,0,0,0];

    // Function updates the value of the state variable array with with values sent in the parameter.
    function updateData(uint[] memory _data) external {
        data = _data;
    }
}
