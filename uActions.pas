unit uActions;

interface

type
  TActionsNames = (Plus, Minus, Divide, Multiply);
  TActions = Record
  public
    actName: TActionsNames;
    prior: ShortInt;
  End;
implementation

end.
