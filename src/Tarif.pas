
{$I DEFINE.INC}

unit tarif;

interface

uses windows, classes, sysutils, MlrThr;

type

TConnType = (ctDIAL, ctIP, ctALL);
TDirection= (dirIN, dirOUT, dirALL);

TTimePeriod = record
   StartTime: TDateTime;
   StopTime: TDateTime;
end;

TarifRec = record
  ConnType: TConnType;
  Direction: TDirection;
  PhoneNumber: string;
  Period: TTimePeriod;
  PerHour: extended;
  PerSentMB: extended;
  PerReceivedMB: extended;
end;
TarifRecPtr = ^TarifRec;

OperTimeRec = record
  ConnType: TConnType;
  Direction: TDirection;
  PhoneNumber: string;
  Period: TTimePeriod;
  Sent: extended;
  received: extended;
end;

var
  Cost: extended;

procedure LoadTarifPlan(var TarifPlan: TList);
procedure FreeTarifPlan(var TarifPlan: TList);
function ParseTarifString(Buf: string; var TarifItem: TarifRec): boolean;
function ParseTimePeriod(Buf: string):TTimePeriod;
procedure ImportParam(var TarifItem: TarifRec; ParamNumber: integer; const ParamStr: string);
procedure LogError(const Message: string);
procedure ShowTarifPlan(TarifPlan: TList);
function CalcCostWithinDay(TarifPlan: TList; OperTimeItem: OperTimeRec): extended;
function CalcCost(TarifPlan: TList; OperTimeItem: OperTimeRec): extended;
function Crossing(const OperTime, TarifTime: TTimePeriod): TDateTime;
procedure SaveTarifLog(MTInfo: TMailerThread);

implementation

uses
   RadIni, DateUtils, recs, xBase;

var
  StrNumber: integer;

procedure LoadTarifPlan;
var
  FileID: TextFile;
  Buf: string;
  TarifItem: TarifRec;
  TarifItemPtr: TarifRecPtr;

begin
  if IniFile.DontLogTariff then exit;

  if TarifPlan <> nil then TarifPlan.Free;
  TarifPlan := TList.Create;

  {$I-}
  AssignFile(FileID, HomeDir + '\tariff.cfg');
  Reset(FileID);
  if IOResult <> 0 then
    begin
      IniFile.DontLogTariff := True;
      exit;
    end;
  {$I+}

  StrNumber := 0;
  while not EOF(FileID) do begin
    Readln(FileID, Buf);
    inc(StrNumber);
    if ParseTarifString(Buf, TarifItem) then begin
      new(TarifItemPtr);
      TarifItemPtr^ := TarifItem;
      TarifPlan.Add(TarifItemPtr);
    end;
  end;
  CloseFile(FileID);
end;

procedure FreeTarifPlan(var TarifPlan: TList);
var i: integer;
    p: TarifRecPtr;
begin
   if TarifPlan <> nil then begin
      for i := 0 to TarifPlan.Count - 1 do begin
         p := TarifPlan.Items[i];
         Dispose(p);
      end;
      TarifPlan.Free;
      TarifPlan := nil;
   end;
end;

function ParseTarifString;
var
  i, ParamNumber, LastParamPos: integer;
  ParamStr: string;
begin
  result := True;
  Buf := UpperCase(Trim(Buf));

  if (Copy(Buf, 1, 1) = '#') or (Length(Buf) = 0) then begin
    result := False;
    exit;
  end;

  ParamNumber:=0;
  LastParamPos:=1;

  for i:=1 to length(Buf) do begin
    if (Buf[i]=';') or (i=length(Buf))then begin
      inc(ParamNumber);
      if i=length(Buf) then
        ParamStr:=trim(UpperCase(copy(Buf, LastParamPos, i-LastParampos+1)))
      else
        ParamStr:=trim(UpperCase(copy(Buf, LastParamPos, i-LastParampos)));
      if length(ParamStr) > 0 then begin
        ImportParam(TarifItem, ParamNumber, ParamStr);
        LastParamPos:=i+1;
      end;
    end;
  end;
