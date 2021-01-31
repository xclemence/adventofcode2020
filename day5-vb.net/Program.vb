Imports System.IO

Module Program
    Sub Main(args As String())
        Dim lines = File.ReadAllLines(".\input.txt")

        Dim index = lines.Select(Function(x) GetIndex(x.Substring(0, 7), 127, "F") * 8 + GetIndex(x.Substring(x.Length - 3), 7, "L")).ToList()

        Console.WriteLine($"result {index.Max()}")

        Console.WriteLine($"result {GetPlace(index)}")

    End Sub

    Private Function GetPlace(ByRef values As IList(Of Integer))

        Dim orderedItems = values.OrderBy(Function(x) x).ToList()

        For index = 1 To orderedItems.Count - 1 Step 1
            If orderedItems(index - 1) + 2 = orderedItems(index) Then
                Return orderedItems(index) - 1
            End If
        Next index

        Return 0

    End Function

    Private Function GetIndex(values As String, maxInit As Integer, splitter As Char) As Integer
        Dim min = 0
        Dim max = maxInit

        For Each item In values
            If item = splitter Then
                max = min + Math.Truncate((max - min) / 2)
            Else
                min += Math.Truncate((max - min) / 2) + 1
            End If

        Next


        Return If(values.Last() = splitter, min, max)
    End Function
End Module
