// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract VRFv2DirectFundingConsumer is VRFV2WrapperConsumerBase, ConfirmedOwner {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords, uint256 payment);

    struct RequestStatus {
        uint256 paid; // amount paid in link
        bool fulfilled; // whether the request has been successfully fulfilled
        uint256[] randomWords;
    }

    mapping(uint256 => RequestStatus) public s_requests; /* requestId --> requestStatus */
    uint256[] public requestIds;
    uint256 public lastRequestId;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3; // The default is 3, but you can set this higher.
    uint32 numWords = 2; // For this example, retrieve 2 random values in one request.
    address linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address wrapperAddress = 0x99aFAf084eBA697E584501b8Ed2c0B37Dd136693;

    string[] fortunes = [
        // Good
        "A new opportunity lies ahead of you.",
        "You will be blessed with love (and cash).",
        "You will meet someone new, hopefully a fellow programmer.",
        "Business will be booming, much like your career.",
        "Your code will be error-free for an entire week.",
        "Today is your lucky day.",
        "Your dreams will come true sooner than you think (as long as you wake up).",
        // Neutral
        "Overthinking is your greatest enemy.",
        "Be careful who you tell your secrets to.",
        "Think before you speak, especially in a Webinar.",
        "Prepare yourself for the unknown.",
        "Damned if you do, damned if you don't.",
        "Try and try until you compile and deploy without errors.",
        "In your parent's eyes, you are always too old or too young, depending on their mood.",
        "You will suffer 86,400 seconds of bad luck.",
        // Bad
        "Your partner will dump you and take away all your money.",
        "Your love life, much like your code, will be riddled with issues.",
        "Your partner is only as trustworthy as a dApp without an oracle.",
        "You're just having an unlucky streak today.",
        "You will be elimintaed from OCC by the end of this week.",
        "A close family member will pass... by, and you won't even notice."
    ];

    constructor() ConfirmedOwner(msg.sender) VRFV2WrapperConsumerBase(linkAddress, wrapperAddress) {}

    function requestRandomWords() external onlyOwner returns (uint256 requestId) {
        requestId = requestRandomness(callbackGasLimit, requestConfirmations, numWords);
        s_requests[requestId] = RequestStatus({
            paid: VRF_V2_WRAPPER.calculateRequestPrice(callbackGasLimit),
            randomWords: new uint256[](0),
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords ) internal override {
        require(s_requests[_requestId].paid > 0, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords, s_requests[_requestId].paid);
    }

    function getRequestStatus(uint256 _requestId) external view returns (uint256 paid, bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].paid > 0, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.paid, request.fulfilled, request.randomWords);
    }

    function getFortune(uint256 _requestId) external view returns(string memory){
        require(s_requests[_requestId].fulfilled, "Request not yet fulfilled.");
        uint256[] memory numbers = s_requests[_requestId].randomWords;
        uint index = ((numbers[0] % 3) * 7) + (numbers[1] % 7);
        return fortunes[index];
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(linkAddress);
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }
}