end;

procedure ImportParam;
begin
  case ParamNumber of
    1: begin
         if ParamStr='DIAL' then TarifItem.ConnType:=ctDIAL else
         if ParamStr='IP' then TarifItem.ConnType:=ctIP else
         if ParamStr='*' then TarifItem.ConnType:=ctALL else
         begin
           TarifItem.ConnType:=ctALL;
           LogError('TARIF: Invalid connection type - '+ParamStr);
         end;
       end;
    2: begin
         if ParamStr='IN' then TarifItem.Direction:=dirIN else
         if ParamStr='OUT' then TarifItem.Direction:=dirOUT else
         if ParamStr='*' then TarifItem.Direction:=dirALL else
         begin
           TarifItem.Direction:=dirALL;
           LogError('TARIF: Invalid direction type - '+ParamStr);
         end;
       end;
    3: TarifItem.PhoneNumber:=ParamStr;
    4: TarifItem.Period:=ParseTimePeriod(ParamStr);
    5: try
         TarifItem.PerHour:=StrToFloat(ParamStr);
       except
         LogError('TARIF: Invalid cost per hour - '+ ParamStr);
       end;
    6: try
         TarifItem.PerSentMB:=StrToFloat(ParamStr);
       except
         LogError('TARIF: Invalid cost per sent MB - '+ ParamStr);
       end;
    7: try
         TarifItem.PerReceivedMB:=StrToFloat(ParamStr);
       except
         LogError('TARIF: Invalid cost per receive MB - '+ ParamStr);
       end;
  end;
end;

function ParseTimePeriod;
var
  i: integer;
begin
  Buf:=trim(Buf);
  if (Length(Buf)=0) then begin
    LogError('TARIF: Invalid time period - '+ Buf);
    exit;
  end;
  if Buf='*' then begin
    result.StartTime:=StrToTime('00:00:00');
    result.StopTime:=StrToTime('23:59:59');
    exit;
  end;
  i:=Pos('-',Buf);
  if i > 0 then begin
    try
      result.StartTime:=StrToTime(Copy(Buf,1,i-1));
      result.StopTime:=StrToTime(Copy(Buf,i+1,length(Buf)));
    except
      LogError('TARIF: Invalid time period - '+ Buf);
    end;
    exit;
  end else begin
    LogError('TARIF: Invalid time period - '+ Buf);
    exit;
  end;
end;

procedure LogError;
var
  FileId: TextFile;
begin
  AssignFile(FileID, IniFile.Log+'\tariff.err');
  {$I-}
  Reset(FileID);
  {$I+}
  if IOResult <> 0 then
    Rewrite(FileID)
  else
    Append(FileID);
  Writeln(FileID, Message+' in string number: '+IntToStr(StrNumber));
  CloseFile(FileId);
end;

procedure ShowTarifPlan;
var
  i: integer;
  TarifItemPtr: TarifRecPtr;
begin
  writeln('Number of rules:', TarifPlan.Count);
  for i:=0 to TarifPlan.Count-1 do begin
    TarifItemPtr:=TarifPlan.Items[i];
    writeln(
    ord(TarifItemPtr^.ConnType),' ; ',
    ord(TarifItemPtr^.Direction),' ; ',
    TarifItemPtr^.PhoneNumber,' ; ',
    TimeToStr(TarifItemPtr^.Period.StartTime),' - ',
    TimeToStr(TarifItemPtr^.Period.StopTime),' ; ',
    TarifItemPtr^.PerHour:8:2,' ; ',
    TarifItemPtr^.PerSentMB:8:2,
    TarifItemPtr^.PerReceivedMB:8:2,' ; '
    );
  end;
end;

function CalcCostWithinDay;
var
  k: integer;
  Cost, CrosTime: extended;
  TarifItemPtr: TarifRecPtr;
  s: string;
  AHour, AMin, ASec, AMSec: Word;
