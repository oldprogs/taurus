unit RasUnit;

interface
Uses Windows;

type 
RASSTATS2000 = record 
  dwSize:Longint; 
  dwBytesXmited:Longint; 
  dwBytesRcved:Longint; 
  dwFramesXmited:Longint; 
  dwFramesRcved:Longint; 
  dwCrcErr:Longint; 
  dwTimeoutErr:Longint; 
  dwAlignmentErr:Longint;
  dwHardwareOverrunErr:Longint; 
  dwFramingErr:Longint; 
  dwBufferOverrunErr:Longint; 
  dwCompressionRatioIn:Longint; 
  dwCompressionRatioOut:Longint; 
  dwBps:Longint; 
  dwConnectDuration:Longint; 
End; 

RASType = record 
  dwSize:Longint; 
  hRasCon:Longint; 
  szEntryName:array[0..256] of Byte; 
  szDeviceType:array[0..16] of Byte;
  szDeviceName:array[0..32] of Byte; 
End; 

RASStatusType = record 
  dwSize:Longint; 
  RasConnState:Longint; 
  dwError:Longint; 
  szDeviceType:array[0..16] of byte; 
  szDeviceName:array[0..32] of Byte; 
  szInBytes:Double; 
  syOutbytes:Double 
End; 

(*RASAPI*)const
(*RASAPI*){ These are from lmcons.h }
(*RASAPI*)  DNLEN            = 15;  // Maximum domain name length
(*RASAPI*)  UNLEN            = 256; // Maximum user name length
(*RASAPI*)  PWLEN            = 256; // Maximum password length
(*RASAPI*)  NETBIOS_NAME_LEN = 16;  // NetBIOS net name (bytes)
(*RASAPI*)
(*RASAPI*)  RAS_MaxDeviceType     = 16;
(*RASAPI*)  RAS_MaxPhoneNumber    = 128;
(*RASAPI*)  RAS_MaxIpAddress      = 15;
(*RASAPI*)  RAS_MaxIpxAddress     = 21;
(*RASAPI*)  RAS_MaxEntryName      = 256;
(*RASAPI*)  RAS_MaxDeviceName     = 128;
(*RASAPI*)  RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
(*RASAPI*)
(*RASAPI*)type
(*RASAPI*)  LPHRasConn = ^THRasConn;
(*RASAPI*)  THRasConn  = Longint;
(*RASAPI*)
(*RASAPI*){* Identifies an active RAS connection.  (See RasEnumConnections) *}
(*RASAPI*)  LPRasConnW = ^TRasConnW;
(*RASAPI*)  TRasConnW  = record
(*RASAPI*)    dwSize       : Longint;
(*RASAPI*)    hrasconn     : THRasConn;
(*RASAPI*)    szEntryName  : Array[0..RAS_MaxEntryName] of WideChar;
(*RASAPI*)    szDeviceType : Array[0..RAS_MaxDeviceType] of WideChar;
(*RASAPI*)    szDeviceName : Array[0..RAS_MaxDeviceName] of WideChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasConnA = ^TRasConnA;
(*RASAPI*)  TRasConnA  = record
(*RASAPI*)    dwSize       : Longint;
(*RASAPI*)    hrasconn     : THRasConn;
(*RASAPI*)    szEntryName  : Array[0..RAS_MaxEntryName] of AnsiChar;
(*RASAPI*)    szDeviceType : Array[0..RAS_MaxDeviceType] of AnsiChar;
(*RASAPI*)    szDeviceName : Array[0..RAS_MaxDeviceName] of AnsiChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasConn = ^TRasConn;
(*RASAPI*)  TRasConn  = TRasConnA;
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*){* Enumerates intermediate states to a connection.  (See RasDial) *}
(*RASAPI*)  RASCS_PAUSED = $1000;
(*RASAPI*)  RASCS_DONE   = $2000;
(*RASAPI*)
(*RASAPI*)type
(*RASAPI*)  LPRasConnState = ^TRasConnState;
(*RASAPI*)  TRasConnState  = Integer;
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*)  RASCS_OpenPort                  = 0;
(*RASAPI*)  RASCS_PortOpened                = 1;
(*RASAPI*)  RASCS_ConnectDevice             = 2;
(*RASAPI*)  RASCS_DeviceConnected           = 3;
(*RASAPI*)  RASCS_AllDevicesConnected       = 4;
(*RASAPI*)  RASCS_Authenticate              = 5;
(*RASAPI*)  RASCS_AuthNotify                = 6;
(*RASAPI*)  RASCS_AuthRetry                 = 7;
(*RASAPI*)  RASCS_AuthCallback              = 8;
(*RASAPI*)  RASCS_AuthChangePassword        = 9;
(*RASAPI*)  RASCS_AuthProject               = 10;
(*RASAPI*)  RASCS_AuthLinkSpeed             = 11;
(*RASAPI*)  RASCS_AuthAck                   = 12;
(*RASAPI*)  RASCS_ReAuthenticate            = 13;
(*RASAPI*)  RASCS_Authenticated             = 14;
(*RASAPI*)  RASCS_PrepareForCallback        = 15;
(*RASAPI*)  RASCS_WaitForModemReset         = 16;
(*RASAPI*)  RASCS_WaitForCallback           = 17;
(*RASAPI*)  RASCS_Projected                 = 18;
(*RASAPI*)  RASCS_StartAuthentication       = 19;
(*RASAPI*)  RASCS_CallbackComplete          = 20;
(*RASAPI*)  RASCS_LogonNetwork              = 21;
(*RASAPI*)
(*RASAPI*)  RASCS_Interactive               = RASCS_PAUSED;
(*RASAPI*)  RASCS_RetryAuthentication       = RASCS_PAUSED + 1;
(*RASAPI*)  RASCS_CallbackSetByCaller       = RASCS_PAUSED + 2;
(*RASAPI*)  RASCS_PasswordExpired           = RASCS_PAUSED + 3;
(*RASAPI*)
(*RASAPI*)  RASCS_Connected                 = RASCS_DONE;
(*RASAPI*)  RASCS_Disconnected              = RASCS_DONE + 1;
(*RASAPI*)
(*RASAPI*)type
(*RASAPI*){* Describes the status of a RAS connection.  (See RasConnectionStatus)*}
(*RASAPI*)  LPRasConnStatusW = ^TRasConnStatusW;
(*RASAPI*)  TRasConnStatusW  = record
(*RASAPI*)    dwSize         : Longint;
(*RASAPI*)    rasconnstate   : TRasConnState;
(*RASAPI*)    dwError        : LongInt;
(*RASAPI*)    szDeviceType   : Array[0..RAS_MaxDeviceType] of WideChar;
(*RASAPI*)    szDeviceName   : Array[0..RAS_MaxDeviceName] of WideChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasConnStatusA = ^TRasConnStatusA;
(*RASAPI*)  TRasConnStatusA  = record
(*RASAPI*)    dwSize         : Longint;
(*RASAPI*)    rasconnstate   : TRasConnState;
(*RASAPI*)    dwError        : LongInt;
(*RASAPI*)    szDeviceType   : Array[0..RAS_MaxDeviceType] of AnsiChar;
(*RASAPI*)    szDeviceName   : Array[0..RAS_MaxDeviceName] of AnsiChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasConnStatus = ^TRasConnStatus;
(*RASAPI*)  TRasConnStatus  = TRasConnStatusA;
(*RASAPI*)
(*RASAPI*){* Describes connection establishment parameters.  (See RasDial)*}
(*RASAPI*)  LPRasDialParamsW = ^TRasDialParamsW;
(*RASAPI*)  TRasDialParamsW  = record
(*RASAPI*)    dwSize           : LongInt;
(*RASAPI*)    szEntryName      : Array[0..RAS_MaxEntryName] of WideChar;
(*RASAPI*)    szPhoneNumber    : Array[0..RAS_MaxPhoneNumber] of WideChar;
(*RASAPI*)    szCallbackNumber : Array[0..RAS_MaxCallbackNumber] of WideChar;
(*RASAPI*)    szUserName       : Array[0..UNLEN] of WideChar;
(*RASAPI*)    szPassword       : Array[0..PWLEN] of WideChar;
(*RASAPI*)    szDomain         : Array[0..DNLEN] of WideChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasDialParamsA = ^TRasDialParamsA;
(*RASAPI*)  TRasDialParamsA  = record
(*RASAPI*)    dwSize           : LongInt;
(*RASAPI*)    szEntryName      : Array[0..RAS_MaxEntryName] of AnsiChar;
(*RASAPI*)    szPhoneNumber    : Array[0..RAS_MaxPhoneNumber] of AnsiChar;
(*RASAPI*)    szCallbackNumber : Array[0..RAS_MaxCallbackNumber] of AnsiChar;
(*RASAPI*)    szUserName       : Array[0..UNLEN] of AnsiChar;
(*RASAPI*)    szPassword       : Array[0..PWLEN] of AnsiChar;
(*RASAPI*)    szDomain         : Array[0..DNLEN] of AnsiChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasDialParams = ^TRasDialParams;
(*RASAPI*)  TRasDialParams  = TRasDialParamsA;
(*RASAPI*)
(*RASAPI*){* Describes extended connection establishment options.  (See RasDial)*}
(*RASAPI*)  LPRasDialExtensions = ^TRasDialExtensions;
(*RASAPI*)  TRasDialExtensions  = record
(*RASAPI*)    dwSize            : LongInt;
(*RASAPI*)    dwfOptions        : LongInt;
(*RASAPI*)    hwndParent        : HWND;
(*RASAPI*)    reserved          : LongInt;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*){* 'dwfOptions' bit flags.*}
(*RASAPI*)  RDEOPT_UsePrefixSuffix           = $00000001;
(*RASAPI*)  RDEOPT_PausedStates              = $00000002;
(*RASAPI*)  RDEOPT_IgnoreModemSpeaker        = $00000004;
(*RASAPI*)  RDEOPT_SetModemSpeaker           = $00000008;
(*RASAPI*)  RDEOPT_IgnoreSoftwareCompression = $00000010;
(*RASAPI*)  RDEOPT_SetSoftwareCompression    = $00000020;
(*RASAPI*)
(*RASAPI*)
(*RASAPI*)type
(*RASAPI*)
(*RASAPI*){* Describes an enumerated RAS phone book entry name.  (See RasEntryEnum)*}
(*RASAPI*)  LPRasEntryNameW = ^TRasEntryNameW;
(*RASAPI*)  TRasEntryNameW  = record
(*RASAPI*)    dwSize        : Longint;
(*RASAPI*)    szEntryName   : Array[0..RAS_MaxEntryName] of WideChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasEntryNameA = ^TRasEntryNameA;
(*RASAPI*)  TRasEntryNameA  = record
(*RASAPI*)    dwSize        : Longint;
(*RASAPI*)    szEntryName   : Array[0..RAS_MaxEntryName] of AnsiChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasEntryName = ^TRasEntryName;
(*RASAPI*)  TRasEntryName  = TRasEntryNameA;
(*RASAPI*)
(*RASAPI*){* Protocol code to projection data structure mapping.*}
(*RASAPI*)  LPRasProjection = ^TRasProjection;
(*RASAPI*)  TRasProjection  = Integer;
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*)  RASP_Amb        = $10000;
(*RASAPI*)  RASP_PppNbf     = $803F;
(*RASAPI*)  RASP_PppIpx     = $802B;
(*RASAPI*)  RASP_PppIp      = $8021;
(*RASAPI*)
(*RASAPI*)
(*RASAPI*)type
(*RASAPI*){* Describes the result of a RAS AMB (Authentication Message Block)
(*RASAPI*)** projection.  This protocol is used with NT 3.1 and OS/2 1.3 downlevel
(*RASAPI*)** RAS servers.*}
(*RASAPI*)  LPRasAmbW = ^TRasAmbW;
(*RASAPI*)  TRasAmbW  = record
(*RASAPI*)    dwSize         : Longint;
(*RASAPI*)    dwError        : Longint;
(*RASAPI*)    szNetBiosError : Array[0..NETBIOS_NAME_LEN] of WideChar;
(*RASAPI*)    bLana          : Byte;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasAmbA = ^TRasAmbA;
(*RASAPI*)  TRasAmbA  = record
(*RASAPI*)    dwSize         : Longint;
(*RASAPI*)    dwError        : Longint;
(*RASAPI*)    szNetBiosError : Array[0..NETBIOS_NAME_LEN] of AnsiChar;
(*RASAPI*)    bLana          : Byte;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasAmb = ^TRasAmb;
(*RASAPI*)  TRasAmb  = TRasAmbA;
(*RASAPI*)
(*RASAPI*){* Describes the result of a PPP NBF (NetBEUI) projection.*}
(*RASAPI*)  LPRasPppNbfW = ^TRasPppNbfW;
(*RASAPI*)  TRasPppNbfW  = record
(*RASAPI*)    dwSize             : Longint;
(*RASAPI*)    dwError            : Longint;
(*RASAPI*)    dwNetBiosError     : Longint;
(*RASAPI*)    szNetBiosError     : Array[0..NETBIOS_NAME_LEN] of WideChar;
(*RASAPI*)    szWorkstationName  : Array[0..NETBIOS_NAME_LEN] of WideChar;
(*RASAPI*)    bLana              : Byte;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasPppNbfA = ^TRasPppNbfA;
(*RASAPI*)  TRasPppNbfA  = record
(*RASAPI*)    dwSize             : Longint;
(*RASAPI*)    dwError            : Longint;
(*RASAPI*)    dwNetBiosError     : Longint;
(*RASAPI*)    szNetBiosError     : Array[0..NETBIOS_NAME_LEN] of AnsiChar;
(*RASAPI*)    szWorkstationName  : Array[0..NETBIOS_NAME_LEN] of AnsiChar;
(*RASAPI*)    bLana              : Byte;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LpRaspppNbf = ^TRasPppNbf;
(*RASAPI*)  TRasPppNbf  = TRasPppNbfA;
(*RASAPI*)
(*RASAPI*){* Describes the results of a PPP IPX (Internetwork Packet Exchange)
(*RASAPI*)** projection.*}
(*RASAPI*)  LPRasPppIpxW = ^TRasPppIpxW;
(*RASAPI*)  TRasPppIpxW  = record
(*RASAPI*)    dwSize       : Longint;
(*RASAPI*)    dwError      : Longint;
(*RASAPI*)    szIpxAddress : Array[0..RAS_MaxIpxAddress] of WideChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasPppIpxA = ^TRasPppIpxA;
(*RASAPI*)  TRasPppIpxA  = record
(*RASAPI*)    dwSize       : Longint;
(*RASAPI*)    dwError      : Longint;
(*RASAPI*)    szIpxAddress : Array[0..RAS_MaxIpxAddress] of AnsiChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasPppIpx = ^TRasPppIpx;
(*RASAPI*)  TRasPppIpx  = TRasPppIpxA;
(*RASAPI*)
(*RASAPI*){* Describes the results of a PPP IP (Internet) projection.*}
(*RASAPI*)  LPRasPppIpW = ^TRasPppIpW;
(*RASAPI*)  TRasPppIpW  = record
(*RASAPI*)    dwSize      : Longint;
(*RASAPI*)    dwError     : Longint;
(*RASAPI*)    szIpAddress : Array[0..RAS_MaxIpAddress] of WideChar;
(*RASAPI*)
(*RASAPI*){$IFNDEF WINNT35COMPATIBLE}
(*RASAPI*)    {* This field was added between Windows NT 3.51 beta and Windows NT 3.51
(*RASAPI*)    ** final, and between Windows 95 M8 beta and Windows 95 final.  If you do
(*RASAPI*)    ** not require the server address and wish to retrieve PPP IP information
(*RASAPI*)    ** from Windows NT 3.5 or early Windows NT 3.51 betas, or on early Windows
(*RASAPI*)    ** 95 betas, define WINNT35COMPATIBLE.
(*RASAPI*)    **
(*RASAPI*)    ** The server IP address is not provided by all PPP implementations,
(*RASAPI*)    ** though Windows NT server's do provide it.    *}
(*RASAPI*)    szServerIpAddress: Array[0..RAS_MaxIpAddress] of WideChar;
(*RASAPI*){$ENDIF}
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasPppIpA = ^TRasPppIpA;
(*RASAPI*)  TRasPppIpA  = record
(*RASAPI*)    dwSize      : Longint;
(*RASAPI*)    dwError     : Longint;
(*RASAPI*)    szIpAddress : Array[0..RAS_MaxIpAddress] of AnsiChar;
(*RASAPI*)
(*RASAPI*){$IFNDEF WINNT35COMPATIBLE} {* See RASPPPIPW comment. *}
(*RASAPI*)    szServerIpAddress: Array[0..RAS_MaxIpAddress] of AnsiChar;
(*RASAPI*){$ENDIF}
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasPppIp = ^TRasPppIp;
(*RASAPI*)  TRasPppIp  = TRasPppIpA;
(*RASAPI*)
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*){* If using RasDial message notifications, get the notification message code
(*RASAPI*)** by passing this string to the RegisterWindowMessageA() API.
(*RASAPI*)** WM_RASDIALEVENT is used only if a unique message cannot be registered.*}
(*RASAPI*)  RASDIALEVENT    = 'RasDialEvent';
(*RASAPI*)  WM_RASDIALEVENT = $CCCD;
(*RASAPI*)
(*RASAPI*)
(*RASAPI*){* Prototypes for caller's RasDial callback handler.  Arguments are the
(*RASAPI*)** message ID (currently always WM_RASDIALEVENT), the current RASCONNSTATE and
(*RASAPI*)** the error that has occurred (or 0 if none).  Extended arguments are the
(*RASAPI*)** handle of the RAS connection and an extended error code.
(*RASAPI*)*}
(*RASAPI*){
(*RASAPI*)typedef VOID (WINAPI *RASDIALFUNC)( UINT, RASCONNSTATE, DWORD );
(*RASAPI*)typedef VOID (WINAPI *RASDIALFUNC1)( HRASCONN, UINT, RASCONNSTATE, DWORD, DWORD );
(*RASAPI*)
(*RASAPI*)For Delphi: Just define the callback as
(*RASAPI*)procedure RASCallback(msg: Integer; state: TRasConnState;
(*RASAPI*)    dwError: Longint); stdcall;
(*RASAPI*) or
(*RASAPI*)procedure RASCallback1(hConn: THRasConn; msg: Integer;
(*RASAPI*)    state: TRasConnState; dwError: Longint; dwEexterror: Longint); stdcall;
(*RASAPI*)}
(*RASAPI*)
(*RASAPI*){* External RAS API function prototypes.
(*RASAPI*)*}
(*RASAPI*){Note: for Delphi the function without 'A' or 'W' is the Ansi one
(*RASAPI*)  as on the other Delphi headers}
(*RASAPI*)
{
(*RASAPI*)function RasDialA(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PAnsiChar;
(*RASAPI*)                  var params: TRasDialParamsA; dwNotifierType: Longint;
(*RASAPI*)                  lpNotifier: Pointer; var rasconn: THRasConn): Longint; stdcall;
(*RASAPI*)function RasDialW(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PWideChar;
(*RASAPI*)                  var params: TRasDialParamsW; dwNotifierType: Longint;
(*RASAPI*)                  lpNotifier: Pointer; var rasconn: THRasConn): Longint; stdcall;
}
function RasDial(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PAnsiChar;
                 var params: TRasDialParams; dwNotifierType: Longint;
                 lpNotifier: Pointer; var rasconn: THRasConn): Longint; stdcall;
{
(*RASAPI*)
(*RASAPI*)function RasEnumConnectionsA(RasConnArray: LPRasConnA; var lpcb: Longint;
(*RASAPI*)                             var lpcConnections: Longint): Longint; stdcall;
(*RASAPI*)function RasEnumConnectionsW(RasConnArray: LPRasConnW; var lpcb: Longint;
(*RASAPI*)                             var lpcConnections: Longint): Longint; stdcall;
}
function RasEnumConnections(RasConnArray: LPRasConn; var lpcb: Longint;
                            var lpcConnections: Longint): Longint; stdcall;
{
(*RASAPI*)
(*RASAPI*)function RasEnumEntriesA(Reserved: PAnsiChar; lpszPhoneBook: PAnsiChar;
(*RASAPI*)                         entrynamesArray: LPRasEntryNameA; var lpcb: Longint;
(*RASAPI*)                         var lpcEntries: Longint): Longint; stdcall;
(*RASAPI*)function RasEnumEntriesW(reserved: PWideChar; lpszPhoneBook: PWideChar;
(*RASAPI*)                         entrynamesArray: LPRasEntryNameW; var lpcb: Longint;
(*RASAPI*)                         var lpcEntries: Longint): Longint; stdcall;
}
function RasEnumEntries(reserved: PAnsiChar; lpszPhoneBook: PAnsiChar;
                        entrynamesArray: LPRasEntryName; var lpcb: Longint;
                        var lpcEntries: Longint): Longint; stdcall;
{
(*RASAPI*)
(*RASAPI*)}
function RasGetConnectStatusA(hConn: THRasConn; var lpStatus: TRasConnStatusA): Longint; stdcall;
{
(*RASAPI*)function RasGetConnectStatusW(hConn: THRasConn;var lpStatus: TRasConnStatusW): Longint; stdcall;
(*RASAPI*)function RasGetConnectStatus(hConn: THRasConn;var lpStatus: TRasConnStatus): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasGetErrorStringA(errorValue: Integer;erroString: PAnsiChar;cBufSize: Longint): Longint; stdcall;
(*RASAPI*)function RasGetErrorStringW(errorValue: Integer;erroString: PWideChar;cBufSize: Longint): Longint; stdcall;
}
function RasGetErrorString(errorValue: Integer; errorString: PAnsiChar; cBufSize: Longint): Longint; stdcall;
{
(*RASAPI*)
}
function RasHangUpA(hConn: THRasConn): Longint; stdcall;
{
(*RASAPI*)function RasHangUpW(hConn: THRasConn): Longint; stdcall;
(*RASAPI*)function RasHangUp(hConn: THRasConn): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasGetProjectionInfoA(hConn: THRasConn; rasproj: TRasProjection;
(*RASAPI*)                               lpProjection: Pointer; var lpcb: Longint): Longint; stdcall;
(*RASAPI*)function RasGetProjectionInfoW(hConn: THRasConn; rasproj: TRasProjection;
(*RASAPI*)                               lpProjection: Pointer; var lpcb: Longint): Longint; stdcall;
(*RASAPI*)function RasGetProjectionInfo(hConn: THRasConn; rasproj: TRasProjection;
(*RASAPI*)                              lpProjection: Pointer; var lpcb: Longint): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasCreatePhonebookEntryA(hwndParentWindow: HWND;lpszPhoneBook: PAnsiChar): Longint; stdcall;
(*RASAPI*)function RasCreatePhonebookEntryW(hwndParentWindow: HWND;lpszPhoneBook: PWideChar): Longint; stdcall;
(*RASAPI*)function RasCreatePhonebookEntry(hwndParentWindow: HWND;lpszPhoneBook: PAnsiChar): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasEditPhonebookEntryA(hwndParentWindow: HWND; lpszPhoneBook: PAnsiChar;
(*RASAPI*)                                lpszEntryName: PAnsiChar): Longint; stdcall;
(*RASAPI*)function RasEditPhonebookEntryW(hwndParentWindow: HWND; lpszPhoneBook: PWideChar;
(*RASAPI*)                                lpszEntryName: PWideChar): Longint; stdcall;
(*RASAPI*)function RasEditPhonebookEntry(hwndParentWindow: HWND; lpszPhoneBook: PAnsiChar;
(*RASAPI*)                               lpszEntryName: PAnsiChar): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasSetEntryDialParamsA(lpszPhoneBook: PAnsiChar; var lpDialParams: TRasDialParamsA;
(*RASAPI*)                                fRemovePassword: LongBool): Longint; stdcall;
(*RASAPI*)function RasSetEntryDialParamsW(lpszPhoneBook: PWideChar; var lpDialParams: TRasDialParamsW;
(*RASAPI*)                                fRemovePassword: LongBool): Longint; stdcall;
(*RASAPI*)function RasSetEntryDialParams(lpszPhoneBook: PAnsiChar; var lpDialParams: TRasDialParams;
(*RASAPI*)                               fRemovePassword: LongBool): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasGetEntryDialParamsA(lpszPhoneBook: PAnsiChar; var lpDialParams: TRasDialParamsA;
(*RASAPI*)                                var lpfPassword: LongBool): Longint; stdcall;
(*RASAPI*)function RasGetEntryDialParamsW(lpszPhoneBook: PWideChar; var lpDialParams: TRasDialParamsW;
(*RASAPI*)                                var lpfPassword: LongBool): Longint; stdcall;
}
function RasGetEntryDialParams(lpszPhoneBook: PAnsiChar; var lpDialParams: TRasDialParams;
                               var lpfPassword: LongBool): Longint; stdcall;
{
(*by buster*)function RasGetConnectionStatistics(hRasConn:Longint;var lpStatistics:RASSTATS2000):longint; stdcall;
(*by buster*)
}
(*RASAPI*)
(*RASAPI*){**
(*RASAPI*)** raserror.h
(*RASAPI*)** Remote Access external API
(*RASAPI*)** RAS specific error codes *}
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*)  RASBASE = 600;
(*RASAPI*)  SUCCESS = 0;
(*RASAPI*)
(*RASAPI*)  PENDING                              = (RASBASE+0);
(*RASAPI*)  ERROR_INVALID_PORT_HANDLE            = (RASBASE+1);
(*RASAPI*)  ERROR_PORT_ALREADY_OPEN              = (RASBASE+2);
(*RASAPI*)  ERROR_BUFFER_TOO_SMALL               = (RASBASE+3);
(*RASAPI*)  ERROR_WRONG_INFO_SPECIFIED           = (RASBASE+4);
(*RASAPI*)  ERROR_CANNOT_SET_PORT_INFO           = (RASBASE+5);
(*RASAPI*)  ERROR_PORT_NOT_CONNECTED             = (RASBASE+6);
(*RASAPI*)  ERROR_EVENT_INVALID                  = (RASBASE+7);
(*RASAPI*)  ERROR_DEVICE_DOES_NOT_EXIST          = (RASBASE+8);
(*RASAPI*)  ERROR_DEVICETYPE_DOES_NOT_EXIST      = (RASBASE+9);
(*RASAPI*)  ERROR_BUFFER_INVALID                 = (RASBASE+10);
(*RASAPI*)  ERROR_ROUTE_NOT_AVAILABLE            = (RASBASE+11);
(*RASAPI*)  ERROR_ROUTE_NOT_ALLOCATED            = (RASBASE+12);
(*RASAPI*)  ERROR_INVALID_COMPRESSION_SPECIFIED  = (RASBASE+13);
(*RASAPI*)  ERROR_OUT_OF_BUFFERS                 = (RASBASE+14);
(*RASAPI*)  ERROR_PORT_NOT_FOUND                 = (RASBASE+15);
(*RASAPI*)  ERROR_ASYNC_REQUEST_PENDING          = (RASBASE+16);
(*RASAPI*)  ERROR_ALREADY_DISCONNECTING          = (RASBASE+17);
(*RASAPI*)  ERROR_PORT_NOT_OPEN                  = (RASBASE+18);
(*RASAPI*)  ERROR_PORT_DISCONNECTED              = (RASBASE+19);
(*RASAPI*)  ERROR_NO_ENDPOINTS                   = (RASBASE+20);
(*RASAPI*)  ERROR_CANNOT_OPEN_PHONEBOOK          = (RASBASE+21);
(*RASAPI*)  ERROR_CANNOT_LOAD_PHONEBOOK          = (RASBASE+22);
(*RASAPI*)  ERROR_CANNOT_FIND_PHONEBOOK_ENTRY    = (RASBASE+23);
(*RASAPI*)  ERROR_CANNOT_WRITE_PHONEBOOK         = (RASBASE+24);
(*RASAPI*)  ERROR_CORRUPT_PHONEBOOK              = (RASBASE+25);
(*RASAPI*)  ERROR_CANNOT_LOAD_STRING             = (RASBASE+26);
(*RASAPI*)  ERROR_KEY_NOT_FOUND                  = (RASBASE+27);
(*RASAPI*)  ERROR_DISCONNECTION                  = (RASBASE+28);
(*RASAPI*)  ERROR_REMOTE_DISCONNECTION           = (RASBASE+29);
(*RASAPI*)  ERROR_HARDWARE_FAILURE               = (RASBASE+30);
(*RASAPI*)  ERROR_USER_DISCONNECTION             = (RASBASE+31);
(*RASAPI*)  ERROR_INVALID_SIZE                   = (RASBASE+32);
(*RASAPI*)  ERROR_PORT_NOT_AVAILABLE             = (RASBASE+33);
(*RASAPI*)  ERROR_CANNOT_PROJECT_CLIENT          = (RASBASE+34);
(*RASAPI*)  ERROR_UNKNOWN                        = (RASBASE+35);
(*RASAPI*)  ERROR_WRONG_DEVICE_ATTACHED          = (RASBASE+36);
(*RASAPI*)  ERROR_BAD_STRING                     = (RASBASE+37);
(*RASAPI*)  ERROR_REQUEST_TIMEOUT                = (RASBASE+38);
(*RASAPI*)  ERROR_CANNOT_GET_LANA                = (RASBASE+39);
(*RASAPI*)  ERROR_NETBIOS_ERROR                  = (RASBASE+40);
(*RASAPI*)  ERROR_SERVER_OUT_OF_RESOURCES        = (RASBASE+41);
(*RASAPI*)  ERROR_NAME_EXISTS_ON_NET             = (RASBASE+42);
(*RASAPI*)  ERROR_SERVER_GENERAL_NET_FAILURE     = (RASBASE+43);
(*RASAPI*)  WARNING_MSG_ALIAS_NOT_ADDED          = (RASBASE+44);
(*RASAPI*)  ERROR_AUTH_INTERNAL                  = (RASBASE+45);
(*RASAPI*)  ERROR_RESTRICTED_LOGON_HOURS         = (RASBASE+46);
(*RASAPI*)  ERROR_ACCT_DISABLED                  = (RASBASE+47);
(*RASAPI*)  ERROR_PASSWD_EXPIRED                 = (RASBASE+48);
(*RASAPI*)  ERROR_NO_DIALIN_PERMISSION           = (RASBASE+49);
(*RASAPI*)  ERROR_SERVER_NOT_RESPONDING          = (RASBASE+50);
(*RASAPI*)  ERROR_FROM_DEVICE                    = (RASBASE+51);
(*RASAPI*)  ERROR_UNRECOGNIZED_RESPONSE          = (RASBASE+52);
(*RASAPI*)  ERROR_MACRO_NOT_FOUND                = (RASBASE+53);
(*RASAPI*)  ERROR_MACRO_NOT_DEFINED              = (RASBASE+54);
(*RASAPI*)  ERROR_MESSAGE_MACRO_NOT_FOUND        = (RASBASE+55);
(*RASAPI*)  ERROR_DEFAULTOFF_MACRO_NOT_FOUND     = (RASBASE+56);
(*RASAPI*)  ERROR_FILE_COULD_NOT_BE_OPENED       = (RASBASE+57);
(*RASAPI*)  ERROR_DEVICENAME_TOO_LONG            = (RASBASE+58);
(*RASAPI*)  ERROR_DEVICENAME_NOT_FOUND           = (RASBASE+59);
(*RASAPI*)  ERROR_NO_RESPONSES                   = (RASBASE+60);
(*RASAPI*)  ERROR_NO_COMMAND_FOUND               = (RASBASE+61);
(*RASAPI*)  ERROR_WRONG_KEY_SPECIFIED            = (RASBASE+62);
(*RASAPI*)  ERROR_UNKNOWN_DEVICE_TYPE            = (RASBASE+63);
(*RASAPI*)  ERROR_ALLOCATING_MEMORY              = (RASBASE+64);
(*RASAPI*)  ERROR_PORT_NOT_CONFIGURED            = (RASBASE+65);
(*RASAPI*)  ERROR_DEVICE_NOT_READY               = (RASBASE+66);
(*RASAPI*)  ERROR_READING_INI_FILE               = (RASBASE+67);
(*RASAPI*)  ERROR_NO_CONNECTION                  = (RASBASE+68);
(*RASAPI*)  ERROR_BAD_USAGE_IN_INI_FILE          = (RASBASE+69);
(*RASAPI*)  ERROR_READING_SECTIONNAME            = (RASBASE+70);
(*RASAPI*)  ERROR_READING_DEVICETYPE             = (RASBASE+71);
(*RASAPI*)  ERROR_READING_DEVICENAME             = (RASBASE+72);
(*RASAPI*)  ERROR_READING_USAGE                  = (RASBASE+73);
(*RASAPI*)  ERROR_READING_MAXCONNECTBPS          = (RASBASE+74);
(*RASAPI*)  ERROR_READING_MAXCARRIERBPS          = (RASBASE+75);
(*RASAPI*)  ERROR_LINE_BUSY                      = (RASBASE+76);
(*RASAPI*)  ERROR_VOICE_ANSWER                   = (RASBASE+77);
(*RASAPI*)  ERROR_NO_ANSWER                      = (RASBASE+78);
(*RASAPI*)  ERROR_NO_CARRIER                     = (RASBASE+79);
(*RASAPI*)  ERROR_NO_DIALTONE                    = (RASBASE+80);
(*RASAPI*)  ERROR_IN_COMMAND                     = (RASBASE+81);
(*RASAPI*)  ERROR_WRITING_SECTIONNAME            = (RASBASE+82);
(*RASAPI*)  ERROR_WRITING_DEVICETYPE             = (RASBASE+83);
(*RASAPI*)  ERROR_WRITING_DEVICENAME             = (RASBASE+84);
(*RASAPI*)  ERROR_WRITING_MAXCONNECTBPS          = (RASBASE+85);
(*RASAPI*)  ERROR_WRITING_MAXCARRIERBPS          = (RASBASE+86);
(*RASAPI*)  ERROR_WRITING_USAGE                  = (RASBASE+87);
(*RASAPI*)  ERROR_WRITING_DEFAULTOFF             = (RASBASE+88);
(*RASAPI*)  ERROR_READING_DEFAULTOFF             = (RASBASE+89);
(*RASAPI*)  ERROR_EMPTY_INI_FILE                 = (RASBASE+90);
(*RASAPI*)  ERROR_AUTHENTICATION_FAILURE         = (RASBASE+91);
(*RASAPI*)  ERROR_PORT_OR_DEVICE                 = (RASBASE+92);
(*RASAPI*)  ERROR_NOT_BINARY_MACRO               = (RASBASE+93);
(*RASAPI*)  ERROR_DCB_NOT_FOUND                  = (RASBASE+94);
(*RASAPI*)  ERROR_STATE_MACHINES_NOT_STARTED     = (RASBASE+95);
(*RASAPI*)  ERROR_STATE_MACHINES_ALREADY_STARTED = (RASBASE+96);
(*RASAPI*)  ERROR_PARTIAL_RESPONSE_LOOPING       = (RASBASE+97);
(*RASAPI*)  ERROR_UNKNOWN_RESPONSE_KEY           = (RASBASE+98);
(*RASAPI*)  ERROR_RECV_BUF_FULL                  = (RASBASE+99);
(*RASAPI*)  ERROR_CMD_TOO_LONG                   = (RASBASE+100);
(*RASAPI*)  ERROR_UNSUPPORTED_BPS                = (RASBASE+101);
(*RASAPI*)  ERROR_UNEXPECTED_RESPONSE            = (RASBASE+102);
(*RASAPI*)  ERROR_INTERACTIVE_MODE               = (RASBASE+103);
(*RASAPI*)  ERROR_BAD_CALLBACK_NUMBER            = (RASBASE+104);
(*RASAPI*)  ERROR_INVALID_AUTH_STATE             = (RASBASE+105);
(*RASAPI*)  ERROR_WRITING_INITBPS                = (RASBASE+106);
(*RASAPI*)  ERROR_X25_DIAGNOSTIC                 = (RASBASE+107);
(*RASAPI*)  ERROR_ACCT_EXPIRED                   = (RASBASE+108);
(*RASAPI*)  ERROR_CHANGING_PASSWORD              = (RASBASE+109);
(*RASAPI*)  ERROR_OVERRUN                        = (RASBASE+110);
(*RASAPI*)  ERROR_RASMAN_CANNOT_INITIALIZE       = (RASBASE+111);
(*RASAPI*)  ERROR_BIPLEX_PORT_NOT_AVAILABLE      = (RASBASE+112);
(*RASAPI*)  ERROR_NO_ACTIVE_ISDN_LINES           = (RASBASE+113);
(*RASAPI*)  ERROR_NO_ISDN_CHANNELS_AVAILABLE     = (RASBASE+114);
(*RASAPI*)  ERROR_TOO_MANY_LINE_ERRORS           = (RASBASE+115);
(*RASAPI*)  ERROR_IP_CONFIGURATION               = (RASBASE+116);
(*RASAPI*)  ERROR_NO_IP_ADDRESSES                = (RASBASE+117);
(*RASAPI*)  ERROR_PPP_TIMEOUT                    = (RASBASE+118);
(*RASAPI*)  ERROR_PPP_REMOTE_TERMINATED          = (RASBASE+119);
(*RASAPI*)  ERROR_PPP_NO_PROTOCOLS_CONFIGURED    = (RASBASE+120);
(*RASAPI*)  ERROR_PPP_NO_RESPONSE                = (RASBASE+121);
(*RASAPI*)  ERROR_PPP_INVALID_PACKET             = (RASBASE+122);
(*RASAPI*)  ERROR_PHONE_NUMBER_TOO_LONG          = (RASBASE+123);
(*RASAPI*)  ERROR_IPXCP_NO_DIALOUT_CONFIGURED    = (RASBASE+124);
(*RASAPI*)  ERROR_IPXCP_NO_DIALIN_CONFIGURED     = (RASBASE+125);
(*RASAPI*)  ERROR_IPXCP_DIALOUT_ALREADY_ACTIVE   = (RASBASE+126);
(*RASAPI*)  ERROR_ACCESSING_TCPCFGDLL            = (RASBASE+127);
(*RASAPI*)  ERROR_NO_IP_RAS_ADAPTER              = (RASBASE+128);
(*RASAPI*)  ERROR_SLIP_REQUIRES_IP               = (RASBASE+129);
(*RASAPI*)  ERROR_PROJECTION_NOT_COMPLETE        = (RASBASE+130);
(*RASAPI*)  ERROR_PROTOCOL_NOT_CONFIGURED        = (RASBASE+131);
(*RASAPI*)  ERROR_PPP_NOT_CONVERGING             = (RASBASE+132);
(*RASAPI*)  ERROR_PPP_CP_REJECTED                = (RASBASE+133);
(*RASAPI*)  ERROR_PPP_LCP_TERMINATED             = (RASBASE+134);
(*RASAPI*)  ERROR_PPP_REQUIRED_ADDRESS_REJECTED  = (RASBASE+135);
(*RASAPI*)  ERROR_PPP_NCP_TERMINATED             = (RASBASE+136);
(*RASAPI*)  ERROR_PPP_LOOPBACK_DETECTED          = (RASBASE+137);
(*RASAPI*)  ERROR_PPP_NO_ADDRESS_ASSIGNED        = (RASBASE+138);
(*RASAPI*)  ERROR_CANNOT_USE_LOGON_CREDENTIALS   = (RASBASE+139);
(*RASAPI*)  ERROR_TAPI_CONFIGURATION             = (RASBASE+140);
(*RASAPI*)  ERROR_NO_LOCAL_ENCRYPTION            = (RASBASE+141);
(*RASAPI*)  ERROR_NO_REMOTE_ENCRYPTION           = (RASBASE+142);
(*RASAPI*)  ERROR_REMOTE_REQUIRES_ENCRYPTION     = (RASBASE+143);
(*RASAPI*)  ERROR_IPXCP_NET_NUMBER_CONFLICT      = (RASBASE+144);
(*RASAPI*)  ERROR_INVALID_SMM                    = (RASBASE+145);
(*RASAPI*)  ERROR_SMM_UNINITIALIZED              = (RASBASE+146);
(*RASAPI*)  ERROR_NO_MAC_FOR_PORT                = (RASBASE+147);
(*RASAPI*)  ERROR_SMM_TIMEOUT                    = (RASBASE+148);
(*RASAPI*)  ERROR_BAD_PHONE_NUMBER               = (RASBASE+149);
(*RASAPI*)  ERROR_WRONG_MODULE                   = (RASBASE+150);
(*RASAPI*)
(*RASAPI*)  RASBASEEND                           = (RASBASE+150);
(*RASAPI*)
(*RASAPI*){* Copyright (c) 1995, Microsoft Corporation, all rights reserved
(*RASAPI*)**
(*RASAPI*)** rnaph.h  (to be merged with ras.h)
(*RASAPI*)**
(*RASAPI*)** Remote Access external API
(*RASAPI*)** Public header for external API clients
(*RASAPI*)**}
(*RASAPI*)
(*RASAPI*){*
(*RASAPI*)   Original conversion by Gideon le Grange <legrang@adept.co.za>
(*RASAPI*)   Merged with ras.pas by Davide Moretti <dmoretti@iper.net>
(*RASAPI*)*}
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*)  RAS_MaxAreaCode   =  10;
(*RASAPI*)  RAS_MaxPadType    =  32;
(*RASAPI*)  RAS_MaxX25Address = 200;
(*RASAPI*)  RAS_MaxFacilities = 200;
(*RASAPI*)  RAS_MaxUserData   = 200;
(*RASAPI*)
(*RASAPI*)
(*RASAPI*)type
(*RASAPI*)(* Describes a RAS IP Address *)
(*RASAPI*)  LPRasIPAddr = ^TRasIPAddr;
(*RASAPI*)  TRasIPAddr = record
(*RASAPI*)    A, B, C, D: Byte;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)(* Describes a RAS phonebook entry *)
(*RASAPI*)  LPRasEntryA = ^TRasEntryA;
(*RASAPI*)  TRasEntryA  = record
(*RASAPI*)    dwSize,
(*RASAPI*)    dwfOptions,
(*RASAPI*)    dwCountryID,
(*RASAPI*)    dwCountryCode          : Longint;
(*RASAPI*)    szAreaCode             : array[0.. RAS_MaxAreaCode] of AnsiChar;
(*RASAPI*)    szLocalPhoneNumber     : array[0..RAS_MaxPhoneNumber] of AnsiChar;
(*RASAPI*)    dwAlternatesOffset     : Longint;
(*RASAPI*)    ipaddr,
(*RASAPI*)    ipaddrDns,
(*RASAPI*)    ipaddrDnsAlt,
(*RASAPI*)    ipaddrWins,
(*RASAPI*)    ipaddrWinsAlt          : TRasIPAddr;
(*RASAPI*)    dwFrameSize,
(*RASAPI*)    dwfNetProtocols,
(*RASAPI*)    dwFramingProtocol      : Longint;
(*RASAPI*)    szScript               : Array[0..MAX_PATH - 1] of AnsiChar;
(*RASAPI*)    szAutodialDll          : Array [0..MAX_PATH - 1] of AnsiChar;
(*RASAPI*)    szAutodialFunc         : Array [0..MAX_PATH - 1] of AnsiChar;
(*RASAPI*)    szDeviceType           : Array [0..RAS_MaxDeviceType] of AnsiChar;
(*RASAPI*)    szDeviceName           : Array [0..RAS_MaxDeviceName] of AnsiChar;
(*RASAPI*)    szX25PadType           : Array [0..RAS_MaxPadType] of AnsiChar;
(*RASAPI*)    szX25Address           : Array [0..RAS_MaxX25Address] of AnsiChar;
(*RASAPI*)    szX25Facilities        : Array [0..RAS_MaxFacilities] of AnsiChar;
(*RASAPI*)    szX25UserData          : Array [0..RAS_MaxUserData] of AnsiChar;
(*RASAPI*)    dwChannels,
(*RASAPI*)    dwReserved1,
(*RASAPI*)    dwReserved2            : Longint;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasEntryW = ^TRasEntryW;
(*RASAPI*)  TRasEntryW  = record
(*RASAPI*)    dwSize,
(*RASAPI*)    dwfOptions,
(*RASAPI*)    dwCountryID,
(*RASAPI*)    dwCountryCode          : Longint;
(*RASAPI*)    szAreaCode             : array[0.. RAS_MaxAreaCode] of WideChar;
(*RASAPI*)    szLocalPhoneNumber     : array[0..RAS_MaxPhoneNumber] of WideChar;
(*RASAPI*)    dwAlternatesOffset     : Longint;
(*RASAPI*)    ipaddr,
(*RASAPI*)    ipaddrDns,
(*RASAPI*)    ipaddrDnsAlt,
(*RASAPI*)    ipaddrWins,
(*RASAPI*)    ipaddrWinsAlt          : TRasIPAddr;
(*RASAPI*)    dwFrameSize,
(*RASAPI*)    dwfNetProtocols,
(*RASAPI*)    dwFramingProtocol      : Longint;
(*RASAPI*)    szScript               : Array[0..MAX_PATH - 1] of WideChar;
(*RASAPI*)    szAutodialDll          : Array [0..MAX_PATH - 1] of WideChar;
(*RASAPI*)    szAutodialFunc         : Array [0..MAX_PATH - 1] of WideChar;
(*RASAPI*)    szDeviceType           : Array [0..RAS_MaxDeviceType] of WideChar;
(*RASAPI*)    szDeviceName           : Array [0..RAS_MaxDeviceName] of WideChar;
(*RASAPI*)    szX25PadType           : Array [0..RAS_MaxPadType] of WideChar;
(*RASAPI*)    szX25Address           : Array [0..RAS_MaxX25Address] of WideChar;
(*RASAPI*)    szX25Facilities        : Array [0..RAS_MaxFacilities] of WideChar;
(*RASAPI*)    szX25UserData          : Array [0..RAS_MaxUserData] of WideChar;
(*RASAPI*)    dwChannels,
(*RASAPI*)    dwReserved1,
(*RASAPI*)    dwReserved2            : Longint;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasEntry = ^TRasEntry;
(*RASAPI*)  TRasEntry  = TRasEntryA;
(*RASAPI*)
(*RASAPI*)(* Describes Country Information *)
(*RASAPI*)  LPRasCtryInfo = ^TRasCtryInfo;
(*RASAPI*)  TRasCtryInfo  = record
(*RASAPI*)    dwSize,
(*RASAPI*)    dwCountryID,
(*RASAPI*)    dwNextCountryID,
(*RASAPI*)    dwCountryCode,
(*RASAPI*)    dwCountryNameOffset : Longint;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)(* Describes RAS Device Information *)
(*RASAPI*)  LPRasDevInfoA = ^TRasDevInfoA;
(*RASAPI*)  TRasDevInfoA  = record
(*RASAPI*)    dwSize       : Longint;
(*RASAPI*)    szDeviceType : Array[0..RAS_MaxDeviceType] of AnsiChar;
(*RASAPI*)    szDeviceName : Array[0..RAS_MaxDeviceName] of AnsiChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasDevInfoW = ^TRasDevInfoW;
(*RASAPI*)  TRasDevInfoW  = record
(*RASAPI*)    dwSize       : Longint;
(*RASAPI*)    szDeviceType : Array[0..RAS_MaxDeviceType] of WideChar;
(*RASAPI*)    szDeviceName : Array[0..RAS_MaxDeviceName] of WideChar;
(*RASAPI*)  end;
(*RASAPI*)
(*RASAPI*)  LPRasDevInfo = ^TRasDevInfo;
(*RASAPI*)  TRasDevInfo  = TRasDevInfoA;
(*RASAPI*)
(*RASAPI*)const
(*RASAPI*)(* TRasEntry 'dwfOptions' bit flags. *)
(*RASAPI*)  RASEO_UseCountryAndAreaCodes = $00000001;
(*RASAPI*)  RASEO_SpecificIpAddr         = $00000002;
(*RASAPI*)  RASEO_SpecificNameServers    = $00000004;
(*RASAPI*)  RASEO_IpHeaderCompression    = $00000008;
(*RASAPI*)  RASEO_RemoteDefaultGateway   = $00000010;
(*RASAPI*)  RASEO_DisableLcpExtensions   = $00000020;
(*RASAPI*)  RASEO_TerminalBeforeDial     = $00000040;
(*RASAPI*)  RASEO_TerminalAfterDial      = $00000080;
(*RASAPI*)  RASEO_ModemLights            = $00000100;
(*RASAPI*)  RASEO_SwCompression          = $00000200;
(*RASAPI*)  RASEO_RequireEncryptedPw     = $00000400;
(*RASAPI*)  RASEO_RequireMsEncryptedPw   = $00000800;
(*RASAPI*)  RASEO_RequireDataEncryption  = $00001000;
(*RASAPI*)  RASEO_NetworkLogon           = $00002000;
(*RASAPI*)  RASEO_UseLogonCredentials    = $00004000;
(*RASAPI*)  RASEO_PromoteAlternates      = $00008000;
(*RASAPI*)
(*RASAPI*)(* TRasEntry 'dwfNetProtocols' bit flags. (session negotiated protocols) *)
(*RASAPI*)  RASNP_Netbeui = $00000001;  // Negotiate NetBEUI
(*RASAPI*)  RASNP_Ipx     = $00000002;  // Negotiate IPX
(*RASAPI*)  RASNP_Ip      = $00000004;  // Negotiate TCP/IP
(*RASAPI*)
(*RASAPI*)(* TRasEntry 'dwFramingProtocols' (framing protocols used by the server) *)
(*RASAPI*)  RASFP_Ppp  = $00000001;  // Point-to-Point Protocol (PPP)
(*RASAPI*)  RASFP_Slip = $00000002;  // Serial Line Internet Protocol (SLIP)
(*RASAPI*)  RASFP_Ras  = $00000004;  // Microsoft proprietary protocol
(*RASAPI*)
(*RASAPI*)(* TRasEntry 'szDeviceType' strings *)
(*RASAPI*)  RASDT_Modem = 'modem';     // Modem
(*RASAPI*)  RASDT_Isdn  = 'isdn';      // ISDN
(*RASAPI*)  RASDT_X25   = 'x25';      // X.25
(*RASAPI*)
{
(*RASAPI*)(* RAS functions found in RNAPH.DLL *)
(*RASAPI*)function RasValidateEntryNameA(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;
(*RASAPI*)function RasValidateEntryNameW(lpszPhonebook,szEntry: PWideChar): Longint; stdcall;
//(*RASAPI*)function RasValidateEntryName(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasRenameEntryA(lpszPhonebook,szEntryOld,szEntryNew: PAnsiChar): Longint; stdcall;
(*RASAPI*)function RasRenameEntryW(lpszPhonebook,szEntryOld,szEntryNew: PWideChar): Longint; stdcall;
//(*RASAPI*)function RasRenameEntry(lpszPhonebook,szEntryOld,szEntryNew: PAnsiChar): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasDeleteEntryA(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;
(*RASAPI*)function RasDeleteEntryW(lpszPhonebook,szEntry: PWideChar): Longint; stdcall;
//(*RASAPI*)function RasDeleteEntry(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasGetEntryPropertiesA(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
(*RASAPI*)                                var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
(*RASAPI*)                                var lpdwDeviceInfoSize: Longint): Longint; stdcall;
(*RASAPI*)function RasGetEntryPropertiesW(lpszPhonebook, szEntry: PWideChar; lpbEntry: Pointer;
(*RASAPI*)                                var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
(*RASAPI*)                                var lpdwDeviceInfoSize: Longint): Longint; stdcall;
//(*RASAPI*)function RasGetEntryProperties(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
//(*RASAPI*)                                var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
//(*RASAPI*)                                var lpdwDeviceInfoSize: Longint): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasSetEntryPropertiesA(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
(*RASAPI*)                                dwEntrySize: Longint; lpbDeviceInfo: Pointer;
(*RASAPI*)                                dwDeviceInfoSize: Longint): Longint; stdcall;
(*RASAPI*)function RasSetEntryPropertiesW(lpszPhonebook, szEntry: PWideChar; lpbEntry: Pointer;
(*RASAPI*)                                dwEntrySize: Longint; lpbDeviceInfo: Pointer;
(*RASAPI*)                                dwDeviceInfoSize: Longint): Longint; stdcall;
//(*RASAPI*)function RasSetEntryProperties(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
//(*RASAPI*)                               dwEntrySize: Longint; lpbDeviceInfo: Pointer;
//(*RASAPI*)                               dwDeviceInfoSize: Longint): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasGetCountryInfoA(var lpCtryInfo: TRasCtryInfo;var lpdwSize: Longint): Longint; stdcall;
(*RASAPI*)function RasGetCountryInfoW(var lpCtryInfo: TRasCtryInfo;var lpdwSize: Longint): Longint; stdcall;
//(*RASAPI*)function RasGetCountryInfo(var lpCtryInfo: TRasCtryInfo;var lpdwSize: Longint): Longint; stdcall;
(*RASAPI*)
(*RASAPI*)function RasEnumDevicesA(lpBuff: LpRasDevInfoA; var lpcbSize: Longint;
(*RASAPI*)                         var lpcDevices: Longint): Longint; stdcall;
(*RASAPI*)function RasEnumDevicesW(lpBuff: LpRasDevInfoW; var lpcbSize: Longint;
(*RASAPI*)                         var lpcDevices: Longint): Longint; stdcall;
//(*RASAPI*)function RasEnumDevices(lpBuff: LpRasDevInfo; var lpcbSize: Longint;
//(*RASAPI*)                         var lpcDevices: Longint): Longint; stdcall;
(*RASAPI*)
}
{******************************************************}
{******************************************************}
{******************************************************}
{******************************************************}
{******************************************************}
{******************************************************}

