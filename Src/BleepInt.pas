Unit BleepInt; { Version 4.5b - For VP/2 }

Interface

Type
  TBleepType= (bOK, bInterrupt, bError);

Procedure ShutUp; { Added to help counter the effects of DoBleep (Freq, -1).
                    If you are producing a tone, & you want to stop without
doing another Bleep, call this procedure }

Procedure DoBleep (Freq : Word; MSecs : LongInt); { Duration of -1 means bleep
until the next bleep sent, or ShutUp is called }

Procedure Bleep (BleepType : TBleepType);

Implementation

Uses
  Windows;
{ -- --- -- --- -- --- -- --- -- --- -- --- -- --- Assembler Bits for Wind 3.x
And '95 -- --- -- --- -- --- -- --- -- --- }

Procedure AsmShutUp; Pascal;
Begin
  Asm
    In AL, $61
    And AL, $FC
    Out $61, AL
  End;
End;

Procedure AsmBeep (Freq : Word); Pascal;
Begin
  Asm
        Push BX
        In AL, $61
        Mov BL, AL
        And AL, 3
        Jne @@Skip
        Mov AL, BL
        Or AL, 3
        Out $61, AL
        Mov AL, $B6
        Out $43, AL
@@Skip: Mov AX, Freq
        Out $42, AL
        Mov AL, AH
        Out $42, AL
        Pop BX
  End;
End;

{ -- --- -- --- -- --- -- --- -- --- -- --- -- --- Low Level Bits for Wind 3.x
And '95 -- --- -- --- -- --- -- --- -- --- }

Procedure HardBleep (Freq : Word; MSecs : LongInt);
Const
  HiValue=High (DWord);

Var
  iCurrTickCount, iFirstTickCount : DWord;
  iElapTime : LongInt;
Begin
  If (Freq>=20)And (Freq<=5000)Then Begin
    AsmBeep (Word (1193181 Div LongInt (Freq)));
    If MSecs>=0 Then Begin
      iFirstTickCount:=GetTickCount;
      Repeat
        iCurrTickCount:=GetTickCount;
        { Has GetTickCount wrapped to 0 ? }
        If iCurrTickCount<iFirstTickCount Then
iElapTime:=HiValue-iFirstTickCount+iCurrTickCount
        Else iElapTime:=iCurrTickCount-iFirstTickCount;
      Until iElapTime>=MSecs;
      AsmShutUp;
    End;
  End;
End;

{ This is the old 'succumbs to Murphy's Law version of HardBleep              }
{ I'll delete it later - it's here just in case Murphy's Law hits the new one }
{ Why have I used (* *) style comments to hide it?                            }

(* Procedure HardBleep (Freq : Word; MSecs : Integer);
   Var
    FirstTickCount : {$IFDEF WIN32} DWord {$ELSE} LongInt {$ENDIF};
   Begin
     If (Freq>=20) And (Freq<=5000) Then Begin
       AsmBeep (Word (1193181 Div LongInt(Freq)));
       If MSecs>-1 Then Begin
         FirstTickCount:=GetTickCount;
         Repeat
           {$IFNDEF CONSOLE} If MSecs>1000 Then Application.ProcessMessages;
{$ENDIF}
         Until ((GetTickCount-FirstTickCount)>{$IFDEF WIN32} DWord {$ELSE}
LongInt {$ENDIF}(MSecs));
         AsmShutUp;
       End;
     End;
   End; *)

{ -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- Procedures for you to
use -- --- -- --- -- --- -- --- -- --- -- --- }

Procedure Bleep (BleepType : TBleepType);
Begin
  Case BleepType Of
    bOK : Begin
        DoBleep (1047, 100);
        DoBleep (1109, 100);
        DoBleep (1175, 100);
      End;
    bInterrupt : Begin
        DoBleep (2093, 100);
        DoBleep (1976, 100);
        DoBleep (1857, 100);
      End;
    bError : DoBleep (40, 500);
  End;
End;

Var
  SysWinNT : Boolean;

Procedure DoBleep (Freq : Word; MSecs : LongInt);
Begin
  If MSecs<-1 Then MSecs:=0;
  If SysWinNT Then Windows.Beep (Freq, MSecs) Else HardBleep (Freq, MSecs);
End;

Procedure ShutUp;
Begin
  If SysWinNT Then Windows.Beep (1, 0) Else AsmShutUp;
End;

Procedure InitSysType;
Var
  VersionInfo : TOSVersionInfo;
Begin
  VersionInfo.dwOSVersionInfoSize:=SizeOf (VersionInfo);
  GetVersionEx (VersionInfo);
  SysWinNt:=VersionInfo.dwPlatformID=VER_PLATFORM_WIN32_NT;
End;

Initialization
  InitSysType;

End.
