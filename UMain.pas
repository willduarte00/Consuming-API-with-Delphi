unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  System.Net.HttpClient, System.Net.URLClient, System.JSON, System.Generics.Collections,
  Data.DB, Datasnap.DBClient, Vcl.DBGrids;

type
  TMain = class(TForm)
    pnTitle: TPanel;
    lbTitle: TLabel;
    pnButtonsAndFilters: TPanel;
    edCountryName: TEdit;
    btSearch: TButton;
    pnGrid: TPanel;
    cdsCovidData: TClientDataSet;
    cdsCovidDataCountry: TStringField;
    cdsCovidDataConfirmed: TIntegerField;
    cdsCovidDataDeaths: TIntegerField;
    cdsCovidDataRecovered: TIntegerField;
    cdsCovidDataUpdatedAt: TStringField;
    dsCovidData: TDataSource;
    grItems: TDBGrid;
    btClearSearch: TButton;
    btUpdateData: TButton;
    pnSubtitle: TPanel;
    lblSubtitle: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cdsCovidDataRecoveredGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure btSearchClick(Sender: TObject);
    procedure btClearSearchClick(Sender: TObject);
    procedure edCountryNameChange(Sender: TObject);
    procedure grItemsTitleClick(Column: TColumn);
    procedure btUpdateDataClick(Sender: TObject);
  private
    procedure LoadData;
    procedure PopulateCds(JsonArray: TJSONArray);
    procedure FilterdByCountry(Country: string);
    procedure SaveLog(const Text: String);
  end;

var
  Main: TMain;

const ListCountriesURL = 'https://covid19-brazil-api.now.sh/api/report/v1/countries';

implementation

uses
  System.DateUtils, System.UITypes, StrUtils;

{$R *.dfm}

procedure TMain.FormCreate(Sender: TObject);
begin
cdsCovidData.CreateDataSet;
LoadData;
end;

// Rotina criada para gerar um arquivo texto que sera utilizado para
// armazenar os logs do sistema. O arquivo será salvo na pasta onde esta o executável da aplicação.
procedure TMain.SaveLog(const Text: String);
var
  LogFilePath: string;
  LogFile: TextFile;
  DataHora: string;
begin
LogFilePath:=ExtractFilePath(ParamStr(0))+'Log.txt';
DataHora:=FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);
AssignFile(LogFile, LogFilePath);
if FileExists(LogFilePath) then
  Append(LogFile)
else
  Rewrite(LogFile);
try
  Writeln(LogFile, Format('[%s] %s', [DataHora, Text]));
finally
  CloseFile(LogFile);
  end;
end;

// Rotina criada para ordenar as informações do grid com um click no titulo da coluna
// Para a ordenação esta sendo utilizado o indice nos campos Pais, Confirmados e Mortes
// são apenas os campos citados que permitem ordenação.
procedure TMain.grItemsTitleClick(Column: TColumn);
begin
if MatchText(Column.FieldName, ['Country', 'Confirmed', 'Deaths']) then
  begin
  if cdsCovidData.IndexName='idx'+Column.FieldName+'Asc' then
    cdsCovidData.IndexName:='idx'+Column.FieldName+'Desc'
  else
    cdsCovidData.IndexName:='idx'+Column.FieldName+'Asc';
  end;
cdsCovidData.First;
end;

// Rotina crida para limpar o filtro. Como no evento "onChange" do edit esta fazendo o filto
// ao setar o texto do edit para vazio, dispara o evento "onChange" e limpa o filtro
procedure TMain.btClearSearchClick(Sender: TObject);
begin
edCountryName.Text:='';
end;

procedure TMain.btSearchClick(Sender: TObject);
begin
FilterdByCountry(edCountryName.Text);
end;

procedure TMain.btUpdateDataClick(Sender: TObject);
begin
btClearSearchClick(Self);
LoadData;
end;

// Rotina criada para realizar um filtro no cds pelo nome do país
procedure TMain.FilterdByCountry(Country: string);
begin
cdsCovidData.Filtered:=False;
if (Trim(Country)<>'') then
   cdsCovidData.Filter:=Format('Upper(Country) LIKE ''%s%%''', [UpperCase(Country)])
else
  cdsCovidData.Filter:='';
cdsCovidData.Filtered:=True;
end;

