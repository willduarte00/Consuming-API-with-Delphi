object Main: TMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Consulta de Casos de Covid 19 '
  ClientHeight = 620
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnTitle: TPanel
    Left = 0
    Top = 0
    Width = 780
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lbTitle: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 15
      Width = 774
      Height = 65
      Margins.Top = 15
      Align = alTop
      Alignment = taCenter
      Caption = 'Painel Covid-19'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -48
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 4
      ExplicitTop = 14
    end
  end
  object pnButtonsAndFilters: TPanel
    Left = 0
    Top = 111
    Width = 780
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 136
    ExplicitWidth = 918
    object edCountryName: TEdit
      Left = 66
      Top = 30
      Width = 341
      Height = 23
      Margins.Left = 300
      Margins.Right = 460
      Align = alCustom
      TabOrder = 0
      TextHint = 'Digite o pa'#237's para pesquisar'
      OnChange = edCountryNameChange
    end
    object btSearch: TButton
      Left = 413
      Top = 30
      Width = 90
      Height = 23
      Caption = 'Buscar Pais'
      TabOrder = 1
      OnClick = btSearchClick
    end
    object btClearSearch: TButton
      Left = 509
      Top = 30
      Width = 90
      Height = 23
      Caption = 'Limpar Busca'
      TabOrder = 2
      OnClick = btClearSearchClick
    end
    object btUpdateData: TButton
      Left = 605
      Top = 30
      Width = 90
      Height = 23
      Caption = 'Atualizar Dados'
      TabOrder = 3
      OnClick = btUpdateDataClick
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 184
    Width = 780
    Height = 436
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 304
    ExplicitWidth = 1101
    ExplicitHeight = 415
    object grItems: TDBGrid
      AlignWithMargins = True
      Left = 30
      Top = 3
      Width = 720
      Height = 408
      Margins.Left = 30
      Margins.Right = 30
      Margins.Bottom = 25
      Align = alClient
      DataSource = dsCovidData
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleName = 'Windows'
      OnTitleClick = grItemsTitleClick
    end
  end
  object pnSubtitle: TPanel
    Left = 0
    Top = 73
    Width = 780
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object lblSubtitle: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 774
      Height = 35
      Margins.Top = 0
      Align = alClient
      Alignment = taCenter
      Caption = 'Consulta de casos pelo mundo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
      ExplicitLeft = 0
      ExplicitTop = 28
      ExplicitWidth = 772
      ExplicitHeight = 26
    end
  end
  object cdsCovidData: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'idxCountryAsc'
        Fields = 'Country'
      end
      item
        Name = 'idxCountryDesc'
        DescFields = 'Country'
        Fields = 'Country'
        Options = [ixDescending]
      end
      item
        Name = 'idxConfirmedAsc'
        Fields = 'Confirmed'
      end
      item
        Name = 'idxConfirmedDesc'
        DescFields = 'Confirmed'
        Fields = 'Confirmed'
        Options = [ixDescending]
      end
      item
        Name = 'idxDeathsAsc'
        Fields = 'Deaths'
      end
      item
        Name = 'idxDeathsDesc'
        DescFields = 'Deaths'
        Fields = 'Deaths'
        Options = [ixDescending]
      end>
    Params = <>
    StoreDefs = True
    Left = 40
    Top = 16
    object cdsCovidDataCountry: TStringField
      DisplayLabel = 'Pa'#237's'
      DisplayWidth = 30
      FieldName = 'Country'
      Size = 100
    end
    object cdsCovidDataConfirmed: TIntegerField
      DisplayLabel = 'Casos Confirmados'
      DisplayWidth = 20
      FieldName = 'Confirmed'
    end
    object cdsCovidDataDeaths: TIntegerField
      DisplayLabel = 'Mortes'
      DisplayWidth = 20
      FieldName = 'Deaths'
    end
    object cdsCovidDataRecovered: TIntegerField
      DisplayLabel = 'Recuperados'
      DisplayWidth = 20
      FieldName = 'Recovered'
      OnGetText = cdsCovidDataRecoveredGetText
    end
    object cdsCovidDataUpdatedAt: TStringField
      DisplayLabel = 'Atualizado em'
      FieldName = 'UpdatedAt'
    end
  end
  object dsCovidData: TDataSource
    DataSet = cdsCovidData
    Left = 40
    Top = 72
  end
end