const MaxEntries = 100; //It's enough

var
  LIBHandle: THandle;
   _RasDial: function(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PAnsiChar;
                      var params: TRasDialParams; dwNotifierType: Longint;
                      lpNotifier: Pointer; var rasconn: THRasConn): Longint; stdcall;
   _RasEnumConnections: function(RasConnArray: LPRasConn; var lpcb: Longint;
                      var lpcConnections: Longint): Longint; stdcall;
   _RasEnumEntries: function(reserved: PAnsiChar; lpszPhoneBook: PAnsiChar;
                      entrynamesArray: LPRasEntryName; var lpcb: Longint;
                      var lpcEntries: Longint): Longint; stdcall;
   _RasGetEntryDialParams: function(lpszPhoneBook: PAnsiChar; var lpDialParams: TRasDialParams;
                      var lpfPassword: LongBool): Longint; stdcall;
   _RasGetErrorString: function(errorValue: Integer; erroString: PAnsiChar;
                      cBufSize: Longint): Longint; stdcall;
   _RasHangUpA: function(hConn: THRasConn): Longint; stdcall;
   _RasGetConnectStatusA: function(hConn: THRasConn; var lpStatus: TRasConnStatusA): Longint; stdcall;


procedure InitRasFunctions;
procedure DeInitRasFunctions;

