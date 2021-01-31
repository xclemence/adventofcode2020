package xce.day13

import java.io.File
import kotlin.math.*

fun main() {
    val fileName = "data.txt"
    
    val lines = File(fileName).readLines()

    var bus = lines[1].split(',').asSequence()
                        .mapIndexed { idx, value -> object { val number = value; val timeDelay = idx } }
                        .filter { it.number != "x"  }
                        .map { object { val number = it.number.toInt(); val  timeDelay = it.timeDelay } }
                        .sortedByDescending { it.number }
                        .toList()

    val biggerBus = bus.first()

    bus = bus - biggerBus;

    var iterationNumber = 1L
    var currentBiggerValue: Long

    do {
        var end = true
        currentBiggerValue = iterationNumber * biggerBus.number;

        for(item in bus) {
            val diffWithBigger = item.timeDelay - biggerBus.timeDelay
            var timeCandidate = currentBiggerValue + diffWithBigger

            end = (timeCandidate % item.number.toLong()) == 0L
            
            if (!end)
                break
        }

        iterationNumber++;

    } while (!end) 

    var firstTime = currentBiggerValue - biggerBus.timeDelay

    println("Result : $iterationNumber, bigger Time: $firstTime")

    // end result 487905974205117 => 10248.975 seconds
}