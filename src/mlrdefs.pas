unit MlrDefs;

interface

uses windows;

type

  TSocksRequest = packed record
    VN: Byte;           // VN is the SOCKS protocol version number
    CD: Byte;           // CD is the SOCKS command code
    DstPort: Word;
    DstIP: DWORD;
  end;

const

  cszr = SizeOf(TSocksRequest);

// SOCKS protocol version number
  SOCKS_VERSION_4 = 04;
  SOCKS_VERSION_5 = 05;

// Socks Request method (command code)
  SOCKS_CONNECT  = 01;
  SOCKS_BIND     = 02;
  SOCKS_ACCEPT   = 82;

// Socket auth method
  SOCKS_NOAUTH   = 00;
  SOCKS_USERPASS = 02;

// Remote address type
  SOCKS_TYPEIP4  = #01;
  SOCKS_TYPENAME = #03;

  SOCKS_LOGIN_VERSION = #01;


implementation

begin
end.