begin
  Cost := 0;
  Result := 0;
  if TarifPlan = nil then exit;
    for k:=TarifPlan.Count-1 downto 0 do begin
      TarifItemPtr:=TarifPlan.Items[k];
      s:=TarifItemPtr^.PhoneNumber;
      if s='' then;
//      with TarifItemPtr^ do
        if (OperTimeItem.ConnType=TarifItemPtr^.ConnType) or (TarifItemPtr^.ConnType=ctALL) then
          if (OperTimeItem.Direction=TarifItemPtr^.Direction) or (TarifItemPtr^.Direction=dirALL) then
            if (copy(UpperCase(OperTimeItem.PhoneNumber),1,length(TarifItemPtr^.PhoneNumber))=TarifItemPtr^.PhoneNumber) or (TarifItemPtr^.PhoneNumber='*') then
              begin
                CrosTime:=Crossing(OperTimeItem.Period, TarifItemPtr^.Period);
{if <поминутная тарификация> then}
                if IniFile.PerMinute then
                begin
                  DecodeTime(CrosTime, AHour, AMin, ASec, AMSec);
                  if (ASec>0) then
                  begin
                    CrosTime:=IncMinute(CrosTime);
                    CrosTime:=RecodeSecond(CrosTime,0);
                  end;
                end;
                CrosTime:=RecodeMilliSecond(CrosTime,0);
{endif}
                CrosTime:=CrosTime*24;
                if CrosTime > 0 then 
                begin
                  Cost:=Cost+CrosTime*TarifItemPtr^.PerHour+
                             OperTimeItem.Sent*TarifItemPtr^.PerSentMB+
                             OperTimeItem.received*TarifItemPtr^.PerReceivedMB;
                  break;
                end;
              end;
    end;

    result:=Cost;

end;

function Crossing;
begin
  result:=0;
  if ((TarifTime.StartTime >= OperTime.StartTime) and
            (TarifTime.StartTime < OperTime.StopTime )) then

     if ((TarifTime.StopTime > OperTime.StartTime ) and
            (TarifTime.StopTime <= OperTime.StopTime  )) then
        begin
          result:= (TarifTime.StopTime - TarifTime.StartTime);
          exit;
        end
     else
        begin
          result:= (OperTime.StopTime - TarifTime.StartTime);
          exit;
        end;


  if (TarifTime.StopTime > OperTime.StartTime ) then
    begin
      if { and} (TarifTime.StopTime <= OperTime.StopTime) then
        begin
          result:= (TarifTime.StopTime - OperTime.StartTime);
          exit;
        end;
      if  (TarifTime.StartTime < OperTime.StartTime ) then
        begin
          result:= (OperTime.StopTime - OperTime.StartTime);
          exit;
        end;
    end;
end;

function CalcCost;
var
  TmpTime: TDateTime;
  StartDay, StopDay, DayOverCount: integer;
  Cost: extended;

begin
  result:=0;
  if IniFile.DontLogTariff then exit;
  with OperTimeItem.Period do begin
    StartDay:=StrToInt(FloatToStr(Int(StartTime)));
    StopDay:=StrToInt(FloatToStr(Int(StopTime)));
  end;
  DayOverCount:=StopDay-StartDay;

  if DayOverCount=0 then begin
    with OperTimeItem.Period do begin
      StartTime:=Frac(StartTime);
      StopTime:=Frac(StopTime);
    end;
    Cost:=CalcCostWithinDay(TarifPlan, OperTimeItem);
  end else begin

    with OperTimeItem.Period do begin
      StartTime:=Frac(StartTime);
      TmpTime:=StopTime;
      StopTime:=StrToTime('23:59:59');
    end;
    Cost:=CalcCostWithinDay(TarifPlan, OperTimeItem);
    with OperTimeItem.Period do begin
      StartTime:=StrToTime('00:00:00');
      StopTime:=TmpTime;
      StopTime:=Frac(StopTime);
    end;
    Cost:=Cost+CalcCostWithinDay(TarifPlan, OperTimeItem);

    if DayOverCount > 1 then begin
      with OperTimeItem.Period do begin
        StartTime:=StrToTime('00:00:00');
        StopTime:=StrToTime('23:59:59');
      end;
    Cost:=Cost+(CalcCostWithinDay(TarifPlan, OperTimeItem)*(DayOverCount-1));
    end;
  end;
  result:=Cost;
