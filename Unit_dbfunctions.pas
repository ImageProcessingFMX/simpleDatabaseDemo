unit Unit_dbfunctions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
   System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;



procedure ConnecttoDatabase(servername,
  databasename: String; aConnection: TFDConnection);  overload;

procedure ConnecttoDatabase(servername, databasename,
  Username, Password: String; aConnection: TFDConnection); overload;

procedure ConnecttoServer(aConnection: TFDConnection;
  servername: String);

procedure GetAllDatabases(servername: String;
  DatabaseList: TStringList);  overload;

procedure GetAllDatabases(aConnection: TFDConnection;
  DatabaseList: TStringList);   overload;

procedure GetAllTables(aConnection: TFDConnection;
  databasename: string; Tablelist: TStringList);

implementation


procedure ConnecttoDatabase(servername,
  databasename: String; aConnection: TFDConnection);
begin
  with aConnection do
  begin

    Close;
    DriverName := 'MSSQL';
    // create temporary connection definition
    with aConnection.Params do
    begin
      Clear;
      Add('DriverID=MSSQL');
      Add('Server=' + servername);
      Add('Database=' + databasename);
      Add('OSAuthent=Yes');
    end;
    Open;
  end;

end;

procedure ConnecttoDatabase(servername, databasename,
  Username, Password: String; aConnection: TFDConnection);
begin
  with aConnection do
  begin
    Close;
    DriverName := 'MSSQL';
    // create temporary connection definition
    with aConnection.Params do
    begin
      Clear;
      Add('DriverID=MSSQL');
      Add('Server=' + servername);
      Add('Database=' + databasename);
      Add('User=' + servername);
      Add('Password=' + databasename);
      Add('OSAuthent=Yes');
    end;
    Open;
  end;
end;

procedure ConnecttoServer(aConnection: TFDConnection;
  servername: String);
begin
  with aConnection do
  begin

    Close;

    {$IFDEF  MSWINDOWS}
    // create temporary connection definition
    with Params do
    begin
      Clear;
      Add('DriverID=MSSQL');
      Add('Server=' + servername);
      Add('OSAuthent=Yes');
    end;
    {$ENDIF}

        {$IFDEF  LINUX}
    //  create temporary connection definition
    //  DriverID=ODBC Driver 17 for SQL
    with Params do
    begin
      Clear;
      Add('DriverID=ODBC');
      Add('Server=' + servername);
      Add('OSAuthent=Yes');
    end;
    {$ENDIF}

    Open;
  end;
end;


procedure GetAllDatabases(servername: String;
  DatabaseList: TStringList);
var
  tempConnection: TFDConnection;
begin

  tempConnection := TFDConnection.Create(nil);
  try
    ConnecttoServer(tempConnection, servername);
    GetAllDatabases(tempConnection, DatabaseList);
  finally
    tempConnection.Free;
  end;
end;


procedure GetAllDatabases(aConnection: TFDConnection;
  DatabaseList: TStringList);

var
  aFDQuery: TFDQuery;
begin

  aFDQuery := TFDQuery.Create(nil);
  aFDQuery.Connection := aConnection;
  aFDQuery.Sql.Add('select * from sys.databases');
  aFDQuery.Open;
  while not aFDQuery.Eof do
  begin
    DatabaseList.Add(aFDQuery.Fields[0].asString);
    aFDQuery.Next;
  end;

  aFDQuery.Close;
  aFDQuery.Free;

end;

procedure GetAllTables(aConnection: TFDConnection;
  databasename: string; Tablelist: TStringList);
var
  aFDQuery: TFDQuery;
begin
  aFDQuery := TFDQuery.Create(nil);
  aFDQuery.Connection := aConnection;
  aFDQuery.Sql.Add('use ' + databasename + '; select * from sys.tables');
  aFDQuery.Open;

  while not aFDQuery.Eof do
  begin
    Tablelist.Add(aFDQuery.Fields[0].asString);
    aFDQuery.Next;
  end;

  aFDQuery.Close;
  aFDQuery.Free;
end;




end.
