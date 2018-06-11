
//The *RasGetConnectionStatistics* function retrieves accumulated connection
//statistics for the specified connection.

unit RasThrd;

interface

uses xBase, SysUtils, Windows, Classes, RasUnit, MClasses;

  type TConnectState = (csIdle, csConnecting, csInProgress, csConnected, csError, csDisconnecting);
       TToDoState = (tdNone, tdConnect, tdDisconnect);

  TMyDialParam = Record
    AMsg : Integer;// - ��� ���������
    AState : TRasConnState;// - ������ ���������� (��� ���������� ��������� �  RasUnit.pas)
    AError : Integer;// - ��� ������
  end;

  type TRasThread = class(T_Thread)
         oEvt: DWORD;
         private
           fEntryName: string;
           fConnected: TConnectState;
           // � ��� ���������� ����� ������� handle
           //(��� ������� "���") "���������� ����������",
           // � ���� ���������� ����� ���������� �������
           // RasHangUp ��� ���������� ����������, ���
           // ���������� ������ � RasUnit.pas
           hRas          : ThRASConn;
           aRasConn      : array [0..10] of TRASCONN;
           nRasConnCount : longint;
           ConnectTime   : DWORD;
           AlienRAS      : boolean;
           ToDoState     : TToDoState;
           CS            : TRTLCriticalSection;
           HangUp        : boolean;
           procedure GetActiveConn;
           function GetResultString: string;
           function GetActiveConnHandle(const szName : String) : THRASCONN;
         protected
           procedure InvokeExec; override;
           function GetConnected: boolean;
         public
           Log: TLogContainer;
           //���� �� �������� �������� "��������� ����������" ��� ���������� ������ � ����
           AllEntries: TStrings;
           property handle: ThRASConn read hRas;
           procedure LoadEntryList;
           function Lasts: longint;
           Function GetStatusString(State: TRasConnState; Error: Integer): String;
           procedure CheckConnection;
           property IsConnected: TConnectState read fConnected;
           property Connected: boolean read GetConnected;
           procedure Disconnected;
           procedure Connect(HU: boolean);
           procedure DoConnect;
           procedure Disconnect;
           procedure DoDisconnect;
           property ResultString: string read GetResultString;
           property EntryName: string read fEntryName write fEntryName;
           constructor Create;
           destructor Destroy; override;
           class function ThreadName: string; override;
           procedure Enter;
           procedure Leave;
         end;

var
   g_hWnd: HWND;
   RasThread: TRasThread;
   MyDialParam : TMyDialParam;
   RASSoundsON : boolean;

procedure StartRas;
procedure FinishRas;

implementation

uses
   RadIni, Forms, MlrThr, recs, xMisc;

procedure StartRas;
var
   n:integer;
begin
   InitRasFunctions;
   RasThread := TRasThread.Create;
   RasThread.Suspended := false;
   RasThread.Priority := tpIdle;
   RasThread.AllEntries := TStringList.Create;
   RasThread.LoadEntryList;
   n := RasThread.AllEntries.IndexOf(RadIni.IniFile.iEntryName);
   if n < 0 then RasThread.EntryName := ''
   else RasThread.EntryName := RasThread.AllEntries[n];
   RasThread.hRas := RasThread.GetActiveConnHandle(RasThread.EntryName);
   if RasThread.hRas <> 0 then
   begin
      RasThread.Log.Log('');
      RasThread.Log.Log(FormatLogStr(ltPolls, 'Connection to ' + RasThread.EntryName + ' found', 'RasDial'));
      RasThread.ConnectTime := gettickcount;
      RasThread.AlienRAS := True;
   end;
   RASSoundsON := IniFile.PlaySounds;
end;

procedure FinishRas;
var
   c: integer;
begin
   if RASThread = nil then exit;
   if not RASThread.AlienRAS then RASThread.Disconnect;
   c := 0;
   While RASThread.fConnected <> csIdle do begin
      inc(c);
      Sleep(1000);
      if c = 30 then break;
   end;
   RasThread.Terminated := True;
   SetEvt(RasThread.oEvt);
   RasThread.WaitFor;
   RasThread.AllEntries.Free;
   DeInitRasFunctions;
   FreeObject(RasThread);
end;

Function TRasThread.GetStatusString(State: TRasConnState; Error: Integer): String;
var
   C: array[0..100] of char;
   S: string;