end;

procedure SaveTarifLog;
var
  FileId: TextFile;
  isDialup: boolean;
  OperTimeItem: OperTimeRec;
  TypeStr, DirStr: string;
  ZoneTimeDiff: DWORD;

begin

  FillChar(OperTimeItem,sizeof(OperTimeItem),#00);

  if IniFile.DontLogTariff then exit;

  {$I-}
  AssignFile(FileID, MakeNormName(dLog,IniFile.tariff_log));
  Reset(FileID);
  if IOResult <> 0 then
    begin
      Rewrite(FileID);
      if IOResult <> 0 then exit
    end
  else
    begin
      Append(FileID);
      if IOResult <> 0 then exit
    end;
  {$I+}

   {$IFDEF WS}
   isDialup := MTInfo.DialupLine;
   {$ELSE}
   isdialup:=true;
   {$ENDIF}
   with OperTimeItem do begin
    if isDialup then
      begin
        ConnType := ctDial;
        TypeStr:='dial';
      end
    else
      begin
        ConnType := ctIP;
        TypeStr:='ip';
      end;

    if not isDialup then
      if MTInfo.SD.ActivePoll=nil then
         begin
           Direction := dirIn;
           DirStr:='in';
           PhoneNumber := MTInfo.PublicDS.ConnectString;
           PhoneNumber := copy(PhoneNumber,6,pos('#',PhoneNumber)-7);
         end
      else
         begin
           Direction := dirOUT;
           DirStr:='out';
           PhoneNumber := MTInfo.PublicDS.ConnectString;
           PhoneNumber := copy(PhoneNumber,4,pos('#',PhoneNumber)-5);
         end
    else
      if MTInfo.SD.ActivePoll=nil then
         begin
           Direction := dirIn;
           DirStr:='in';
           PhoneNumber := MTInfo.PublicDS.rmtPhone;
         end
      else
         begin
           Direction := dirOUT;
           DirStr:='out';
           PhoneNumber := MTInfo.SD.ActivePoll.DialupPhone
         end;

    ZoneTimeDiff:=uGetLocalTime-uGetSystemTime;
    Period.StartTime := uDelphiTime(MTInfo.SD.ConnectStart+ZoneTimeDiff);
    Period.StopTime := uDelphiTime(uGetSystemTime+ZoneTimeDiff);

    if MTInfo.PubBatchT = nil then
      Sent:=(MTInfo.SD.cTxBytes{MTInfo.D.txBytes}) / 1048576
    else
      Sent:=(MTInfo.D.txBytes + MTInfo.PubBatchT.D.FPos) / 1048576;

    if MTInfo.PubBatchR = nil then
      Received:=(MTInfo.SD.cRxBytes{MTInfo.D.rxBytes}) / 1048576
    else
      Received:=(MTInfo.D.rxBytes + MTInfo.PubBatchR.D.FPos + MTInfo.PubBatchR.D.Part) / 1048576;
  end;

  Cost:=CalcCost(TarifPlan, OperTimeItem);

  if OperTimeItem.PhoneNumber='' then OperTimeItem.PhoneNumber:='-Unpublished-';

  with MTInfo.SD do
  Writeln(FileID, Format('%s;%s;%d:%d/%d.%d;%s;%s;%s;%.5f;%.5f;%.5f',
   [DirStr,
    TypeStr,
    rmtPrimaryAddr.Zone,
    rmtPrimaryAddr.Net,
    rmtPrimaryAddr.Node,
    rmtPrimaryAddr.Point,
    OperTimeItem.PhoneNumber,
    DateTimeToStr(OperTimeItem.Period.StartTime),
    DateTimeToStr(OperTimeItem.Period.StopTime),
    OperTimeItem.Sent,
    OperTimeItem.Received,
    Cost]));

  CloseFile(FileId);
end;

end.
