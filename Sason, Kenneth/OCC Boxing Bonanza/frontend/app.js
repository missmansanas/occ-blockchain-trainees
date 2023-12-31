let choice;
let multiplier = 0;
let betAmount = 0;
let togleOn = false;

const ContractAddress = "0x2F73d2863Bf3A6879d91810e000f29d002bFEff0";
const ContractABI = [
  { inputs: [], stateMutability: "payable", type: "constructor" },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "requestId",
        type: "uint256",
      },
    ],
    name: "GameID",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "requestId",
        type: "uint256",
      },
      { indexed: false, internalType: "bool", name: "didWin", type: "bool" },
    ],
    name: "GameResult",
    type: "event",
  },
  {
    inputs: [],
    name: "getEthBalance",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getLinkBalance",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "requestId", type: "uint256" }],
    name: "getStatus",
    outputs: [
      {
        components: [
          { internalType: "uint256", name: "fees", type: "uint256" },
          { internalType: "uint256", name: "randomWord", type: "uint256" },
          { internalType: "address", name: "player", type: "address" },
          { internalType: "bool", name: "didWin", type: "bool" },
          { internalType: "bool", name: "fullfilled", type: "bool" },
          {
            internalType: "enum BoxingBonanza.PlayerChoice",
            name: "choice",
            type: "uint8",
          },
          { internalType: "uint256", name: "entryFee", type: "uint256" },
          { internalType: "uint256", name: "winningResult", type: "uint256" },
        ],
        internalType: "struct BoxingBonanza.GameStatus",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getWinStats",
    outputs: [
      {
        components: [
          { internalType: "uint256", name: "redWins", type: "uint256" },
          { internalType: "uint256", name: "drawWins", type: "uint256" },
          { internalType: "uint256", name: "blueWins", type: "uint256" },
        ],
        internalType: "struct BoxingBonanza.Winstats",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "matches",
    outputs: [
      { internalType: "uint256", name: "fees", type: "uint256" },
      { internalType: "uint256", name: "randomWord", type: "uint256" },
      { internalType: "address", name: "player", type: "address" },
      { internalType: "bool", name: "didWin", type: "bool" },
      { internalType: "bool", name: "fullfilled", type: "bool" },
      {
        internalType: "enum BoxingBonanza.PlayerChoice",
        name: "choice",
        type: "uint8",
      },
      { internalType: "uint256", name: "entryFee", type: "uint256" },
      { internalType: "uint256", name: "winningResult", type: "uint256" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "uint256", name: "_requestId", type: "uint256" },
      { internalType: "uint256[]", name: "_randomWords", type: "uint256[]" },
    ],
    name: "rawFulfillRandomWords",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "enum BoxingBonanza.PlayerChoice",
        name: "choice",
        type: "uint8",
      },
    ],
    name: "startGame",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "winStats",
    outputs: [
      { internalType: "uint256", name: "redWins", type: "uint256" },
      { internalType: "uint256", name: "drawWins", type: "uint256" },
      { internalType: "uint256", name: "blueWins", type: "uint256" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "amount", type: "uint256" }],
    name: "withdrawEth",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "amount", type: "uint256" }],
    name: "withdrawLink",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  { stateMutability: "payable", type: "receive" },
];
let MyContract;
let signer;
const provider = new ethers.providers.Web3Provider(window.ethereum, 80001);
async function getProviderOrSigner() {
  provider.send("eth_requestAccounts", []).then(() => {
    provider.listAccounts().then((accounts) => {
      signer = provider.getSigner(accounts[0]);
      MyContract = new ethers.Contract(ContractAddress, ContractABI, signer);
      MyContract.on("GameResult", (player, requestId, didWin) => {
        handleResult(player, requestId).then(() => {
          if (togleOn == true) {
            var logBtn = document.querySelector(".log-btn");
            logBtn.click();
          }
          togleOn = false;
        });
      });
    });
  });
}
async function handleResult(address, requestId) {
  const currentAddress = await signer.getAddress();
  let result = await MyContract.getStatus(requestId);
  if (currentAddress === result[2]) {
    updateAnimation();
    togleOn = true;
    let winningResult = (await ethers.utils.formatEther(result[7])) * 10 ** 18;
    let playerChoice = await result[5];
    document.getElementById("announcement").innerText = "Place your bet!";
    if (winningResult == 0)  {
      document.getElementById("winner-result").innerText = "Red";
    } else if (winningResult == 1) {
      document.getElementById("winner-result").innerText = "Draw";
    } else if (winningResult == 2) {
      document.getElementById("winner-result").innerText = "Blue";
    }

    if (winningResult == playerChoice) {
      document.getElementById("bet-result").innerText = "You won!";
      document.getElementById("bet-result").style.color = "green";
    } else {
      document.getElementById("bet-result").innerText = "You lost!";
      document.getElementById("bet-result").style.color = "red";
    }
  }
}
getProviderOrSigner();
function updateAnimation() {
  let red = document.getElementById("red-animation");
  let engage = document.getElementById("engage-animation");
  let blue = document.getElementById("blue-animation");
  red.style.display = "block";
  blue.style.display = "block";
  engage.style.display = "none";
}
let endTime;

