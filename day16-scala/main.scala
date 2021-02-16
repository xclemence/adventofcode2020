import scala.io.Source
import java.io.File
import scala.collection.mutable.ArrayBuffer

class FieldRange (var min: Int, var max: Int) {
  override def toString(): String = s"[${min} - ${max}]"

  def isValid(value: Int): Boolean = value >= min && value <= max

}

class Field (var name: String, var allowedValues: Vector[FieldRange], var positionCandidates: ArrayBuffer[Int] = ArrayBuffer[Int]()) {
  def position(): Int = if(positionCandidates.size == 1) positionCandidates.head else -1

  override def toString(): String = s"Position ${positionCandidates} - ${name} - ${allowedValues}"
}

object Factory {
  def createField(line: String): Field = {
    println(line)
    val pattern = """(.*): (\d+)-(\d+) or (\d+)-(\d+)""".r

    val pattern(name, val1, val2, val3, val4) = line

    new Field(name, Vector(new FieldRange(val1.toInt, val2.toInt), new FieldRange(val3.toInt, val4.toInt)))
  }

  def createValues(line: String): Vector[Int] = line.split(",").map(x => x.toInt).toVector  
}

object Analyser {
  def findPositionCandidate(fields: ArrayBuffer[Field], values: ArrayBuffer[Vector[Int]]): Unit = {
    val valueNumber = values.head.size

    fields.foreach(f => {
      for(index <- 0 to valueNumber -1) {
        if (values.forall(x => f.allowedValues.exists(r => r.isValid(x(index)))))
          f.positionCandidates += index
      }
    })
  }

  def consolidateFieldPosition(fields: ArrayBuffer[Field]): Unit = {

    val sortedValues = fields.sortBy(x => x.positionCandidates.size)

    for(index <- 0 to sortedValues.size -1) {
      val currentPosition =  sortedValues(index).position()
      sortedValues.slice(index + 1, sortedValues.size).foreach(x => x.positionCandidates -= currentPosition)
    }
  }
}

object Day16 extends App {
    val filename = "data.txt"
    val fileContent = Source.fromFile(filename).getLines()

    var yourTicket = false
    var neabyTickets = false

    val fields = ArrayBuffer[Field]()
    val values = ArrayBuffer[Vector[Int]]()
    var ticket = Vector[Int]()

    for (line <- fileContent) {
      line match {
        case x if (x.isEmpty()) => {}
        case x if (x.startsWith("your ticket")) => yourTicket = true
        case x if (x.startsWith("nearby tickets")) => neabyTickets = true
        case x if (!yourTicket && !neabyTickets) => fields += Factory.createField(x)
        case x if (neabyTickets) => values += Factory.createValues(x)
        case x if (!neabyTickets && yourTicket) => ticket = Factory.createValues(x)
        case _ => {}
      }
    }
    val allValues = fields.flatMap(x => x.allowedValues)
    val notValidValues = values.flatMap(x => x).filter(x => !allValues.exists(v => v.isValid(x)))
    println(s"result: ${notValidValues.sum}")

    val validValues = values.filter(x => x.forall(v => allValues.exists(r => r.isValid(v))))

    Analyser.findPositionCandidate(fields, validValues)
    Analyser.consolidateFieldPosition(fields)


    println(s"ticket: ${ticket}")

    val responsealues = fields.filter(x => x.name.startsWith("departure")).map(x => ticket(x.position()))

    var endValue: Long = 1
    responsealues.foreach(x => endValue *= x)
    println(s"goodValues: ${responsealues} -> ${endValue}")
}