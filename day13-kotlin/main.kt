package xce.day13

import java.io.File
import kotlin.math.*

fun main() {
    val fileName = "data.txt"
    
    val lines = File(fileName).readLines()

    var minTime = lines[0].toInt()

    var bus = lines[1].split(',').asSequence()
                        .filter { it != "x"  }
                        .map { it.toInt() }
                        .map { 
                            var runNumber = Math.ceil(minTime / it.toDouble())
                            object { val bus = it; var horaire = it * runNumber }
                        }
                        .sortedBy { it.horaire }
                        
    bus.forEach { println("${it.bus} - ${it.horaire}") }

    var goodBus = bus.first()
    
    println("result : ${goodBus.bus * (goodBus.horaire - minTime )}")
}