begin
   if Error <> 0 then begin
      case Error of
      633: Result := 'Port is busy';
      else
         begin
            C := '';
            RasGetErrorString(Error, @C, 100);
            Result := C;
         end;
      end;{of case}
   end else begin
      S := '';
      case State Of
      RASCS_OpenPort:
         S := 'Opening port';
      RASCS_PortOpened:
         S := 'Port opened';
      RASCS_ConnectDevice:
         S := 'Connecting device';
      RASCS_DeviceConnected:
         S := 'Device connected';
      RASCS_AllDevicesConnected:
         S := 'All devices connected';
      RASCS_Authenticate:
         S := 'Start authenticating';
      RASCS_AuthNotify:
         S := 'Authentication: notify';
      RASCS_AuthRetry:
         S := 'Authentication: retry';
      RASCS_AuthCallback:
         S := 'Authentication: callback';
      RASCS_AuthChangePassword:
         S := 'Authentication: change password';
      RASCS_AuthProject:
         S := 'Authentication: projecting';
      RASCS_AuthLinkSpeed:
         S := 'Authentication: link speed';
      RASCS_AuthAck:
         S := 'Authentication: acknowledge';
      RASCS_ReAuthenticate:
         S := 'Authentication: reauthenticate';
      RASCS_Authenticated:
         S := 'Authenticated';
      RASCS_PrepareForCallback:
         S := 'Preparing for callback';
      RASCS_WaitForModemReset:
         S := 'Waiting for modem reset';
      RASCS_WaitForCallback:
         S := 'Waiting for callback';
      RASCS_Projected:
         S := 'Projected';
      RASCS_StartAuthentication:
         S := 'Start authentication';
      RASCS_CallbackComplete:
         S := 'Callback complete';
      RASCS_LogonNetwork:
         S := 'Logging on network';
      RASCS_Interactive:
         S := 'Interactive';
      RASCS_RetryAuthentication:
         S := 'Retry Authentication';
      RASCS_CallbackSetByCaller:
         S := 'Callback set by caller';
      RASCS_PasswordExpired:
         S := 'Password expired';
      RASCS_Connected:
         begin
            fConnected := csConnected;
            S := 'Connected';
         end;
      RASCS_Disconnected:
         begin
            ConnectTime := 0;
            fConnected := csIdle;
            S := 'Disconnected';
         end;
      end; {of case}
      Result := S;
   end;
end;

procedure TRasThread.LoadEntryList;
var
   BuffSize: Integer;
//������ ������� �� AnsiChar, � ������� ����� ���������� c������� �� "��������� �����������"
   Entries: Integer;
//���������� ������������������ "��������� ����������"
   Entry: Array[1..MaxEntries] of TRasEntryName;
//������ ��������� �� ����������, � ������� ����� �������� �������� �� "��������� �����������", ��� ��������� MaxEntries - ���������� ��������� ����������, TRasEntryName - ����������� (type) ������ ��������� �� ���� ����� dwSize � szEntryName (���������� � RasUnit.pas)
   X, Result_: Integer;
begin
//1. ��������� ������ ���������� ���� TRasEntryName � �������������� ���������� Entry, �������� � ���� dwSize ���������� ������.
   Entry[1].dwSize := SizeOf(TRasEntryName);
//2. ��������� ������ AnsiChar-�������, � ������� �������� �������� ��� ���� "��������� �����������"
   BuffSize := SizeOf(TRasEntryName) * MaxEntries;
//3. ������� ������� RasEnumEntries � ���������� ���� ������� ������� ����������:
   Result_ := RasEnumEntries(nil, nil, @Entry[1], BuffSize, Entries);//, ���
{
Result_- � ������ ��������� ���������� ���������� 0, � ��������� ������ ������� ERROR_BUFFER_TOO_SMALL (����� ������� ���������) ��� ERROR_NOT_ENOUGH_MEMORY(�� ������� ������).
BuffSize - ��������� ���� ������ AnsiChar-�������.
@Entry[1]- ������� ��������� �� ������ ������� �������, � ������� ����������� ����������� ��� ��������.
Entries - ������� ���������� ������������������ � ������� "��������� ��������".
}
   if (Result_ = 0) and (Entries > 0) then begin
      AllEntries.Clear;
      for X := 1 to Entries do begin
         AllEntries.Add(Entry[x].szEntryName);
      end;
{      .....����� �� �������� �� ����� ����������, ��������,
      �������� �������� �� "��������� �����������" � ListBox......}
      PostMsg(WM_RASLOADENTRYLIST);//cbRASActiveEntryName.Items.AddStrings(AllEntries);
   end;
end;

