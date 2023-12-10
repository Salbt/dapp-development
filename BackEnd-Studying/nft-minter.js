import { ethers, JsonRpcProvider } from 'ethers'
import fs from 'fs'

// 合约地址：0xd9145CCE52D386f254917e481eB44e9943F39138
// 账户地址：0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

export async function mint(to,url){
    const provider = new JsonRpcProvider("http://localhost:8545")
    const signer = await provider.getSigner(0)
    const contractAddress = 
    "0xd9145CCE52D386f254917e481eB44e9943F39138"
    const abi = JSON.parse(fs.readFileSync("./abi/MyNFT.json"))
    const contract = new ethers.Contract(contractAddress, abi, signer)
    const result = await contract.safeMint(to, url)
    console.log(result)
}

