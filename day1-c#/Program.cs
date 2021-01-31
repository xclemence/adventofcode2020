using System;
using System.IO;
using System.Linq;

var noteString = await File.ReadAllLinesAsync(@".\notes.txt");

var notes = noteString.Select(x => int.Parse(x)).ToArray();

Part1();
Part2();

void Part1()
{
    foreach (var item in notes)
    {
        var corresponding = notes.FirstOrDefault(x => x + item == 2020);

        if (corresponding != 0)
        {
            Console.WriteLine($"{item} - {corresponding}");
            return;
        }
    }
}

void Part2()
{
    for (var i = 0; i < notes.Length; ++i)
    {
        for (var j = i + 1; j < notes.Length; ++j)
        {
            var corresponding = notes.Skip(j).FirstOrDefault(x => x + notes[i] + notes[j] == 2020);

            if (corresponding != 0)
            {
                Console.WriteLine($"{notes[i]} - {notes[j]} - {corresponding}");
                return;
            }
        }
    }

}

