unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MemTableDataEh, Data.DB, MemTableEh, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase, EhLibVCL, GridsEh,
  DBAxisGridsEh, DBGridEh, fib, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    mds_m: TMemTableEh;
    gr_m: TDBGridEh;
    tmpDB: TpFIBDatabase;
    tmpTrans: TpFIBTransaction;
    tmpQry: TpFIBQuery;
    ds_m: TDataSource;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    chbDate2: TCheckBox;
    Button2: TButton;
    chbDate1: TCheckBox;
    rbMale: TRadioButton;
    rbFemale: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chbDate2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chbDate1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  libname = 'c:\firebird\fb_3_0_10_x32\fbclient.dll';
  connstr = '127.0.0.1/31064:C:\proj\base\GENERAL_BASE.FDB';
  usrname = 'user_name=SYSDBA';
  pwd = 'password=cooladmin';
  chrset = 'lc_ctype=WIN1251';

  SQLtextMainBasic =
              'SELECT ' +
                'A.ID_ANKETA, A.ANK_LINKTOWN, T.TOWNVILLAGE, ' +
                'A.ANKLASTNAME, A.ANKFIRSTNAME, A.ANKTHIRDNAME, ' +
                'A.ANKDATEBORN, A.ANKPHONE, A.SHEDUL_EXISTS, A.SEX ' +
                ', MAX(V.DATEVISIT) AS DATEVISIT ' +
              'FROM TBL_TOWN T LEFT JOIN TBL_ANKETA A ON (A.ANK_LINKTOWN = T.ID_TOWN) ' +
                'LEFT JOIN TBL_VISITMAIN V ON (V.VIS_LINKANKETA = A.ID_ANKETA)';

  SQLtextMainWhere = 'A.ID_ANKETA IS NOT NULL';

  SQLtextMainGroupClause =
              'GROUP BY ' +
                'A.ID_ANKETA, A.ANK_LINKTOWN, T.TOWNVILLAGE, ' +
                'A.ANKLASTNAME, A.ANKFIRSTNAME, A.ANKTHIRDNAME, ' +
                'A.ANKDATEBORN, A.ANKPHONE, A.SHEDUL_EXISTS, A.SEX';

  SQLtextDetail =
          'SELECT ' +
          'V.ID_VISITMAIN AS ID_VISITMAIN, ' +
          'V.VIS_LINKANKETA AS VIS_LINKANKETA, ' +
          'V.VIS_LINKDOCTOR AS VIS_LINKDOCTOR, ' +
          'V.VIS_LINKCLINIC AS VIS_LINKCLINIC, ' +
          'V.DATEVISIT AS DATEVISIT, ' +
          'V.FIRSTVISIT AS FIRSTVISIT, ' +
          'D.DOC_PROFIL||'' ''||D.DOC_LASTNAME||'' ''|| LEFT (D.DOC_FIRSTNAME, 1) ' +
            '||''.''||LEFT(D.DOC_THIRDNAME, 1)||''.'' AS FAM_DOC, ' +
          'VB.DSTEXT_STR AS DSTEXT_STR, ' +
          'VB.DRUGTEXT_STR AS DRUGTEXT_STR, ' +
          'VB.MANIPTEXT_STR AS MANIPTEXT_STR, ' +
          'VB.RECOMTEXT_STR AS RECOMTEXT_STR ' +
        'FROM TBL_VISITMAIN V LEFT JOIN TBL_DOCTOR D ON (V.VIS_LINKDOCTOR = D.ID_DOCTOR) ' +
          'LEFT JOIN TBL_VISITBLOB VB ON (V.ID_VISITMAIN = VB.ID_VISITBLOB) ' +
        'WHERE (V.VIS_LINKANKETA = :PatID)';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//  Caption:= DateToStr(DateTimePicker1.Date);
//  Caption:=Extr(mds_m.FieldByName('DATEBORN').AsDateTime);
//  Caption:= formDateToStr(mds_m.FieldByName('DATEBORN').AsDateTime);
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  sb: TStringBuilder;
  b: Boolean;
