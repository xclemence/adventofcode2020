

const fs = require('fs')

const data = fs.readFileSync('data', 'utf8')

const allLines = data.split('\r\n');

let {endIndex, accumulator} = tryRun(allLines);

let lastReplaceIndex = -1;

while(endIndex !== allLines.length) {
    const newLines = [...allLines];

    const replaceIndex = newLines.findIndex((x, index) => (x[0] === 'j' || x[0] === 'n') && index > lastReplaceIndex && x !== 'nop +0');
    lastReplaceIndex = replaceIndex;
    if (newLines[replaceIndex][0] === 'j') {
        newLines[replaceIndex] = newLines[replaceIndex].replace('jmp', 'nop');
    } else {
        newLines[replaceIndex] = newLines[replaceIndex].replace('nop', 'jmp');
    }

    ({endIndex, accumulator} = tryRun(newLines));

    console.log(`index info : ${endIndex} | ${allLines.length}`);
}

console.log(`index info : ${endIndex} | ${allLines.length}`);
console.log(`result : ${accumulator}`);

function tryRun(lines) {
    let accumulator = 0;
    const runIndexes = [];
    
    let currentIndex = 0;
    
    while(!runIndexes.find(x => x === currentIndex) && currentIndex !== lines.length) {
        runIndexes.push(currentIndex);
    
        const instruction = lines[currentIndex];
    
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
    
    return {endIndex: currentIndex, accumulator};
}

