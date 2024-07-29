unit uRecord;

interface

uses
  uActions, Classes, System.Generics.Collections;

type
  TExample = Record
  public
    numbers  : TList<Double>;//Array of Double;
    actions  : TList<TActions>;//
  end;

implementation

end.