begin
  b:= False;
  sb:= TStringBuilder.Create;
  try
    sb.Clear;

    if (System.Length(Trim(Edit1.Text)) <> 0) then
    begin
      b:= True;
      sb.AppendFormat('(UPPER(LASTNAME) LIKE UPPER(''%%%s%%''))',[Trim(Edit1.Text)]);
    end;

    if (System.Length(Trim(Edit2.Text)) <> 0) then
    begin
      if b then sb.Append(' AND ');
      b:= True;
      sb.AppendFormat('(UPPER(FIRSTNAME) LIKE UPPER(''%%%s%%''))',[Trim(Edit2.Text)]);
    end;

    if (System.Length(Trim(Edit3.Text)) <> 0) then
    begin
      if b then sb.Append(' AND ');
      b:= True;
      sb.AppendFormat('(UPPER(THIRDNAME) LIKE UPPER(''%%%s%%''))',[Trim(Edit3.Text)]);
    end;

    if chbDate1.Checked then
    begin
      if b then sb.Append(' AND ');
      b:= True;

      if chbDate2.Checked
        then sb.AppendFormat('((YEAR(DATEBORN) >= %s) AND (YEAR(DATEBORN) <= %s))',[
                          FormatDateTime('yyyy',DateTimePicker1.DateTime),
                          FormatDateTime('yyyy',DateTimePicker2.DateTime)
                          ])
        else sb.AppendFormat('(YEAR(DATEBORN) = %s)',[FormatDateTime('yyyy',DateTimePicker1.DateTime)]);

    end;

    if b then sb.Append(' AND ');

    if rbMale.Checked
      then sb.Append('(SEX = 1)')
      else sb.Append('(SEX = 0)');


    if (System.Length(Trim(sb.ToString)) = 0) then Exit;

    mds_m.Filtered:= False;
    mds_m.Filter:= sb.ToString;
    mds_m.Filtered:= True;

    Self.Caption:= Format('Найдено удовлетворяющих условию %d записей',[mds_m.RecordCount]);
  finally
    sb.Free;
  end;
end;

procedure TForm1.chbDate1Click(Sender: TObject);
begin
  DateTimePicker1.Enabled:= chbDate1.Checked;
  chbDate2.Enabled:= chbDate1.Checked;
  chbDate2Click(Sender);
end;

procedure TForm1.chbDate2Click(Sender: TObject);
begin
  DateTimePicker2.Enabled:= chbDate2.Checked and chbDate2.Enabled;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with tmpDB do
  begin
    DBName:= connstr;
    LibraryName:= libname;
    DBParams.Add(usrname);
    DBParams.Add(pwd);
    DBParams.Add(chrset);
    DefaultTransaction:= tmpTrans;
  end;

  with mds_m do
  begin
    FieldDefs.Add('ID', ftInteger);
    FieldDefs.Add('LASTNAME', ftString, 30);
    FieldDefs.Add('FIRSTNAME', ftString, 20);
    FieldDefs.Add('THIRDNAME', ftString, 20);
    FieldDefs.Add('DATEBORN', ftDate);
    FieldDefs.Add('PHONE', ftString, 30);
    FieldDefs.Add('TOWNVILLAGE', ftString, 100);
    FieldDefs.Add('DATEVISIT', ftDate);
    FieldDefs.Add('SHEDUL_EXISTS', ftInteger);
    FieldDefs.Add('SEX', ftShortint);

    CreateDataSet;
    Filtered:= False;
    Active := False;
  end;

  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;

  chbDate1.Checked:= False;
  chbDate2.Checked:= False;
  DateTimePicker1.DateTime:= Now;
  DateTimePicker2.DateTime:= Now;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  tmpDB.Connected:= True;

  try
    mds_m.DisableControls;
    try
      tmpTrans.StartTransaction;

      with tmpQry do
      begin
        Close;
        SQL.Text:= Format('%s WHERE %s %s',
                                  [SQLtextMainBasic,
                                  SQLtextMainWhere,
                                  SQLtextMainGroupClause]);
        ExecQuery;

        mds_m.Active:= True;

        while not Eof do
        begin
             mds_m.AppendRecord([
              Fields[0].AsInteger, //A.ID_ANKETA
              Fields[3].AsString, //A.ANKLASTNAME
              Fields[4].AsString, //A.ANKFIRSTNAME
              Fields[5].AsString, //A.ANKTHIRDNAME
              Fields[6].AsDate, //A.ANKDATEBORN
              Fields[7].AsString, //A.ANKPHONE
              Fields[2].AsString, //T.TOWNVILLAGE
              Fields[10].Value, //DATEVISIT
              Fields[8].AsInteger, //A.SHEDUL_EXISTS
              Fields[9].AsShort //A.SEX
              ]);
          Next;
        end;
      end;
      tmpTrans.Commit;
    except
      on E: EFIBError do
      begin
        tmpTrans.Rollback;
        Application.MessageBox(PChar(E.Message), 'Ошибка доступа к данным', MB_ICONERROR);
      end;
    end;
  finally
    mds_m.EnableControls;
  end;

  chbDate1Click(Sender);
end;

end.
