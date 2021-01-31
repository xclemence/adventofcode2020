package main

import (
    "fmt"
    "io/ioutil"
    "strings"
    "strconv"
    "math"
)

type Action struct {
    code string
    value int
}

func mouve(operations []Action) {
    currentPositionX := 0
    currentPositionY := 0

    directionX := 1
    directionY := 0

    for _, operation := range operations {
        switch operation.code {
        case "N":
            currentPositionY += operation.value
        case "S":
            currentPositionY -= operation.value
        case "E":
            currentPositionX += operation.value
        case "W":
            currentPositionX -= operation.value
        case "F":
            currentPositionX += directionX * operation.value;
            currentPositionY += directionY * operation.value;

        case "L":
            angle := float64(operation.value) * math.Pi / 180
            savedDirectionX := directionX

            directionX = savedDirectionX * int(math.Round(math.Cos(angle))) - directionY  * int(math.Round(math.Sin(angle)))
            directionY = savedDirectionX * int(math.Round(math.Sin(angle))) + directionY  * int(math.Round(math.Cos(angle)))
        case "R":
            angle := -1 * float64(operation.value) * math.Pi / 180

            savedDirectionX := directionX
            directionX = savedDirectionX * int(math.Round(math.Cos(angle))) - directionY  * int(math.Round(math.Sin(angle)))
            directionY = savedDirectionX * int(math.Round(math.Sin(angle))) + directionY  * int(math.Round(math.Cos(angle)))
        }
    }

    fmt.Printf("x: %d, y: %d, result: %d", currentPositionX, currentPositionY, int(math.Abs(float64(currentPositionX)) + math.Abs(float64(currentPositionY))))
}

func mouve2(operations []Action) {
    currentPositionX := 0
    currentPositionY := 0

    waypointX := 10
    waypointY := 1

    for _, operation := range operations {
        switch operation.code {
        case "N":
            waypointY += operation.value
        case "S":
            waypointY -= operation.value
        case "E":
            waypointX += operation.value
        case "W":
            waypointX -= operation.value
        case "F":
            currentPositionX += operation.value * waypointX;
            currentPositionY += operation.value * waypointY;

        case "L", "R":
            var angle float64

            if operation.code == "L" {
                angle = float64(operation.value) * math.Pi / 180
            } else {
                angle = -1 * float64(operation.value) * math.Pi / 180
            }

            saveWaypointX := waypointX

            waypointX = saveWaypointX * int(math.Round(math.Cos(angle))) - waypointY  * int(math.Round(math.Sin(angle)))
            waypointY = saveWaypointX * int(math.Round(math.Sin(angle))) + waypointY  * int(math.Round(math.Cos(angle)))
        }
    }

    fmt.Printf("x: %d, y: %d, result: %d", currentPositionX, currentPositionY, int(math.Abs(float64(currentPositionX)) + math.Abs(float64(currentPositionY))))
}

func main() {

    content, _ := ioutil.ReadFile("data.txt")
    
    linesString := string(content)
    lines := strings.Split(linesString,"\r\n")

    actions := [] Action{}

    for _, line := range lines {
        value, _ := strconv.Atoi(line[1:])
        actions = append(actions, Action { line[0:1], value})
    }

    mouve2(actions)
}