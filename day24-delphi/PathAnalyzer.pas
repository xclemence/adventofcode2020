unit PathAnalyzer;


interface
  uses Types,
    Generics.Collections,
    Generics.Defaults,
    Position;

  function FindTile(Path: string): TPosition;

  function AnalyzePaths(const Lines: TStringDynArray): TDictionary<TPosition, Boolean>;
implementation


function AnalyzePaths(const Lines: TStringDynArray): TDictionary<TPosition, Boolean>;
var
  CurrentPosition: TPosition;
  KnowTiles: TDictionary<TPosition, Boolean>;
  Line: String;
begin
   KnowTiles := TDictionary<TPosition, Boolean>.Create(
    TEqualityComparer<TPosition>.Construct(
      TPosition.EqualityComparison,
      TPosition.Hasher
    )
  );

  for Line in Lines do
  begin
    CurrentPosition := FindTile(Line);

    if KnowTiles.ContainsKey(CurrentPosition) then
      KnowTiles.Items[CurrentPosition] := not KnowTiles.Items[CurrentPosition]
    else
      KnowTiles.Add(CurrentPosition, true);
  end;

  Result := KnowTiles;
end;

function FindTile(Path: string): TPosition;
var
  Position: TPosition;
  I: Integer;
  Test: Char;
begin
  Position := TPosition.New(0,0);
  I := 1;

  while I <= Length(Path) - 1 do
  begin
    Test:= Path[I];
    if Test = 'w' then Position.X := Position.X - 1;
    if Test = 'e' then Position.X := Position.X + 1;

    if Test = 'n' then
    begin
      if (Path[I + 1] = 'e')  then
      begin
        if TPosition.IsPair(Position) then
        begin
          Position.X := Position.X + 1;
          Position.Y := Position.Y + 1;
        end
        else
          Position.Y := Position.Y + 1;
      end
      else
      begin
        if TPosition.IsPair(Position) then
          Position.Y := Position.Y + 1
        else
        begin
          Position.X := Position.X - 1;
          Position.Y := Position.Y + 1;
        end;
      end;

      I := I + 1;
    end;

    if Test = 's' then
    begin
      if (Path[I + 1] = 'e')  then
      begin
        if TPosition.IsPair(Position) then
        begin
          Position.X := Position.X + 1;
          Position.Y := Position.Y - 1;
        end
        else
          Position.Y := Position.Y - 1;
      end
      else
      begin
        if TPosition.IsPair(Position) then
          Position.Y := Position.Y - 1
        else
        begin
          Position.X := Position.X - 1;
          Position.Y := Position.Y - 1;
        end;
      end;
      I := I + 1;
    end;

    I := I + 1;
  end;

  if I = Length(Path) then
  begin
    Test:= Path[I];
    if Test = 'w' then Position.X := Position.X - 1;
    if Test = 'e' then Position.X := Position.X + 1;
  end;

  Result := Position;
end;


end.