implementation

procedure InitRasFunctions;
begin
  LibHandle := LoadLibrary('rasapi32.dll');
  if LibHandle <> 0 then begin
     _RasDial := GetProcAddress(LibHandle, 'RasDialA');
     _RasEnumConnections := GetProcAddress(LibHandle, 'RasEnumConnectionsA');
     _RasEnumEntries := GetProcAddress(LibHandle, 'RasEnumEntriesA');
     _RasGetEntryDialParams := GetProcAddress(LibHandle, 'RasGetEntryDialParamsA');
     _RasGetErrorString := GetProcAddress(LibHandle, 'RasGetErrorStringA');
     _RasHangUpA := GetProcAddress(LibHandle, 'RasHangUpA');
     _RasGetConnectStatusA := GetProcAddress(LibHandle, 'RasGetConnectStatusA');
  end;
end;

procedure DeInitRasFunctions;
begin
  FreeLibrary(LibHandle);
  LIBHandle := 0;
  _RasDial := nil;
  _RasEnumConnections := nil;
  _RasEnumEntries := nil;
  _RasGetEntryDialParams := nil;
  _RasGetErrorString := nil;
  _RasHangUpA := nil;
  _RasGetConnectStatusA := nil;
end;

{
function RasCreatePhonebookEntryA; external 'rasapi32.dll' name 'RasCreatePhonebookEntryA';
function RasCreatePhonebookEntryW; external 'rasapi32.dll' name 'RasCreatePhonebookEntryW';
function RasCreatePhonebookEntry;  external 'rasapi32.dll' name 'RasCreatePhonebookEntryA';
function RasDialA;                 external 'rasapi32.dll' name 'RasDialA';
function RasDialW;                 external 'rasapi32.dll' name 'RasDialW';
}
function RasDial(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PAnsiChar;
                 var params: TRasDialParams; dwNotifierType: Longint;
                 lpNotifier: Pointer; var rasconn: THRasConn): Longint;
