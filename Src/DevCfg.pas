unit DevCfg;

interface

{$I DEFINE.INC}

uses
   Forms, Recs, StdCtrls, Controls, Classes, ExtCtrls
   {$IFDEF USE_TAPI} , xTAPI, TAPI {$ENDIF};

type
  TDeviceConfig = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    gbComDirect: TGroupBox;
    lComPort: TLabel;
    lRate: TLabel;
    cbCom: TComboBox;
    cbSpeed: TComboBox;
    gFlow: TGroupBox;
    cbCTS_RTS: TCheckBox;
    cbXon_Xoff: TCheckBox;
    gBits: TGroupBox;
    lBits: TLabel;
    bBits: TButton;
    cxTAPI: TComboBox;
    lTapiDevice: TLabel;
    cbDirect: TCheckBox;
    cbAccept: TCheckBox;
    procedure bBitsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbSpeedKeyPress(Sender: TObject; var Key: Char);
    procedure bHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbComChange(Sender: TObject);
    procedure cbDirectClick(Sender: TObject);
    procedure gbComDirectDblClick(Sender: TObject);
  private
    fData, fParity, fStop: Integer;
    Port: TPortRec;
{$IFDEF USE_TAPI}
    Numb: integer;
{$ENDIF}
    procedure SetData;
    procedure UpdateLineBits;
  end;

function EditPort(Port: Pointer): Boolean;

implementation

uses xBase, LineBits, LngTools, SysUtils, Windows, xMisc;

{$R *.DFM}

procedure TDeviceConfig.bBitsClick(Sender: TObject);
begin
   EditLineBits(fData, fParity, fStop);
   UpdateLineBits;
end;

function EditPort(Port: Pointer): Boolean;
var
   DeviceConfig: TDeviceConfig;
begin
   DeviceConfig := TDeviceConfig.Create(Application);
   DeviceConfig.Port := Port;
   DeviceConfig.SetData;
   Result := DeviceConfig.ShowModal = mrOK;
   FreeObject(DeviceConfig);
end;

procedure TDeviceConfig.SetData;
{$IFDEF USE_TAPI}
var
  i: integer;
{$ENDIF}
begin
{$IFNDEF USE_TAPI}
  cbCom.ItemIndex := cbCom.Items.IndexOf(ComName(Port.d.Port) + ':');
{$ELSE}
  if Port.d.Port < MaxComPorts then
    cbCom.ItemIndex := cbCom.Items.IndexOf(ComName(Port.d.Port) + ':')
  else
    cbCOM.ItemIndex := numb;
{$ENDIF}

  cbSpeed.Text := IntToStr(Port.d.BPS);
  cbCTS_RTS.Checked := Port.d.hFlow;
  cbXon_Xoff.Checked := Port.d.sFlow;
  fData := Port.d.Data;
  fParity := Port.d.Parity;
  fStop := Port.d.Stop and $0F;
  UpdateLineBits;
{$IFDEF USE_TAPI}
  cbDirect.Checked := boolean(Port.d.Stop and $80);
  cbAccept.Checked := boolean(Port.d.Stop and $40);
  cbAccept.Visible := not cbDirect.Checked;
  if Port.d.Port >= MaxComPorts then begin
     if Port.n <> '' then begin
        Port.d.Port := GetLineID(Port.n) + MaxComPorts;
     end;
     for i := 0 to cxTAPI.Items.Count - 1 do begin
        if integer(cxTAPI.Items.Objects[i]) = Port.d.Port - MaxComPorts then begin
           cxTAPI.ItemIndex := i;
        end;
     end;
  end;
{$ENDIF}
  cbComChange(nil)
end;

procedure TDeviceConfig.UpdateLineBits;
begin
   lBits.Caption := GetLineBits(fData, fParity, fStop);
end;

procedure TDeviceConfig.FormClose(Sender: TObject; var Action: TCloseAction);
var
   D  : DWORD;
   I  : integer;
   CP : TDevicePort;
begin
   if ModalResult <> mrOK then Exit;
   Port.d.Port := NameCom(cbCom.Text);
   D := Vl(cbSpeed.Text);
   if D = INVALID_VALUE then Port.d.BPS := DefBPS else Port.d.BPS := D;
   Port.d.hFlow := cbCTS_RTS.Checked;
   Port.d.sFlow := cbXon_Xoff.Checked;
   Port.d.Data := fData;
   Port.d.Parity := fParity;
   Port.d.Stop := fStop or
                 (byte(cbDirect.Checked) shl 7) or
                 (byte(cbAccept.Checked) shl 6);
{$IFDEF USE_TAPI}
   if cbCom.ItemIndex = numb then begin
      if cxTAPI.ItemIndex > -1 then begin
         if cxTAPI.ItemIndex < cxTAPI.Items.Count then begin
            Port.d.Port := integer(cxTAPI.Items.Objects[cxTAPI.ItemIndex]) + MaxComPorts;
            Port.n := cxTAPI.Items[cxTAPI.ItemIndex];
            PortsColl.Enter;
            for I := 0 to PortsColl.Count - 1 do begin
               CP := PortsColl[I];
               if CP is TTAPIPort then begin
                  if (CP as TTAPIPort).Device = Cardinal(Port.d.Port - MaxComPorts) then begin
                     (CP as TTAPIPort).PassThrough := cbDirect.Checked;
                     (CP as TTAPIPort).CallHandOff := cbAccept.Checked;
                     (CP as TTAPIPort).DevNam := Port.n;
                  end;
               end;
            end;
            PortsColl.Leave;
         end;
      end;
   end else begin
      Port.n := '';
   end;
{$ENDIF}
end;

procedure TDeviceConfig.cbSpeedKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
     #8, '0'..'9' :;
    else Key := #0;
  end;
end;

procedure TDeviceConfig.bHelpClick(Sender: TObject);
begin
   Application.HelpContext(HelpContext);
end;

procedure TDeviceConfig.FormCreate(Sender: TObject);
begin
   FillForm(Self, rsDeviceConfig);
   EnumSerialPorts(cbCom.Items);
   {$IFDEF USE_TAPI}
   numb := cbCom.Items.Count;
   cbCom.Items.Add('TAPI');
   FillTapiLines(cxTAPI.Items);
   {$ENDIF}
end;

procedure TDeviceConfig.cbComChange(Sender: TObject);
{$IFDEF USE_TAPI}
var
  usetapi: boolean;
begin
  usetapi := NameCom(cbCom.Items[cbCom.ItemIndex]) < 0;
  gFlow.visible := not usetapi;
  gBits.Visible := not usetapi;
  cbSpeed.Visible := not usetapi;
  lRate.Visible := not usetapi;
  lTapiDevice.Visible := usetapi;
  cxTapi.Visible := usetapi;
  cbDirect.Visible := usetapi;
  cbAccept.Visible := usetapi and not cbDirect.Checked;
{$ELSE}
begin
{$ENDIF}
end;

procedure TDeviceConfig.cbDirectClick(Sender: TObject);
begin
  cbAccept.Visible := not cbDirect.Checked;
end;

procedure TDeviceConfig.gbComDirectDblClick(Sender: TObject);
begin
   if cbCom.ItemIndex = numb then begin
      if cxTAPI.ItemIndex > -1 then begin
         if cxTAPI.ItemIndex < cxTAPI.Items.Count then begin
            lineConfigDialog(THandle(cxTAPI.Items.Objects[cxTAPI.ItemIndex]), 0, nil);
         end;
      end;
   end;
end;

end.


