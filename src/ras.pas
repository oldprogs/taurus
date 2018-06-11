{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


Unit:         Remote Access Service (RAS)
Creation:     Feb 18, 1997. Translated from MS-Visual C 4.2 header files
EMail:        francois.piette@pophost.eunet.be    francois.piette@rtfm.be
              http://www.rtfm.be/fpiette
Legal issues: Copyright (C) 1997, 1998 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@pophost.eunet.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.
Updates:
Sep 25, 1998  V1.10  Added RasGetIPAddress and RasGetProjectionInfoA. Thanks to
              Jan Tomasek <xtomasej@fel.cvut.cz> for his help.
Jan 20, 2002 V1.11 Added RasGerEntryProperties[A|W] and RAS specific error codes
              by Denis Voituk <deniska666@mail.ru>

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit Ras;

interface

uses
    Windows, SysUtils;

{$DEFINE WINVER400}
const
    RasUnitVersion        = 110;
//    CopyRight    : String = ' RasUnit (c) 97-98 F. Piette V1.10 ';
    rasapi32              = 'rasapi32.dll';

    UNLEN                 = 256;    // Maximum user name length
    PWLEN                 = 256;    // Maximum password length
    CNLEN                 = 15;     // Computer name length
    DNLEN                 = CNLEN;  // Maximum domain name length

    RAS_MaxDeviceType     = 16;
    RAS_MaxPhoneNumber    = 128;
    RAS_MaxIpAddress      = 15;
    RAS_MaxIpxAddress     = 21;

{$IFDEF WINVER400}
    RAS_MaxEntryName      = 256;
    RAS_MaxDeviceName     = 128;
    RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
{$ELSE}
    RAS_MaxEntryName      = 20;
    RAS_MaxDeviceName     = 32;
    RAS_MaxCallbackNumber = 48;
{$ENDIF}

    RAS_MaxAreaCode       = 10;
    RAS_MaxPadType        = 32;
    RAS_MaxX25Address     = 200;
    RAS_MaxFacilities     = 200;
    RAS_MaxUserData       = 200;

    RASCS_OpenPort            = 0;
    RASCS_PortOpened          = 1;
    RASCS_ConnectDevice       = 2;
    RASCS_DeviceConnected     = 3;
    RASCS_AllDevicesConnected = 4;
    RASCS_Authenticate        = 5;
    RASCS_AuthNotify          = 6;
    RASCS_AuthRetry           = 7;
    RASCS_AuthCallback        = 8;
    RASCS_AuthChangePassword  = 9;
    RASCS_AuthProject         = 10;
    RASCS_AuthLinkSpeed       = 11;
    RASCS_AuthAck             = 12;
    RASCS_ReAuthenticate      = 13;
    RASCS_Authenticated       = 14;
    RASCS_PrepareForCallback  = 15;
    RASCS_WaitForModemReset   = 16;
    RASCS_WaitForCallback     = 17;
    RASCS_Projected           = 18;

{$IFDEF WINVER400}
    RASCS_StartAuthentication = 19;
    RASCS_CallbackComplete    = 20;
    RASCS_LogonNetwork        = 21;
{$ENDIF}
    RASCS_SubEntryConnected   = 22;
    RASCS_SubEntryDisconnected= 23;

    RASCS_PAUSED              = $1000;
    RASCS_Interactive         = RASCS_PAUSED;
    RASCS_RetryAuthentication = (RASCS_PAUSED + 1);
    RASCS_CallbackSetByCaller = (RASCS_PAUSED + 2);
    RASCS_PasswordExpired     = (RASCS_PAUSED + 3);

    RASCS_DONE                = $2000;
    RASCS_Connected           = RASCS_DONE;
    RASCS_Disconnected        = (RASCS_DONE + 1);

    // If using RasDial message notifications, get the notification message code
    // by passing this string to the RegisterWindowMessageA() API.
    // WM_RASDIALEVENT is used only if a unique message cannot be registered.
    RASDIALEVENT    = 'RasDialEvent';
    WM_RASDIALEVENT = $CCCD;

    // TRASPROJECTION
    RASP_Amb        = $10000;
    RASP_PppNbf     = $0803F;
    RASP_PppIpx     = $0802B;
    RASP_PppIp      = $08021;
    RASP_Slip       = $20000;

type
    THRASCONN     = THandle;
    PHRASCONN     = ^THRASCONN;
    TRASCONNSTATE = DWORD;
    PDWORD        = ^DWORD;
    PBOOL         = ^BOOL;

    TRASDIALPARAMS = packed record
        dwSize           : DWORD;
        szEntryName      : array [0..RAS_MaxEntryName] of Char;
        szPhoneNumber    : array [0..RAS_MaxPhoneNumber] of Char;
        szCallbackNumber : array [0..RAS_MaxCallbackNumber] of Char;
        szUserName       : array [0..UNLEN] of Char;
        szPassword       : array [0..PWLEN] of Char;
        szDomain         : array [0..DNLEN] of Char;
{$IFDEF WINVER401}
        dwSubEntry       : DWORD;
        dwCallbackId     : DWORD;
{$ENDIF}
        szPadding        : array [0..2] of Char;
    end;
    PRASDIALPARAMS = ^TRASDIALPARAMS;

    TRASDIALEXTENSIONS = packed record
        dwSize     : DWORD;
        dwfOptions : DWORD;
        hwndParent : HWND;
        reserved   : DWORD;
    end;
    PRASDIALEXTENSIONS = ^TRASDIALEXTENSIONS;

    TRASCONNSTATUS = packed record
        dwSize       : DWORD;
        RasConnState : TRASCONNSTATE;
        dwError      : DWORD;
        szDeviceType : array [0..RAS_MaxDeviceType] of char;
        szDeviceName : array [0..RAS_MaxDeviceName] of char;
        szPadding    : array [0..1] of Char;
    end;
    PRASCONNSTATUS = ^TRASCONNSTATUS;

    TRASCONN = packed record
        dwSize       : DWORD;
        hRasConn     : THRASCONN;
        szEntryName  : array [0..RAS_MaxEntryName] of char;
{$IFDEF WINVER400}
        szDeviceType : array [0..RAS_MaxDeviceType] of char;
        szDeviceName : array [0..RAS_MaxDeviceName] of char;
{$ENDIF}
        szPadding    : array [0..0] of Char;
    end;
    PRASCONN = ^TRASCONN;

    TRASENTRYNAME = packed record
        dwSize       : DWORD;
        szEntryName  : array [0..RAS_MaxEntryName] of char;
        szPadding    : array [0..2] of Char;
    end;
    PRASENTRYNAME = ^TRASENTRYNAME;

    TRASENTRYDLG = packed record
        dwSize       : DWORD;
        hWndOwner    : HWND;
        dwFlags      : DWORD;
        xDlg         : LongInt;
        yDlg         : LongInt;
        szEntry      : array [0..RAS_MaxEntryName] of char;
        dwError      : DWORD;
        Reserved     : DWORD;
        Reserved2    : DWORD;
        szPadding    : array [0..2] of Char;
    end;
    PRASENTRYDLG = ^TRASENTRYDLG;

    TRASPROJECTION = integer;
    TRASPPPIP = record
        dwSize  : DWORD;
        dwError : DWORD;
        szIpAddress : array [0..RAS_MaxIpAddress] of char;
    end;


(* A RAS IP Address.
*)
  LPRasIPAddr = ^TRasIPAddr;
  TRasIPAddr = record
    a, b, c, d: Byte;
  end;


(* A RAS phonebook entry.
*)
  LPRasEntryA = ^TRasEntryA;
  TRasEntryA = record
    dwSize,
    dwfOptions,
    //
    // Location/phone number.
    //
    dwCountryID,
    dwCountryCode: Longint;
    szAreaCode: array[0.. RAS_MaxAreaCode] of AnsiChar;
    szLocalPhoneNumber: array[0..RAS_MaxPhoneNumber] of AnsiChar;
    dwAlternatesOffset: Longint;
    //
    // PPP/Ip
    //
    ipaddr,
    ipaddrDns,
    ipaddrDnsAlt,
    ipaddrWins,
    ipaddrWinsAlt: TRasIPAddr;
    //
    // Framing
    //
    dwFrameSize,
    dwfNetProtocols,
    dwFramingProtocol: Longint;
    //
    // Scripting
    //
    szScript: Array[0..MAX_PATH - 1] of AnsiChar;
    //
    // AutoDial
    //
    szAutodialDll: Array [0..MAX_PATH - 1] of AnsiChar;
    szAutodialFunc: Array [0..MAX_PATH - 1] of AnsiChar;
    //
    // Device
    //
    szDeviceType: Array [0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: Array [0..RAS_MaxDeviceName] of AnsiChar;
    //
    // X.25
    //
    szX25PadType: Array [0..RAS_MaxPadType] of AnsiChar;
    szX25Address: Array [0..RAS_MaxX25Address] of AnsiChar;
    szX25Facilities: Array [0..RAS_MaxFacilities] of AnsiChar;
    szX25UserData: Array [0..RAS_MaxUserData] of AnsiChar;
    dwChannels: Longint;
    //
    // Reserved
    //
    dwReserved1,
    dwReserved2: Longint;
{.$IFDEF WINVER401}
    //
    // Multilink
    //
    dwSubEntries,
    dwDialMode,
    dwDialExtraPercent,
    dwDialExtraSampleSeconds,
    dwHangUpExtraPercent,
    dwHangUpExtraSampleSeconds: Longint;
    //
    // Idle timeout
    //
    dwIdleDisconnectSeconds: Longint;
{.$ENDIF}
{$IFDEF WINVER500}
    dwType,               // entry type
    dwEncryptionType,     // type of encryption to use
    dwCustomAuthKey: LongInt;      // authentication key for EAP
    guidId: GUID;               // guid that represents
                                // the phone-book entry
    szCustomDialDll:Array[0..MAX_PATH - 1] of AnsiChar;    // DLL for custom dialing
    dwVpnStrategy: LongInt;         // specifies type of VPN protocol
{$endif}
{$ifdef WINVER501}
    dwfOptions2,
    dwfOptions3: LongInt;
{$endif}
  end;

(*
  LPRasEntryW = ^TRasEntryW;
  TRasEntryW = record
    dwSize,
    dwfOptions,
    //
    // Location/phone number.
    //
    dwCountryID,
    dwCountryCode: Longint;
    szAreaCode: array[0.. RAS_MaxAreaCode] of WideChar;
    szLocalPhoneNumber: array[0..RAS_MaxPhoneNumber] of WideChar;
    dwAlternatesOffset: Longint;
    //
    // PPP/Ip
    //
    ipaddr,
    ipaddrDns,
    ipaddrDnsAlt,
    ipaddrWins,
    ipaddrWinsAlt: TRasIPAddr;
    //
    // Framing
    //
    dwFrameSize,
    dwfNetProtocols,
    dwFramingProtocol: Longint;
    //
    // Scripting
    //
    szScript: Array[0..MAX_PATH - 1] of WideChar;
    //
    // AutoDial
    //
    szAutodialDll: Array [0..MAX_PATH - 1] of WideChar;
    szAutodialFunc: Array [0..MAX_PATH - 1] of WideChar;
    //
    // Device
    //
    szDeviceType: Array [0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: Array [0..RAS_MaxDeviceName] of WideChar;
    //
    // X.25
    //
    szX25PadType: Array [0..RAS_MaxPadType] of WideChar;
    szX25Address: Array [0..RAS_MaxX25Address] of WideChar;
    szX25Facilities: Array [0..RAS_MaxFacilities] of WideChar;
    szX25UserData: Array [0..RAS_MaxUserData] of WideChar;
    dwChannels,
    //
    // Reserved
    //
    dwReserved1,
    dwReserved2: Longint;
{$IFDEF WINVER41}
    //
    // Multilink
    //
    dwSubEntries,
    dwDialMode,
    dwDialExtraPercent,
    dwDialExtraSampleSeconds,
    dwHangUpExtraPercent,
    dwHangUpExtraSampleSeconds: Longint;
    //
    // Idle timeout
    //
    dwIdleDisconnectSeconds: Longint;
{$ENDIF}
  end;
*)
  LPRasEntry = ^TRasEntry;
  TRasEntry = TRasEntryA;



function RasGetEntryPropertiesA(lpszPhonebook,
                                szEntry                : PAnsiChar;
                                lpbEntry               : Pointer;
                                var lpdwEntrySize      : Longint;
                                lpbDeviceInfo          : Pointer;
                                var lpdwDeviceInfoSize : Longint
                               ): Longint; stdcall;
{function RasGetEntryPropertiesW(
    lpszPhonebook,
    szEntry: PWideChar;
          lpbEntry: Pointer;
    var lpdwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    var lpdwDeviceInfoSize: Longint
    ): Longint; stdcall;}
function RasGetEntryProperties(lpszPhonebook,
                               szEntry                : PAnsiChar;
                               lpbEntry               : Pointer;
                               var lpdwEntrySize      : Longint;
                               lpbDeviceInfo          : Pointer;
                               var lpdwDeviceInfoSize : Longint
                              ): Longint; stdcall;


function RasDialA(RasDialExtensions: PRASDIALEXTENSIONS;
                  PhoneBook     : PChar;
                  RasDialParams : PRASDIALPARAMS;
                  NotifierType  : DWORD;
                  Notifier      : Pointer;
                  RasConn       : PHRASCONN
                 ): DWORD; stdcall;
function RasGetErrorStringA(
                  uErrorValue   : DWORD; // error to get string for
                  szErrorString : PChar; // buffer to hold error string
                  cBufSize      : DWORD  // size, in characters, of buffer
                 ): DWORD; stdcall;
function RasHangupA(RasConn: THRASCONN): DWORD; stdcall;
function RasConnectionStateToString(nState : Integer) : String;
function RasGetConnectStatusA(
                  hRasConn: THRASCONN;   // handle to RAS connection of interest
                  lpRasConnStatus : PRASCONNSTATUS // buffer to receive status data
                 ): DWORD; stdcall;
function RasEnumConnectionsA(
                  pRasConn : PRASCONN;   // buffer to receive connections data
                  pCB      : PDWORD;     // size in bytes of buffer
                  pcConnections : PDWORD // number of connections written to buffer
                 ) : DWORD; stdcall
function RasEnumEntriesA(
                  Reserved : Pointer;    // reserved, must be NIL
                  szPhonebook : PChar;   // full path and filename of phonebook file
                  lpRasEntryName : PRASENTRYNAME; // buffer to receive entries
                  lpcb : PDWORD;         // size in bytes of buffer
                  lpcEntries : PDWORD    // number of entries written to buffer
                 ) : DWORD; stdcall;
function RasGetEntryDialParamsA(
                  lpszPhonebook : PChar; // pointer to the full path and filename of the phonebook file
                  lprasdialparams : PRASDIALPARAMS;     // pointer to a structure that receives the connection parameters
                  lpfPassword : PBOOL    // indicates whether the user's password was retrieved
                 ) : DWORD; stdcall;
function RasEditPhonebookEntryA(
                   hWndParent : HWND;     // handle to the parent window of the dialog box
                   lpszPhonebook : PChar; // pointer to the full path and filename of the phonebook file
                   lpszEntryName : PChar  // pointer to the phonebook entry name
                 ) : DWORD; stdcall;
//function RasEntryDlgA(
//                   lpszPhonebook : PChar; // pointer to the full path and filename of the phone-book file
//                   lpszEntry : PChar;     // pointer to the name of the phone-book entry to edit, copy, or create
//                   lpInfo : PRASENTRYDLG  // pointer to a structure that contains additional parameters
//                 ) : DWORD; stdcall;
function RasCreatePhonebookEntryA(
                     hWndParent : HWND;    // handle to the parent window of the dialog box
                     lpszPhonebook : PChar // pointer to the full path and filename of the phonebook file
                   ) : DWORD; stdcall;

function RasGetProjectionInfoA(
                    hRasConn      : THRASCONN;      // handle that specifies remote access connection of interest
                    RasProjection : TRASPROJECTION; // specifies type of projection information to obtain
                    lpProjection  : Pointer;        // points to buffer that receives projection information
                    lpcb          : PDWORD          // points to variable that specifies buffer size
                   ) : DWORD; stdcall;
function RasGetIPAddress: string;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RasConnectionStateToString(nState : Integer) : String;
begin
    case nState of
    RASCS_OpenPort:             Result := 'Opening Port';
    RASCS_PortOpened:           Result := 'Port Opened';
    RASCS_ConnectDevice:        Result := 'Connecting Device';
    RASCS_DeviceConnected:      Result := 'Device Connected';
    RASCS_AllDevicesConnected:  Result := 'All Devices Connected';
    RASCS_Authenticate:         Result := 'Starting Authentication';
    RASCS_AuthNotify:           Result := 'Authentication Notify';
    RASCS_AuthRetry:            Result := 'Authentication Retry';
    RASCS_AuthCallback:         Result := 'Callback Requested';
    RASCS_AuthChangePassword:   Result := 'Change Password Requested';
    RASCS_AuthProject:          Result := 'Projection Phase Started';
    RASCS_AuthLinkSpeed:        Result := 'Link Speed Calculation';
    RASCS_AuthAck:              Result := 'Authentication Acknowledged';
    RASCS_ReAuthenticate:       Result := 'Reauthentication Started';
    RASCS_Authenticated:        Result := 'Authenticated';
    RASCS_PrepareForCallback:   Result := 'Preparation For Callback';
    RASCS_WaitForModemReset:    Result := 'Waiting For Modem Reset';
    RASCS_WaitForCallback:      Result := 'Waiting For Callback';
    RASCS_Projected:            Result := 'Projected';
{$IFDEF WINVER400}
    RASCS_StartAuthentication:  Result := 'Start Authentication';
    RASCS_CallbackComplete:     Result := 'Callback Complete';
    RASCS_LogonNetwork:         Result := 'Logon Network';
{$ENDIF}
    RASCS_SubEntryConnected:    Result := '';
    RASCS_SubEntryDisconnected: Result := '';
    RASCS_Interactive:          Result := 'Interactive';
    RASCS_RetryAuthentication:  Result := 'Retry Authentication';
    RASCS_CallbackSetByCaller:  Result := 'Callback Set By Caller';
    RASCS_PasswordExpired:      Result := 'Password Expired';
    RASCS_Connected:            Result := 'Connected';
    RASCS_Disconnected:         Result := 'Disconnected';
    else
        Result := 'Connection state #' + IntToStr(nState);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RasGetIPAddress: string;
var
    RASConns   : TRasConn;
    dwSize     : DWORD;
    dwCount    : DWORD;
    RASpppIP   : TRASPPPIP;
begin
    Result          := '';
    RASConns.dwSize := SizeOf(TRASConn);
    RASpppIP.dwSize := SizeOf(RASpppIP);
    dwSize          := SizeOf(RASConns);
    if RASEnumConnectionsA(@RASConns, @dwSize, @dwCount) = 0 then begin
        if dwCount > 0 then begin
            dwSize := SizeOf(RASpppIP);
            RASpppIP.dwSize := SizeOf(RASpppIP);
            if RASGetProjectionInfoA(RASConns.hRasConn,
                                     RASP_PppIp,
                                     @RasPPPIP,
                                     @dwSize) = 0 then
                Result := StrPas(RASpppIP.szIPAddress);
       end;
    end;
end;

{**
** raserror.h
** Remote Access external API
** RAS specific error codes
*}

const

  RASBASE = 600;
  SUCCESS = 0;

  PENDING                              = (RASBASE+0);
{*
 * An operation is pending.%0
 *}
  ERROR_INVALID_PORT_HANDLE            = (RASBASE+1);
{*
 * The port handle is invalid.%0
 *}
  ERROR_PORT_ALREADY_OPEN              = (RASBASE+2);
{*
 * The port is already open.%0
 *}
  ERROR_BUFFER_TOO_SMALL               = (RASBASE+3);
{*
 * Caller's buffer is too small.%0
 *}
  ERROR_WRONG_INFO_SPECIFIED           = (RASBASE+4);
{*
 * Wrong information specified.%0
 *}
  ERROR_CANNOT_SET_PORT_INFO           = (RASBASE+5);
{*
 * Cannot set port information.%0
 *}
  ERROR_PORT_NOT_CONNECTED             = (RASBASE+6);
{*
 * The port is not connected.%0
 *}
  ERROR_EVENT_INVALID                  = (RASBASE+7);
{*
 * The event is invalid.%0
 *}
  ERROR_DEVICE_DOES_NOT_EXIST          = (RASBASE+8);
{*
 * The device does not exist.%0
 *}
  ERROR_DEVICETYPE_DOES_NOT_EXIST      = (RASBASE+9);
{*
 * The device type does not exist.%0
 *}
  ERROR_BUFFER_INVALID                 = (RASBASE+10);
{*
 * The buffer is invalid.%0
 *}
  ERROR_ROUTE_NOT_AVAILABLE            = (RASBASE+11);
{*
 * The route is not available.%0
 *}
  ERROR_ROUTE_NOT_ALLOCATED            = (RASBASE+12);
{*
 * The route is not allocated.%0
 *}
  ERROR_INVALID_COMPRESSION_SPECIFIED  = (RASBASE+13);
{*
 * Invalid compression specified.%0
 *}
  ERROR_OUT_OF_BUFFERS                 = (RASBASE+14);
{*
 * Out of buffers.%0
 *}
  ERROR_PORT_NOT_FOUND                 = (RASBASE+15);
{*
 * The port was not found.%0
 *}
  ERROR_ASYNC_REQUEST_PENDING          = (RASBASE+16);
{*
 * An asynchronous request is pending.%0
 *}
  ERROR_ALREADY_DISCONNECTING          = (RASBASE+17);
{*
 * The port or device is already disconnecting.%0
 *}
  ERROR_PORT_NOT_OPEN                  = (RASBASE+18);
{*
 * The port is not open.%0
 *}
  ERROR_PORT_DISCONNECTED              = (RASBASE+19);
{*
 * The port is disconnected.%0
 *}
  ERROR_NO_ENDPOINTS                   = (RASBASE+20);
{*
 * There are no endpoints.%0
 *}
  ERROR_CANNOT_OPEN_PHONEBOOK          = (RASBASE+21);
{*
 * Cannot open the phone book file.%0
 *}
  ERROR_CANNOT_LOAD_PHONEBOOK          = (RASBASE+22);
{*
 * Cannot load the phone book file.%0
 *}
  ERROR_CANNOT_FIND_PHONEBOOK_ENTRY    = (RASBASE+23);
{*
 * Cannot find the phone book entry.%0
 *}
  ERROR_CANNOT_WRITE_PHONEBOOK         = (RASBASE+24);
{*
 * Cannot write the phone book file.%0
 *}
  ERROR_CORRUPT_PHONEBOOK              = (RASBASE+25);
{*
 * Invalid information found in the phone book file.%0
 *}
  ERROR_CANNOT_LOAD_STRING             = (RASBASE+26);
{*
 * Cannot load a string.%0
 *}
  ERROR_KEY_NOT_FOUND                  = (RASBASE+27);
{*
 * Cannot find key.%0
 *}
  ERROR_DISCONNECTION                  = (RASBASE+28);
{*
 * The port was disconnected.%0
 *}
  ERROR_REMOTE_DISCONNECTION           = (RASBASE+29);
{*
 * The port was disconnected by the remote machine.%0
 *}
  ERROR_HARDWARE_FAILURE               = (RASBASE+30);
{*
 * The port was disconnected due to hardware failure.%0
 *}
  ERROR_USER_DISCONNECTION             = (RASBASE+31);
{*
 * The port was disconnected by the user.%0
 *}
  ERROR_INVALID_SIZE                   = (RASBASE+32);
{*
 * The structure size is incorrect.%0
 *}
  ERROR_PORT_NOT_AVAILABLE             = (RASBASE+33);
{*
 * The port is already in use or is not configured for Remote Access dial out.%0
 *}
  ERROR_CANNOT_PROJECT_CLIENT          = (RASBASE+34);
{*
 * Cannot register your computer on on the remote network.%0
 *}
  ERROR_UNKNOWN                        = (RASBASE+35);
{*
 * Unknown error.%0
 *}
  ERROR_WRONG_DEVICE_ATTACHED          = (RASBASE+36);
{*
 * The wrong device is attached to the port.%0
 *}
  ERROR_BAD_STRING                     = (RASBASE+37);
{*
 * The string could not be converted.%0
 *}
  ERROR_REQUEST_TIMEOUT                = (RASBASE+38);
{*
 * The request has timed out.%0
 *}
  ERROR_CANNOT_GET_LANA                = (RASBASE+39);
{*
 * No asynchronous net available.%0
 *}
  ERROR_NETBIOS_ERROR                  = (RASBASE+40);
{*
 * A NetBIOS error has occurred.%0
 *}
  ERROR_SERVER_OUT_OF_RESOURCES        = (RASBASE+41);
{*
 * The server cannot allocate NetBIOS resources needed to support the client.%0
 *}
  ERROR_NAME_EXISTS_ON_NET             = (RASBASE+42);
{*
 * One of your NetBIOS names is already registered on the remote network.%0
 *}
  ERROR_SERVER_GENERAL_NET_FAILURE     = (RASBASE+43);
{*
 * A network adapter at the server failed.%0
 *}
  WARNING_MSG_ALIAS_NOT_ADDED          = (RASBASE+44);
{*
 * You will not receive network message popups.%0
 *}
  ERROR_AUTH_INTERNAL                  = (RASBASE+45);
{*
 * Internal authentication error.%0
 *}
  ERROR_RESTRICTED_LOGON_HOURS         = (RASBASE+46);
{*
 * The account is not permitted to logon at this time of day.%0
 *}
  ERROR_ACCT_DISABLED                  = (RASBASE+47);
{*
 * The account is disabled.%0
 *}
  ERROR_PASSWD_EXPIRED                 = (RASBASE+48);
{*
 * The password has expired.%0
 *}
  ERROR_NO_DIALIN_PERMISSION           = (RASBASE+49);
{*
 * The account does not have Remote Access permission.%0
 *}
  ERROR_SERVER_NOT_RESPONDING          = (RASBASE+50);
{*
 * The Remote Access server is not responding.%0
 *}
  ERROR_FROM_DEVICE                    = (RASBASE+51);
{*
 * Your modem (or other connecting device) has reported an error.%0
 *}
  ERROR_UNRECOGNIZED_RESPONSE          = (RASBASE+52);
{*
 * Unrecognized response from the device.%0
 *}
  ERROR_MACRO_NOT_FOUND                = (RASBASE+53);
{*
 * A macro required by the device was not found in the device .INF file section.%0
 *}
  ERROR_MACRO_NOT_DEFINED              = (RASBASE+54);
{*
 * A command or response in the device .INF file section refers to an undefined macro.%0
 *}
  ERROR_MESSAGE_MACRO_NOT_FOUND        = (RASBASE+55);
{*
 * The <message> macro was not found in the device .INF file secion.%0
 *}
  ERROR_DEFAULTOFF_MACRO_NOT_FOUND     = (RASBASE+56);
{*
 * The <defaultoff> macro in the device .INF file section contains an undefined macro.%0
 *}
  ERROR_FILE_COULD_NOT_BE_OPENED       = (RASBASE+57);
{*
 * The device .INF file could not be opened.%0
 *}
  ERROR_DEVICENAME_TOO_LONG            = (RASBASE+58);
{*
 * The device name in the device .INF or media .INI file is too long.%0
 *}
  ERROR_DEVICENAME_NOT_FOUND           = (RASBASE+59);
{*
 * The media .INI file refers to an unknown device name.%0
 *}
  ERROR_NO_RESPONSES                   = (RASBASE+60);
{*
 * The device .INF file contains no responses for the command.%0
 *}
  ERROR_NO_COMMAND_FOUND               = (RASBASE+61);
{*
 * The device .INF file is missing a command.%0
 *}
  ERROR_WRONG_KEY_SPECIFIED            = (RASBASE+62);
{*
 * Attempted to set a macro not listed in device .INF file section.%0
 *}
  ERROR_UNKNOWN_DEVICE_TYPE            = (RASBASE+63);
{*
 * The media .INI file refers to an unknown device type.%0
 *}
  ERROR_ALLOCATING_MEMORY              = (RASBASE+64);
{*
 * Cannot allocate memory.%0
 *}
  ERROR_PORT_NOT_CONFIGURED            = (RASBASE+65);
{*
 * The port is not configured for Remote Access.%0
 *}
  ERROR_DEVICE_NOT_READY               = (RASBASE+66);
{*
 * Your modem (or other connecting device) is not functioning.%0
 *}
  ERROR_READING_INI_FILE               = (RASBASE+67);
{*
 * Cannot read the media .INI file.%0
 *}
  ERROR_NO_CONNECTION                  = (RASBASE+68);
{*
 * The connection dropped.%0
 *}
  ERROR_BAD_USAGE_IN_INI_FILE          = (RASBASE+69);
{*
 * The usage parameter in the media .INI file is invalid.%0
 *}
  ERROR_READING_SECTIONNAME            = (RASBASE+70);
{*
 * Cannot read the section name from the media .INI file.%0
 *}
  ERROR_READING_DEVICETYPE             = (RASBASE+71);
{*
 * Cannot read the device type from the media .INI file.%0
 *}
  ERROR_READING_DEVICENAME             = (RASBASE+72);
{*
 * Cannot read the device name from the media .INI file.%0
 *}
  ERROR_READING_USAGE                  = (RASBASE+73);
{*
 * Cannot read the usage from the media .INI file.%0
 *}
  ERROR_READING_MAXCONNECTBPS          = (RASBASE+74);
{*
 * Cannot read the maximum connection BPS rate from the media .INI file.%0
 *}
  ERROR_READING_MAXCARRIERBPS          = (RASBASE+75);
{*
 * Cannot read the maximum carrier BPS rate from the media .INI file.%0
 *}
  ERROR_LINE_BUSY                      = (RASBASE+76);
{*
 * The line is busy.%0
 *}
  ERROR_VOICE_ANSWER                   = (RASBASE+77);
{*
 * A person answered instead of a modem.%0
 *}
  ERROR_NO_ANSWER                      = (RASBASE+78);
{*
 * There is no answer.%0
 *}
  ERROR_NO_CARRIER                     = (RASBASE+79);
{*
 * Cannot detect carrier.%0
 *}
  ERROR_NO_DIALTONE                    = (RASBASE+80);
{*
 * There is no dial tone.%0
 *}
  ERROR_IN_COMMAND                     = (RASBASE+81);
{*
 * General error reported by device.%0
 *}
  ERROR_WRITING_SECTIONNAME            = (RASBASE+82);
{*
 * ERROR_WRITING_SECTIONNAME%0
 *}
  ERROR_WRITING_DEVICETYPE             = (RASBASE+83);
{*
 * ERROR_WRITING_DEVICETYPE%0
 *}
  ERROR_WRITING_DEVICENAME             = (RASBASE+84);
{*
 * ERROR_WRITING_DEVICENAME%0
 *}
  ERROR_WRITING_MAXCONNECTBPS          = (RASBASE+85);
{*
 * ERROR_WRITING_MAXCONNECTBPS%0
 *}
  ERROR_WRITING_MAXCARRIERBPS          = (RASBASE+86);
{*
 * ERROR_WRITING_MAXCARRIERBPS%0
 *}
  ERROR_WRITING_USAGE                  = (RASBASE+87);
{*
 * ERROR_WRITING_USAGE%0
 *}
  ERROR_WRITING_DEFAULTOFF             = (RASBASE+88);
{*
 * ERROR_WRITING_DEFAULTOFF%0
 *}
  ERROR_READING_DEFAULTOFF             = (RASBASE+89);
{*
 * ERROR_READING_DEFAULTOFF%0
 *}
  ERROR_EMPTY_INI_FILE                 = (RASBASE+90);
{*
 * ERROR_EMPTY_INI_FILE%0
 *}
  ERROR_AUTHENTICATION_FAILURE         = (RASBASE+91);
{*
 * Access denied because username and/or password is invalid on the domain.%0
 *}
  ERROR_PORT_OR_DEVICE                 = (RASBASE+92);
{*
 * Hardware failure in port or attached device.%0
 *}
  ERROR_NOT_BINARY_MACRO               = (RASBASE+93);
{*
 * ERROR_NOT_BINARY_MACRO%0
 *}
  ERROR_DCB_NOT_FOUND                  = (RASBASE+94);
{*
 * ERROR_DCB_NOT_FOUND%0
 *}
  ERROR_STATE_MACHINES_NOT_STARTED     = (RASBASE+95);
{*
 * ERROR_STATE_MACHINES_NOT_STARTED%0
 *}
  ERROR_STATE_MACHINES_ALREADY_STARTED = (RASBASE+96);
{*
 * ERROR_STATE_MACHINES_ALREADY_STARTED%0
 *}
  ERROR_PARTIAL_RESPONSE_LOOPING       = (RASBASE+97);
{*
 * ERROR_PARTIAL_RESPONSE_LOOPING%0
 *}
  ERROR_UNKNOWN_RESPONSE_KEY           = (RASBASE+98);
{*
 * A response keyname in the device .INF file is not in the expected format.%0
 *}
  ERROR_RECV_BUF_FULL                  = (RASBASE+99);
{*
 * The device response caused buffer overflow.%0
 *}
  ERROR_CMD_TOO_LONG                   = (RASBASE+100);
{*
 * The expanded command in the device .INF file is too long.%0
 *}
  ERROR_UNSUPPORTED_BPS                = (RASBASE+101);
{*
 * The device moved to a BPS rate not supported by the COM driver.%0
 *}
  ERROR_UNEXPECTED_RESPONSE            = (RASBASE+102);
{*
 * Device response received when none expected.%0
 *}
  ERROR_INTERACTIVE_MODE               = (RASBASE+103);
{*
 * ERROR_INTERACTIVE_MODE%0
 *}
  ERROR_BAD_CALLBACK_NUMBER            = (RASBASE+104);
{*
 * ERROR_BAD_CALLBACK_NUMBER
 *}
  ERROR_INVALID_AUTH_STATE             = (RASBASE+105);
{*
 * ERROR_INVALID_AUTH_STATE%0
 *}
  ERROR_WRITING_INITBPS                = (RASBASE+106);
{*
 * ERROR_WRITING_INITBPS%0
 *}
  ERROR_X25_DIAGNOSTIC                 = (RASBASE+107);
{*
 * X.25 diagnostic indication.%0
 *}
  ERROR_ACCT_EXPIRED                   = (RASBASE+108);
{*
 * The account has expired.%0
 *}
  ERROR_CHANGING_PASSWORD              = (RASBASE+109);
{*
 * Error changing password on domain.  The password may be too short or may match a previously used password.%0
 *}
  ERROR_OVERRUN                        = (RASBASE+110);
{*
 * Serial overrun errors were detected while communicating with your modem.%0
 *}
  ERROR_RASMAN_CANNOT_INITIALIZE             = (RASBASE+111);
{*
 * RasMan initialization failure.  Check the event log.%0
 *}
  ERROR_BIPLEX_PORT_NOT_AVAILABLE      = (RASBASE+112);
{*
 * Biplex port initializing.  Wait a few seconds and redial.%0
 *}
  ERROR_NO_ACTIVE_ISDN_LINES           = (RASBASE+113);
{*
 * No active ISDN lines are available.%0
 *}
  ERROR_NO_ISDN_CHANNELS_AVAILABLE     = (RASBASE+114);
{*
 * No ISDN channels are available to make the call.%0
 *}
  ERROR_TOO_MANY_LINE_ERRORS           = (RASBASE+115);
{*
 * Too many errors occured because of poor phone line quality.%0
 *}
  ERROR_IP_CONFIGURATION               = (RASBASE+116);
{*
 * The Remote Access IP configuration is unusable.%0
 *}
  ERROR_NO_IP_ADDRESSES                = (RASBASE+117);
{*
 * No IP addresses are available in the static pool of Remote Access IP addresses.%0
 *}
  ERROR_PPP_TIMEOUT                    = (RASBASE+118);
{*
 * Timed out waiting for a valid response from the remote PPP peer.%0
 *}
  ERROR_PPP_REMOTE_TERMINATED          = (RASBASE+119);
{*
 * PPP terminated by remote machine.%0
 *}
  ERROR_PPP_NO_PROTOCOLS_CONFIGURED    = (RASBASE+120);
{*
 * No PPP control protocols configured.%0
 *}
  ERROR_PPP_NO_RESPONSE                = (RASBASE+121);
{*
 * Remote PPP peer is not responding.%0
 *}
  ERROR_PPP_INVALID_PACKET             = (RASBASE+122);
{*
 * The PPP packet is invalid.%0
 *}
  ERROR_PHONE_NUMBER_TOO_LONG          = (RASBASE+123);
{*
 * The phone number including prefix and suffix is too long.%0
 *}
  ERROR_IPXCP_NO_DIALOUT_CONFIGURED    = (RASBASE+124);
{*
 * The IPX protocol cannot dial-out on the port because the machine is an IPX router.%0
 *}
  ERROR_IPXCP_NO_DIALIN_CONFIGURED     = (RASBASE+125);
{*
 * The IPX protocol cannot dial-in on the port because the IPX router is not installed.%0
 *}
  ERROR_IPXCP_DIALOUT_ALREADY_ACTIVE   = (RASBASE+126);
{*
 * The IPX protocol cannot be used for dial-out on more than one port at a time.%0
 *}
  ERROR_ACCESSING_TCPCFGDLL            = (RASBASE+127);
{*
 * Cannot access TCPCFG.DLL.%0
 *}
  ERROR_NO_IP_RAS_ADAPTER              = (RASBASE+128);
{*
 * Cannot find an IP adapter bound to Remote Access.%0
 *}
  ERROR_SLIP_REQUIRES_IP               = (RASBASE+129);
{*
 * SLIP cannot be used unless the IP protocol is installed.%0
 *}
  ERROR_PROJECTION_NOT_COMPLETE        = (RASBASE+130);
{*
 * Computer registration is not complete.%0
 *}
  ERROR_PROTOCOL_NOT_CONFIGURED        = (RASBASE+131);
{*
 * The protocol is not configured.%0
 *}
  ERROR_PPP_NOT_CONVERGING             = (RASBASE+132);
{*
 * The PPP negotiation is not converging.%0
 *}
  ERROR_PPP_CP_REJECTED                = (RASBASE+133);
{*
 * The PPP control protocol for this network protocol is not available on the server.%0
 *}
  ERROR_PPP_LCP_TERMINATED             = (RASBASE+134);
{*
 * The PPP link control protocol terminated.%0
 *}
  ERROR_PPP_REQUIRED_ADDRESS_REJECTED  = (RASBASE+135);
{*
 * The requested address was rejected by the server.%0
 *}
  ERROR_PPP_NCP_TERMINATED             = (RASBASE+136);
{*
 * The remote computer terminated the control protocol.%0
 *}
  ERROR_PPP_LOOPBACK_DETECTED          = (RASBASE+137);
{*
 * Loopback detected.%0
 *}
  ERROR_PPP_NO_ADDRESS_ASSIGNED        = (RASBASE+138);
{*
 * The server did not assign an address.%0
 *}
  ERROR_CANNOT_USE_LOGON_CREDENTIALS   = (RASBASE+139);
{*
 * The authentication protocol required by the remote server cannot use the Windows NT encrypted password.  Redial, entering the password explicitly.%0
 *}
  ERROR_TAPI_CONFIGURATION             = (RASBASE+140);
{*
 * Invalid TAPI configuration.%0
 *}
  ERROR_NO_LOCAL_ENCRYPTION            = (RASBASE+141);
{*
 * The local computer does not support encryption.%0
 *}
  ERROR_NO_REMOTE_ENCRYPTION           = (RASBASE+142);
{*
 * The remote server does not support encryption.%0
 *}
  ERROR_REMOTE_REQUIRES_ENCRYPTION     = (RASBASE+143);
{*
 * The remote server requires encryption.%0
 *}
  ERROR_IPXCP_NET_NUMBER_CONFLICT      = (RASBASE+144);
{*
 * Cannot use the IPX network number assigned by remote server.  Check the event log.%0
 *}
  ERROR_INVALID_SMM                    = (RASBASE+145);
{*
 * ERROR_INVALID_SMM%0
 *}
  ERROR_SMM_UNINITIALIZED              = (RASBASE+146);
{*
 * ERROR_SMM_UNINITIALIZED%0
 *}
  ERROR_NO_MAC_FOR_PORT                = (RASBASE+147);
{*
 * ERROR_NO_MAC_FOR_PORT%0
 *}
  ERROR_SMM_TIMEOUT                    = (RASBASE+148);
{*
 * ERROR_SMM_TIMEOUT%0
 *}
  ERROR_BAD_PHONE_NUMBER               = (RASBASE+149);
{*
 * ERROR_BAD_PHONE_NUMBER%0
 *}
  ERROR_WRONG_MODULE                   = (RASBASE+150);
{*
 * ERROR_WRONG_MODULE%0
 *}
  ERROR_INVALID_CALLBACK_NUMBER        = (RASBASE+151);
{*
 * Invalid callback number.  Only the characters 0 to 9, T, P, W, (, ), -, @, and space are allowed in the number.%0
 *}
  ERROR_SCRIPT_SYNTAX                  = (RASBASE+152);
{*
 * A syntax error was encountered while processing a script.%0
 *}
  RASBASEEND                           = (RASBASE+152);


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RasGetEntryPropertiesA;     external 'rasapi32.dll' name 'RasGetEntryPropertiesA';
//function RasGetEntryPropertiesW;     external 'rasapi32.dll' name 'RasGetEntryPropertiesW';
function RasGetEntryProperties;      external 'rasapi32.dll' name 'RasGetEntryPropertiesA';

function RasDialA; external rasapi32 name 'RasDialA';
function RasGetErrorStringA; external rasapi32 name 'RasGetErrorStringA';
function RasHangUpA; external rasapi32 name 'RasHangUpA';
function RasGetConnectStatusA; external rasapi32 name 'RasGetConnectStatusA';
function RasEnumConnectionsA; external rasapi32 name 'RasEnumConnectionsA';
function RasEnumEntriesA; external rasapi32 name 'RasEnumEntriesA';
function RasGetEntryDialParamsA; external rasapi32 name 'RasGetEntryDialParamsA';
function RasEditPhonebookEntryA; external rasapi32 name 'RasEditPhonebookEntryA';
//function RasEntryDlgA; external rasapi32 name 'RasEntryDlgA';
function RasCreatePhonebookEntryA; external rasapi32 name 'RasCreatePhonebookEntryA';
function RasGetProjectionInfoA; external rasapi32 name 'RasGetProjectionInfoA';

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.



