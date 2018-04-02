pragma solidity ^0.4.16;

contract Ownable {
	address public owner;
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

contract Lottery is Ownable {
	bytes32 winningGuess; // hash of the winning guess
	//address[] winnerlist; // list of winners
	//uint256 winnersNum;
	address winnerAddress;
	bool isClosed; // tells if the game is closed
	mapping (address=>uint256) balance; // token balance for users

	event Winner(address winAddress); // emit this event when a users guesses correctly

	function Lottery(bytes32 winHash) public {
		// just use a simple contract (different from this) to get sha3 of winning number to keep the number completely out of this contract
		// copy that hash while calling this contructor (directly pass int and not the string)
		winningGuess = winHash;
		isClosed = false;
	}
	
	function getBalance() public view returns (uint256 balances){
	    return (balance[msg.sender]);
	}

	// This function takes ether and transfers participation tokens to users
	function buyToken() public payable returns (uint256 amount) {

		require(!isClosed);  //game must not be closed
		uint256 tokens = (msg.value) / (1 ether);

		balance[msg.sender] += tokens;
		uint256 sendBack = msg.value - (tokens * (1 ether));
		msg.sender.transfer(sendBack);
		return tokens;

	}

	// This function takes a guess and deducts a token
	function makeGuess(uint256 guess) public returns (bool success, bytes32 guessHash) {
		require(!isClosed);
		require(balance[msg.sender] >= 1);
		balance[msg.sender] --;
        success = false;
		guessHash = keccak256(guess);
		if(guessHash == winningGuess) {
			//winnersNum = winnerlist.push(msg.sender);
			winnerAddress = msg.sender;
			Winner(msg.sender);
			isClosed = true;
			success = true;
		}
	}
	
	function getWinHash() public view returns (bytes32) {
	    return winningGuess;
	}

	function closeGame() onlyOwner returns (bool) {
		isClosed = true;
		return true;
	}

	function getWinner() public view returns (address winner) {
		return winnerAddress;
	}

	function getGameStatus() public view returns (bool isGameClosed) {
		return isClosed;
	}

	function getLotteryValue() public view returns (uint256 lValue) {
		lValue = this.balance;
	}

	function getPrice() public returns (bool success) {
		require(isClosed);
		uint256 amount = this.balance - 0.1 ether; //keep some for gas cost of contract
		owner.transfer(amount/2);
		winnerAddress.transfer(amount/2);
		return true;
	}

}
