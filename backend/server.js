const express = require('express');
const Web3 = require('web3');
const { abi, networks } = require('../smart-contract/NFTMinter.json');

const app = express();
const port = process.env.PORT || 3000;

const web3 = new Web3('https://mainnet.infura.io/v3/3eda99f3f1644f62a87d781578f6e34f');
const contractAddress = networks['1'].address;
const contract = new web3.eth.Contract(abi, contractAddress);

app.use(express.json());

app.post('/mint-nft', async (req, res) => {
    const { recipient, tokenURI } = req.body;

    const gas = await contract.methods.mintNFT(recipient, tokenURI).estimateGas();
    const gasPrice = await web3.eth.getGasPrice();

    const data = contract.methods.mintNFT(recipient, tokenURI).encodeABI();

    const nonce = await web3.eth.getTransactionCount('YOUR_SENDER_ADDRESS');
    const signedTx = await web3.eth.accounts.signTransaction(
        {
            to: contractAddress,
            gas,
            gasPrice,
            data,
            nonce,
        },
        'YOUR_PRIVATE_KEY'
    );

    web3.eth
        .sendSignedTransaction(signedTx.rawTransaction)
        .on('receipt', (receipt) => {
            res.json({ transactionHash: receipt.transactionHash });
        })
        .on('error', (error) => {
            res.status(500).json({ error: 'Minting NFT failed' });
        });
});

app.listen(port, () => {
    console.log(`Backend server is running on port ${port}`);
});
