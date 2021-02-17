program day24;

{$APPTYPE CONSOLE}
uses
  IOUtils,
  Types,
  Generics.Collections,
  SysUtils,
  Position in 'Position.pas',
  PathAnalyzer in 'PathAnalyzer.pas',
  DayActivity in 'DayActivity.pas';

var
  Lines: TStringDynArray;
  KnowTiles: TDictionary<TPosition, Boolean>;

  IsBlack: Boolean;
  BlackTilesNumber: Integer;

  I: Integer;
begin
  Lines := TFile.ReadAllLines('input.txt');
  BlackTilesNumber := 0;

  KnowTiles := AnalyzePaths(Lines);

  //Find  Black Titles
  for IsBlack in KnowTiles.Values do
  begin
    if IsBlack then BlackTilesNumber := BlackTilesNumber +1;
  end;

  WriteLn('Black Titles: ' + IntToStr(BlackTilesNumber));

  for I := 1 to 100 do KnowTiles := RunDay(KnowTiles);

  WriteLn('After 100 days: ' + IntToStr(KnowTiles.Keys.Count));

  WriteLn('End !!!!!!!!');
end.

