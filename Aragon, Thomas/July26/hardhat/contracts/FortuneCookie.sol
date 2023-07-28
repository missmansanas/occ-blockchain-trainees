// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract FortuneCookie is VRFV2WrapperConsumerBase, ConfirmedOwner {
    event GetID(uint256 requestID);
    event FortuneStatus(uint256 requestID, FortuneTypes fortuneType, string fortune);

    enum FortuneTypes { NONE, GOOD, NEUTRAL, BAD }

    struct Fortune {
        uint256 fees;
        bool fulfilled;
        uint256 randomFortuneType;
        uint256 randomFortune;
        address to;
        FortuneTypes fortuneType;
        string fortune;
    }

    mapping(uint256 => Fortune) public fortunes;

    string[] good = [
        "A new opportunity lies ahead of you.",
        "You will be blessed with love (and cash).",
        "You will meet someone new, hopefully a fellow programmer.",
        "Business will be booming, much like your career.",
        "Your code will be error-free for an entire week.",
        "Today is your lucky day.",
        "Your dreams will come true sooner than you think (as long as you wake up)."
    ];

    string[] neutral = [
        "Overthinking is your greatest enemy.",
        "Be careful who you tell your secrets to.",
        "Think before you speak, especially when meeting the in-laws.",
        "Prepare yourself for the unknown.",
        "Damned if you do, damned if you don't.",
        "Try and try until you compile and deploy without errors.",
        "In your parent's eyes, you are always too old or too young, depending on their mood."
    ];

    string[] bad = [
        "You will suffer 86,400 seconds of bad luck.",
        "Your partner will dump you and take away all your money.",
        "Your love life, much like your code, will be riddled with issues.",
        "Your partner is only as trustworthy as a dApp without an oracle.",
        "You're just having an unlucky streak today.",
        "You will be fired from your job for unknown reasons.",
        "A close family member will pass... by, and you won't even notice."
    ];

    uint32 constant callbackGasLimit = 300000;
    uint16 constant requestConfirmations = 3;
    uint32 constant numWords = 2;

    address constant linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address constant vrfWrapper = 0x99aFAf084eBA697E584501b8Ed2c0B37Dd136693;

    constructor() ConfirmedOwner(msg.sender) VRFV2WrapperConsumerBase(linkAddress, vrfWrapper) {}

    function getFortune() external returns(uint256) {
        uint256 requestID = requestRandomness(callbackGasLimit, requestConfirmations, numWords);
        fortunes[requestID] = Fortune ({
            fees: VRF_V2_WRAPPER.calculateRequestPrice(callbackGasLimit),
            fulfilled: false,
            randomFortuneType: 0,
            randomFortune: 0,
            to: msg.sender,
            fortuneType: FortuneTypes(0),
            fortune: ""
        });

        emit GetID(requestID);
        return requestID;
    }

    function fulfillRandomWords(uint256 requestID, uint256[] memory randomWords) internal override {
        require(fortunes[requestID].fees > 0, "Request not found.");
        fortunes[requestID].fulfilled = true;
        fortunes[requestID].randomFortuneType = randomWords[0];
        fortunes[requestID].randomFortune = randomWords[1];
        string[] memory myFortune;
        uint256 result = (fortunes[requestID].randomFortuneType % 3) + 1;
        fortunes[requestID].fortuneType = FortuneTypes(result);

        if (result == 1) myFortune = good;
        else if (result == 2) myFortune = neutral;
        else if (result == 3) myFortune = bad;

        fortunes[requestID].fortune = myFortune[fortunes[requestID].randomFortune % myFortune.length];

        emit FortuneStatus(requestID, fortunes[requestID].fortuneType, fortunes[requestID].fortune);
    }

    function getStatus(uint256 requestID) public view returns(Fortune memory) {
        return fortunes[requestID];
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(linkAddress);
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }
}

// 0x1537C39dE67A2FF1eD8A82C53B3C2eBb8A31B1d5