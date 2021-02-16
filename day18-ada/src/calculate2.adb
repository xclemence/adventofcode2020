with Operation; use Operation;

package body Calculate2 is
   
   procedure Update_Result(Value: NaturalDouble;
                           Result: in out NaturalDouble;
                           Operation: OperationMethod) is
   begin
      if Result = -1 then
         Result := Value;
      else
         Result := Operation(Result, Value);                                          
      end if;
         
   end Update_Result;

   function Execute(Value: String;
                    Current_Index: in out Integer;
                    Priority_Mode: Boolean := False) return NaturalDouble is
   
      Current_Element: Character;
      Result: NaturalDouble;
      Value_String : string(1..1);
      Current_Operation: OperationMethod;
       
   begin
      
      Result := -1;
      Current_Operation := Add'Access;

      if Current_Index > Value'Length then
         return Result;
      end if;
      
      while Current_Index <= Value'Length loop

         Current_Element := Value(Current_Index);
         Current_Index := Current_Index + 1;
         
         if Current_Element /= ' ' then
            case Current_Element is
               when '(' =>
                  
                  Update_Result(Execute(Value, Current_Index, False), Result, Current_Operation);
               when ')' =>
                  if Priority_Mode then
                     Current_Index := Current_Index - 1;
                  end if;
                  
                  return Result;
               when '+' =>
                  Current_Operation := Add'Access;
               when '*' =>
                  if Priority_Mode then
                     Current_Index := Current_Index - 1;
                     return Result;
                  else
                     Update_Result(Execute(Value, Current_Index, True), Result, Multiple'Access);
                  end if;
               when others =>
                  Value_String(1) := Current_Element;
                  Update_Result(NaturalDouble'Value (Value_String), Result, Add'Access);
            end case;
         end if;
         
      end loop;
            
      return Result;
   end Execute;


end Calculate2;