procedure TRasThread.Disconnected;
var
   RCS: TRasConnStatusA;
   Cnt: boolean;
// see the remarks section at http://msdn.microsoft.com/library/default.asp?url=/library/en-us/rras/rras/rashangup.asp
begin
   if fConnected = csDisconnecting then exit;
   Cnt := fConnected = csConnected;
   fConnected := csDisconnecting;
   if hRas <> 0 then begin
      RasHangUpA(hRas);
      RCS.dwSize := sizeof(RCS);
      repeat
         Sleep(100); //MSDN
         Application.ProcessMessages;
      until RasGetConnectStatusA(hRas, RCS) = ERROR_INVALID_HANDLE;
      hRas := 0;
      PostMessage(MainWinHandle, WM_RASDIALEVENT, RASCS_Disconnected, 0);
      if Cnt then begin
         Log.Log(FormatLogStr(ltPolls, 'Disconnected', 'RasDial'));
      end;
   end;
   ConnectTime := 0;
   fConnected := csIdle;
end;

procedure TRasThread.GetActiveConn;
var
   dwRet : longint;
   nCB   : longint;
   Buf   : array [0..255] of Char;
begin
   aRasConn[0].dwSize := SizeOf(aRasConn[0]);
   nCB   := SizeOf(aRasConn);
   dwRet := RasUnit.RasEnumConnections(@aRasConn, nCB, nRasConnCount);
   if (dwRet <> 0) and (dwRet <> -1) then begin
      RasGetErrorString(dwRet, @Buf[0], SizeOf(Buf));
      Log.Log(FormatLogStr(ltPolls, Buf, 'RasDial'));
   end;
end;

function TRasThread.GetActiveConnHandle(const szName : String) : THRASCONN;
var
   I : Integer;
begin
   GetActiveConn;
   if nRasConnCount > 0 then begin
      for I := 0 to nRasConnCount - 1 do begin
         if StrIComp(PChar(szName), aRasConn[I].szEntryName) = 0 then begin
            Result := aRasConn[I].hRasConn;
            Exit;
         end else begin
            fEntryName := aRasConn[i].szEntryName;
         end;
      end;
   end;
   Result := 0;
end;

function TRasThread.GetConnected;
begin
   Result := fConnected = csConnected;
end;

constructor TRasThread.Create;
begin
   oEvt := CreateEvt(False);
   Log := TLogContainer.Create;
   Log.FTag := ltRasDial;
   Log.FMsg := 0;
   Log.FName := MakeNormName(dlog, Ras_Log);
   fConnected := csIdle;
   InitializeCriticalSection(CS);
   inherited create;
end;

destructor TRasThread.Destroy;
begin
   if not AlienRAS then begin
      Disconnect;
   end;
   ZeroHandle(oEvt);
   FreeObject(Log);
   PurgeCS(CS);
   inherited destroy;
end;

procedure TRasThread.CheckConnection;
begin
   if (fConnected = csConnecting) then exit;
   if (fConnected = csIdle) then begin
      hRas := GetActiveConnHandle(fEntryName);
      if hRas <> 0 then begin
         if ConnectTime = 0 then begin
            Log.Log('');
            Log.Log(FormatLogStr(ltPolls, 'Connection to ' + fEntryName + ' found', 'RasDial'));
            ConnectTime := gettickcount;
           _RecalcPolls(True);
            PostMsg(WM_UPDATEVIEW);
         end;
         fConnected := csConnected;
         AlienRAS := True;
      end else exit;
   end else
   if (GetActiveConnHandle(fEntryName) = 0) and (AlienRAS) then begin
      ConnectTime := 0;
      fConnected := csIdle;
      AlienRAS := False;
      Log.Log(FormatLogStr(ltPolls, 'Connection to ' + fEntryName + ' lost', 'RasDial'));
   end else
   if (GetActiveConnHandle(fEntryName) = 0) and (fConnected = csConnected) then begin
      Disconnect;
   end;
end;

function TRasThread.GetResultString: string;
begin
   case fConnected of
   csIdle: result := 'Idle';
   csConnecting: result := 'Dialing ' + fEntryName;
   csInProgress,
   csError: result := RasThread.GetStatusString(MyDialParam.AState, MyDialParam.AError);
   csConnected: result := 'Connected to ' + fEntryName;
   csDisconnecting: result := 'Disconnecting';
   else GlobalFail('TRasThread.GetResultString, %s%d', ['fConnected=', byte(fConnected)]);
   end;
end;