// Rotina criada para tratar a exibição do total de recuperados.
// Como a API esta devolvendo sempre null para esse campo, foi necessário um tratamento
// para exibir a informação de maneira amigável ao usuário.
procedure TMain.cdsCovidDataRecoveredGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
if not cdsCovidData.IsEmpty then
  begin
  if Sender.IsNull then
    Text:='Sem dados'
  else
    Text:=Sender.AsString;
  end
else
  Text:='';
end;

procedure TMain.edCountryNameChange(Sender: TObject);
begin
FilterdByCountry(edCountryName.Text);
end;


// Rotina criada para trazer as informações da API
// A rotina faz um Get no endpoint, como o retorno é um campo que contem uma lista
// foi necessário transformar a resposta da requisição em um objeto e após isso transformar
// os dados desse objeto em um array. Tendo coletado as informações no array,
// é chamado a rotina para popular o cds.
// A rotina contem tratamento de erros que exibem mensagens ao usuario e em caso de exceção
// exibe uma mensagem amigável e salva os detalhes da exceção em log.

procedure TMain.LoadData;
var
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
begin
HttpClient:=THTTPClient.Create;
JsonArray:=nil;
try
    try
      Response:=HttpClient.Get(ListCountriesURL);
        if (Response.StatusCode=200) then
          begin
          try
            JsonObject:=TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
            try
              if Assigned(JsonObject) then
                begin
                if JsonObject.TryGetValue<TJSONArray>('data', JsonArray) then
                  begin
                  if Assigned(JsonArray) then
                    PopulateCds(JsonArray)
                  else
                    MessageDlg('Nenhum dado foi retornado pela API.', mtInformation, [mbOk], 0);
                  end
                else
                  MessageDlg('O campo "data" não foi encontrado na resposta da API.',
                    mtWarning, [mbOk], 0);
                end
              else
                MessageDlg('Não foi possível consultar as informações, '+
                  'resposta inválida ou vazia.', mtError, [mbOk], 0);
            finally
              JsonObject.Free;
              end;
          except on E: Exception do
            begin
            SaveLog('Erro ao processar a requisição: '+sLineBreak+
              E.Message);
            MessageDlg('Ocorreu um erro ao processar a resposta da requisição.',
              mtError, [mbOk], 0);
            end;
          end;
          end
        else
          MessageDlg(Format('"Não foi possível concluir a requisição.'+
            'A API retornou um código de status inesperado: %d.', [Response.StatusCode]),
             mtError, [mbOk], 0);
    except on E: Exception do
      begin
      SaveLog('Erro ao realizar a requisição'+sLineBreak+E.Message);
      MessageDlg('Ocorreu um erro ao processar a requisição.', mtError, [mbOk], 0);
      end;
  end;
finally
  HttpClient.Free;
  end;
end;

// Rotina criada para popular o cds onde é recebido um jsonArray, percorrido esse array
// e cada item do array vira um registro no cds.
procedure TMain.PopulateCds(JsonArray: TJSONArray);
var
  I, RecoveredValue: Integer;
  Item: TJSONObject;
  Recovered: String;
  Date: TDateTime;

begin
if not cdsCovidData.Active then
  cdsCovidData.Open;
cdsCovidData.DisableControls;
try
  cdsCovidData.EmptyDataSet;
  for I:=0 to (JsonArray.Count-1) do
  begin
  Item:=JsonArray.Items[I] as TJSONObject;
  cdsCovidData.Append;
  cdsCovidData.FieldByName('Country').AsString:=Item.GetValue<string>('country');
  cdsCovidData.FieldByName('Confirmed').AsInteger:=Item.GetValue<Integer>('confirmed');
  cdsCovidData.FieldByName('Deaths').AsInteger:=Item.GetValue<Integer>('deaths');
  if Item.TryGetValue<string>('recovered', Recovered) and
    TryStrToInt(Recovered, RecoveredValue) then
    cdsCovidData.FieldByName('Recovered').AsInteger:=RecoveredValue
  else
    cdsCovidData.FieldByName('Recovered').Clear;
  Date:=ISO8601ToDate(Item.GetValue<string>('updated_at'));
  cdsCovidData.FieldByName('UpdatedAt').AsString:=FormatDateTime('dd/mm/yyyy hh:nn:ss', Date);
  cdsCovidData.Post;
  end;
finally
  cdsCovidData.First;
  cdsCovidData.EnableControls;
  end;
end;

end.
