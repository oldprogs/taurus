unit NewThrd;

interface
                      
uses xBase, {RadIniEx,} RadIni, SysUtils, Windows, Classes, ComeOn;

  type TMailerThr = class(T_Thread)
         oEvt: DWORD;
//         procedure InvokeDone; override;
         procedure InvokeExec; override;
         constructor Create;
         destructor Destroy; override;
         procedure CheckIni;
//         procedure DoCheck;
         class function ThreadName: string; override;
       end;

var FTime: TFileTime;
  MailerThr: TMailerThr;

procedure Start;
procedure Finish;


implementation

procedure Start;
begin
//  testini(false);
  MailerThr :=TMailerThr.Create;
  MailerThr.Suspended:=false;
  MailerThr.Priority:=tpIdle;
  MailerThr.InvokeExec;
end;

procedure Finish;
begin
  MailerThr.InvokeDone;
  MailerThr.Terminated:=True;
  MailerThr.WaitFor;
  FreeObject(MailerThr);
end;

constructor TMailerThr.create;
begin
  oEvt := CreateEvt(False);
  inherited create;
end;

destructor TMailerThr.Destroy;
begin
  ZeroHandle(oEvt);
  inherited destroy;
end;

procedure TMailerThr.InvokeExec;
begin
//  testini(true);
  come_on;
  repeat
    WaitEvt(oEvt, 1000);
  until (not ApplicationDowned) or (Terminated);
end;

class function TMailerThr.ThreadName: string;
begin
  Result := 'MailerThr';
end;

procedure TMailerThr.CheckIni;

{Const
  BufSize=63488;
  nibble:array[0..$F] of char='0123456789ABCDEF';
  polynom=$EDB88320;

Var Buff:array[1..BufSize] of byte;
    CRC32Table:array[byte] of longint;
    f:file;
    CRC,i,m,n:longint;

begin
     for i := 0 to 255 do
     begin
       m:=i;
       for n:=1 to 8 do if odd(m) then m:=(m shr 1) xor polynom
                                   else m:=m shr 1;
       CRC32Table[i]:=m;
     end;

     CRC:=$FFFFFFFF;

     assign(f,IniFile.FName);
     FileMode:=$20; reset(f,1);
     m:=FileSize(f);
     repeat
       if m>BufSize then n:=BufSize else n:=m;
       BlockRead(f,Buff,n);
       for i:=1 to n do crc:=CRC32Table[lo(crc) xor Buff[i]] xor (crc shr 8);
       dec(m,n);
     until m=0;
     close(f);

     CRC:=not CRC;

     write(ParamStr(1),' CRC32 = ');
     for i:=7 downto 0 do write(nibble[CRC shr (i shl 2) and $F]);
     writeln;}
//var f: tfilestream;
var p3: TFileTime;
begin
  getfiletime(SysUtils.FileOpen(_IniFile.FName,SysUtils.fmOpenRead),nil,nil,@p3);
// Why `and' ???  if (p3.dwLowDateTime <> FTime.dwLowDateTime) and (p3.dwHighDateTime <> FTime.dwHighDateTime) then IniFIle.ReReadCFG;
// Maybe `or' ?
  if (p3.dwLowDateTime <> FTime.dwLowDateTime) or (p3.dwHighDateTime <> FTime.dwHighDateTime) then IniFIle.ReReadCFG;
end;

end.

