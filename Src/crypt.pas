(***************************************************************
*     Project: Proxy FTP                                       *
*        Unit: crypt.pas                                       *
*     version: 1.5.0.0                                         *
* Description: Crypt functions (Base64 and XOR crypting)       *
*                                                              *
* Copyright (c) 1998-1999 GranDe Soft lab.                     *
*           http://www.angelfire.com/me/vmoshninov             *
*  mail to: proxyftp@chat.ru                                   *
***************************************************************)
unit Crypt;

interface

function EncodeStr(const InString: string): string;
function DecodeStr(InString: string): string;
function EncodeB64(const InString: string): string;
function DecodeB64(InString: string): string;

implementation

const
  CSTARTKEY        = 4793;       {Start default key}
  CMULTKEY         = 29683;      {Mult default key}
  CADDKEY          = 87469;      {Add default key}

  BIN2B64: string  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  B642BIN: string  = '~~~~~~~~~~^~~~_TUVWXYZ[\]~~~~~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';

function EncodeStr(const InString:string): string;
var i : Byte;
    StartKey,
    MultKey,
    AddKey: integer;
begin
  Result := '';
  try
    StartKey:= CSTARTKEY;
    MultKey:= CMULTKEY;
    AddKey:= CADDKEY;
    for i := 1 to Length(InString) do
    begin
      Result := Result + Char(Byte(InString[i]) xor (StartKey shr 8));
      StartKey := (Byte(Result[i]) + StartKey) * MultKey + AddKey;
    end;
    result:= EncodeB64(result);
  except
    result:= '';
  end;
end;

function DecodeStr(InString:string): string;
var i : Byte;
    StartKey,
    MultKey,
    AddKey: integer;
begin
  result:= '';
  try
    InString := DecodeB64(InString);
    StartKey:= CSTARTKEY;
    MultKey:= CMULTKEY;
    AddKey:= CADDKEY;
    for i := 1 to Length(InString) do
    begin
      Result := Result + Char(Byte(InString[i]) xor (StartKey shr 8));
      StartKey := (Byte(InString[i]) + StartKey) * MultKey + AddKey;
    end;
  except
    result:= '';
  end;
end;

function EncodeB64(const InString: string): string;
var i: integer;
    sVal,sMod, Mask: byte;
    Len,Offset: integer;
begin
  result:= '';
  i:= 1;
  Len:= Length(InString);
  Offset:= 2;
  Mask:= $FC;
  sMod:= 0;
  while i <= Len do
  begin
    sVal:= (byte(InString[i]) and Mask) shr Offset;
    case Offset of
      2: begin
           result:= result + BIN2B64[Succ(sVal)];
           sMod:= (byte(InString[i]) and (not Mask)) shl 4;
           Offset:= 4;
           Mask:= $F0;
         end;
      4: begin
           result:= result + BIN2B64[Succ(sVal or sMod)];
           sMod:= (byte(InString[i]) and (not Mask)) shl 2;
           Offset:= 6;
           Mask:= $C0;
         end;
      6: begin
           result:= result + BIN2B64[Succ(sVal or sMod)];
           sMod:= (byte(InString[i]) and (not Mask));
           Offset:= 8;
           Mask:= $00;
         end;
      8: begin
           result:= result + BIN2B64[Succ(sMod)];
           Offset:= 2;
           Mask:= $FC;
           Dec(i);
         end;
    end;
    Inc(i);
  end;
  if Offset <> 2 then
    result:= result + BIN2B64[Succ(sMod)];
  while (Length(result) mod 4) <> 0 do
    result:= result + '=';
end;

function DecodeB64(InString: string): string;
var i: integer;
    sVal,sMod, Mask: byte;
    Len,Offset: integer;
begin
  result := '';
  sVal := 0;
  Len := Length(InString);
  While (Len > 0) and (InString[Len] = '=') do
    Dec(Len);
  i:= 1;
  Offset:= 2;
  Mask:= $3F;
  while i <= Len do
  begin
    InString[i]:= char((byte(B642BIN[(byte(InString[i]) - $20)]) - $20));
    sMod:= (byte(InString[i]) and (not Mask)) shr (8 - Offset);
    case Offset of
      2: begin
           sVal:= (byte(InString[i]) and Mask) shl Offset;
           Offset:= 4;
           Mask:= $0F;
         end;
      4: begin
           result:= result + char(sVal or sMod);
           sVal:= (byte(InString[i]) and Mask) shl Offset;
           Offset:= 6;
           Mask:= $03;
         end;
      6: begin
           result:= result + char(sVal or sMod);
           sVal:= (byte(InString[i]) and Mask) shl Offset;
           Offset:= 8;
           Mask:= $00;
         end;
      8: begin
           result:= result + char(sVal or sMod);
           Offset:= 2;
           Mask:= $3F;
         end;
    end;
    Inc(i);
  end;
end;

end.
