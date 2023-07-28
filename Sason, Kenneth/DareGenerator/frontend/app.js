const contractAbi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "OwnershipTransferRequested",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "requestId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "randomWords",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "payment",
        type: "uint256",
      },
    ],
    name: "RequestFulfilled",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "requestId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint32",
        name: "numWords",
        type: "uint32",
      },
    ],
    name: "RequestSent",
    type: "event",
  },
  {
    inputs: [],
    name: "acceptOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getLinkBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_requestId",
        type: "uint256",
      },
    ],
    name: "getRequestStatus",
    outputs: [
      {
        internalType: "uint256",
        name: "paid",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "fulfilled",
        type: "bool",
      },
      {
        internalType: "uint256[]",
        name: "randomWords",
        type: "uint256[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "lastRequestId",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_requestId",
        type: "uint256",
      },
      {
        internalType: "uint256[]",
        name: "_randomWords",
        type: "uint256[]",
      },
    ],
    name: "rawFulfillRandomWords",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "requestDare",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "requestIds",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "requestRandomWords",
    outputs: [
      {
        internalType: "uint256",
        name: "requestId",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "s_requests",
    outputs: [
      {
        internalType: "uint256",
        name: "paid",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "fulfilled",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "showRandomWord",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "withdrawLink",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];
const contractAddress = "0x4C32e735eDc5a00658Dc33b9c1837c2419aAB6b4";
let MyContract;
let signer;
const provider = new ethers.providers.Web3Provider(window.ethereum, 80001);

async function getProviderOrSigner() {
  await provider.send("eth_requestAccounts", []);
  const accounts = await provider.listAccounts();
  signer = provider.getSigner(accounts[0]);
  MyContract = new ethers.Contract(contractAddress, contractAbi, signer);
  MyContract.on("RequestFulfilled", (requestId, randomWords, payment) => {
    // let resultDare = MyContract.requestDare();
    console.log("Request ID: " + requestId);
    console.log("randomWords: " + randomWords);
    console.log("paymenet : " + payment);
    // let dareTextElement = (document.getElementById("dare-text").innerText =
    //   resultDare);
  });
}
setInterval(timer, 1000);

async function timer() {
  _getLinkBalance();
}
async function _getLinkBalance() {
  let linkBalance = await MyContract.getLinkBalance();
  console.log(linkBalance);
  let link = await linkBalance;
  link = ethers.utils.formatEther(link);
  document.querySelector(".balance-text").innerText =
    parseFloat(link).toFixed(3);
}
function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
async function getProviderOrSigner() {
  try {
    await provider.send("eth_requestAccounts", []);
    const accounts = await provider.listAccounts();
    signer = provider.getSigner(accounts[0]);
    MyContract = new ethers.Contract(contractAddress, contractAbi, signer);
    console.log("Connected to contract:", MyContract.address);
  } catch (error) {
    console.error("Failed to connect to contract:", error);
  }
}
async function updateDareText() {
  try {
    let dareTextElement = document.getElementById("dare-text");
    //dareTextElement.innerText = "Generating new dare...";
    let resultDare = await MyContract.requestDare();
    dareTextElement.innerText = "Generating new dare...";
    setTimeout(() => {
      dareTextElement.innerText = resultDare;
      console.log("Dare text updated:", resultDare);
    }, 3000);
  } catch (error) {
    console.error("Error while updating dare text:", error);
  }
}

async function getDare() {
  try {
    //let requestNum = await getRandomWords();
    await updateDareText();
  } catch (error) {
    console.error("Error while getting dare:", error);
  }
}
async function getRandomWords() {
  try {
    let requestNum = await MyContract.requestRandomWords();
    console.log("Random words requested with requestId:", requestNum);
    return requestNum;
  } catch (error) {
    console.error("Error while requesting random words:", error);
    throw error;
  }
}
async function showRandomWord() {
  let randomWord = await MyContract.showRandomWord();
  let dareTextElement = document.getElementById("dare-text");
  dareTextElement.innerText = randomWord;
}
async function getRandomDare1() {
  try {
    // Request random words from the smart contract
    const requestId = await MyContract.requestRandomWords({ gasLimit: 500000 });

    await updateDareText();
  } catch (error) {
    console.error("Error getting random dare:", error);
  }
}
getProviderOrSigner();
