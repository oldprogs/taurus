unit AtomEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, xBase, MClasses, ComCtrls, mGrids;

const
  MaxBevel = 7;

type
  TAtomEditorForm = class(TForm)
    Bevel2: TBevel;
    llTyp: TLabel;
    cb: TComboBox;
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    nb: TNotebook;
    bvl1: TBevel;
    lString: TLabel;
    iString: TEdit;
    lCombo: TLabel;
    bvl2: TBevel;
    cbCombo: TComboBox;
    lSpin: TLabel;
    bvl3: TBevel;
    sSpin: TxSpinEdit;
    bvl4: TBevel;
    cbCheckBox: TCheckBox;
    bvl5: TBevel;
    iDstrA: TEdit;
    lDstrA: TLabel;
    lDstrB: TLabel;
    iDstrB: TEdit;
    bvl6: TBevel;
    MemoPageControl: TPageControl;
    tsMemoA: TTabSheet;
    tsMemoB: TTabSheet;
    MemoA: TMemo;
    MemoB: TMemo;
    bvl7: TBevel;
    lGrid: TLabel;
    eGrid: TEdit;
    StringGrid: TAdvGrid;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbComboClick(Sender: TObject);
    procedure sSpinChange(Sender: TObject);
    procedure cbCheckBoxClick(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure StringGridRowDelete(Sender: TObject; xRow: Integer);
    procedure StringGridRowInsert(Sender: TObject; xRow: Integer);
    procedure RenumRows(G: TAdvGrid; xRow, Delta: integer);
  private
   // DisableFreqs: Boolean;
    FreqPwdDur,
    FreqPwdSz,
    FreqPwdCnt,
    FreqPubDur,
    FreqPubSz,
    FreqPubCnt,
    TimeDial,
    Retry,
    NumRings,
    AccDurMax,
    TrsDurMax,
    MinInConnectSpeed,
    MinOutConnectSpeed,
    MinInCPS,
    MinOutCPS,
    MinInEfBPS,
    MinOutEfBPS,
    ModemId,
    StationId,
    TrafShIn,
    TrafShOut,
    RestrictionId,
    AccFilSiz,
    DelFilSiz: DWORD;
    RASHangUp: boolean;
    CmdMap: TColl;
    Bevels: array[0..MaxBevel] of TBevel;
    procedure FillCombo(Typ: Integer);
    procedure UpdateNB;
    procedure DoAdjustSize;
    function GetAtom: Pointer;
    function CurTyp: Integer;
    procedure SetAtom(Atom: Pointer);
    procedure StoreSpinValue(ATyp: Integer; i: DWORD);
  public
  end;

function EditAtom(Atom: Pointer): Pointer;

implementation

uses Recs, LngTools, xFido, Wizard;

{$R *.DFM}

type
  TCmdCaption = class
    Typ: Integer;
    Cap: string;
  end;

function EditAtom;
var
  AtomEditorForm: TAtomEditorForm;
  Typ: Integer;
begin
  Result := nil;
  AtomEditorForm := TAtomEditorForm.Create(Application);
  if Atom <> nil then Typ := TEventAtom(Atom).Typ else Typ := -1;
  AtomEditorForm.FillCombo(Typ);
  AtomEditorForm.DoAdjustSize;
  if Atom <> nil then AtomEditorForm.SetAtom(Atom);
  if AtomEditorForm.ShowModal = mrOK then Result := AtomEditorForm.GetAtom;
  FreeObject(AtomEditorForm);
end;

function CmdMapSort(Item1, Item2: Pointer): Integer;
var
  a1 : TCmdCaption absolute Item1;
  a2 : TCmdCaption absolute Item2;
begin
  Result := AnsiCompareStr(a1.cap, a2.cap);
end;


procedure TAtomEditorForm.FillCombo(Typ: Integer);
var
  i: Integer;
  s,z: string;
  cc: TCmdCaption;
begin
  i := 0;
  repeat
    s := LngStr(i + LngEvtBase);
    if s = '' then GlobalFail('%s', ['TAtomEditorForm.FillCombo']);
    if s = '!' then Break;
    if s <> '-' then begin
      GetWrd(s, z, '|');
      cc := TCmdCaption.Create;
      cc.Typ := i;
      cc.Cap := z;
      CmdMap.Insert(cc);
    end;
    Inc(i);
  until False;
  CmdMap.Sort(CmdMapSort);
  for i := 0 to CmdMap.Count - 1 do begin
    cc := CmdMap[i];
    cb.Items.Add(cc.Cap);
    if cc.Typ = Typ then cb.ItemIndex := i;
  end;
  if Typ = -1 then cb.ItemIndex := 0;
  UpdateNB;
end;

procedure TAtomEditorForm.DoAdjustSize;
begin
  if not nb.Visible then ClientHeight := bHelp.Top + 28 else
  ClientHeight := nb.Top + Bevels[nb.PageIndex].Height + 5;
end;

procedure TAtomEditorForm.FormDestroy(Sender: TObject);
begin
  FreeObject(CmdMap);
end;

procedure TAtomEditorForm.FormCreate(Sender: TObject);
begin
   FillForm(Self, rsAtomEditorForm);
   CmdMap := TColl.Create;
   sSpin.MinValue := 0;
   Bevels[1] := bvl1;
   Bevels[2] := bvl2;
   Bevels[3] := bvl3;
   Bevels[4] := bvl4;
   Bevels[5] := bvl5;
   Bevels[6] := bvl6;
   Bevels[7] := bvl7;
end;

procedure TAtomEditorForm.UpdateNB;
var
  Ct: Integer;
  Typ: TEventParamTyp;
  s, z, t1, t2, t3, t4: string;

procedure Skip;
begin
  GetWrd(s, z, '|');
end;

begin
  ct := CurTyp;
  s := LngStr(ct + LngEvtBase);
  Typ := GetEventParamTyp(ct);
  nb.Visible := Typ <> eptVoid;
  case Typ of
  eptDMemo:
     begin
        nb.PageIndex := 6;
        Skip; Skip;
        tsMemoA.Caption := z;
        Skip;
        tsMemoB.Caption := z;
     end;
  eptDStr:
     begin
        nb.PageIndex := 5;
        Skip; Skip;
        lDStrA.Caption := z;
        Skip;
        lDStrB.Caption := z;
     end;
  eptString:
     begin
        nb.PageIndex := 1;
        Skip; Skip;
        lString.Caption := z;
     end;
  eptCombo:
     begin
        nb.PageIndex := 2;
        case ct of
        eiRplStation     : Cfg.Station.FillCombo(cbCombo, rsRecsDefaultS, StationId);
        eiRplModem       : Cfg.Modems.FillCombo(cbCombo, rsRecsDefaultM, ModemId);
        eiRplRestriction : Cfg.Restrictions.FillCombo(cbCombo, rsRecsDefaultR, RestrictionId);
        else GlobalFail('%s', ['TAtomEditorForm.UpdateNB eptCombo']);
        end;
        Skip; Skip;
        lCombo.Caption := z;
     end;
  eptSpin:
     begin
        nb.PageIndex := 3;
        Skip; Skip;
        lSpin.Caption := z;
        case ct of
        eiAccDurMax:
           begin
              sSpin.Increment := 5;
              sSpin.MaxValue := 8640000;
              sSpin.Value := AccDurMax;
           end;
        eiTrsDurMax:
           begin
              sSpin.Increment := 5;
              sSpin.MaxValue := 8640000;
              sSpin.Value := TrsDurMax;
           end;
        eiAccSpeedMin:
           begin
              sSpin.Increment := 2400;
              sSpin.MaxValue := 24576000;
              sSpin.Value := MinInConnectSpeed;
           end;
        eiTrsSpeedMin:
           begin
              sSpin.Increment := 2400;
              sSpin.MaxValue := 24576000;
              sSpin.Value := MinOutConnectSpeed;
           end;
        eiAccCPSMin:
           begin
              sSpin.Increment := 100;
              sSpin.MaxValue := 10000000;
              sSpin.Value := MinInCPS;
           end;
        eiTrsCPSMin:
           begin
              sSpin.Increment := 100;
              sSpin.MaxValue := 10000000;
              sSpin.Value := MinOutCPS;
           end;
        eiTrafShOut:
           begin
              sSpin.Increment := 256;
              sSpin.MaxValue := 99999999;
              sSpin.MinValue := 0;
              sSpin.Value := TrafShOut;
           end;
        eiTrafShIn:
           begin
              sSpin.Increment := 256;
              sSpin.MaxValue := 99999999;
              sSpin.MinValue := 0;
              sSpin.Value := TrafShIn;
           end;
        eiAccBPSEfMin:
           begin
              sSpin.Increment := 10;
              sSpin.MaxValue := 10000;
              sSpin.MinValue := 1;
              sSpin.Value := MinInEfBPS;
           end;
        eiTrsBPSEfMin:
           begin
              sSpin.Increment := 10;
              sSpin.MaxValue := 10000;
              sSpin.MinValue := 1;
              sSpin.Value := MinOutEfBPS;
           end;
        eiNumRings:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 30;
              sSpin.Value := NumRings;
           end;
        eiFreqPwdDur:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 14400;
              sSpin.Value := FreqPwdDur;
           end;
        eiFreqPubDur:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 14400;
              sSpin.Value := FreqPubDur;
           end;
        eiFreqPwdSz:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 2000000;
              sSpin.Value := FreqPwdSz;
           end;
        eiFreqPubSz:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 2000000;
              sSpin.Value := FreqPubSz;
           end;
        eiFreqPwdCnt:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 10000;
              sSpin.Value := FreqPwdCnt;
           end;
        eiFreqPubCnt:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 10000;
              sSpin.Value := FreqPubCnt;
           end;
        eiTimeDial:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 200;
              sSpin.MinValue := 30;
              sSpin.Value := TimeDial;
           end;
        eiRetry:
           begin
              sSpin.Increment := 1;
              sSpin.MaxValue := 20000;
              sSpin.MinValue := 10;
              sSpin.Value := Retry;
           end;
        eiAccFilesSiz:
           begin
              sSpin.Increment := 96;
              sSpin.MaxValue := 1048576;
              sSpin.MinValue := 10;
              sSpin.Value := AccFilSiz;
           end;
        eiDelFilesSiz:
           begin
              sSpin.Increment := 96;
              sSpin.MaxValue := 1048576;
              sSpin.MinValue := 10;
              sSpin.Value := DelFilSiz;
           end;
        else GlobalFail('%s', ['TAtomEditorForm.UpdateNB eptSpin']);
        end;
     end;
  eptVoid: nb.PageIndex := 1;

  eptBool:
     begin
        nb.PageIndex := 4;
        Skip; Skip;
        cbCheckBox.Caption := z;
        cbCheckBox.Checked := RASHangUp;
{        case ct of
          eiAccFreqs: cbCheckBox.Checked := DisableFreqs;
          else GlobalFail;
        end;}
     end;

  eptGrid:
     begin
        nb.PageIndex := 7;
        Skip; Skip;
        lGrid.Caption := z; Skip;
        t1 := z; Skip;
        t2 := z; Skip;
        t3 := z; Skip;
        t4 := z; Skip;
        StringGrid.FillColTitles(['', t1, t2, t3, t4]);
     end;

  else GlobalFail('%s', ['TAtomEditorForm.UpdateNB Typ ??']);
  end;
  DoAdjustSize;
end;

function TAtomEditorForm.CurTyp: Integer;
begin
  Result := TCmdCaption(CmdMap[cb.ItemIndex]).Typ;
end;

function TAtomEditorForm.GetAtom: Pointer;
var
  Typ: Integer;
  Par: TEventAtom;
  ParS: TEvParString absolute Par;
  ParDS: TEvParDStr absolute Par;
  ParDM: TEvParDMemo absolute Par;
  ParUV: TEvParUV absolute Par;
  ParGr: TEvParGrid absolute Par;
  d: DWORD;
  sl1, sl2, sl3, sl4: TStringColl;
begin
  Typ := CurTyp;
  case GetEventParamTyp(Typ) of
    eptVoid:
      begin
        Par := TEvParVoid.Create;
      end;
    eptString:
      begin
        ParS := TEvParString.Create;
        ParS.s := iString.Text;
      end;
    eptDMemo:
      begin
        ParDM := TEvParDMemo.Create;
        ParDM.MemoA := MemoA.Text;
        ParDM.MemoB := MemoB.Text;
      end;
    eptDStr:
      begin
        ParDS := TEvParDStr.Create;
        ParDS.StrA := iDStrA.Text;
        ParDS.StrB := iDStrB.Text;
      end;
    eptCombo:
      begin
        case Typ of
          eiRplStation     : d := StationId;
          eiRplModem       : d := ModemId;
          eiRplRestriction : d := RestrictionId;
          else d := // equation to avoid "unitialized" warning
                  GlobalFail('%s', ['TAtomEditorForm.GetAtom eptCombo']);
        end;
        ParUV := TEvParUV.Create;
        ParUV.d.DwordData := d;
      end;
    eptSpin:
      begin
        case Typ of
          eiAccDurMax      : d := AccDurMax;
          eiTrsDurMax      : d := TrsDurMax;
          eiAccSpeedMin    : d := MinInConnectSpeed;
          eiTrsSpeedMin    : d := MinOutConnectSpeed;
          eiAccCPSMin      : d := MinInCPS;
          eiTrsCPSMin      : d := MinOutCPS;
          eiAccBPSEfMin    : d := MinInEfBPS;
          eiTrsBPSEfMin    : d := MinOutEfBPS;
          eiNumRings       : d := NumRings;
          eiFreqPwdDur     : d := FreqPwdDur;
          eiFreqPwdSz      : d := FreqPwdSz;
          eiFreqPwdCnt     : d := FreqPwdCnt;
          eiFreqPubDur     : d := FreqPubDur;
          eiFreqPubSz      : d := FreqPubSz;
          eiFreqPubCnt     : d := FreqPubCnt;
          eiTimeDial       : d := TimeDial;
          eiRetry          : d := Retry;
          eiTrafShOut      : d := TrafShOut;
          eiTrafShIn       : d := TrafShIn;
          eiAccFilesSiz    : d := AccFilSiz;
          eiDelFilesSiz    : d := DelFilSiz;
          else
            d := // equation to avoid "unitialized" warning
                 GlobalFail('%s', ['TAtomEditorForm.GetAtom eptSpin']);
        end;
        ParUV := TEvParUV.Create;
        ParUV.d.DwordData := d;
      end;
    eptBool:
      begin
        ParUV := TEvParUV.Create;
        ParUV.d.BooleanData := RASHangUp;
{        case Typ of
          eiAccFreqs       : ParUV.d.BooleanData := DisableFreqs;
          else GlobalFail;
        end;}
      end;
    eptGrid:
      begin
        sl1 := TStringColl.Create;
        sl2 := TStringColl.Create;
        sl3 := TStringColl.Create;
        sl4 := TStringColl.Create;
        StringGrid.GetData([sl1, sl2, sl3, sl4]);
        ParGr := TEvParGrid.Create;
        ParGr.s := Trim(eGrid.Text);
        ParGr.L.Add(sl1);
        ParGr.L.Add(sl2);
        ParGr.L.Add(sl3);
        ParGr.L.Add(sl4);
      end;
    else GlobalFail('%s', ['TAtomEditorForm.GetAtom Typ ??']);
  end;
  Par.Typ := Typ;
  Result := Par;
end;

procedure TAtomEditorForm.cbChange(Sender: TObject);
begin
  UpdateNB;
  DoAdjustSize;
end;

procedure TAtomEditorForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i,li, Typ: Integer;
  Msgs: TStringColl;
begin
  if ModalResult <> mrOK then Exit;
  CanClose := False;
  Typ := CurTyp;
  case GetEventParamTyp(Typ) of
    eptDMemo:;
    eptDStr:
      case Typ of
        eiDoor: ;
        eiInputWdExtApp :;
        eiPassword:
          begin
            if not ValidateAddrs(iDStrA.Text, Handle) then Exit;
            if Trim(iDStrB.Text) = '' then
            begin
              DisplayErrorFmtLng(rsPswEmptyPwd, [1], Handle);
              Exit;
            end;
          end;
        else
        GlobalFail('%s', ['TAtomEditorForm.FormCloseQuery eptDStr']);
      end;
    eptString:
      case Typ of
        eiAccNodesRqd, eiAccNodesFrb, eiTrsNoCram, eiChatEnabled, eiChatDisabled, eiAccBack:
          if not {ValidateAddrs}ValidMaskAddressList(iString.Text, Handle) then Exit;
        eiModemCmdInit..eiModemCmdExit, eiModemCmdTest:
          begin
            i := Typ - eiModemCmdInit;
            if not ValidModemCmd(i, iString.Text, lString.Caption, Handle) then Exit;
          end;

        eiRestrictRqd,
        eiRestrictFrb:
          begin
            Msgs := TStringColl.Create;
            if not ValidRestrictEntry(iString.Text, Msgs, rspBoth) then
            begin
              case Typ of
                eiRestrictRqd: li := rsDRestInvReq;
                eiRestrictFrb: li := rsDRestInvFrb;
                  else
                  begin
                    GlobalFail('%s', ['TAtomEditorForm.FormCloseQuery Typ ??']);
                    Exit;  // to avoid uninitialized warning
                  end;
              end;
              DisplayError(FormatLng(li, [Trim(Msgs.LongString)]), Handle);
              FreeObject(Msgs);
              Exit;
            end;
          end;

        eiTrsFilesFrb,
        eiTrsFilesRqd,

        eiAccFilesRqd,
        eiAccFilesFrb,
        eiAccFilesFrK,

        eiChatBell,
        
        eiAccLinkRqd,
        eiAccLinkFrb,

        eiModemErrExtApp,
        eiInputWdReset : ;

        else GlobalFail('%s', ['TAtomEditorForm.FormCloseQuery eptString']);
      end;
    eptCombo: ;
    eptSpin: ;
    eptBool: ;
    eptVoid: ;
    eptGrid: ;
    else GlobalFail('%s', ['TAtomEditorForm.FormCloseQuery Typ ??']);
  end;
  CanClose := True;
end;


procedure TAtomEditorForm.cbComboClick(Sender: TObject);
var
  Typ: Integer;
begin
  Typ := CurTyp;
  case Typ of
    eiRplStation     : StationId := Cfg.Station.GetIdCombo(cbCombo);
    eiRplModem       : ModemId := Cfg.Modems.GetIdCombo(cbCombo);
    eiRplRestriction : RestrictionId := Cfg.Restrictions.GetIdCombo(cbCombo);
    else GlobalFail('%s', ['TAtomEditorForm.cbComboClick']);
  end;
end;

procedure TAtomEditorForm.StoreSpinValue(ATyp: Integer; i: DWORD);
begin
  case ATyp of
    eiAccDurMax      : AccDurMax          := i;
    eiTrsDurMax      : TrsDurMax          := i;
    eiAccSpeedMin    : MinInConnectSpeed  := i;
    eiTrsSpeedMin    : MinOutConnectSpeed := i;
    eiAccCPSMin      : MinInCPS           := i;
    eiTrsCPSMin      : MinOutCPS          := i;
    eiAccBPSEfMin    : MinInEfBPS         := i;
    eiTrsBPSEfMin    : MinOutEfBPS        := i;
    eiNumRings       : NumRings           := i;
    eiFreqPwdDur     : FreqPwdDur         := i;
    eiFreqPwdSz      : FreqPwdSz          := i;
    eiFreqPwdCnt     : FreqPwdCnt         := i;
    eiFreqPubDur     : FreqPubDur         := i;
    eiFreqPubSz      : FreqPubSz          := i;
    eiFreqPubCnt     : FreqPubCnt         := i;
    eiTimeDial       : TimeDial           := i;
    eiRetry          : Retry              := i;
    eiTrafShOut      : TrafShOut          := i;
    eiTrafShIn       : TrafShIn           := i;
    eiAccFilesSiz    : AccFilSiz          := i;
    eiDelFilesSiz    : DelFilSiz          := i;
    else GlobalFail('%s', ['TAtomEditorForm.StoreSpinValue']);
  end;
end;


procedure TAtomEditorForm.SetAtom(Atom: Pointer);
var
  a: TEventAtom absolute Atom;
  aStr: TEvParString absolute Atom;
  aDStr: TEvParDStr absolute Atom;
  aDMemo: TEvParDMemo absolute Atom;
  aUV: TEvParUV absolute Atom;
  aGrid: TEvParGrid absolute Atom;
  i: Dword;
  b: boolean;
  sl1, sl2, sl3, sl4: TStringColl;
begin
  case GetEventParamTyp(a.Typ) of
    eptString: iString.Text := aStr.s;
    eptDMemo:
      begin
        MemoA.Text := aDMemo.MemoA;
        MemoB.Text := aDMemo.MemoB;
      end;
    eptDStr:
      begin
        iDStrA.Text := aDStr.StrA;
        iDStrB.Text := aDStr.StrB;
      end;
    eptCombo:
      begin
        i := aUV.d.DwordData;
        case a.Typ of
          eiRplStation     : StationId := i;
          eiRplModem       : ModemId := i;
          eiRplRestriction : RestrictionId := i;
          else GlobalFail('%s', ['TAtomEditorForm.SetAtom eptCombo']);
        end;
      end;
    eptSpin:
      StoreSpinValue(a.Typ, aUV.d.DwordData);
    eptVoid:;
    eptBool:
      begin
         b := aUV.d.BooleanData;
         RASHangUp := b;
         cbCheckBox.Checked := b;
{        case a.Typ of
          eiAccFreqs : DisableFreqs := b;
          else GlobalFail;
        end;}
      end;
    eptGrid:
      begin
        sl1 := aGrid.L[0];
        sl2 := aGrid.L[1];
        sl3 := aGrid.L[2];
        sl4 := aGrid.L[3];
        StringGrid.SetData([sl1, sl2, sl3, sl4]);
        eGrid.Text := Trim(aGrid.s);
      end;
    else GlobalFail('%s', ['TAtomEditorForm.SetAtom']);
  end;
  UpdateNB;
end;

procedure TAtomEditorForm.sSpinChange(Sender: TObject);
begin
  if ((CurTyp = eiAccFilesSiz) or (CurTyp = eiDelFilesSiz)) and (sSpin.Value = sSpin.MinValue) then begin
     sSpin.Value := sSpin.MaxValue;
  end;
  StoreSpinValue(CurTyp, sSpin.Value);
end;

procedure TAtomEditorForm.cbCheckBoxClick(Sender: TObject);
begin
  RASHangUp := cbCheckBox.Checked;
end;

procedure TAtomEditorForm.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TAtomEditorForm.StringGridRowDelete(Sender: TObject;
  xRow: Integer);
begin
   RenumRows(Sender as TAdvGrid, xRow, -1);
end;

procedure TAtomEditorForm.StringGridRowInsert(Sender: TObject;
  xRow: Integer);
begin
   RenumRows(Sender as TAdvGrid, xRow, +1);
end;

procedure TAtomEditorForm.RenumRows;
var s: string;
    i: integer;
    t: integer;
begin
   for i := 1 to G.RowCount - 1 do begin
      s := UpperCase(G.Cells[1, i]);
      if pos('%GOTO', s) > 0 then begin
         try
            s := ExtractWord(2, s, [' ']);
            if s <> '' then begin
               t := StrToInt(s);
            end else begin
               t := StrToInt(G.Cells[4, i]);
            end;
            if t >= xRow then begin
               G.Cells[1, i] := '%GOTO';
               G.Cells[4, i] := IntToStr(t + Delta);
            end;
         except
            WinDlgT('Syntax Error: ' + G.Cells[1, i]);
         end;
         continue;
      end;
      s := Trim(G.Cells[4, i]);
      if s <> '' then begin
         try
            t := StrToInt(G.Cells[4, i]);
            if t >= xRow then begin
               G.Cells[4, i] := IntToStr(t + Delta);
            end;
         except
            WinDlgT('Syntax Error: ' + G.Cells[4, i]);
         end;
      end;
   end;
end;

end.