setInterval(timer, 1000);

async function timer() {
  _getEthBalance();
  getWalletBalance();
  getBattleStats();
}
async function getWalletBalance() {
  const bal = await signer.getBalance();
  const walletBalance = ethers.utils.formatEther(bal);
  document.getElementById("eth-balance").innerText =
    parseFloat(walletBalance).toFixed(3);
}
async function _getEthBalance() {
  let ethBalance = await MyContract.getEthBalance();
  let eth = await ethBalance;
  document.getElementById("prize-pool").innerText =
    ethers.utils.formatEther(eth) + " MATIC";
}
async function getBattleStats() {
  const winStats = await MyContract.getWinStats();
  redWins = ethers.utils.formatEther(winStats[0]) * 10 ** 18;
  drawWins = ethers.utils.formatEther(winStats[1]) * 10 ** 18;
  blueWins = ethers.utils.formatEther(winStats[2]) * 10 ** 18;
  totalMatches = redWins + drawWins + blueWins;
  document.getElementById("red-stats").innerText =
    ((redWins / totalMatches) * 100).toFixed(2) + "%";
  document.getElementById("draw-stats").innerText =
    ((drawWins / totalMatches) * 100).toFixed(2) + "%";
  document.getElementById("blue-stats").innerText =
    ((blueWins / totalMatches) * 100).toFixed(2) + "%";
}

const multiplierOne = function () {
  multiplier = 1;
};

const multiplierTwo = function () {
  multiplier = 0.1;
};

const multiplierThree = function () {
  multiplier = 0.01;
};
const selectRed = function () {
  if (multiplier == 0) {
    alert("Please select a multiplier");
  } else {
    if (choice != 0) {
      betAmount = 0;
    }
    choice = 0;
    betAmount = parseFloat((Number(betAmount) + Number(multiplier)).toFixed(2));
    document.getElementById("red").innerText = betAmount;
    document.getElementById("draw").innerText = 0;
    document.getElementById("blue").innerText = 0;
  }
};
const selectDraw = function () {
  if (multiplier == 0) {
    alert("Please select a multiplier");
  } else {
    if (choice != 1) {
      betAmount = 0;
    }
    choice = 1;
    betAmount = parseFloat((Number(betAmount) + Number(multiplier)).toFixed(2));
    document.getElementById("red").innerText = 0;
    document.getElementById("draw").innerText = betAmount.toFixed(2);
    document.getElementById("blue").innerText = 0;
  }
};
const selectBlue = function () {
  if (multiplier == 0) {
    alert("Please select a multiplier");
  } else {
    if (choice != 2) {
      betAmount = 0;
    }
    choice = 2;
    betAmount = parseFloat((Number(betAmount) + Number(multiplier)).toFixed(2));
    document.getElementById("red").innerText = 0;
    document.getElementById("draw").innerText = 0;
    document.getElementById("blue").innerText = betAmount.toFixed(2);
  }
};
async function placeBet() {
  if (betAmount == 0) {
    alert("Please select an amount to bet!");
  } else {
    let red = document.getElementById("red-animation");
    let engage = document.getElementById("engage-animation");
    let blue = document.getElementById("blue-animation");
    try {
      const msgValue = ethers.utils.parseEther(`${betAmount}`);
      let requestId = await MyContract.startGame(choice, {
        value: msgValue,
        gasLimit: 500000,
      });
      red.style.display = "none";
      blue.style.display = "none";
      engage.style.display = "block";
      document.getElementById("announcement").innerText =
        "Generating match result...";
    } catch (error) {
      console.error(error);
    }
  }
}
