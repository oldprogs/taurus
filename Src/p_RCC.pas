unit p_RCC;

interface

uses xMisc, Types, Windows, xBase, SysUtils,
     Menus, Controls, Forms, Classes;

function CreateRCCProtocol(CP: Pointer): Pointer;

type

   TRCCState = (
   bdInit,
   bdWork,
   bdDone
   );

   TRCC = class(TBiDirProtocol)
      SList: TStringColl;

      function GetStateStr: string;                               override;
      procedure ReportTraf(txMail, txFiles: DWORD);               override;
      procedure Cancel;                                           override;

      constructor Create(ACP: TPort);
      destructor Destroy; override;
      function TimeoutValue: DWORD;                               override;
      function NextStep: boolean;                                 override;
      procedure Start({RX}AAcceptFile: TAcceptFile;
                          AFinishRece: TFinishRece;
                      {TX}AGetNextFile: TGetNextFile;
                          AFinishSend: TFinishSend;
                      {CH}AChangeOrder: TChangeOrder
                      ); override;
      procedure PutString(const s: string);
      procedure CloseLine;
   private
      State: TRCCState;
      RForm: TForm;
      LList: TStringColl;
      TBuff: string;
//      Click: TNotifyEvent;
      function ExpandMenu(t: TMenuItem): string;
      function FindMenu(const o: TComponent; const N: string): string;
      procedure PushMenu(const o: TComponent; const N, I: string);
      procedure ClickMenu(const i: TMenuItem; const N: string);
      procedure DoStep;
   end;

implementation

uses Wizard, RemoteUnit, RCCUnit;

function CreateRCCProtocol;
begin
   Result := TRCC.Create(CP);
end;

function TRCC.GetStateStr: string;
begin
  result := ''; //just to avoid warning
end;

procedure TRCC.ReportTraf(txMail, txFiles: DWORD);
begin
  //nothing, just to avoid warning
end;

procedure TRCC.Cancel;
begin
  // nothing, just to avoid warning
end;

constructor TRCC.Create;
begin
   inherited Create(ACP);
   LList := TStringColl.Create('');
   SList := TStringColl.Create('');
   pRCC  := self;
end;

destructor TRCC.Destroy;
begin
   FreeObject(LList);
   FreeObject(SList);
   inherited Destroy;
end;

function TRCC.TimeoutValue;
begin
   Result := 1000;
end;

function TRCC.ExpandMenu;
var i: integer;
begin
   Result := '{' + t.Caption + '[' + inttostr(integer(t.Enabled)) + ',' +
                                     inttostr(integer(t.Visible)) + ']';
   for i := 0 to t.Count - 1 do begin
      Result := Result + ExpandMenu(t.Items[i]);
   end;
   Result := Result + '}'
end;

function TRCC.FindMenu;
var m: TMainMenu;
    c: TComponent;
    i: integer;
    j: integer;
begin
   Result := '';
   for i := 0 to o.ComponentCount - 1 do begin
      c := o.Components[i];
      if c is TForm then begin
         Result := Result + FindMenu(c, n);
      end else
      if UpperCase(c.Name) = n then begin
         m := c as TMainMenu;
         for j := 0 to m.Items.Count - 1 do begin
            Result := Result + ExpandMenu(m.Items[j]);
         end;
         exit;
      end;
   end;
end;

procedure TRCC.ClickMenu;
var p: integer;
//    s: integer;
begin
   for p := 0 to i.Count - 1 do begin
      if UpperCase(Trim(i.Items[p].Caption)) = n then begin
         SendMessage(MainWinHandle, WM_CLICKMENU, integer(self), integer(i.Items[p]));
      end else begin
         ClickMenu(i.Items[p], n);
      end;
   end;
end;

procedure TRCC.PushMenu;
var m: integer;
//    p: integer;
    c: TComponent;
begin
   for m := 0 to o.ComponentCount - 1 do begin
      c := o.Components[m];
      if c is TForm then begin
         if UpperCase(TForm(c).Caption) <> 'REMOTEFORM' then begin
            PushMenu(c, n, i);
         end;
      end else
      if UpperCase(c.Name) = n then begin
         ClickMenu(TMenu(c).Items, i);
      end;
   end;
end;

procedure TRCC.DoStep;
var C: byte;
    S,
    Z: string;
begin
   case State of
   bdInit:
      begin
         if originator then begin
            PutString('get menu MainMenu');
            State := bdWork;
         end;
      end;
   bdWork:;
   bdDone:;
   end;
   while CP.CharReady do begin
      if CP.GetChar(C) then begin
         if C <> 10 then begin
            TBuff := TBuff + Chr(C);
         end else begin
            LList.Add(TBuff);
            TBuff := '';
         end;           
      end;
   end;
   while LList.Count > 0 do begin
      s := LList[0];
      GetWrd(s, z, ' ');
      z := UpperCase(z);
      if z = 'GET' then begin
         GetWrd(s, z, ' ');
         if UpperCase(z) = 'MENU' then begin
            s := 'put menu ' + s + ' ' + FindMenu(Application, UpperCase(s));
            PutString(s);
         end;
      end else
      if z = 'PUT' then begin
         GetWrd(s, z, ' ');
         if UpperCase(z) = 'MENU' then begin
            GetWrd(s, z, ' ');
            (RForm as TRemoteForm).FillMenu(s);
         end else
         if UpperCase(z) = 'CNTR' then begin
            (RForm as TRemoteForm).FillForm(s);
         end;
      end else
      if z = 'PUSH' then begin
         GetWrd(s, z, ' ');
         if UpperCase(z) = 'MENU' then begin
            GetWrd(s, z, ' ');
            PushMenu(Application, UpperCase(z), UpperCase(s));
         end;
      end;
      LList.AtFree(0);
   end;
   SList.Enter;
   while SList.Count > 0 do begin
      if CP.OutUsed < 1024 then begin
         PutString(SList[0]);
         SList.AtFree(0);
      end else begin
         CP.Flsh;
         break;
      end;
   end;
   SList.Leave;
   Application.ProcessMessages;
end;

function TRCC.NextStep: boolean;
begin
   DoStep;
   Result := (State <> bdDone) and (CP.Carrier = CP.DCD);
end;

procedure TRCC.Start;
begin
   if Originator then begin
      RForm := Pointer(SendMessage(MainWinHandle, WM_OPENREMOTE, integer(Self), 0));
   end;
end;

procedure TRCC.PutString;
var i: integer;
begin
   for i := 1 to length(s) do CP.PutChar(ord(s[i]));
   CP.PutChar(10);
end;

procedure TRCC.CloseLine;
begin
   State := bdDone;
end;

end.
