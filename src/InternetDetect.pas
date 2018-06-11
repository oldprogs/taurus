{*************************************************************}
unit InternetDetect;

{$G+}

{*************************************************************}
{         TInternetDetect Component for Delphi 32             }
{ This component determines online status of the computer     }
{ and returns current IP address                              }
{*************************************************************}
{             Copyright (c) 1999 Vladimir Bakhvaloff          }
{                                2:5030/535                   }
{                                Bakh@sut.ru                  }
{                     Created:   Oct, 3, 1999                 }
{                     Modified:  Dec,30, 1999                 }
{*************************************************************}
{ This component determines online status of the computer     }
{ and returns current IP address                              }
{*************************************************************}
{            TOnlineIP Component for Delphi 32                }
{ Version:   1.1                                              }
{ Author:    Aleksey Kuznetsov, Kiev, Ukraine                 }
{            Алексей Кузнецов (Xacker), Киев, Украина         }
{ E-Mail:    xacker@phreaker.net                              }
{ Home Page: http://www.angen.net/~xacker/                    }
{ Created:   May, 9, 1999                                     }
{ Modified:  May, 17, 1999                                    }
{ Legal:     Copyright (c) 1999 by Aleksey Xacker             }
{*************************************************************}

interface

uses
  Windows,
  Messages,
  Winsock,
  Classes,
  Forms,
  SysUtils,
  ICMPPing,
  RASUnit,
  WinInet;

type
  TMyNotifyEvent = procedure(Sender: TObject; var Res: DWORD) of object;
  TDetectMethod = (dmRAS, dmPING, dmWININET);

type
  TInternetDetect = class(TComponent)
  private
    FDetectMethod: TDetectMethod;
    FTryAddress: String;
    FEnabled: Boolean;
    FDispatchInterval: Cardinal;
    FWindowHandle: hWnd;
    FTimerHandle: UINT;
    FOnline: Boolean;
    FIP: String;
    FConnectionName: String;
    FOnChanged: TNotifyEvent;
    FOnQueryEndSession: TMyNotifyEvent;
    FOnEndSession: TMyNotifyEvent;

    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetTryAddress(Value: String);
    procedure SetDispatchInterval(Value: Cardinal);
    procedure SetDetectMethod(Value: TDetectMethod);
    procedure SetNoneBool(Value: Boolean);
    procedure SetIPStr(Value: String);
    procedure SetConnStr(Value: String);
    function InternetConnected: Boolean;
    procedure TimerProc(var Message: TMessage);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DetectMethod: TDetectMethod read FDetectMethod write SetDetectMethod;
    property TryAddress: String read FTryAddress write SetTryAddress;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property DispatchInterval: Cardinal read FDispatchInterval write SetDispatchInterval;
    property Online: Boolean read FOnline write SetNoneBool;
    property IP: String read FIP write SetIPStr;
    property ConnectionName: String read FConnectionName write SetConnStr;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnQueryEndSession: TMyNotifyEvent read FOnQueryEndSession write FOnQueryEndSession;
    property OnEndSession: TMyNotifyEvent read FOnEndSession write FOnEndSession;
  end;

procedure Register;

implementation

function LocalIP: String;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  GInitData: TWSAData;
  szHostName: array[0..255] of Char;
  phe: PHostEnt;
  pptr: PaPInAddr;
begin
  Result := '127.0.0.1';
  WSAStartup($101, GInitData);
  { sometimes the hostname will also have domainname }
  GetHostName(szHostName, 255);  { get what the local computer thinks is his
                                 { hostname - may not agree with DNS }
  phe  := GetHostByName(szHostName);
  if phe = nil then Exit;

  pptr := PaPInAddr(Phe^.h_addr_list);

  Result := StrPas(inet_ntoa(pptr^[0]^));
  WSACleanup;
end;

function TryTheWire(url: PChar): Boolean;
var
  hInet: HINTERNET;
  hUrl: HINTERNET;
  Flags: DWORD;
begin
//
// Try opening each URL in the collection, until one succeeds.
//
  Result := False;
  hInet := InternetOpen('UFO DynDNS Updater', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hInet<>nil then begin
    Flags := INTERNET_FLAG_KEEP_CONNECTION Or INTERNET_FLAG_NO_CACHE_WRITE Or INTERNET_FLAG_RELOAD;
    hUrl := InternetOpenUrl(hInet, url, nil, 0, Flags, 0);
    if hUrl<>nil then begin
      InternetCloseHandle(hUrl);
      Result := True;
    end;
  end;
  InternetCloseHandle(hInet)
end;

constructor TInternetDetect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDetectMethod := dmRAS;
  FEnabled := True;
  FDispatchInterval := 1000;
  FTryAddress := 'http://www.yahoo.com';
  FIP:=LocalIP;
  FWindowHandle := AllocateHWnd(TimerProc);
  UpdateTimer;
end;

destructor TInternetDetect.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

function TInternetDetect.InternetConnected: Boolean;
var
  dwConnectionTypes: DWORD;
begin
  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
  if (dwConnectionTypes and INTERNET_CONNECTION_MODEM)=INTERNET_CONNECTION_MODEM then begin
    Result :=  True;
  end;
  if (dwConnectionTypes and INTERNET_CONNECTION_LAN)=INTERNET_CONNECTION_LAN then begin
    Result := TryTheWire(PChar(FTryAddress));
  end;
end;

procedure TInternetDetect.TimerProc;
var
  RasProj: TRasProjection;
  RasHandle: THRasConn;
  NumOfRecieved,
  SizeOfRecieved: Longint;
  RasEnumConP: array [0..1] of TRasConn;
  RasProjP: LPRasPppIp;
  dwPPPsize: Longint;
  OldState: Boolean;
  TempState: Boolean;
  i: DWORD;
  Error: Integer;
begin
  try
    with Message do begin
      if (msg = WM_QUERYENDSESSION) then begin
        Enabled := False;
        if Assigned(FOnQueryEndSession) then begin
          if (lParam = Longint(ENDSESSION_LOGOFF)) then i := ENDSESSION_LOGOFF;
          FOnQueryEndSession(Self, i);
          Result := i;
          if (i = 1) and (lParam <> Longint(ENDSESSION_LOGOFF)) then begin
            Halt;
          end{ else AddStringToLog('@', 'QueryEndSession ignored.')};
        end;
        Exit;
      end else if (msg = WM_ENDSESSION) then begin
        Enabled := False;
        if Assigned(FOnEndSession) then begin
          if (lParam = Longint(ENDSESSION_LOGOFF)) then i := ENDSESSION_LOGOFF;
          FOnEndSession(Self, i);
          Result := i;
          if (i = 0) and (lParam <> Longint(ENDSESSION_LOGOFF)) then begin
            Halt;
          end{ else AddStringToLog('@', 'EndSession ignored.')};
        end;
        Exit;
      end else if (Msg = WM_TIMER) then begin
        case FDetectMethod of
          dmRAS: begin
            try
{              FIP := LocalIP;}
              OldState := FOnline;

              for i:=0 to 1 do RasEnumConP[i].dwSize:=sizeof(TRasConn);
              repeat
                i:=RasEnumConnections(@RasEnumConP, SizeOfRecieved, NumOfRecieved);
                Sleep(100);
              until i=0;
              if NumOfRecieved=0 then begin
                TempState:=False;
              end else begin
                RasHandle:=RasEnumConP[NumOfRecieved-1].HRasConn;
                RasProj:=RASP_PppIp;
                dwPPPsize:=SizeOf(TRasPppIp);
                New(RasProjP);
                RasProjP^.dwSize:=dwPPPsize;
                i:=RasGetProjectionInfo(RasHandle, RasProj, RasProjP, dwPPPsize);
                if i = 0 then begin
                  if RasProjP^.szIPAddress <> '' then FIP := RasProjP^.szIPAddress;
                  FConnectionName := RasEnumConP[NumOfRecieved-1].szEntryName;
                  TempState:=True;
                end else begin
                  FConnectionName:='';
                  TempState:=False;
                end;
                Dispose(RasProjP);
              end;

              if OldState<>TempState then begin
                Sleep(2000);
                FOnline := TempState;
                if not TempState then FIP := LocalIP;
                if Assigned(FOnChanged) then FOnChanged(Self);
               end;
            except
              Application.HandleException(Self);
            end;
          end; //dmRAS
          dmPING: begin
            try
{              FIP := LocalIP;}
              OldState := FOnline;

              I := iPing(FTryAddress, 1, 1000, Error);
              if I=0 then begin
                FConnectionName:='';
                TempState := False;
              end else begin
                FConnectionName:='LAN Connection';
                TempState := True;
              end;

              if OldState<>TempState then begin
                FOnline:=TempState;
                if Assigned(FOnChanged) then FOnChanged(Self);
              end;
            except
              Application.HandleException(Self);
            end;
          end; // dmPING
          dmWININET: begin
            try
{              FIP := LocalIP;}
              OldState := FOnline;

              TempState := InternetConnected;
              if OldState<>TempState then begin
                FOnline:=TempState;
                if TempState
                  then FConnectionName:='LAN Connection'
                  else FConnectionName:='';
                if Assigned(FOnChanged) then FOnChanged(Self);
              end;
            except
              Application.HandleException(Self);
            end;
          end; // dmWININET
        end; // case DetectMethod
      end else Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
    end;
  except
    on E:Exception do MessageBox(0, PChar('Ошибка:'#13 + E.Message), 'Error', MB_ICONERROR);
  end;
end;

procedure TInternetDetect.UpdateTimer;
begin
  KillTimer(FWindowHandle, FTimerHandle);
  if (FDispatchInterval <> 0) and FEnabled then begin
    FTimerHandle := SetTimer(FWindowHandle, 301, FDispatchInterval, nil);
  end;
end;

procedure TInternetDetect.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TInternetDetect.SetDispatchInterval(Value: Cardinal);
begin
  if Value <> FDispatchInterval then begin
    FDispatchInterval := Value;
    UpdateTimer;
  end;
end;

procedure TInternetDetect.SetTryAddress;
begin
  if Value <> FTryAddress then begin
    FTryAddress := Value;
    UpdateTimer;
  end;
end;

procedure TInternetDetect.SetDetectMethod;
begin
  if Value <> FDetectMethod then begin
    FDetectMethod := Value;
    UpdateTimer;
  end;
end;

procedure TInternetDetect.SetNoneBool(Value: Boolean); begin {} end;

procedure TInternetDetect.SetIPStr(Value: String);
begin
   fIP := Value;
end;

procedure TInternetDetect.SetConnStr(Value: String);
begin
   fConnectionName := Value;
end;

procedure Register;
begin
  RegisterComponents('Argus', [TInternetDetect]);
end;

end.
{*************************************************************}
