// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract FirstContract {

    //les variables d'états
    string message;
    constructor(){
        message = "First message";
    }

    //les fonctions
    function getMessage() public view returns (string memory){
       return message; 
    }
    function setMessage(string calldata _message) external {
        message = _message;
    }
}