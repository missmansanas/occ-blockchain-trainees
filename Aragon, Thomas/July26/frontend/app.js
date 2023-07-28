let toggleOn = false;

const ContractAddress = "0xb037E0832FcDFa82d12ee608C92cc98aCE3fEa6F";
const ContractABI = [
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "requestID",
          "type": "uint256"
        },
        {
          "indexed": false,
          "internalType": "enum FortuneCookie.FortuneTypes",
          "name": "fortuneType",
          "type": "uint8"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "fortune",
          "type": "string"
        }
      ],
      "name": "FortuneStatus",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "requestID",
          "type": "uint256"
        }
      ],
      "name": "GetID",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "from",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "to",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferRequested",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "from",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "to",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "acceptOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "fortunes",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "fees",
          "type": "uint256"
        },
        {
          "internalType": "bool",
          "name": "fulfilled",
          "type": "bool"
        },
        {
          "internalType": "uint256",
          "name": "randomFortuneType",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "randomFortune",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "to",
          "type": "address"
        },
        {
          "internalType": "enum FortuneCookie.FortuneTypes",
          "name": "fortuneType",
          "type": "uint8"
        },
        {
          "internalType": "string",
          "name": "fortune",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getFortune",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "requestID",
          "type": "uint256"
        }
      ],
      "name": "getStatus",
      "outputs": [
        {
          "components": [
            {
              "internalType": "uint256",
              "name": "fees",
              "type": "uint256"
            },
            {
              "internalType": "bool",
              "name": "fulfilled",
              "type": "bool"
            },
            {
              "internalType": "uint256",
              "name": "randomFortuneType",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "randomFortune",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "to",
              "type": "address"
            },
            {
              "internalType": "enum FortuneCookie.FortuneTypes",
              "name": "fortuneType",
              "type": "uint8"
            },
            {
              "internalType": "string",
              "name": "fortune",
              "type": "string"
            }
          ],
          "internalType": "struct FortuneCookie.Fortune",
          "name": "",
          "type": "tuple"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_requestId",
          "type": "uint256"
        },
        {
          "internalType": "uint256[]",
          "name": "_randomWords",
          "type": "uint256[]"
        }
      ],
      "name": "rawFulfillRandomWords",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "to",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "withdrawLink",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]

let fortuneCookieContract;
let signer;

const provider = new ethers.providers.Web3Provider(window.ethereum, 80001);
getProviderOrSigner();

async function getProviderOrSigner() {
	provider.send("eth_requestAccounts", []).then(() => {
		provider.listAccounts().then((accounts) => {
			signer = provider.getSigner(accounts[0]);
			fortuneCookieContract = new ethers.Contract(
				ContractAddress,
				ContractABI,
				signer
			);
			fortuneCookieContract.on("FortuneStatus", (requestID, fortuneType, fortune) => {
				handleResult(requestID).then(() => {
					if (toggleOn == true) {
					    loadResult();
					}
					toggleOn = false;
				})
            });
		});
	});
}

async function handleResult(requestID) {
    const currentAddress = await signer.getAddress();
    let result = await fortuneCookieContract.getStatus(requestID);
    if (currentAddress === result[4]) {
		  toggleOn = true;
      let fortuneType = result[5];
      let fortune = result[6];
      document.getElementById("wait").innerText="Your fortune has arrived!";

      if(fortuneType == "1") {
			  document.getElementById("result").innerText = "GOOD";
			  document.getElementById("result").style.color = "green";
        document.getElementById("message").innerText = fortune; 
      }
      else if(fortuneType == "2") {
			  document.getElementById("result").innerText = "NEUTRAL";
			  document.getElementById("result").style.color = "yellow";
        document.getElementById("message").innerText = fortune; 
      }
      else if(fortuneType == "3"){
			  document.getElementById("result").innerText = "BAD";
			  document.getElementById("result").style.color = "red"; 
        document.getElementById("message").innerText = fortune;
      }
	}
}

function loadResult() {
  document.querySelector('.result').classList.toggle('hidden');
}

function loadWaiting() {
  document.querySelector('.waiting').classList.toggle('hidden');
}

function buttonPopUp() {
  document.querySelector('.button').classList.toggle('hidden');
}

async function getFortune() {
  try {
      var requestID = await fortuneCookieContract.getFortune({ gasLimit: 300000 });
      buttonPopUp();
      loadWaiting();
      document.getElementById("wait").innerText="Generating your fortune...";
  } catch (error) {
      console.error(error);
  }
}