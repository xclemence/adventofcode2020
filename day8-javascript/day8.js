

const fs = require('fs')

const data = fs.readFileSync('data', 'utf8')

const allLines = data.split('\r\n');

let accumulator = 0;
const runIndexes = [];

let currentIndex = 0;
console.log(`${allLines.length} -> ${currentIndex}`);

while(!runIndexes.find(x => x === currentIndex) && currentIndex !== allLines.length) {
    runIndexes.push(currentIndex);

    const instruction = allLines[currentIndex];

    const operation = instruction.slice(0,3);
    const value = instruction.slice(4);

    if(operation === 'acc') {
        accumulator+= +value;
        currentIndex++;
    } else if (operation === 'jmp') {
        currentIndex+= +value
    } else {
        currentIndex++;
    }
}

console.log(`result : ${accumulator}`);
