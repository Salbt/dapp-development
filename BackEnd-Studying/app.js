import express from 'express'
import bodyParser from 'body-parser'
import fileUpload from 'express-fileupload'
import { uploadFileToIPFS, updatedJSONToIPFS } from './ipfs-uploader.js'
import { mint } from './ntf-minter.js'


const app = express()

const port = 4100

app.set('view engine', 'ejs')
app.use(bodyParser.urlencoded({extended: true}))
app.use(fileUpload())

app.get('/',(req, res) => {
    res.send('Hello, world')
})

app.get('/load', (req, res) => {
    res.render("load")
})

app.post('/upload', (req, res) => {
    const title = req.body.title
    const description = req.body.description
    
    console.log(title, description)
    console.log(req.files)

    const file = req.files.file
    const filename = file.name
    const filePath = "files/" + filename

    file.mv(filePath, async (err) => {
        if (err) {
            console.log(err)
            res.status(500).send("err occured")
        }
    
        const fileResult = await uploadFileToIPFS(filePath)
        const fileCid = fileResult.cid.toString()
        // metadata的封装
        const metadata = {
            title: title,
            description: description,
            image: 'http://127.0.0.1:8081/ipfs' + fileCid
        }

        const metadataResult = await updatedJSONToIPFS(metadata)
        const metadataCid = metadataResult.cid.toString()

        console.log(metadataCid)
        
        await mint('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4','http://127.0.0.1:8081/ipfs'+ metadataCid)
        res.json({
            message : "file updated success",
            data: fileCid
        })
    })
})

app.listen(port, () => {
    console.log(`Running a app in ${port}`)
})