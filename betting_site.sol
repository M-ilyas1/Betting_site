// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BettingSite{
    address private Owner;  // CONTRACT DEPLOYER
    enum Status{ Open, Closed, Resolved}
    Status status;

    enum Teams{ Team_A, Team_B}

    struct Data{
        uint Amount;
        Teams Selected_Team;
    }

    mapping ( address => Data) User_Data;

    event Done_Bet(address Address, uint Bet_Value, Teams Chosen_Team);
    event Withdraw_Amount(address Address, uint Withdraw_Value, uint Withdraw_Time);

    constructor(){
        Owner = msg.sender;
    }

    function Change_Status(Status state) public {
        require(msg.sender == Owner, "Only Owner is allowed to Change the state");
        require(state == Status.Closed || state == Status.Open || state == Status.Resolved, "Selected an undefined State");
        status = state;
    }

    function  Place_Bet(Teams Team) payable public {
        require (status == Status.Open, "Batting is Closed");
        require(Team == Teams.Team_A || Team == Teams.Team_B, "Selected an Undefined Team");

        User_Data[msg.sender] = Data(User_Data[msg.sender].Amount + msg.value , Team);

        emit Done_Bet(msg.sender, msg.value, Team);
    }
    
    function Withdraw() public{
        require(User_Data[msg.sender].Selected_Team == Teams.Team_B, "You Are Not The Winner");
        
        payable(msg.sender).transfer(User_Data[msg.sender].Amount);
    
        emit Withdraw_Amount(msg.sender, User_Data[msg.sender].Amount, block.timestamp); 
     }
        

}
