unit uExample;

interface

uses
  uActions, Classes, System.Generics.Collections;

type
  TExample = Record
  public
    numbers  : TList<Double>;
    actions  : TList<TActions>;
  end;

implementation

end.
