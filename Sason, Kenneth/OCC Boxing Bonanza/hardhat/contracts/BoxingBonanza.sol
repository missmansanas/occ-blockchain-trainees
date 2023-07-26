// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BoxingBonanza is VRFV2WrapperConsumerBase {
    event GameID(uint256 requestId);
    event GameResult(address player, uint256 requestId, bool didWin);

    address owner;
    enum PlayerChoice {
        RED,
        DRAW,
        BLUE
    }
    struct GameStatus {
        uint256 fees;
        uint256 randomWord;
        address player;
        bool didWin;
        bool fullfilled;
        PlayerChoice choice;
        uint256 entryFee;
        uint256 winningResult;
    }
    mapping(uint256 => GameStatus) public matches;
    struct Winstats {
        uint256 redWins;
        uint256 drawWins;
        uint256 blueWins;
    }
    Winstats public winStats;

    uint32 constant callbackGasLimit = 25000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 3;

    address constant linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address constant vrfWrapper = 0x99aFAf084eBA697E584501b8Ed2c0B37Dd136693;

    constructor() payable VRFV2WrapperConsumerBase(linkAddress, vrfWrapper) {
        owner = msg.sender;
    }

    function startGame(PlayerChoice choice) external payable returns (uint256) {
        uint256 requestId = requestRandomness(
            callbackGasLimit,
            requestConfirmations,
            numWords
        );
        matches[requestId] = GameStatus({
            fees: VRF_V2_WRAPPER.calculateRequestPrice(callbackGasLimit),
            randomWord: 0,
            player: msg.sender,
            didWin: false,
            fullfilled: false,
            choice: choice,
            entryFee: msg.value,
            winningResult: 0
        });
        emit GameID(requestId);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        require(matches[requestId].fees > 0, "Request not found");
        matches[requestId].fullfilled = true;
        matches[requestId].randomWord = randomWords[0];
        uint256 result = randomWords[0] % 3;
        matches[requestId].winningResult = result;
        if (matches[requestId].choice == PlayerChoice(result)) {
            matches[requestId].didWin = true;
            payable(matches[requestId].player).transfer(
                matches[requestId].entryFee * 3
            );
        }
        if (result == 0) winStats.redWins++;
        else if (result == 1) winStats.drawWins++;
        else if (result == 2) winStats.blueWins++;
        emit GameResult(
            matches[requestId].player,
            requestId,
            matches[requestId].didWin
        );
    }

    function getStatus(
        uint256 requestId
    ) public view returns (GameStatus memory) {
        return (matches[requestId]);
    }

    function getWinStats() public view returns (Winstats memory) {
        return winStats;
    }

    function getLinkBalance() public view returns (uint256) {
        return IERC20(linkAddress).balanceOf(address(this));
    }

    function getEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawLink(uint256 amount) external {
        require(owner == msg.sender, "You are not the onwer");
        require(getEthBalance() > 0, "Not Enough Balance");
        IERC20(linkAddress).transfer(msg.sender, amount);
    }

    function withdrawEth(uint256 amount) external {
        require(owner == msg.sender, "You are not the onwer");
        require(getEthBalance() > 0, "Not Enough Balance");
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {}
}