begin
   if Assigned(_RasDial) then begin
      result := _RasDial(lpRasDialExt, lpszPhoneBook, params, dwNotifierType, lpNotifier, rasconn);
   end else begin
      result := -1;
   end;
end;

{
function RasEditPhonebookEntryA;   external 'rasapi32.dll' name 'RasEditPhonebookEntryA';
function RasEditPhonebookEntryW;   external 'rasapi32.dll' name 'RasEditPhonebookEntryW';
function RasEditPhonebookEntry;    external 'rasapi32.dll' name 'RasEditPhonebookEntryA';
function RasEnumConnectionsA;      external 'rasapi32.dll' name 'RasEnumConnectionsA';
function RasEnumConnectionsW;      external 'rasapi32.dll' name 'RasEnumConnectionsW';
}
function RasEnumConnections(RasConnArray: LPRasConn; var lpcb: Longint;
                            var lpcConnections: Longint): Longint; stdcall;
begin
   if Assigned(_RasEnumConnections) then begin
      result := _RasEnumConnections(RasConnArray, lpcb, lpcConnections);
   end else begin
      result := -1;
   end;
end;
{
function RasEnumEntriesA;          external 'rasapi32.dll' name 'RasEnumEntriesA';
function RasEnumEntriesW;          external 'rasapi32.dll' name 'RasEnumEntriesW';
}
function RasEnumEntries(reserved: PAnsiChar; lpszPhoneBook: PAnsiChar;
                        entrynamesArray: LPRasEntryName; var lpcb: Longint;
                        var lpcEntries: Longint): Longint; stdcall;
