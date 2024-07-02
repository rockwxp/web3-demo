const { proofOfWork } = require('./get-hash-pow');
const crypto = require('crypto');
//ganerate rsa key pair
function generateKeyPair(){
    return crypto.generateKeyPairSync('rsa', {
        modulusLength: 2048,
        publicKeyEncoding: {
            type: 'spki',
            format: 'pem'
        },
        privateKeyEncoding: {
            type: 'pkcs8',
            format: 'pem'
        }
    });
}

//use private key to sign message
function signContent(privateKey,content){
    const sign = crypto.createSign('SHA256');
    sign.update(content);
    sign.end();
    return sign.sign(privateKey,'hex');
}

//use public key to verify message
function verifySignature(publicKey, contnet,signature){
    const verify = crypto.createVerify('SHA256');
    verify.update(contnet);
    verify.end();
    return verify.verify(publicKey,signature,'hex');
}

const {publicKey,privateKey} = generateKeyPair();
console.log(`publicKey:${publicKey},privateKey:${privateKey}`);



const powResult = proofOfWork('rock',4);
const content = powResult.content;
const signature =signContent(privateKey,content);
console.log(powResult);
console.log(`content ${content}`);
console.log(`signature:${signature}`);

const isVerified = verifySignature(publicKey,content,signature);
console.log(isVerified);
