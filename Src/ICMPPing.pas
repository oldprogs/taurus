unit
  IcmpPing;

interface

  function iPing(Host: string; Times, Timeout: integer; var FError: Integer): Integer;

implementation

uses
  Windows,
  SysUtils,
  WinSock,
  IcmpApi;

type
  PIPOptionInformation = ^TIPOptionInformation;
  TIPOptionInformation = packed record
     TTL:         Byte;      // Time To Live (used for traceroute)
     TOS:         Byte;      // Type Of Service (usually 0)
     Flags:       Byte;      // IP header flags (usually 0)
     OptionsSize: Byte;      // Size of options data (usually 0, max 40)
     OptionsData: PChar;     // Options data buffer
  end;

  PIcmpEchoReply = ^TIcmpEchoReply;
  TIcmpEchoReply = packed record
     Address:       DWord;                // replying address
     Status:        DWord;                // IP status value
     RTT:           Longint;                // Round Trip Time in milliseconds
     DataSize:      Word;                 // reply data size
     Reserved:      Word;
     Data:          Pointer;              // pointer to reply data buffer
     Options:       TIPOptionInformation; // reply options
  end;

  function iPing;
  var
    H: THandle;
    C, D: integer;
    I: Byte;
    T: longint;
    rstat: integer;
    _wsadata: TWSAData;                // Winsock init data

    _Address: DWord;                   // Address of host to contact
    _pEchoReplyData: Pointer;          // Pointer to sendecho data buffer initially $AA
    _EchoReplySize: integer;
    _EchoRequestSize: integer;
    _pEchoRequestData: Pointer;
    _pIPEchoReply: PIcmpEchoReply;     // ICMP Echo reply buffer
    _IPOptions: TIPOptionInformation;  // IP Options for packet to send
  begin
    result := 0;

    rstat := WSAStartup($101,_wsadata);
    if rstat <> 0 then begin
      FError := rstat;
      Exit;
    end;

    H := IcmpCreateFile;

    FillChar(_IPOptions, SizeOf(_IPOptions), 0);
    _IPOptions.TTL := 64;
    _EchoRequestSize := 56;

    GetMem(_pEchoReplyData, _EchoRequestSize); // should get back what we send
    _EchoReplySize := SizeOf(TICMPEchoReply) + _EchoRequestSize;

    GetMem(_pEchoRequestData, _EchoRequestSize);
    GetMem(_pIPEchoReply, _EchoReplySize);
    FillChar(_pEchoRequestData^, _EchoRequestSize, $AA);
    _pIPEchoReply^.Data := _pEchoReplyData;

    _Address := inet_addr(PChar(Host));

    D := Timeout;
    T := 0;

    if H <> INVALID_HANDLE_VALUE then begin
      for I := 1 to Times do begin
        C := IcmpSendEcho(H, _Address,
                          _pEchoRequestData, _EchoRequestSize,
                          @_IPOptions,
                          _pIPEchoReply, _EchoReplySize, D);
        if C <> 0 then begin
          T := T + _pIPEchoReply^.RTT + 1;
        end else begin
          FError := WSAGetLastError;
        end;
        IcmpCloseHandle(H);
      end;
    end {else AddStringToLog('#', 'INVALID_HANDLE_VALUE')};
// Release Winsock
    WSACleanup;
    result:=T;
  end;

end.
