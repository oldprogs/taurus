unit RCCUnit;

interface

uses Forms, p_RCC;

procedure TreatForm(Form: TForm);

var pRCC: TRCC;

implementation

uses Controls, Classes, TypInfo, SysUtils;

procedure GetPublishedProperties(AObject: TObject; AStrings: TStrings);
var
  PropList: PPropList;
  TypeInfo: PTypeInfo;
  TypeData: PTypeData;
  I: integer;
  v: string;
begin
  TypeInfo:= AObject.ClassInfo;
  TypeData := GetTypeData(TypeInfo);
  if TypeData.PropCount <> 0 then
  begin
    GetMem(PropList, SizeOf(PPropInfo) * TypeData.PropCount);
    try
      GetPropInfos(AObject.ClassInfo, PropList);
      for I:= 0 to TypeData.PropCount - 1 do begin
        v := '';
        case PropList[I]^.PropType^.Kind of
        tkInteger:
           begin
              v := IntToStr(GetOrdProp(AObject, PropList[I]^.Name));
           end;
        tkLString,
        tkWString,
        tkString:
           begin
              v := GetStrProp(AObject, PropList[I]^.Name);
           end;
        end;
        if v <> '' then begin
           AStrings.Add('put prop ' + PropList[I]^.Name + ' ' + IntToStr(Integer(PropList[I]^.PropType^.Kind)) + ' ' + v);
        end;
      end;
    finally
      FreeMem(PropList, SizeOf(PPropInfo) * TypeData.PropCount);
    end;
  end;
end;

procedure ExportControl(C: TComponent);
var i: integer;
    s: TStringList;
    p: string;
begin
   if c is TControl then begin
      s := TStringList.Create;
      p := 'Application';
      if (c as TControl).Parent <> nil then p := (c as TControl).Parent.Name;
      pRCC.SList.Add('put cntr ' + p + ' ' + c.ClassName + ' ' + c.Name);
      GetPublishedProperties(C, s);
      for i := 0 to s.Count - 1 do begin
         pRCC.SList.Add(s[i]);
      end;
      s.Free;
   end;
end;

procedure ScanComponent(O: TComponent);
var i: integer;
    c: TComponent;
begin
   ExportControl(O);
   for i := 0 to O.ComponentCount - 1 do begin
      c := O.Components[i];
      ScanComponent(C);
   end;
end;

procedure TreatForm;
begin
   if pRCC = nil then exit;
   ScanComponent(Form);
end;

initialization

pRCC := nil;

end.