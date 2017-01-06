program TestParams;

uses
  SysUtils;

var
  Input1, Input2, Output: Integer;

begin
  if ParamCount > 1 then
  begin
    Input1 := StrToInt(ParamStr(1));
    Input2 := StrToInt(ParamStr(2));
    Output := Input1 + Input2;
    WriteLn(Format('%d + %d = %d', [Input1, Input2, Output]));
  end
  else
  begin
    WriteLn('Syntax: ', ParamStr(0));  { Just to demonstrate ParamStr(0) }
    WriteLn('There are two parameters required. You provided ', ParamCount);
  end;
end.
