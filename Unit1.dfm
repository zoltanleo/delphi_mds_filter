object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 467
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    628
    467)
  TextHeight = 15
  object Button1: TButton
    Left = 537
    Top = 434
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object gr_m: TDBGridEh
    Left = 8
    Top = 8
    Width = 604
    Height = 305
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = ds_m
    DynProps = <>
    IndicatorTitle.TitleButton = True
    TabOrder = 1
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 320
    Width = 521
    Height = 140
    Anchors = [akLeft, akBottom]
    Caption = 'GroupBox1'
    TabOrder = 2
    object Edit1: TEdit
      Left = 24
      Top = 24
      Width = 185
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 24
      Top = 53
      Width = 185
      Height = 23
      TabOrder = 1
      Text = 'Edit2'
    end
    object Edit3: TEdit
      Left = 24
      Top = 82
      Width = 185
      Height = 23
      TabOrder = 2
      Text = 'Edit3'
    end
    object DateTimePicker1: TDateTimePicker
      Left = 400
      Top = 24
      Width = 105
      Height = 23
      Date = 45100.000000000000000000
      Time = 0.357057557870575700
      TabOrder = 3
    end
    object DateTimePicker2: TDateTimePicker
      Left = 400
      Top = 53
      Width = 105
      Height = 23
      Date = 45100.000000000000000000
      Time = 0.357326099539932300
      TabOrder = 4
    end
    object chbDate2: TCheckBox
      Left = 305
      Top = 56
      Width = 81
      Height = 17
      Caption = 'chbDate2'
      TabOrder = 5
      OnClick = chbDate2Click
    end
    object Button2: TButton
      Left = 430
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 6
      OnClick = Button2Click
    end
    object chbDate1: TCheckBox
      Left = 305
      Top = 30
      Width = 81
      Height = 17
      Caption = 'chbDate1'
      TabOrder = 7
      OnClick = chbDate1Click
    end
    object rbMale: TRadioButton
      Left = 240
      Top = 95
      Width = 65
      Height = 17
      Caption = 'rbMale'
      Checked = True
      TabOrder = 8
      TabStop = True
    end
    object rbFemale: TRadioButton
      Left = 311
      Top = 94
      Width = 75
      Height = 17
      Caption = 'rbFemale'
      TabOrder = 9
    end
  end
  object mds_m: TMemTableEh
    Params = <>
    Left = 272
    Top = 208
  end
  object tmpDB: TpFIBDatabase
    SQLDialect = 1
    Timeout = 0
    WaitForRestoreConnect = 0
    Left = 56
    Top = 184
  end
  object tmpTrans: TpFIBTransaction
    DefaultDatabase = tmpDB
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 56
    Top = 240
  end
  object tmpQry: TpFIBQuery
    Transaction = tmpTrans
    Database = tmpDB
    Left = 56
    Top = 304
  end
  object ds_m: TDataSource
    AutoEdit = False
    DataSet = mds_m
    Left = 272
    Top = 280
  end
end
