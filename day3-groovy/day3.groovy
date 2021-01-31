println "hello world"

def lines = new File("input.txt") as String[]

def lineSize = lines[0].length()
def sum = 0

lines.eachWithIndex { value, index -> 
    def y = index * 3
    
    if(value[y % lineSize] == '#') {
        sum++
    }
}

println "Result $sum"
println "--------------------------------"

def r1 = count(1, 1, lines, lineSize)
def r2 = count(3, 1, lines, lineSize)
def r3 = count(5, 1, lines, lineSize)
def r4 = count(7, 1, lines, lineSize)
def r5 = count(1, 2, lines, lineSize)

def finalResult = (long)r1 * r2 * r3 * r4 * r5

println "---------------------------------"
println "Result2 $finalResult"

def count(rigth, down, lines, lineSize) {
    def number = 0;
    def incrementIndex = 0;

    for (def i = 0; i < lines.size(); i += down)
    {
        def y = incrementIndex * rigth;

        if (lines[i][y % lineSize] == '#')
            number++;

        incrementIndex++;
    }

    return number
}