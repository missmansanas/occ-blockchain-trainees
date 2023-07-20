// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*  Data Types
    * int/uint
    * address
    * bool
    * bytes
    * string
*/

contract RecapDataTypes {
    int public myInt;
    // signed integer - default value: 0
    uint public myUint;
    // unsigned integer - DV: 0

    address public myAddress;
    // contract address or wallet address - DV: address(0)
    bool public myBoolean;
    // holds either true or false values only - DV: false
    string public myString;
    // stores a series of characters - DV: empty string
    bytes1 public myBytes;
    // stores a limited series of characters as bytes - DV: empty bytes
}

/*  Data Structures
    * arrays
    * mapping
    * structs
    * enums
*/

/*  Data Storage
    * storage - the program will remember this data even after the function is complete
    * memory - the program will erase this data after the function is complete 
*/


contract RecapDataStructures {
    
    enum TraineeStatus {
        None,
        Absent,
        Present,
        Late
    }

    struct Trainee {
        string name;
        uint256 birthday;
        address walletAddress;
        TraineeStatus status;
    }

    Trainee[] private trainees;
    mapping(address => Trainee) private traineeId;

    function setTrainee (
        string memory _name,
        uint256 _birthday,
        address _walletAddress,
        TraineeStatus _status)
        public {
        Trainee memory newTrainee = Trainee(
            _name,
            _birthday,
            _walletAddress,
            _status
        );
        // creates a new instance of the Trainee structure
        // the string and struct are created in memory, so their data is forgotten once the function is complete. In order to retain the data, we push them to either an array or mapping

        trainees.push(newTrainee);
        // adds the new Trainee to "trainees" array

        traineeId[_walletAddress] = newTrainee;
        // associates the trainee's wallet address with the struct, for easy lookup
        // mapping data structures do not accept structs as a key, only as a value
    }

    function updateStatus (address _traineeAddress, TraineeStatus _status) public {
        Trainee storage checkTrainee = traineeId[_traineeAddress];
        // uses the mapping to look up a Trainee's struct record and captures it in a local variable

        checkTrainee.status = _status;
        // updates the status of the trainee being checked
    }



}

/*  Function Modifiers
    * public
    - variable/function can be accessed from inside+outside the SC
    * private
    - variable/function can only be accessed from within the SC
    * internal
    - variable/function can only be accessed from within, and by child SC
    * external
    - variable/function can only be accessed from outside the SC
    * view
    - promises it will only read the state of the contract, not update/write
    * pure
    - does not read nor write the state, can be used to perform mathematical equations

    Function Output
    * return/returns
*/
