unit DayActivity;

interface
  uses Types,
    Generics.Collections,
    Generics.Defaults,
    Position;

  function RunDay(const Titles: TDictionary<TPosition, Boolean>): TDictionary<TPosition, Boolean>;

  function GetAdjacents(const Position: TPosition): TList <TPosition>;

  function IsBlackAfterDay(const Position: TPosition; IsBlack: Boolean; const AllTitles: TDictionary<TPosition, Boolean>): Boolean;

implementation


  function IsBlackAfterDay(const Position: TPosition; IsBlack: Boolean; const AllTitles: TDictionary<TPosition, Boolean>): Boolean;
  var
    Neighbours: TList <TPosition>;
    BackNumber: Integer;

    Item: TPosition;
  begin
    Neighbours :=  GetAdjacents(Position);
    BackNumber := 0;

    for Item in Neighbours do
    begin
      if AllTitles.ContainsKey(Item) and AllTitles[Item] then
        BackNumber := BackNumber + 1;
    end;

    if IsBlack then Result := (BackNumber = 1) or (BackNumber = 2)
    else Result := BackNumber = 2

  end;


  function RunDay(const Titles: TDictionary<TPosition, Boolean>): TDictionary<TPosition, Boolean>;
  var
    NewBlacks: TList <TPosition>;

    Neighbours: TList <TPosition>;

    Item: TPosition;
    Key: TPosition;
  begin

    NewBlacks := TList<TPosition>.Create;

    for Key in Titles.Keys do
    begin
      if IsBlackAfterDay(Key, Titles.Items[Key], Titles) then
        NewBlacks.Add(Key);

      Neighbours := GetAdjacents(Key);

      for Item in Neighbours do
      begin
        if (not Titles.ContainsKey(Item)) and IsBlackAfterDay(Item, false, Titles) then
          NewBlacks.Add(Item);
      end;

    end;

    // Compute final result
   Result := TDictionary<TPosition, Boolean>.Create(
      TEqualityComparer<TPosition>.Construct(
        TPosition.EqualityComparison,
        TPosition.Hasher
      )
    );

    for Item in NewBlacks do
       Result.AddOrSetValue(Item, true);
  end;

  function GetAdjacents(const Position: TPosition): TList <TPosition>;
  begin
    Result := TList<TPosition>.Create;

    if TPosition.IsPair(Position) then
    begin
      Result.Add(TPosition.New(Position.X + 1, Position.Y + 1));
      Result.Add(TPosition.New(Position.X + 1, Position.Y));
      Result.Add(TPosition.New(Position.X + 1, Position.Y - 1));
      Result.Add(TPosition.New(Position.X, Position.Y - 1));
      Result.Add(TPosition.New(Position.X - 1, Position.Y));
      Result.Add(TPosition.New(Position.X, Position.Y + 1));
    end
    else
    begin
      Result.Add(TPosition.New(Position.X, Position.Y + 1));
      Result.Add(TPosition.New(Position.X + 1, Position.Y));
      Result.Add(TPosition.New(Position.X, Position.Y - 1));
      Result.Add(TPosition.New(Position.X - 1, Position.Y - 1));
      Result.Add(TPosition.New(Position.X  - 1, Position.Y));
      Result.Add(TPosition.New(Position.X - 1, Position.Y + 1));
    end;

  end;

end.
