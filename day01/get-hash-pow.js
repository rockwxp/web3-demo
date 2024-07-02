module.exports = { proofOfWork };
const crypto = require('crypto');
function proofOfWork(nickname, difficulty) {
    let nonce = 0;
    const prefix = '0'.repeat(difficulty);
    const starttime = Date.now();

    while(true){
        const text = nickname + nonce
        const hash = crypto.createHash('sha256').update(text).digest('hex');
        if(hash.startsWith(prefix)){
            const endtime = Date.now();
            const timeTaken = (endtime - starttime) /1000;
            console.log(`Found ${hash} with nonce ${nonce} in ${timeTaken} seconds`);
            const content = `${nickname},${nonce}`;   
            
            return {nonce, hash, content};
        }
        nonce++;
    }
}

const nickname = 'rock';


proofOfWork(nickname,4);
proofOfWork(nickname,5);

