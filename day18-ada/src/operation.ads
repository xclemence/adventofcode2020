package Operation is
   type NaturalDouble is range -1 .. +(2 ** 63 - 1);
   
   type OpeationMethod is access function(Left: NaturalDouble;
                                          Right: NaturalDouble) return NaturalDouble;

   function Add (Left: NaturalDouble;
                 Right: NaturalDouble) return NaturalDouble;
   
   function Multiple (Left: NaturalDouble;
                     Right: NaturalDouble) return NaturalDouble;
   

end Operation;