procedure TRasThread.DoDisconnect;
begin
   if (fConnected = csConnecting) or (fConnected = csIdle) then Log.Log(FormatLogStr(ltPolls, 'Canceled', 'RasDial')) else
   if (fConnected <> csDisconnecting) then Log.Log(FormatLogStr(ltPolls, 'Disconnecting', 'RasDial'));
   Disconnected;
end;

procedure TRasThread.Disconnect;
begin
   ToDoState := tdDisconnect;
   SetEvt(oEvt);
end;

function TRasThread.Lasts: longint;
begin
   if (fConnected = csConnected) then result := gettickcount - connecttime
                                 else begin result := 0; ConnectTime := 0; end;
end;

Procedure RasCallBack (msg: Integer; state: TRasConnState; error: Integer);stdcall;// , ���
 {  msg: Integer - ��� ���������
  state: TRasConnState - ��������� ����������
  error: Integer - ��� ������}
begin
   if RASThread = nil then exit;
   MyDialParam.AMsg   := msg;
   MyDialParam.AState := state;
   MyDialParam.AError := error;
   if RASThread.fConnected = csDisconnecting then exit;
   if state > 2 then begin
      RASThread.fConnected := csInProgress;
   end;
   if error > 0 then begin
      RASThread.fConnected := csError;
      RasHangUpA(RASThread.hRas);
   end;
   if state = RASCS_Connected then begin
      RASThread.ConnectTime := GetTickCount;
   end else
   if state = RASCS_Disconnected then begin
      RASThread.ConnectTime := 0;
      RASThread.fConnected := csIdle;
   end;
   PostMessage(MainWinHandle, WM_RASDIALEVENT, state, error);
   RasThread.Log.Log(FormatLogStr(ltPolls, RasThread.GetStatusString(MyDialParam.AState, MyDialParam.AError), 'RasDial'));
   SetEvt(RasThread.oEvt);
end;

procedure TRasThread.DoConnect;
var
   Fp: LongBool;
   DialParams: TRasDialParams;
   R: Integer;
   C: Array[0..100] of Char;
   n: integer;
begin
   if (hRas <> 0) and HangUp then begin
      RasHangUpA(hRas);
   end;

   hras := 0;
   n := AllEntries.IndexOf(RadIni.IniFile.iEntryName);
   if n < 0 then begin
      Log.Log(FormatLogStr(ltPolls, 'Connection is not defined. Please use setup to define connection.', 'RasDial'));
      exit;
   end;

   fEntryName := AllEntries[n]; //cbRASActiveEntryName.Items.Strings[cbRASActiveEntryName.ItemIndex];
   fConnected := csConnecting;

   FillChar(DialParams, SizeOf(TRasDialParams), 0);
   With DialParams Do Begin
      dwSize := Sizeof(TRasDialParams);
      StrPCopy(szEntryName, fEntryName);
   End;
   R := RasGetEntryDialParams(Nil, DialParams, Fp);
   If R = 0 Then Begin
      PlaySnd('RASDial', RASSoundsON);
      Application.ProcessMessages;
      RasThread.Log.Log('');
      RasThread.Log.Log(FormatLogStr(ltPolls, 'Dialling ' + fEntryName, 'RasDial'));
      R := RasUnit.RasDial(Nil, Nil, DialParams, 0, @RasCallback, hRAS);
      If R <> 0 Then Begin
         RasGetErrorString(R, C, 100);
         RasThread.Log.Log(FormatLogStr(ltPolls, RasThread.GetStatusString(MyDialParam.AState,MyDialParam.AError), 'RasDial'));
         RasHangUpA(hRas);
         ConnectTime := 0;
         RASThread.fConnected := csIdle;
         Exit;
      End;
   End;
   ConnectTime := GetTickCount;
end;

procedure TRasThread.Connect;
begin
   ToDoState := tdConnect;
   HangUP := HU;
   SetEvt(oEvt);
end;

procedure TRasThread.InvokeExec;
begin
   repeat
      WaitEvt(oEvt, INFINITE);
      ResetEvt(oEvt);
      if Terminated then exit;
      case ToDoState of
      tdConnect: DoConnect;
      tdDisconnect: DoDisconnect;
      end;
      ToDoState := tdNone;
      CheckConnection;
   until (Terminated);
end;

class function TRasThread.ThreadName: string;
begin
   Result := 'RasThread';
end;

procedure TRasThread.Enter;
begin
   EnterCS(CS);
end;

procedure TRasThread.Leave;
begin
   LeaveCS(CS);
end;

end.

