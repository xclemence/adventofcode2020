unit Position;

interface

type
  TPosition = record
    X: Integer;
    Y: Integer;

    class function IsPair(const Value: TPosition): Boolean; static;

    class function New(const x, y: Integer): TPosition; static;

    class operator Equal(const A, B: TPosition): Boolean;
    class operator NotEqual(const A, B: TPosition): Boolean;

    class function EqualityComparison(const Left, Right: TPosition): Boolean; static;
    class function Hasher(const Value: TPosition): Integer; static;
  end;

implementation

class function TPosition.New(const x, y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
end;

class function TPosition.IsPair(const Value: TPosition): Boolean;
begin
  Result := (Value.Y mod 2) = 0
end;


class operator TPosition.Equal(const A, B: TPosition): Boolean;
begin
  Result := (A.X=B.X) and (A.Y=B.Y);
end;

class operator TPosition.NotEqual(const A, B: TPosition): Boolean;
begin
  Result := not (A=B);
end;

class function TPosition.EqualityComparison(const Left, Right: TPosition): Boolean;
begin
  Result := Left=Right;
end;

class function TPosition.Hasher(const Value: TPosition): Integer;
begin
  Result := 17;
  Result := Result * 37 + Value.X;
  Result := Result * 37 + Value.Y;
end;

end.

