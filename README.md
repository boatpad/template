# INTRO
BoatPad is the first decentralized real Yacht Lottery Platform on the Polygon (MATIC) network.

Thanks to BoatPad, you can participate in the yacht lottery and win a real yacht.

[Web Site](https://boatpad.io/)

[Twitter](https://twitter.com/BoatPadIO)

[Telegram Channel](https://t.me/boatpad_io)

[Telegram Group](https://t.me/boatpadiopublic)

[Medium](https://medium.com/@BoatPadIO)

## What Is BoatPad?

BoatPad is a decentralized yacht lottery and real yacht selling platform on the Polygon network. It is necessary to buy a minimum of 1 and a maximum 100 tickets to participate in the yacht lottery. Buying more tickets increases the chances of winning a real yacht. If the ticket sales process is not completed or the yacht sales process is not completed, the ticket fees will be sent to the participants back. In addition, each ticket to be issued will be a reliable and unbiased unique number randomly generated using Chainlink VRF. There is a smart contract for each yacht. Therefore, there is no human factor at the yacht lottery.

The fact that yacht prices are expensive does not mean that you can no longer own a real yacht. You can win a real yacht for 1 ticket (~$1). The winner of the lottery will be a real yacht owner and will receive 1 year yacht expenses as a reward.

### Polygon (MATIC) provides you to trade with low costs.

Yacht application or brokerage application can be made independently on the BoatPad platform. All transactions, from yacht price to sales, will be controlled by reliable agents. Each yacht contract includes system administrator, yacht owner, agent, broker and participants.

# How To
1. Buy Ticket: Anyone with a Metamask wallet can participate in the lottery. In order to complete the lottery, the yacht price and the 1-year expense price must be collected. If not collected the budget, the 90% of the refund will be given back to all participants by the smart contract


2. Increment: After the yacht price and 1 year yacht expenses are collected, the costs for the system administrator, yacht owner, agent and broker will be determined


3. Lottery: The lottery will be done from a random ticket bag with Chainlink VRF. The main and alternate winners will be chosen


4. Sale: The winner of the lottery and the yacht owner must carry out the buying and selling process. In order for the sale to take place, the agency and broker must additionally approve. If the purchase and sale is not realized, 70% of the budget will be refunded to all participants by the smart contract


5. Sold: With the approval of the agent, the smart contract will send 97% of the yacht budget to the yacht owner and 3% to the broker. The smart contract will send 70% of the increment fee to the system administrator, 15% to the yacht owner, 5% to the broker and 10% to the agent


# Development

npm install
npx yarn add @chainlink/contracts

npm run compile
npm run test

npm run migrateTest
npm run migrateProd

# Verify
verify
npm install -D truffle-plugin-verify
npx truffle run verify BEP20Token@{deployed-address} --network mumbai
npx truffle run verify Name__0001@{CONTRACTADDRESS} --network mumbai
