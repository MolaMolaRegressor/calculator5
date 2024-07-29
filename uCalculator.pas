unit uCalculator;

interface
uses
  System.SysUtils, System.Variants, uRecord, System.Generics.Collections,
  uActions;

type
  TCalculator = class
    public
      memoryNum: Double;
      example: TExample;
      numberOpenBrackets: ShortInt;
      function CalculateAll: Double;
      constructor Create;
  end;
implementation

constructor TCalculator.Create;
begin
  inherited;
  example.numbers := TList<Double>.Create;
  example.actions := TList<TActions>.Create;
end;

{
function TCalculator.CalculateFirstPrior(ANum: ShortInt;AStr : string): string;
var
  I, J, iNumFirst, iNumSecond: ShortInt;
  firstNum, secondNum, answ: Double;
begin
  for I := 1 to ANum do
  begin
    for J := 1 to AStr.Length do
    begin
      if (AStr[J] = '*') or (AStr[J] = '/') then
      begin
        iNumFirst := J - 1;
        while not((iNumFirst = 1) or (AStr[iNumFirst -1 ] in ['+', '-', '*', '/'])) do
          iNumFirst := iNumFirst - 1;
        firstNum := StrToFloat(Copy(AStr, iNumFirst, J-iNumFirst));
        iNumSecond := J + 1;
        while not((iNumSecond = AStr.Length) or (AStr[iNumSecond + 1] in ['+', '-', '*', '/'])) do
          iNumSecond := iNumSecond + 1;
        secondNum := StrToFloat(Copy(AStr, J + 1, iNumSecond - J));
        if AStr[J] = '*' then
          answ := firstNum * secondNum
        else
        begin
          if (secondNum <> 0) then
            answ := firstNum / secondNum
          else
            begin
              Result := 'Невозможно деление на 0';
              exit;
            end;
        end;
        AStr := Copy(AStr, 1, iNumFirst-1) + FloatToStr(answ) + Copy(AStr, iNumSecond + 1);
        break;
      end;
    end;
  end;
  Result := AStr;
end;
}


{
function TCalculator.CalculateSecondPrior(ANum: ShortInt;AStr : string): string;
var
  I, J, iNumSecond: ShortInt;
  firstNum, secondNum, answ: Double;
begin
  for I := 1 to ANum do
  begin
    for J := 1 to AStr.Length do
    begin
      if (AStr[J] = '+') or (AStr[J] = '-') then
      begin
        iNumSecond := J + 1;
        firstNum := StrToFloat(Copy(AStr, 1, J - 1));
        while not((iNumSecond = AStr.Length) or (AStr[iNumSecond + 1] in ['+', '-'])) do
          iNumSecond := iNumSecond + 1;
        secondNum := StrToFloat(Copy(AStr, J + 1, iNumSecond - J));
        if AStr[J] = '+' then
          answ := firstNum + secondNum
        else
          answ := firstNum - secondNum;
        AStr := FloatToStr(answ) + Copy(AStr, iNumSecond + 1);
        break;
      end;
    end;
  end;
  Result := AStr;
end;
}

function TCalculator.CalculateAll: Double;
var
  I, priority, lowPrior: ShortInt;
  //arrNum: array of Double;
  //arrAct: array of TActions;
begin
  I := 0;
  priority := 0;
  lowPrior := 10;
  for I := 0 to example.actions.Count - 1 do
  begin
    if lowPrior > example.actions[I].prior then
      lowPrior := example.actions[I].prior;
  end;

  for priority := lowPrior to 3 do
  begin
    I := 0;
    while I < example.actions.Count	do
    begin
      if priority = example.actions[I].prior	then
      begin
        case example.actions[I].actName of
        Plus:
          example.numbers[I] := example.numbers[I] + example.numbers[I + 1];
        Minus:
          example.numbers[I] := example.numbers[I] - example.numbers[I + 1];
        Divide:
          example.numbers[I] := example.numbers[I] / example.numbers[I + 1];
        Multiply:
          example.numbers[I] := example.numbers[I] * example.numbers[I + 1];
        end;
        example.numbers.Delete(I+1);
        example.actions.Delete(I);
        I:= I - 1;
      end;
      I:= I + 1;
    end;
  end;
  Result :=  example.numbers[0];
  example.numbers.Delete(0);
  numberOpenBrackets := 0;
end;
{
function TCalculator.CalculateAll(AStr : string): string;
var
  I, J, iNumFirst, iNumSecond, numAct, numFirstAct: ShortInt;
  firstNum, secondNum, answ: Double;
  actFirst, actSecond: Char;
begin
  numAct := 0;
  numFirstAct := 0;
  firstNum := 0;
  iNumFirst := 1;
  for I := 1 to AStr.Length do
  begin
    if (AStr[I] in ['+', '-']) then
      numAct := numAct + 1;
    if (AStr[I] in ['*', '/']) then
      numFirstAct := numFirstAct + 1;
  end;
  if AStr[AStr.Length] in ['*','/','-','+'] then
  begin
    Result := 'Некорректная запись';
    exit;
  end;
  AStr := CalculateFirstPrior(numFirstAct, AStr);
  if AStr <> 'Невозможно деление на 0' then
    AStr := CalculateSecondPrior(numAct, AStr);
  Result := AStr;
end;
}

end.
