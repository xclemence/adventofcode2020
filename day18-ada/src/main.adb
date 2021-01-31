with Ada.Text_IO; use Ada.Text_IO;

with Ada.Containers.Vectors;
with Calculate2; use Calculate2;
with Operation; use Operation;

procedure Main is
   File : File_Type;
   Start_Index : Integer;
   Sum: NaturalDouble := 0;

   package Integer_Vectors is new Ada.Containers.Vectors(Index_Type   => Natural, Element_Type => NaturalDouble);

   Results: Integer_Vectors.Vector;
begin
   Open (File => File,
         Mode => In_File,
         Name => ".\test\data");

   While not  End_Of_File (File) Loop
      Start_Index := 1;
      Results.Append(Execute (Get_Line (File), Start_Index));
   end loop;

   Close (File);

   for Result of Results loop
      Put_Line ("Result :" & Result'Image);
      Sum := Sum + Result;
   end loop;

   Put_Line ("Final Sum :" & Sum'Image);
end Main;
