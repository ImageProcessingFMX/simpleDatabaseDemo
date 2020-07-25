unit Unit_FD.FMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,  Unit_dbfunctions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, System.IOUtils,

   System.Rtti, FMX.Grid.Style, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.ScrollBox,
  FMX.Grid, FMX.Layouts, FMX.ListBox, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.ODBCBase;

type
  TForm_dbtest = class(TForm)
    edt_server: TEdit;
    edt_databasename: TEdit;
    pnl1: TPanel;
    statusbar: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    btn_ConnectDatabase: TButton;
    con1: TFDConnection;
    btn_getOBJTable: TButton;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    StringGrid1: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    lst_servernames: TListBox;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    lst_Databases: TListBox;
    lbl3: TLabel;
    edt_tablename: TEdit;
    lst_databasetablelist: TListBox;
    btn_Connect2Server: TButton;
    btn_LoadServerNames: TButton;
    dlgOpenFile: TOpenDialog;
    lbl4: TLabel;
    procedure btn_ConnectDatabaseClick(Sender: TObject);
    procedure btn_getOBJTableClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lst_servernamesDblClick(Sender: TObject);
    procedure btn_Connect2ServerClick(Sender: TObject);
    procedure lst_DatabasesDblClick(Sender: TObject);
    procedure lst_databasetablelistDblClick(Sender: TObject);
    procedure btn_LoadServerNamesClick(Sender: TObject);
  private
    { Private declarations }
    Fservername: String;
    Fdatabasename: String;
    Fusername: String;
    FPassword: String;

    FTablename: string;

    Fpath : TPath;

    procedure GUI2Params(Sender: TObject);
    procedure LoadServerNames2Listbox(filename: string);
  public
    { Public declarations }
  end;

var
  Form_dbtest: TForm_dbtest;

implementation

{$R *.fmx}













procedure TForm_dbtest.btn_Connect2ServerClick(Sender: TObject);
var
  FDatabaseList: TStringList;
begin
  GUI2Params(nil);

  ConnecttoServer(con1, Fservername);

  statusbar.text := ' Connect to a server ..... ';

  FDatabaseList := TStringList.Create;
  try
    GetAllDatabases(Fservername, FDatabaseList);

    lst_Databases.Items.Clear;

    lst_Databases.Items.AddStrings(FDatabaseList);
  finally
    FDatabaseList.Free;
  end;

  statusbar.text := ' double click a database name and press [3] ';

end;

procedure TForm_dbtest.btn_ConnectDatabaseClick(Sender: TObject);
var
  FTableList: TStringList;
begin
  GUI2Params(nil);

  ConnecttoDatabase(Fservername, Fdatabasename, con1);

  statusbar.text := ' Connect to a database ..... ';

    FTableList := TStringList.Create;
  try
    GetAllTables(Con1 ,Fdatabasename, FTableList);

    lst_databasetablelist.Items.Clear;

    lst_databasetablelist.Items.AddStrings(FTableList);
  finally
    FTableList.Free;
  end;

  statusbar.text := ' double click a datbase table name and press [4] ';
end;

procedure TForm_dbtest.btn_getOBJTableClick(Sender: TObject);
var
  conStatus: Boolean;
begin
  try

    FTablename := edt_tablename.text;

    conStatus := con1.Connected;
    if conStatus = TRUE then
    begin
      FDQuery1.SQL.Add('select * from ' + FTablename);

      FDQuery1.Active := TRUE;
    end
    else
    begin
      ShowMessage('No DB Connection established.');
    end;
  finally;
     statusbar.text := ' done :-) ?? ';
  end;

end;

procedure TForm_dbtest.LoadServerNames2Listbox(filename : string );
var  SQLServerfilenames : TStringList ;
begin
    SQLServerfilenames :=TStringList.Create ;

    try
       SQLServerfilenames.Loadfromfile ( filename ) ;

       lst_servernames.Items.Clear;

       lst_servernames.Items.AddStrings(SQLServerfilenames);

    finally
       SQLServerfilenames.Free ;
    end;


end;


procedure TForm_dbtest.btn_LoadServerNamesClick(Sender: TObject);
var  SQLServerfilename : TStringList ;
begin
   if dlgOpenFile.Execute then
          begin
          statusbar.text := ' Load a text file with all server names in your net work ! ';

          LoadServerNames2Listbox ( dlgOpenFile.FileName );

          end;

    statusbar.text := ' double click a server name and press [2] ';
end;

procedure TForm_dbtest.FormShow(Sender: TObject);
begin
  statusbar.text := ' Connect to da database uning FIREDAC & MSSQL';
end;

procedure TForm_dbtest.GUI2Params(Sender: TObject);
begin
  Fservername := edt_server.text;

  Fdatabasename := edt_databasename.text;
end;

procedure TForm_dbtest.lst_databasetablelistDblClick(Sender: TObject);
begin
   edt_tablename.Text := lst_databasetablelist.Items[lst_databasetablelist.ItemIndex];
end;

procedure TForm_dbtest.lst_DatabasesDblClick(Sender: TObject);
begin
  edt_databasename.text := lst_Databases.Items[lst_Databases.ItemIndex];
end;

procedure TForm_dbtest.lst_servernamesDblClick(Sender: TObject);
begin
  edt_server.text := lst_servernames.Items[lst_servernames.ItemIndex];
end;

end.
