program
  IncVer;

{$APPTYPE CONSOLE}

uses
  Windows, 
  Classes,
  MString,
  SysUtils;

const
  FILEVERSION: String = 'FILEVERSION ';
  PRODUCTVERSION: String = 'PRODUCTVERSION ';
  VALUEFILEVERSION: String = 'VALUE "FileVersion", ';

var
  i, j: integer;
  BuildIn: TStringList;
  s,
  NewProductStr,
  NewVersionStr,
  VersionStr: String;

begin
  BuildIn := TStringList.Create;
  BuildIn.LoadFromFile(ParamStr(1));
(*
  Writeln(StringOfChar('=', 80));
  for i := 0 to BuildIn.Count - 1 do
    Writeln(BuildIn[i]);
  Writeln(StringOfChar('=', 80));
*)
  for i := 0 to BuildIn.Count - 1 do
    if Pos(FILEVERSION, BuildIn[i]) = 1 then 
      Break;
  VersionStr := Trim(Copy(BuildIn[i], Length(FILEVERSION), 255));
  Writeln('Old version build = "', VersionStr, '"');

  j := WordCount(VersionStr, [',']);
//  Writeln('j = "', j, '"');
  NewProductStr := '';
  NewVersionStr := '"';
//  Writeln(StringOfChar('=', 80));
  for i := 1 to j do
  begin
//    Writeln(i:2, ' = "', ExtractWord(i, VersionStr, [',']), '"');
    if i = j then
      NewProductStr := NewProductStr + IntToStr(StrToIntDef(ExtractWord(i, VersionStr, [',']), 0) + 1)
    else
      NewProductStr := NewProductStr + ExtractWord(i, VersionStr, [',']) + ',';

    if i = j then
      NewVersionStr := NewVersionStr + IntToStr(StrToIntDef(ExtractWord(i, VersionStr, [',']), 0) + 1) + '"'
    else
      NewVersionStr := NewVersionStr + ExtractWord(i, VersionStr, [',']) + '.';
  end;
  Writeln('New version build = "', NewProductStr, '"');
//  Writeln('New product build = "', NewVersionStr, '"');

  for i := 0 to BuildIn.Count - 1 do
  begin
    if Pos(FILEVERSION, BuildIn[i]) = 1 then 
      BuildIn[i] := FILEVERSION + NewProductStr;

    if Pos(PRODUCTVERSION, BuildIn[i]) = 1 then 
      BuildIn[i] := PRODUCTVERSION + NewProductStr;

    if Pos(VALUEFILEVERSION, BuildIn[i]) <> 0 then 
    begin
      s := BuildIn[i];
      Delete(s, Pos(VALUEFILEVERSION, BuildIn[i]), Length(BuildIn[i]) - Pos(VALUEFILEVERSION, BuildIn[i]) + 1);
      BuildIn[i] := s + VALUEFILEVERSION + NewVersionStr;
    end;
  end;
(*
  Writeln(StringOfChar('=', 80));
  for i := 0 to BuildIn.Count - 1 do
    Writeln(BuildIn[i]);
  Writeln(StringOfChar('=', 80));
*)
  BuildIn.SaveToFile(ParamStr(1));

  BuildIn.Destroy;
end.