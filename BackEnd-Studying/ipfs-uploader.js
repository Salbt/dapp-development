import { create } from 'kubo-rpc-client'
import fs from 'fs'

const ipfs = create('http://localhost:5001')

export async function uploadFileToIPFS(filePath){
    const file = fs.readFileSync(filePath)
    const result = await ipfs.add({
        path: filePath,
        content: file
    })
    return result
}

export async function updatedJSONToIPFS(json){
    const result = await ipfs.add(JSON.stringify(json))
    return result
}

uploadFileToIPFS("files/Image_1700125308698.jpg")
updatedJSONToIPFS({name: "test"})