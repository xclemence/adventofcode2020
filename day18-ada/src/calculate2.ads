with Operation; use Operation;

package Calculate2 is
   function Execute(Value: String;
                    Current_Index: in out Integer;
                    Priority_Mode: Boolean := False) return NaturalDouble;

end Calculate2;
