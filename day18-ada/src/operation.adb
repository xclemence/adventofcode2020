package body Operation is

   function Add (Left: NaturalDouble;
                 Right: NaturalDouble) return NaturalDouble is
   begin
      return Left + Right;
   end Add;
   
   function Multiple (Left: NaturalDouble;
                     Right: NaturalDouble) return NaturalDouble is
   begin
      return Left * Right;
   end Multiple;

end Operation;