begin
   if Assigned(_RasEnumEntries) then begin
      result := _RasEnumEntries(reserved, lpszPhoneBook, entrynamesArray, lpcb, lpcEntries);
   end else begin
      result := -1;
   end;
end;
{
function RasGetConnectStatusA;     external 'rasapi32.dll' name 'RasGetConnectStatusA';
function RasGetConnectStatusW;     external 'rasapi32.dll' name 'RasGetConnectStatusW';
function RasGetConnectStatus;      external 'rasapi32.dll' name 'RasGetConnectStatusA';
function RasGetEntryDialParamsA;   external 'rasapi32.dll' name 'RasGetEntryDialParamsA';
function RasGetEntryDialParamsW;   external 'rasapi32.dll' name 'RasGetEntryDialParamsW';
}
function RasGetEntryDialParams(lpszPhoneBook: PAnsiChar; var lpDialParams: TRasDialParams;
                               var lpfPassword: LongBool): Longint; stdcall;
begin
   if Assigned(_RasGetEntryDialParams) then begin
      result := _RasGetEntryDialParams(lpszPhoneBook, lpDialParams, lpfPassword);
   end else begin
      result := -1;
   end;
end;
{
function RasGetErrorStringA;       external 'rasapi32.dll' name 'RasGetErrorStringA';
function RasGetErrorStringW;       external 'rasapi32.dll' name 'RasGetErrorStringW';
}
function RasGetErrorString(errorValue: Integer; errorString: PAnsiChar; cBufSize: Longint): Longint; stdcall;
begin
   if Assigned(_RasGetErrorString) then begin
      result := _RasGetErrorString(errorValue, errorString, cBufSize);
   end else begin
      result := -1;
   end;
