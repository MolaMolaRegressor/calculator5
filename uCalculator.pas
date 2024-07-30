unit uCalculator;

interface
uses
  System.SysUtils, System.Variants, uExample, System.Generics.Collections,
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

function TCalculator.CalculateAll: Double;
var
  I, priority, lowPrior: ShortInt;
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
end.
