unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uCalculator, uActions, uExample;

type
  TMainFm = class(TForm)
    lblOutput: TLabel;
    lblHistory: TLabel;
    btnEqual: TButton;
    btn1: TButton;
    btn4: TButton;
    btn2: TButton;
    btn5: TButton;
    btn3: TButton;
    btn6: TButton;
    btn9: TButton;
    btn7: TButton;
    btn8: TButton;
    btnMultiply: TButton;
    btnDivide: TButton;
    btnMinus: TButton;
    btnPlus: TButton;
    btn0: TButton;
    btnC: TButton;
    btnCe: TButton;
    btnDot: TButton;
    btnBackspace: TButton;
    btnMS: TButton;
    btnMPlus: TButton;
    btnMRead: TButton;
    btnMMin: TButton;
    btnBrackets: TButton;
    procedure btnEqualClick(Sender: TObject);
    procedure btnNumClick(Sender: TObject);
    procedure btnActClick(Sender: TObject);
    procedure btnDotClick(Sender: TObject);
    procedure btnCClick(Sender: TObject);
    procedure btnMSClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMReadClick(Sender: TObject);
    procedure btnMActionClick(Sender: TObject);
    function CheckStr: Boolean;
    procedure btnBracketsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFm: TMainFm;
  vCalc: TCalculator;

implementation

{$R *.dfm}


procedure TMainFm.btnNumClick(Sender: TObject);
begin
  if (lblOutput.Caption = '0') or (lblOutput.Caption = 'Невозможно деление на 0')
  or (lblOutput.Caption = 'Некорректная запись') then
  begin
    lblOutput.Caption := '';
  end;
  lblOutput.Caption := lblOutput.Caption + (Sender as TButton).Caption;
end;

procedure TMainFm.FormCreate(Sender: TObject);
begin
  vCalc := TCalculator.Create;
  btnPlus.Tag := Ord(TActionsNames.Plus);
  btnMinus.Tag := Ord(TActionsNames.Minus);
  btnDivide.Tag := Ord(TActionsNames.Divide);
  btnMultiply.Tag := Ord(TActionsNames.Multiply);
end;

procedure TMainFm.btnActClick(Sender: TObject);
var
  str, numStr : string;
  I: ShortInt;
  action: TActions;
begin
  str := lblOutput.Caption;
  if not(lblOutput.Caption[str.Length] in ['+','-','/','*']) and
  ((lblOutput.Caption <> 'Невозможно деление на 0') and
  (lblOutput.Caption <> 'Некорректная запись')) then
  begin
    numStr := '';
    I:= str.Length;
    while (I > 0) and (ord(str[I]) > 47) and (ord(str[I]) < 58) do
    begin
      numStr:= str[I] + numStr;
      I:= I - 1;
    end;
    vCalc.example.numbers.Add(StrToFloat(numStr));
    action.actName := TActionsNames((Sender as TButton).Tag);
    case action.actName of
      Plus:
        action.prior := 2;
      Minus:
        action.prior := 2;
      Divide:
        action.prior := 1;
      Multiply:
        action.prior := 1;
    end;
    vCalc.example.actions.Add(action);
    //lblOutput.Caption := FloatToStr(vCalc.example.numbers[0]) + '78';
    lblOutput.Caption := lblOutput.Caption + (Sender as TButton).Caption;
  end;
end;

procedure TMainFm.btnBracketsClick(Sender: TObject);
var
  str: string;
  I, IAct, numBrackets : ShortInt;
  action : TActions;
begin
  str:= lblOutput.Caption;
  numBrackets := vCalc.numberOpenBrackets;
  I := str.Length;
  IAct := vCalc.example.actions.Count - 1;
  if (str[I] in ['*','/','+','-','(']) then
  begin
    vCalc.numberOpenBrackets := vCalc.numberOpenBrackets + 1;
    lblOutput.Caption := str + '('
  end
  else
  begin
    if (str = '0') then
      lblOutput.Caption := '('
    else
    begin
      while I > 1 do
      begin
        if lblOutput.Caption[I] = '(' then
        begin
           if numBrackets > 0 then
            numBrackets := numBrackets - 1
           else
            break;
        end;
        if lblOutput.Caption[I] in ['*','/','+','-'] then
        begin
          action.actName := vCalc.example.actions[IAct].actName;
          action.prior :=  vCalc.example.actions[IAct].prior - 4;
          vCalc.example.actions[IAct] := action;
          IAct := IAct - 1;
        end;
        I := I - 1;
      end;
      if vCalc.numberOpenBrackets > 0 then
      begin
        vCalc.numberOpenBrackets := vCalc.numberOpenBrackets - 1;
        lblOutput.Caption := str + ')';
      end;
            //lblOutput.Caption := IntToStr( vCalc.example.actions[IAct+1].prior)
    end;
  end;
end;

procedure TMainFm.btnCClick(Sender: TObject);
begin
   lblOutput.Caption := '0';
   lblHistory.Caption := '';
end;

procedure TMainFm.btnDotClick(Sender: TObject);
var
  I: ShortInt;
  str: string;
begin
  str := lblOutput.Caption;
  I := str.Length;
  while (not (lblOutput.Caption[I] in ['+', '-', '*', '/','('])) and (I > 1) do
  begin
    if lblOutput.Caption[I] = ',' then
      exit ;
    I := I - 1;
  end;
  lblOutput.Caption := lblOutput.Caption + (Sender as TButton).Caption;
end;

procedure TMainFm.btnEqualClick(Sender: TObject);
var
  str, numStr: string;
  I: ShortInt;
begin
  if vCalc.numberOpenBrackets	> 0 then
  begin
    for I := 0 to vCalc.numberOpenBrackets do
      btnBracketsClick(Sender);
  end;

  str := lblOutput.Caption;
  if str[str.Length] in ['*','/','+','-'] then
  begin
    str := str.Substring(1, str.Length - 2);
  end
  else
  begin
    numStr := '';
    I:= str.Length;
    while str[I] = ')' do
      I:= I - 1;
    while (I > 0) and (ord(str[I]) > 47) and (ord(str[I]) < 58) or (str[I] = ',') do
    begin
      numStr:= str[I] + numStr;
      I:= I - 1;
    end;
  vCalc.example.numbers.Add(StrToFloat(numStr));
  end;
    
  lblHistory.Caption := str + ' =';
  lblOutput.Caption:= FloatToStr(vCalc.CalculateAll());
end;

procedure TMainFm.btnMActionClick(Sender: TObject);
begin
   if CheckStr then
   begin
   if (Sender as TButton).Caption = 'M+' then
      vCalc.memoryNum := vCalc.memoryNum + StrToFloat(lblOutput.Caption)
    else
      vCalc.memoryNum := vCalc.memoryNum - StrToFloat(lblOutput.Caption);
   end;
end;

procedure TMainFm.btnMReadClick(Sender: TObject);
begin
  lblOutput.Caption := lblOutput.Caption + FloatToStr(vCalc.memoryNum);
end;

procedure TMainFm.btnMSClick(Sender: TObject);
begin
  if CheckStr then
    vCalc.memoryNum := StrToFloat(lblOutput.Caption);
end;

function TMainFM.CheckStr: Boolean;
var
  I: ShortInt;
  str: string;
begin
  Result := True;
  str := lblOutput.Caption;
  for I := 1 to str.Length do
  begin
    if str[I] in ['*','/','+','-'] then
    begin
      lblOutput.Caption := 'Некорректная запись';
      Result:= False;
      exit;
    end;
  end;
end;
end.

