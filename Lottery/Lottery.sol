pragma solidity ^0.4.16;

contract Ownable {
	address private owner;
	address public newOwner;

	event OwnershipTransferred(address indexed _from, address indexed _to);

	function Ownable() public {
		owner = msg.sender;
	}

	function getOwner() public constant returns (address currentOwner) {
		return owner;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	// Ownership can be transfered by current owner only
    // New owner should be a non-zero address
	function transferOwnership(address _newOwner) onlyOwner {
		require(_newOwner != address(0));
		newOwner = _newOwner;
	}

	// Ownership can be accepted by the new onwer only
    // Fires an Ownership transfer event
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

}

contract Lottery {
	bytes32 winningGuess; // hash of the winning guess
	address[] winnerlist; // list of winners
	bool isClosed; // tells if the game is closed
	mapping (address=>uint256) balance; // token balance for users

	event Winner(address winAddress); // emit this event when a users guesses correctly

	function Lottery(bytes32 winHash) public {
		winningGuess = winHash;
		isClosed = false;
	}

	// This function takes ether and transfers participation tokens to users
	function buyToken() public payable returns (uint256 amount) {

	}

}