end;
{
function RasGetProjectionInfoA;    external 'rasapi32.dll' name 'RasGetProjectionInfoA';
function RasGetProjectionInfoW;    external 'rasapi32.dll' name 'RasGetProjectionInfoW';
function RasGetProjectionInfo;     external 'rasapi32.dll' name 'RasGetProjectionInfoA';
}
function RasHangUpA(hConn: THRasConn): Longint; stdcall;
begin
  if Assigned(_RasHangUpA) then begin
     result := _RasHangUpA(hConn);
  end else begin
     result := -1;
  end;
end;

function RasGetConnectStatusA(hConn: THRasConn; var lpStatus: TRasConnStatusA): Longint; stdcall;
begin
  if Assigned(_RasGetConnectStatusA) then begin
     result := _RasGetConnectStatusA(hConn, lpStatus);
  end else begin
     result := -1;
  end;
end;

{
function RasHangUpW;               external 'rasapi32.dll' name 'RasHangUpW';
function RasHangUp;                external 'rasapi32.dll' name 'RasHangUpA';
function RasSetEntryDialParamsA;   external 'rasapi32.dll' name 'RasSetEntryDialParamsA';
function RasSetEntryDialParamsW;   external 'rasapi32.dll' name 'RasSetEntryDialParamsW';
function RasSetEntryDialParams;    external 'rasapi32.dll' name 'RasSetEntryDialParamsA';
function RasValidateEntryNameA;  external 'rasapi32.dll' name 'RasValidateEntryNameA';
function RasValidateEntryNameW;  external 'rasapi32.dll' name 'RasValidateEntryNameW';
function RasRenameEntryA;        external 'rasapi32.dll' name 'RasRenameEntryA';
function RasRenameEntryW;        external 'rasapi32.dll' name 'RasRenameEntryW';
function RasDeleteEntryA;        external 'rasapi32.dll' name 'RasDeleteEntryA';
function RasDeleteEntryW;        external 'rasapi32.dll' name 'RasDeleteEntryW';
function RasGetEntryPropertiesA; external 'rasapi32.dll' name 'RasGetEntryPropertiesA';
function RasGetEntryPropertiesW; external 'rasapi32.dll' name 'RasGetEntryPropertiesW';
function RasSetEntryPropertiesA; external 'rasapi32.dll' name 'RasSetEntryPropertiesA';
function RasSetEntryPropertiesW; external 'rasapi32.dll' name 'RasSetEntryPropertiesW';
function RasGetCountryInfoA;     external 'rasapi32.dll' name 'RasGetCountryInfoA';
function RasGetCountryInfoW;     external 'rasapi32.dll' name 'RasGetCountryInfoW';
function RasEnumDevicesA;        external 'rasapi32.dll' name 'RasEnumDevicesA';
function RasEnumDevicesW;        external 'rasapi32.dll' name 'RasEnumDevicesW';
function RasGetConnectionStatistics; external 'RasApi32.DLL' name 'RasGetConnectionStatistics';
}

end.
