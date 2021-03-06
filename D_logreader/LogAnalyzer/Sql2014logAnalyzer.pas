unit Sql2014logAnalyzer;

interface

uses
  windows, Classes, I_logAnalyzer, LogtransPkg, p_structDefine, LogSource, dbDict, System.SysUtils,
  Contnrs, BinDataUtils, SqlDDLs, LogtransPkgMgr, hexValUtils,
  System.Generics.Collections, Xml.XMLIntf;

type
  TSql2014logAnalyzer = class;
  /// <summary>
  /// 一个独立的行数据
  /// </summary>
  Tsql2014RowData = class(TObject)
    Fields: TList;
    FlogAnalyzer: TSql2014logAnalyzer;
    //Table: TdbTableItem;
  public
    function getFieldStrValue(FieldName: string): string;
    function getField(FieldName: string):PdbFieldValue;overload;
    function getField(col_id: Integer):PdbFieldValue;overload;
    constructor Create(logAnalyzer:TSql2014logAnalyzer);
    destructor Destroy; override;
  end;
  /// <summary>
  /// 一个完整的操作（可能包含多个Lsn的运行结果
  /// 缓存日志（COMPENSATION可能会修改数据
  /// </summary>
  Tsql2014Opt = class(TObject)
    OperaType: TOperationType;
    page:TPage_Id;
    table:TdbTableItem;
    R0:Pointer;                    //新数据
    R1:Pointer;                    //老数据
    UniqueClusteredKeys:TBytes;
    UniqueClusteredKeysStr:string;
    deleteFlag:Boolean;            //数据删除标志（ 为ture的数据不生产Sql
    //
    old_data:Tsql2014RowData;
    new_data:Tsql2014RowData;
    //特殊变量
    deleteFromUpdate:Boolean;
    isMixData:Boolean;
    //如果按Pageid处理，这个字段其实没什么用。因为冲突在页内就已经处理了
    ___SourceId:Cardinal;
  public
    constructor Create;
    destructor Destroy; override;
  end;


  TMIX_DATA_Item = class(TObject)
    Idx: QWORD;
    pageid:TPage_Id;
    data: TBytes;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TMIX_DATAs = class(TObject)
    FItems: TObjectList;
  public
    function GetItem_Idx(Key: Qword): TMIX_DATA_Item;
    function GetItem_Pageid(pageid:TPage_Id): TMIX_DATA_Item;
    procedure add(idx:QWORD;pageid:TPage_Id;data:TBytes);
    constructor Create;
    destructor Destroy; override;
  end;


  TDDL_IDX_stats = class(TObject)
    tableId:Integer;
    idxName:string;
    isCLUSTERED:Boolean;
    isUnique:Boolean;
  end;

  TDDL_RsCols = class(TObject)
    rowsetid: int64;
    ColId: Integer;
    statusCode: Integer;
    DataOffset: Integer;
    Nullbit: Integer;
    TableObj:TdbTableItem;
  end;

  TSql2014logAnalyzer = class(TlogAnalyzer)
  private
    FPkgMgr:TTransPkgMgr; //事务队列
    Hvu:THexValueHelper;
    TransId: TTrans_Id;
    TransBeginTime: TDateTime;
    TransCommitTime: TDateTime;
    TransCommitLsn:Tlog_LSN;
    FLogSource: TLogSource;
    //每个事务开始要重新初始化以下对象
    FRows: TObjectList;
    DDL: TDDLMgr;
    //AllocUnitMgr: TAllocUnitMgr;
    tmp_Alloc: TDictionary<UInt64, Integer>;
    tmp_Parti: TDictionary<UInt64, Integer>;
    IDXs:TDDL_Idxs_ColsMgr;
    IDXstats:TObjectList;
    Rscols:TObjectList;
    function binEquals(v1, v2: TBytes): Boolean;
    function getDataFrom_TEXT_MIX(idx: TBytes): TBytes;
    function GenSql: string;
    function GenXML: string;
    function DML_BuilderSql(aRowData: Tsql2014Opt): string;
    function DML_BuilderSql_Insert(aRowData: Tsql2014Opt): string;
    function DML_BuilderSql_Update(aRowData: Tsql2014Opt): string;
    function DML_BuilderSql_Delete(aRowData: Tsql2014Opt): string;
    function DML_BuilderSql_Where(aRowData: Tsql2014Opt): string;
    function DML_BuilderXML(aRowData: Tsql2014Opt): string;
    procedure DML_BuilderXML_Field(pdd: PdbFieldValue; ownNode: IXMLNode; nodeName: string = 'a'; IncludeColName:Boolean = True);
    function DML_BuilderXML_Insert(aRowData: Tsql2014Opt): string;
    function DML_BuilderXML_Update(aRowData: Tsql2014Opt): string;
    function DML_BuilderXML_Delete(aRowData: Tsql2014Opt): string;
    procedure PriseDDLPkg(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_sysrscols(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_sysschobjs(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_sysobjvalues(DataRow: Tsql2014Opt);
    function GenSql_CreateDefault(ddlitem: TDDLItem): string;
    function GenSql_CreateTable(ddlitem: TDDLItem): string;
    procedure PriseDDLPkg_D(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_D_sysschobjs(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_D_syscolpars(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_U(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_U_sysschobjs(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_U_syscolpars(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_U_sysrscols(DataRow: Tsql2014Opt);
    function GenSql_DDL_Insert(ddlitem: TDDLItem_Insert): string;
    function GenSql_DDL_Delete(ddlitem: TDDLItem_Delete): string;
    function GenSql_DDL_Update(ddlitem: TDDLItem_Update): string;
    function GenSql_DropConstraint(ddlitem: TDDL_Delete_Constraint): string;
    function GenSql_DropTable(ddlitem: TDDL_Delete_Table): string;
    function GenSql_DropColumn(ddlitem: TDDL_Delete_Column): string;
    function GenSql_CreatePrimaryKey(ddlitem: TDDL_Create_PrimaryKey): string;
    function GenSql_CreateUniqueKey(ddlitem: TDDL_Create_UniqueKey): string;
    function GenSql_CreateCheck(ddlitem: TDDL_Create_Check): string;
    function GenSql_CreateColumn(ddlitem: TDDL_Create_Column): string;
    function GenSql_UpdateColumn(ddlitem: TDDL_Update_Column): string;
    function GenSql_UpdateRenameObj(ddlitem: TDDL_Update_RenameObj): string;
    procedure PriseDDLPkg_sysiscols(DataRow: Tsql2014Opt);
    procedure PriseDDLPkg_syscolpars(DataRow: Tsql2014Opt);
    procedure DDLClear;
    procedure DDLPretreatment;
    procedure PriseDDLPkg_sysidxstats(DataRow: Tsql2014Opt);
    procedure logTranPkg(FTranspkg: TTransPkg);
    function getDataFrom_TEXT_MIX_DATA(Page: TPage_Id): TBytes;
    procedure PriseDDLPkg_U_sysrowsets(DataRow: Tsql2014Opt);
    function DML_BuilderXML_Truncate(ddlitem: TDDL_truncate_table): string;
    procedure Execute3(FTranspkg: TTransPkg);
  public
    /// <summary>
    ///
    /// </summary>
    /// <param name="PkgMgr">事务队列</param>
    /// <param name="LogSource">数据源</param>
    constructor Create(PkgMgr:TTransPkgMgr; LogSource: TLogSource);
    destructor Destroy; override;
    procedure Execute; override;
    /// <summary>
    /// 将表更改操作，应用到当前系统。以免读取的日志与表结构不匹配
    /// </summary>
    function ApplySysDDLChange:Boolean;
  end;

  TPageidGroup = class(TObject)
  private
    Fcapacity: Cardinal;
    fSize: Cardinal;
    function GetItem(Index: Integer): Cardinal;
  public
    Fid:Word;
    Pid:DWORD;
    Fbuff: array of Dword;
    constructor Create(pageid:TPage_Id;capacity: Cardinal = $100);
    destructor Destroy; override;
    property Count: Cardinal read fSize;
    function Add(value: DWORD): Cardinal;
    property items[Index: Integer]: Dword read GetItem; default;
  end;

  TSql2014logAnalyzerThread = class(TThread)
  private
    FAnalyzerMain:TSql2014logAnalyzer;
    FTranspkg: TTransPkg;
    Flogsource:TLogSource;
    FOpts: TObjectList;
    FMixPending: TList;
    CurProcesspkgIdx:Cardinal;
    procedure PriseRowLog(tPkg: TTransPkgItem);
    procedure PriseRowLog_Insert(tPkg: TTransPkgItem);
    procedure PriseRowLog_Delete(tPkg: TTransPkgItem);
    procedure applyUpdateChange(srcData, pdata: Pointer; offset, size_old, size_new, datarowCnt: Integer);
    procedure PriseRowLog_MODIFY_ROW(tPkg: TTransPkgItem);
    procedure PriseRowLog_MODIFY_COLUMNS(tPkg: TTransPkgItem);
    function PriseRowLog_InsertDeleteRowData(DbTable: TdbTableItem; BinReader: TbinDataReader): Tsql2014RowData;
    function PriseRowLog_UniqueClusteredKeys(uckdata: TBytes; DbTable: TdbTableItem): string;
    procedure PriseRowLOP_FORMAT_PAGE(tPkg: TTransPkgItem);
  public
    startIdx,stopIdx: Integer;
    idsLst:TObjectList;
    isdone:Boolean;

    constructor Create(logsource:TLogSource;Transpkg: TTransPkg);
    destructor Destroy; override;
    procedure Execute;override;
  end;


implementation

uses
  loglog, plugins, OpCode, contextCode, dbFieldTypes,comm_func, math,
  Memory_Common, sqlextendedprocHelper, Xml.XMLDoc, pagecache;

type
  TRawElement = packed record
    Offset: Cardinal;
    Length: Word;
  end;

{ TSql2014logAnalyzer }

function TSql2014logAnalyzer.binEquals(v1, v2: TBytes): Boolean;
begin
  if v1 = v2 then
  begin
    Result := True;
  end else if Length(v1) <> Length(v2) then begin
    Result := False;
  end else begin
    Result := CompareMem(@v1[0], @v2[0], Length(v1));
  end;
end;

constructor TSql2014logAnalyzer.Create(PkgMgr:TTransPkgMgr;LogSource: TLogSource);
begin
  inherited Create(False);

  FPkgMgr := PkgMgr;
  FLogSource := LogSource;
  FRows := TObjectList.Create;
  FRows.OwnsObjects := True;
  DDL := TDDLMgr.Create;
  //AllocUnitMgr := TAllocUnitMgr.Create;
  tmp_Alloc:=TDictionary<UInt64, Integer>.Create();
  tmp_Parti:=TDictionary<UInt64, Integer>.Create();
  IDXs:=TDDL_Idxs_ColsMgr.Create;
  IDXstats:=TObjectList.create;
  Rscols := TObjectList.create;
  Hvu := THexValueHelper.Create(LogSource);
  Self.NameThreadForDebugging('TSql2014logAnalyzer', Self.ThreadID);
  FLogSource.Loger.Add('Analyzer init...');
end;

destructor TSql2014logAnalyzer.Destroy;
begin
  Rscols.Free;
  FRows.Clear;
  FRows.Free;
  DDL.Free;
  //AllocUnitMgr.Free;
  tmp_Alloc.Free;
  tmp_Parti.Free;
  IDXs.Free;
  IDXstats.free;
  Hvu.Free;
  inherited;
end;

procedure TSql2014logAnalyzer.DDLClear;
var
  I,J:Integer;
  ddlitem :TDDLItem;
  ddlitem_J: TDDLItem;
begin
  //清除drop table引发的drop column,drop index等。。。。
  for I := 0 to DDL.FItems.Count - 1 do
  begin
    ddlitem := TDDLItem(DDL.FItems[I]);
    if (ddlitem.OpType = Opt_Delete) and (ddlitem.xType = 'u') then
    begin
      for J := DDl.FItems.Count - 1 downto 0 do
      begin
        ddlitem_J := TDDLItem(DDl.FItems[J]);
        if ddlitem_J.OpType = Opt_Delete then
        begin
          if TDDLItem_Delete(ddlitem_J).ParentId = ddlitem.getObjId then
          begin
            ddlitem_J.isSkip := True;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSql2014logAnalyzer.DDLPretreatment;
var
  I,J:Integer;
  ddlitem :TDDLItem;
  idxObj:TDDL_IDX_stats;
  cUniKey:TDDL_Create_UniqueKey;
  cColumn:TDDL_Create_Column;
  uColumn:TDDL_Update_Column;
  rsC:TDDL_RsCols;
  dck:TDDL_Delete_Constraint_key;
begin
  for I := 0 to DDL.FItems.Count - 1 do
  begin
    ddlitem := TDDLItem(DDL.FItems[I]);
    if not ddlitem.isSkip then
    begin
      if (ddlitem is TDDL_Create_UniqueKey) then
      begin
        cUniKey := TDDL_Create_UniqueKey(ddlitem);
        for J := 0 to IDXstats.Count - 1 do
        begin
          idxObj := TDDL_IDX_stats(IDXstats[J]);
          if (cUniKey.tableid = idxObj.tableId) and (cUniKey.objName = idxObj.idxName) then
          begin
            cUniKey.isCLUSTERED := idxObj.isCLUSTERED;
            cUniKey.isUnique := idxObj.isUnique;
            Break;
          end;
        end;
      end else if (ddlitem is TDDL_Create_Column) then
      begin
        cColumn := TDDL_Create_Column(ddlitem);
        for J := 0 to Rscols.Count - 1 do
        begin
          rsC := TDDL_RsCols(Rscols[J]);
          if (rsC.TableObj.TableId = cColumn.Table.TableId) and (rsC.ColId = cColumn.field.Col_id) then
          begin
            cColumn.field.nullMap := rsC.Nullbit - 1;
            cColumn.field.is_nullable := (rsC.statusCode and $80) = 0;
            cColumn.field.leaf_pos := rsC.DataOffset;
            Break;
          end;
        end;
      end else if (ddlitem is TDDL_Update_Column) then
      begin
        uColumn := TDDL_Update_Column(ddlitem);
        for J := 0 to Rscols.Count - 1 do
        begin
          rsC := TDDL_RsCols(Rscols[J]);
          if (rsC.TableObj.TableId = uColumn.Table.TableId) and (rsC.ColId = uColumn.field.Col_id) then
          begin
            uColumn.field.nullMap := rsC.Nullbit - 1;
            uColumn.field.is_nullable := (rsC.statusCode and $80) = 0;   //128 not null
            uColumn.field.leaf_pos := rsC.DataOffset;
            Break;
          end;
        end;
      end else if (ddlitem is TDDL_Delete_Constraint_key) then
      begin
        dck := TDDL_Delete_Constraint_key(ddlitem);
        for J := 0 to IDXstats.Count - 1 do
        begin
          idxObj := TDDL_IDX_stats(IDXstats[J]);
          if (dck.tableid = idxObj.tableId) and (dck.objName = idxObj.idxName) then
          begin
            dck.isCLUSTERED := idxObj.isCLUSTERED;
            dck.isUnique := idxObj.isUnique;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function TSql2014logAnalyzer.ApplySysDDLChange:Boolean;
procedure addUcK(tableid:Integer);
var
  cols:TObjectList;
  I:Integer;
  TempItem : TDDL_Idxs_ColsItem;
  tableL:TdbTableItem;
  colItem:TdbFieldItem;
begin
  tableL := FLogSource.Fdbc.dict.tables.GetItemById(tableid);
  if tableL <> nil then
  begin
    cols := IDXs.GetById(tableid);
    if (cols <> nil) and (cols.Count > 0) then
    begin
      for I := 0 to cols.Count - 1 do
      begin
        TempItem := TDDL_Idxs_ColsItem(cols[I]);
        colItem := tableL.Fields.GetItemById(TempItem.ColId);
        if colItem <> nil then
        begin
          tableL.UniqueClusteredKeys.Add(colItem);
        end;
      end;
    end;
  end;
end;
var
  I:Integer;
  ddlitem :TDDLItem;
  ctable:TDDL_Create_Table;
  dtable:TDDL_Delete_Table;

  cColumn:TDDL_Create_Column;
  dColumn:TDDL_Delete_Column;

  uColumn:TDDL_Update_Column;

  cPk:TDDL_Create_PrimaryKey;
  cUq:TDDL_Create_UniqueKey;

  TableObj: TdbTableItem;
  FieldObj:TdbFieldItem;
  renameObj:TDDL_Update_RenameObj;
  ddlDck:TDDL_Delete_Constraint_key;

  aar:TArray<TPair<UInt64, Integer>>;
begin
  Result := False;
  for I := 0 to DDL.FItems.Count - 1 do
  begin
    ddlitem := TDDLItem(DDL.FItems[I]);
    if ddlitem.isSkip then
      Continue;

    if (ddlitem.OpType = Opt_Insert) then
    begin
      Result := True;
      if ddlitem.xType = 'u' then
      begin
        ctable := TDDL_Create_Table(ddlitem);
        FLogSource.Fdbc.dict.tables.addTable(ctable.TableObj);
        ctable.TableObj := nil;
      end else if ddlitem.xType = 'column' then
      begin
        cColumn := TDDL_Create_Column(ddlitem);
        cColumn.Table.Fields.addField(cColumn.field);
      end else if ddlitem.xType = 'pk' then
      begin
        cPk := TDDL_Create_PrimaryKey(ddlitem);
        if cPk.isCLUSTERED then
        begin
          addUcK(cPk.tableid);
        end;
      end else if ddlitem.xType = 'uq' then
      begin
        cUq := TDDL_Create_UniqueKey(ddlitem);
        if cUq.isCLUSTERED and cUq.isUnique then
        begin
          addUcK(cUq.tableid);
        end;
      end;
    end else if (ddlitem.OpType = Opt_Delete) then begin
      Result := True;
      if ddlitem.xType = 'u' then
      begin
        dtable := TDDL_Delete_Table(ddlitem);
        FLogSource.Fdbc.dict.tables.RemoveTable(dtable.getObjId);
      end else if ddlitem.xType = 'column' then
      begin
        dColumn := TDDL_Delete_Column(ddlitem);
        TableObj := FLogSource.Fdbc.dict.tables.GetItemById(dColumn.TableId);
        if TableObj <> nil then
        begin
          TableObj.Fields.RemoveField(dColumn.objName);
        end;
      end else if ddlitem.xType = 'constraint' then
      begin
        if ddlitem is TDDL_Delete_Constraint_key then
        begin
          ddlDck := TDDL_Delete_Constraint_key(ddlitem);
          if ddlDck.isCLUSTERED and ddlDck.isUnique then
          begin
            TableObj := FLogSource.Fdbc.dict.tables.GetItemById(ddlDck.tableid);
            if TableObj <> nil then
            begin
              TableObj.UniqueClusteredKeys.Clear;
            end;
          end;
        end;
      end;
    end else if (ddlitem.OpType = Opt_Update) then begin
      Result := True;
      if ddlitem.xType = 'rename' then
      begin
        renameObj := TDDL_Update_RenameObj(ddlitem);
        if renameObj.subType='u' then
        begin
          //table
          TableObj := FLogSource.Fdbc.dict.tables.GetItemById(renameObj.ObjId);
          if TableObj <> nil then
          begin
            TableObj.TableNmae := renameObj.newName
          end;
        end else if renameObj.subType='column' then
        begin
          //column
          TableObj := FLogSource.Fdbc.dict.tables.GetItemById(renameObj.ObjId);
          if TableObj <> nil then
          begin
            FieldObj := TableObj.Fields.GetItemById(renameObj.colId);
            FieldObj.ColName := renameObj.newName;
          end;
        end;
      end else if ddlitem.xType = 'column' then
      begin
        uColumn := TDDL_Update_Column(ddlitem);
        FieldObj := uColumn.Table.Fields.GetItemById(uColumn.field.Col_id);
        if FieldObj<>nil then
        begin
          FieldObj.ColName := uColumn.field.ColName;
          FieldObj.type_id := uColumn.field.type_id;
          FieldObj.Max_length := uColumn.field.Max_length;

          FieldObj.procision := uColumn.field.procision;
          FieldObj.scale := uColumn.field.scale;
          FieldObj.collation_name := uColumn.field.collation_name;
          FieldObj.CodePage := uColumn.field.CodePage;

          if uColumn.field.leaf_pos<>0 then
          begin
            FieldObj.nullMap := uColumn.field.nullMap;
            FieldObj.is_nullable := uColumn.field.is_nullable;
            FieldObj.leaf_pos := uColumn.field.leaf_pos;
          end;
        end;
      end;
    end;
  end;
  aar := tmp_Parti.ToArray();
  for I := 0 to Length(aar)-1 do
  begin
    FLogSource.Fdbc.dict.tables.addParti(aar[i].Key, aar[i].Value);
  end;

  aar := tmp_Alloc.ToArray();
  for I := 0 to Length(aar)-1 do
  begin
    FLogSource.Fdbc.dict.tables.addAlloc(aar[i].Key, aar[i].Value);
  end;
end;

function TSql2014logAnalyzer.DML_BuilderSql(aRowData: Tsql2014Opt): string;
begin
  if not aRowData.deleteFlag then
  begin
    case aRowData.OperaType of
      Opt_Insert:
        Result := DML_BuilderSql_Insert(aRowData);
      Opt_Update:
        Result := DML_BuilderSql_Update(aRowData);
      Opt_Delete:
        Result := DML_BuilderSql_Delete(aRowData);
    else
      FLogSource.Loger.Add('尚未定义的SQLBuilder：%d', [Integer(aRowData.OperaType)], log_error or LOG_IMPORTANT);
    end;
  end;
end;

function TSql2014logAnalyzer.DML_BuilderSql_Update(aRowData: Tsql2014Opt): string;
var
  updateStr:string;
  I: Integer;
  raw_old,raw_new: PdbFieldValue;
  whereStr: string;
  fieldval: PdbFieldValue;
begin
  if Length(aRowData.UniqueClusteredKeys)>0 then
  begin
    whereStr := aRowData.UniqueClusteredKeysStr;
  end else begin
    whereStr := '';
    //没有聚合键
    for I := 0 to aRowData.old_data.Fields.Count - 1 do
    begin
      fieldval := PdbFieldValue(aRowData.old_data.Fields[I]);
      whereStr := whereStr + Format('and %s=%s ', [fieldval.field.getSafeColName, Hvu.GetFieldStrValueWithQuoteIfNeed(fieldval)]);
    end;
    if whereStr.Length > 0 then
    begin
      Delete(whereStr, 1, 4);  //"and "
    end;
  end;

  //对比差异生成update
  updateStr := '';
  for I := 0 to aRowData.Table.Fields.Count - 1 do
  begin
    if not aRowData.Table.Fields[I].isLogSkipCol then
    begin
      raw_old := aRowData.old_data.getField(aRowData.Table.Fields[I].Col_id);
      raw_new := aRowData.new_data.getField(aRowData.Table.Fields[I].Col_id);
      if (raw_new = nil) and (raw_old = nil) then
      begin

      end
      else if raw_new = nil then
      begin
        //var 值 ————>  null
        updateStr := updateStr + Format(', %s=NULL', [raw_old.field.getSafeColName]);
      end
      else if (raw_old = nil) or (not binEquals(raw_new.value, raw_old.value)) then
      begin
        updateStr := updateStr + Format(', %s=%s', [raw_new.field.getSafeColName, Hvu.GetFieldStrValueWithQuoteIfNeed(raw_new)]);
      end
    end;
  end;
  if updateStr.Length = 0 then
  begin
    //如果所有字段一样，肯定就是更新回原始状态了，
    Result := '';
    exit;
  end;
  Delete(updateStr, 1, 2);  //", "

  Result := Format('UPDATE %s SET %s WHERE %s;', [aRowData.Table.getFullName, updateStr, whereStr]);
end;

function TSql2014logAnalyzer.DML_BuilderSql_Where(aRowData: Tsql2014Opt): string;
var
  whereStr: string;
  I: Integer;
  fieldval: PdbFieldValue;
begin
  if Length(aRowData.UniqueClusteredKeys) > 0 then
  begin
    whereStr := aRowData.UniqueClusteredKeysStr;
  end
  else
  begin
    whereStr := '';
    if aRowData.R1<>nil then
    begin
      //Update再delete
      for I := 0 to aRowData.old_data.Fields.Count - 1 do
      begin
        fieldval := PdbFieldValue(aRowData.old_data.Fields[I]);
        whereStr := whereStr + Format('and %s=%s ', [fieldval.field.getSafeColName, Hvu.GetFieldStrValueWithQuoteIfNeed(fieldval)]);
      end;
    end else begin
      for I := 0 to aRowData.new_data.Fields.Count - 1 do
      begin
        fieldval := PdbFieldValue(aRowData.new_data.Fields[I]);
        whereStr := whereStr + Format('and %s=%s ', [fieldval.field.getSafeColName, Hvu.GetFieldStrValueWithQuoteIfNeed(fieldval)]);
      end;
    end;
    if whereStr.Length > 0 then
    begin
      Delete(whereStr, 1, 4);  //"and "
    end;
    Result := whereStr;
  end;
end;

function TSql2014logAnalyzer.DML_BuilderXML_Truncate(ddlitem:TDDL_truncate_table): string;
var
  xml:IXMLDocument;
  rootNode:IXMLNode;
begin
  xml := TXMLDocument.Create(nil);
  xml.Active := True;
  rootNode := xml.AddChild('opt');
  rootNode.Attributes['type'] := 'truncate';
  rootNode.Attributes['table'] := ddlitem.Table.getFullName;
  Result := xml.XML.Text;
end;

function TSql2014logAnalyzer.DML_BuilderXML(aRowData: Tsql2014Opt): string;
begin
  if not aRowData.deleteFlag then
  begin
    case aRowData.OperaType of
      Opt_Insert:
        Result := DML_BuilderXML_Insert(aRowData);
      Opt_Update:
        Result := DML_BuilderXML_Update(aRowData);
      Opt_Delete:
        Result := DML_BuilderXML_Delete(aRowData);
    else
      FLogSource.Loger.Add('尚未定义的XMLBuilder：%d', [Integer(aRowData.OperaType)], log_error or LOG_IMPORTANT);
    end;
  end;
end;

function TSql2014logAnalyzer.DML_BuilderXML_Delete(aRowData: Tsql2014Opt): string;
var
  I: Integer;
  fieldval: PdbFieldValue;

  xml:IXMLDocument;
  rootNode,tmpNode:IXMLNode;
  field : TdbFieldItem;
begin
  xml := TXMLDocument.Create(nil);
  xml.Active := True;
  rootNode := xml.AddChild('opt');
  rootNode.Attributes['type'] := 'delete';
  rootNode.Attributes['table'] := aRowData.Table.getFullName;
  tmpNode := rootNode.AddChild('data');
  if aRowData.R1<>nil then
  begin
    //Update再delete
    for I := 0 to aRowData.old_data.Fields.Count - 1 do
    begin
      fieldval := PdbFieldValue(aRowData.old_data.Fields[I]);
      DML_BuilderXML_Field(fieldval, tmpNode);
    end;
  end else begin
    for I := 0 to aRowData.new_data.Fields.Count - 1 do
    begin
      fieldval := PdbFieldValue(aRowData.new_data.Fields[I]);
      DML_BuilderXML_Field(fieldval, tmpNode);
    end;
  end;
  tmpNode := rootNode.AddChild('key');
  if aRowData.table.UniqueClusteredKeys.Count>0 then
  begin
    for I := 0 to aRowData.table.UniqueClusteredKeys.Count-1 do
    begin
      field := TdbFieldItem(aRowData.table.UniqueClusteredKeys[i]);
      fieldval := aRowData.new_data.getField(field.Col_id);
      if fieldval <> nil then
      begin
        DML_BuilderXML_Field(fieldval, tmpNode);
      end;
    end;
  end;
  Result := xml.XML.Text;
end;

procedure TSql2014logAnalyzer.DML_BuilderXML_Field(pdd: PdbFieldValue; ownNode: IXMLNode; nodeName: string = 'a'; IncludeColName:Boolean = True);
var
  TmpNode: IXMLNode;
  needQuote: Boolean;
  dateTypeStr: string;
begin
  TmpNode := ownNode.AddChild(nodeName);
  if IncludeColName then
    TmpNode.Attributes['name'] := pdd.field.ColName;
  if pdd.isNull then
  begin
    TmpNode.Attributes['null'] := 1;
  end
  else
  begin
    TmpNode.Text := Hvu.GetFieldStrValue(pdd, needQuote, dateTypeStr);
    if pdd.field.type_id = MsTypes.SQL_VARIANT then
    begin
      TmpNode.Attributes['type'] := dateTypeStr;
    end;
  end;
end;

function TSql2014logAnalyzer.DML_BuilderXML_Insert(aRowData: Tsql2014Opt): string;
var
  I: Integer;
  fieldval: PdbFieldValue;

  xml:IXMLDocument;
  rootNode:IXMLNode;
begin
  xml := TXMLDocument.Create(nil);
  xml.Active := True;
  rootNode := xml.AddChild('opt');
  rootNode.Attributes['type'] := 'insert';
  rootNode.Attributes['table'] := aRowData.Table.getFullName;
  for I := 0 to aRowData.new_data.Fields.Count - 1 do
  begin
    fieldval := PdbFieldValue(aRowData.new_data.Fields[I]);
    DML_BuilderXML_Field(fieldval, rootNode);
  end;
  Result := xml.XML.Text;
end;

function TSql2014logAnalyzer.DML_BuilderXML_Update(aRowData: Tsql2014Opt): string;
var
  I,J: Integer;
  raw_old,raw_new: PdbFieldValue;

  xml:IXMLDocument;
  rootNode,fieldNode:IXMLNode;
begin
  xml := TXMLDocument.Create(nil);
  xml.Active := True;
  rootNode := xml.AddChild('opt');
  rootNode.Attributes['type'] := 'update';
  rootNode.Attributes['table'] := aRowData.Table.getFullName;
  try
    if (aRowData.new_data <> nil) and (aRowData.old_data <> nil) then
    begin
      for I := 0 to aRowData.Table.Fields.Count - 1 do
      begin
        if aRowData.Table.Fields[i].isLogSkipCol then Continue;
        raw_old := aRowData.old_data.getField(aRowData.Table.Fields[i].Col_id);
        raw_new := aRowData.new_data.getField(aRowData.Table.Fields[i].Col_id);

        fieldNode := rootNode.AddChild('field');
        fieldNode.Attributes['name'] := aRowData.Table.Fields[i].ColName;
        fieldNode.Attributes['dtype'] := getSingleDataTypeStr(aRowData.Table.Fields[i].type_id);
        for J := 0 to aRowData.Table.UniqueClusteredKeys.Count-1 do
        begin
          if TdbFieldItem(aRowData.Table.UniqueClusteredKeys[j]).Col_id = aRowData.Table.Fields[i].Col_id then
          begin
            fieldNode.Attributes['iskey'] := '1';
            Break;
          end;
        end;
        DML_BuilderXML_Field(raw_old, fieldNode, 'old', false);
        DML_BuilderXML_Field(raw_new, fieldNode, 'new', false);
      end;
    end;
  except
    on ee:Exception do
    begin
      FLogSource.Loger.Add('DML_BuilderXML_Update 生成xml 失败！' + ee.Message);
    end
  end;
  Result := xml.XML.Text;
end;

function TSql2014logAnalyzer.DML_BuilderSql_Insert(aRowData: Tsql2014Opt): string;
var
  fields: string;
  StrVal: string;
  I: Integer;
  fieldval: PdbFieldValue;
begin
  fields := '';
  StrVal := '';
  for I := 0 to aRowData.new_data.Fields.Count - 1 do
  begin
    fieldval := PdbFieldValue(aRowData.new_data.Fields[I]);
    fields := fields + ',' + fieldval.field.getSafeColName;
    StrVal := StrVal + ',' + Hvu.GetFieldStrValueWithQuoteIfNeed(fieldval);
  end;
  if aRowData.new_data.Fields.Count > 0 then
  begin
    Delete(fields, 1, 1);
    Delete(StrVal, 1, 1);
  end;
  Result := '';
  if aRowData.Table.hasIdentity then
    Result := Format('SET IDENTITY_INSERT %s ON', [aRowData.Table.getFullName]) + WIN_EOL;
  Result := Result + Format('INSERT INTO %s(%s)values(%s);', [aRowData.Table.getFullName, fields, StrVal]) + WIN_EOL;
  if aRowData.Table.hasIdentity then
    Result := Result + Format('SET IDENTITY_INSERT %s OFF', [aRowData.Table.getFullName]) + WIN_EOL;
end;

function TSql2014logAnalyzer.DML_BuilderSql_Delete(aRowData: Tsql2014Opt): string;
var
  whereStr: string;
  I,j: Integer;
  field: TdbFieldItem;
  fieldval: PdbFieldValue;
begin
  if aRowData.table.UniqueClusteredKeys.Count>0 then
  begin
    whereStr := '';
    for I := 0 to aRowData.table.UniqueClusteredKeys.Count-1 do
    begin
      field := TdbFieldItem(aRowData.table.UniqueClusteredKeys[i]);
      for J := 0 to aRowData.new_data.Fields.Count -1 do
      begin
        fieldval := PdbFieldValue(aRowData.new_data.Fields[j]);
        if fieldval.field.Col_id=field.Col_id then
        begin
          whereStr := whereStr + Format('and %s=%s ', [field.getSafeColName, Hvu.GetFieldStrValueWithQuoteIfNeed(fieldval)]);
          Break;
        end;
      end;
    end;
    Delete(whereStr, 1, 4);
  end else
    whereStr := DML_BuilderSql_Where(aRowData);
  Result := Format('DELETE FROM %s WHERE %s;', [aRowData.Table.getFullName, whereStr]);
end;

procedure TSql2014logAnalyzer.logTranPkg(FTranspkg: TTransPkg);
var
  xmlStr:string;
  I:Integer;
  TTpi: TTransPkgItem;
  rl:PRawLog;
  OriginRowData:TBytes;
  partition_id :UInt64;
  Rldo: PRawLog_DataOpt;
  table:TdbTableItem;
  objlst:TList;
begin
  try
    objlst:=TList.Create;
    xmlStr := '<root><transId>' + TranId2Str(FTranspkg.Ftransid) + '</transId><rows>';
    for I := 0 to FTranspkg.Items.Count - 1 do
    begin
      TTpi := TTransPkgItem(FTranspkg.Items[I]);
      xmlStr := xmlStr + '<item lsn="' + lsn2str(TTpi.LSN) + '">';
      xmlStr := xmlStr + '<bin>' + DumpMemory2Str(TTpi.Raw.data, TTpi.Raw.dataSize) + '</bin>';
      rl := TTpi.Raw.data;
      partition_id := 0;
      if (rl.OpCode = LOP_MODIFY_ROW) or (rl.OpCode = LOP_MODIFY_COLUMNS) then
      begin
        OriginRowData := getUpdateSoltData(FLogSource.Fdbc, rl.PreviousLSN);
        if OriginRowData <> nil then
        begin
          xmlStr := xmlStr + '<data>' + DumpMemory2Str(@OriginRowData[0], Length(OriginRowData)) + '</data>';
        end;
        Rldo := TTpi.Raw.data;
        partition_id := Rldo.PartitionId;
      end else if (rl.OpCode = LOP_INSERT_ROWS) or (rl.OpCode = LOP_DELETE_ROWS) then begin
        Rldo := TTpi.Raw.data;
        partition_id := Rldo.PartitionId;
      end;
      if partition_id>0 then
      begin
        if objlst.IndexOf(Pointer(partition_id))=-1 then
          objlst.Add(Pointer(partition_id));

      end;
      xmlStr := xmlStr + '</item>'
    end;
    xmlStr := xmlStr + '</rows><tables>';
    for I := 0 to objlst.Count - 1 do
    begin
      table := FLogSource.Fdbc.dict.tables.GetItemByPartitionId(uint64(objlst[I]));
      if table <> nil then
      begin
        xmlStr := xmlStr + table.AsXml;
      end;
    end;
    xmlStr := xmlStr + '</tables></root>';
    FLogSource.Loger.Add(xmlStr, LOG_IMPORTANT or LOG_DATA);
  except
    on dd: Exception do
    begin
      FLogSource.Loger.Add('dump logTranPkg fail!!' + dd.Message, LOG_ERROR);
    end;
  end;
end;

procedure TSql2014logAnalyzer.Execute;
var
  TTsPkg: TTransPkg;
begin
  inherited;
  FLogSource.Loger.Add('Analyzer Start...');
  while not Terminated do
  begin
    if FPkgMgr.FpaddingPrisePkg.Count > 0 then
    begin
      TTsPkg := TTransPkg(FPkgMgr.FpaddingPrisePkg.Pop);
      try
        FRows.Clear;
        DDL.FItems.Clear;
        //AllocUnitMgr.FItems.Clear;
        tmp_Alloc.Clear;
        tmp_Parti.Clear;
        IDXs.FItems.Clear;
        IDXstats.Clear;
        Rscols.Clear;
        Execute3(TTsPkg);
      except
        on ee:Exception do
        begin
          FLogSource.Loger.Add('TSql2014logAnalyzer.事务块处理失败！TranId:' + TranId2Str(TTsPkg.Ftransid) + '.' + ee.Message, LOG_ERROR);
          logTranPkg(TTsPkg);
        end;
      end;
      TTsPkg.Free;
    end else begin
      Sleep(1000);
    end;
  end;
end;

procedure TSql2014logAnalyzer.Execute3(FTranspkg: TTransPkg);
  procedure getAllPageIds(Transpkg: TTransPkg; idsgroup: TObjectList);
  var
    TTpi: TTransPkgItem;
    Rlo: PRawLog_DataOpt;
    I: Cardinal;
    tmpIntlst: TPageidGroup;
    J: Integer;
    found: Boolean;
  begin
    for I := 0 to Transpkg.Items.Count - 1 do
    begin
      TTpi := TTransPkgItem(FTranspkg.Items[I]);
      Rlo := PRawLog_DataOpt(TTpi.Raw.data);
      if Rlo.normalData.OpCode in [LOP_INSERT_ROWS, LOP_DELETE_ROWS, LOP_MODIFY_ROW, LOP_MODIFY_COLUMNS, LOP_FORMAT_PAGE] then
      begin
        found := False;
        for J := 0 to idsgroup.Count - 1 do
        begin
          tmpIntlst := TPageidGroup(idsgroup[J]);
          if (tmpIntlst.FID = Rlo.pageId.FID) and (tmpIntlst.PID = Rlo.pageId.PID) then
          begin
            tmpIntlst.Add(I);
            found := True;
          end;
        end;

        if not found then
        begin
          tmpIntlst := TPageidGroup.Create(Rlo.pageId);
          tmpIntlst.Add(I);
          idsgroup.Add(tmpIntlst);
        end;
      end;
    end;
  end;

  procedure PriseTransInfo(Transpkg: TTransPkg);
  var
    TTpi :TTransPkgItem;
    Rlbx: PRawLog_BEGIN_XACT;
    Rlcx: PRawLog_COMMIT_XACT;
  begin
    TTpi := TTransPkgItem(FTranspkg.Items[0]);
    Rlbx := TTpi.Raw.data;
    if Rlbx.normalData.OpCode = LOP_BEGIN_XACT then
    begin
      TransBeginTime := Hvu.Hex2Datetime(Rlbx.Time);
      TransId := Rlbx.normalData.TransID;
    end;

    TTpi := TTransPkgItem(FTranspkg.Items[FTranspkg.Items.Count - 1]);
    Rlcx := TTpi.Raw.data;
    if Rlcx.normalData.OpCode = LOP_COMMIT_XACT then
    begin
      TransCommitLsn := TTpi.LSN;
      TransCommitTime := Hvu.Hex2Datetime(Rlcx.Time);
    end
  end;
var
  I,J: integer;
  threadCnt:integer;
  perThreadCnt:integer;
  AnalyzerThreads:array of TSql2014logAnalyzerThread;
  pidGroupids:TObjectList;
  DrOpt_buf : Tsql2014Opt;
  DMLitem :TDMLItem;
  fieldval: PdbFieldValue;
  TmpSTr:string;
begin
  FLogSource.Loger.Add(FormatDateTime('====>yyyy-MM-dd HH:nn:ss.zzz',now), LOG_DEBUG);
  FLogSource.Loger.Add('TSql2014logAnalyzer.Execute ==> transId:%s, MinLsn:%s, cnt:%d', [TranId2Str(FTranspkg.Ftransid),LSN2Str(TTransPkgItem(FTranspkg.Items[0]).lsn), FTranspkg.Items.Count],LOG_DEBUG);
//  if FTranspkg.Items.Count<=100 then
//  begin
//    //单线程处理
//    Execute2(FTranspkg);
//    Exit;
//  end;

  pidGroupids := TObjectList.Create;
  getAllPageIds(FTranspkg, pidGroupids);

  //计算线程数最多10个线程
  threadCnt := Ceil(pidGroupids.Count / 50);
  if threadCnt > 10 then
    threadCnt := 10;

  //threadCnt := 1;

  perThreadCnt := pidGroupids.Count div threadCnt;

  SetLength(AnalyzerThreads, threadCnt);
  for I := 0 to threadCnt - 1 do
  begin
    AnalyzerThreads[I] := TSql2014logAnalyzerThread.Create(FLogSource, FTranspkg);
    AnalyzerThreads[I].idsLst := pidGroupids;
    AnalyzerThreads[I].startIdx := I * perThreadCnt;
    if I = threadCnt - 1 then
      AnalyzerThreads[I].stopIdx := pidGroupids.Count
    else
      AnalyzerThreads[I].stopIdx := I * perThreadCnt + perThreadCnt;
    AnalyzerThreads[I].FAnalyzerMain := Self;
    AnalyzerThreads[I].Start;
  end;

  //解析事务开启和结束信息
  PriseTransInfo(FTranspkg);

  //等待所有线程完成
  for I := 0 to threadCnt - 1 do
  begin
    while not (Terminated or AnalyzerThreads[i].isdone) do
    begin
      WaitForSingleObject(AnalyzerThreads[i].Handle, 25); //25ms, an eternity for a cpu
    end;

    //终止所有线程
    if terminated then
    begin
      AnalyzerThreads[i].Terminate;
      AnalyzerThreads[i].WaitFor;
    end;
  end;

  pidGroupids.Free;

  //提取所有线程的成果
  DDL.FItems.Clear;
  for I := 0 to threadCnt - 1 do
  begin
    for J := 0 to AnalyzerThreads[I].FMixPending.Count - 1 do
    begin
      fieldval := PdbFieldValue(AnalyzerThreads[I].FMixPending[j]);
      fieldval.value := getDataFrom_TEXT_MIX(fieldval.value);
    end;
    for J := 0 to AnalyzerThreads[I].FOpts.Count - 1 do
    begin
      DrOpt_buf := Tsql2014Opt(AnalyzerThreads[I].FOpts[J]);
      if DrOpt_buf.deleteFlag or DrOpt_buf.isMixData then
      begin
        Continue;
      end;
      //FLogSource.Loger.Add('-->' + DML_BuilderSql(DrOpt_buf), LOG_DEBUG);
      if DrOpt_buf.Table.Owner = 'sys' then
      begin
        //如果操作的是系统表则是ddl语句
        if DrOpt_buf.OperaType = Opt_Insert then
        begin
          PriseDDLPkg(DrOpt_buf);
        end
        else if DrOpt_buf.OperaType = Opt_Delete then
        begin
          PriseDDLPkg_D(DrOpt_buf);
        end
        else if DrOpt_buf.OperaType = Opt_Update then
        begin
          PriseDDLPkg_U(DrOpt_buf);
        end;
      end
      else
      begin
        // dml 语句
        DMLitem := TDMLItem.Create;
        DMLitem.data := DrOpt_buf;
        DDL.Add(DMLitem);
      end;
    end;
  end;

  DDLClear;
  DDLPretreatment;
  //build Sql
  TmpSTr := GenSql;
  //FLogSource.Loger.Add(TmpSTr);
  PluginsMgr.onTranSql(FLogSource.Fdbc.GetPlgSrc, TmpSTr);
  //build XML
  TmpSTr := GenXML;
  //FLogSource.Loger.Add(TmpSTr);
  PluginsMgr.onTransXml(FLogSource.Fdbc.GetPlgSrc, TmpSTr);
  //save LSN
  FLogSource.FProcCurLSN := TransCommitLsn;
{$IFDEF DEBUG}
ApplySysDDLChange;
for I := 0 to threadCnt - 1 do AnalyzerThreads[I].Free;
Exit;
{$ENDIF}
  if ApplySysDDLChange then
  begin
    //如果表结构有变更，重新保存表结构
    FLogSource.saveToFile;
  end;
  FLogSource.saveToFile_LSN;
  for I := 0 to threadCnt - 1 do AnalyzerThreads[I].Free;
end;

function TSql2014logAnalyzer.GenSql: string;
var
  ddlitem: TDDLItem;
  I: Integer;
  ResList: TStringList;
  Tmpstr:string;
begin
  ResList := TStringList.Create;
  try
    ResList.Add('--genSql begin--');
    ResList.Add('--TransId:' + TranId2Str(TransId));
    ResList.Add('--TranBeinTime:' + formatdatetime('yyyy-MM-dd HH:nn:ss.zzz', TransBeginTime));
    ResList.Add('--CommitTranTime:' + formatdatetime('yyyy-MM-dd HH:nn:ss.zzz', TransCommitTime));

    for I := 0 to DDL.FItems.Count - 1 do
    begin
      ddlitem := TDDLItem(DDL.FItems[I]);
      if not ddlitem.isSkip then
      begin
        Tmpstr := '';
        case ddlitem.OpType of
          Opt_Insert:
            Tmpstr := GenSql_DDL_Insert(TDDLItem_Insert(ddlitem));
          Opt_Update:
            Tmpstr := GenSql_DDL_Update(TDDLItem_Update(ddlitem));
          Opt_Delete:
            Tmpstr := GenSql_DDL_Delete(TDDLItem_Delete(ddlitem));
          Opt_TruncateTable:
            Tmpstr := 'TRUNCATE TABLE '+ TDDL_Truncate_table(ddlitem).Table.getFullName;
          Opt_DML:
            begin
              Tmpstr := DML_BuilderSql(TDMLItem(DDL.FItems[I]).data)
            end;
        end;
        if Tmpstr <> '' then
          ResList.Add(Tmpstr);
      end;
    end;
    ResList.Add('--genSql end--');
    Result := ResList.Text;
  finally
    ResList.Free;
  end;
end;

function TSql2014logAnalyzer.GenXML: string;
var
  ddlitem: TDDLItem;
  I: Integer;
  ResList: TStringList;
  Tmpstr:string;
  hasOneMoreData:Boolean;
begin
  ResList := TStringList.Create;
  try
    ResList.Add('<?xml version="1.0" encoding="gb2312"?>');
    ResList.Add('<root>');
    ResList.Add('<TransId>' + TranId2Str(TransId)+'</TransId>');
    ResList.Add('<TranBeinTime>' + formatdatetime('yyyy-MM-dd HH:nn:ss.zzz', TransBeginTime)+'</TranBeinTime>');
    ResList.Add('<CommitTranTime>' + formatdatetime('yyyy-MM-dd HH:nn:ss.zzz', TransCommitTime)+'</CommitTranTime>');
    ResList.Add('<details>');
    hasOneMoreData := false;
    for I := 0 to DDL.FItems.Count - 1 do
    begin
      ddlitem := TDDLItem(DDL.FItems[I]);
      if not ddlitem.isSkip then
      begin
        Tmpstr := '';
        case ddlitem.OpType of
          Opt_Insert:
            begin
              Tmpstr := GenSql_DDL_Insert(TDDLItem_Insert(ddlitem));
              if Tmpstr <> '' then
                Tmpstr := '<row id="' + IntToStr(I) + '" type="ddl">' + Tmpstr + '</row>';
            end;
          Opt_Update:
            begin
              Tmpstr := GenSql_DDL_Update(TDDLItem_Update(ddlitem));
              if Tmpstr <> '' then
                Tmpstr := '<row id="' + IntToStr(I) + '" type="ddl">' + Tmpstr + '</row>';
            end;
          Opt_Delete:
            begin
              Tmpstr := GenSql_DDL_Delete(TDDLItem_Delete(ddlitem));
              if Tmpstr <> '' then
                Tmpstr := '<row id="' + IntToStr(I) + '" type="ddl">' + Tmpstr + '</row>';
            end;
          Opt_TruncateTable:
            begin
              Tmpstr := DML_BuilderXML_Truncate(TDDL_Truncate_table(ddlitem));
              Tmpstr := '<row id="' + IntToStr(I) + '" type="dml">' + Tmpstr + '</row>';
            end;
          Opt_DML:
            begin
              Tmpstr := DML_BuilderXML(TDMLItem(DDL.FItems[I]).data);
              if Tmpstr <> '' then
                Tmpstr := '<row id="' + IntToStr(I) + '" type="dml">' + Tmpstr + '</row>';
            end;
        end;
        if Tmpstr <> '' then
        begin
          ResList.Add(Tmpstr);
          hasOneMoreData := True;
        end;
      end;
    end;
    ResList.Add('</details>');
    ResList.Add('</root>');
    if hasOneMoreData then
      Result := ResList.Text
    else
      Result := '';
  finally
    ResList.Free;
  end;
end;


function TSql2014logAnalyzer.GenSql_DDL_Insert(ddlitem: TDDLItem_Insert): string;
begin
  if ddlitem.xType = 'u' then
  begin
    Result := GenSql_CreateTable(ddlitem);
  end
  else if ddlitem.xType = 'd' then
  begin
    Result := GenSql_CreateDefault(ddlitem);
  end else if ddlitem.xType = 'pk' then
  begin
    Result := GenSql_CreatePrimaryKey(TDDL_Create_PrimaryKey(ddlitem));
  end else if ddlitem.xType = 'uq' then
  begin
    Result := GenSql_CreateUniqueKey(TDDL_Create_UniqueKey(ddlitem));
  end else if ddlitem.xType = 'c' then
  begin
    Result := GenSql_CreateCheck(TDDL_Create_Check(ddlitem));
  end else if ddlitem.xType = 'column' then
  begin
    Result := GenSql_CreateColumn(TDDL_Create_Column(ddlitem));
  end
  else
  begin

  end;
end;

function TSql2014logAnalyzer.GenSql_DDL_Delete(ddlitem: TDDLItem_Delete): string;
begin
  if ddlitem.xType = 'u' then
  begin
    Result := GenSql_DropTable(TDDL_Delete_Table(ddlitem));
  end
  else if ddlitem.xType = 'constraint' then
  begin
    Result := GenSql_DropConstraint(TDDL_Delete_Constraint(ddlitem));
  end else if ddlitem.xType = 'column' then
  begin
    Result := GenSql_DropColumn(TDDL_Delete_Column(ddlitem));
  end
  else
  begin

  end;
end;

function TSql2014logAnalyzer.GenSql_DDL_Update(ddlitem: TDDLItem_Update): string;
begin
  if ddlitem.xType = 'u' then
  begin
    //Result := GenSql_UpdateTable(TDDL_Update_Table(ddlitem));
  end else if ddlitem.xType = 'rename' then
  begin
    Result := GenSql_UpdateRenameObj(TDDL_Update_RenameObj(ddlitem));
  end else if ddlitem.xType = 'column' then
  begin
    Result := GenSql_UpdateColumn(TDDL_Update_Column(ddlitem));
  end
  else
  begin

  end;
end;

function TSql2014logAnalyzer.GenSql_UpdateRenameObj(ddlitem: TDDL_Update_RenameObj): string;
const
  SQLTEMPLATE = 'exec sp_rename ''%s'',''%s'';';
begin
  Result := '--sp_rename Obj id:'+IntToStr(ddlitem.ObjId);
  Result := Result + #$D#$A + Format(SQLTEMPLATE, [ddlitem.oldName, ddlitem.newName ]);
end;

function TSql2014logAnalyzer.GenSql_UpdateColumn(ddlitem: TDDL_Update_Column): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s alter column %s';
var
  tmpStr:string;
begin
  Result := '--alter Column table id:'+IntToStr(ddlitem.Table.TableId);
  tmpStr := ddlitem.field.getSafeColName + ' ';
  tmpStr := tmpStr + ddlitem.field.getTypeStr + ' ';
  if ddlitem.field.collation_name<>'' then
  begin
    tmpStr := tmpStr + 'COLLATE '+ ddlitem.field.collation_name + ' ';
  end;
  if ddlitem.field.is_nullable then
    tmpStr := tmpStr + 'NULL'
  else
     tmpStr := tmpStr + 'NOT NULL';

  Result := Result + #$D#$A + Format(SQLTEMPLATE, [ddlitem.Table.getFullName, tmpStr]);
end;

function TSql2014logAnalyzer.GenSql_DropColumn(ddlitem: TDDL_Delete_Column): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s drop column %s;';
var
  Table:TdbTableItem;
  DDLtable: TDDLItem;
begin
  Result := '--drop Column table id:'+IntToStr(ddlitem.TableId);

  DDLtable := ddl.GetItem(ddlitem.TableId);
  if (DDLtable <> nil) and (DDLtable.OpType = Opt_Insert) then
  begin
    Table := TDDL_Create_Table(DDLtable).TableObj;
  end
  else
  begin
    Table := FLogSource.Fdbc.dict.tables.GetItemById(ddlitem.TableId);
  end;
  if Table<>nil then
  begin
    Result := Result + #$D#$A + Format(SQLTEMPLATE, [Table.getFullName, ddlitem.objName]);
  end else begin
    Result := Result + #$D#$A + '/*';
    Result := Result + #$D#$A + Format(SQLTEMPLATE, ['#'+IntToStr(ddlitem.TableId), ddlitem.objName]);
    Result := Result + #$D#$A + '*/';
  end;
end;

function TSql2014logAnalyzer.GenSql_DropTable(ddlitem: TDDL_Delete_Table): string;
begin
  Result := '--drop TABLE ID :'+IntToStr(ddlitem.objId);
  Result := Result + #$D#$A + Format('DROP TABLE [%s].[%s]',[ddlitem.Owner,ddlitem.objName]);
end;

function TSql2014logAnalyzer.GenSql_DropConstraint(ddlitem: TDDL_Delete_Constraint): string;
var
  Table:TdbTableItem;
  resStr:Tstringlist;
begin
  resStr := Tstringlist.Create;
  try
    resStr.Add('--drop constraint');
    resStr.Add('--subType:'+ddlitem.subType);
    resStr.Add('--TableId:'+IntToStr(ddlitem.ParentId));
    resStr.Add('--ObjId:'+IntToStr(ddlitem.objId));
    resStr.Add('--objName:'+ddlitem.objName);
    Table := FLogSource.Fdbc.dict.tables.GetItemById(ddlitem.tableid);
    if Table = nil then
    begin
      resStr.Add(Format('-- alter table #%d drop constraint %s;',[ddlitem.ParentId,ddlitem.objName]));
    end
    else
    begin
      resStr.Add(Format('alter table %s drop constraint [%s];',[table.getFullName, ddlitem.objName]));
    end;
    Result := resStr.Text;
  finally
    resStr.Free;
  end;
end;

function TSql2014logAnalyzer.GenSql_CreateColumn(ddlitem: TDDL_Create_Column): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s ADD %s %s; ';
var
  resStr:Tstringlist;
  tmpStr:string;
begin
  resStr:=Tstringlist.Create;
  try
    resStr.Add('--ALTER TABLE Add Column');
    resStr.Add('--Tableid:'+inttostr(ddlitem.Table.TableId));
    resStr.Add('--columnName:'+ddlitem.field.ColName);
    tmpStr := ddlitem.field.getTypeStr + ' ';
    if ddlitem.field.collation_name<>'' then
    begin
      tmpStr := tmpStr + 'COLLATE '+ ddlitem.field.collation_name + ' ';
    end;
    if ddlitem.field.is_nullable then
    begin
      tmpStr := tmpStr + 'NULL';
    end
    else
    begin
      tmpStr := tmpStr + 'NOT NULL';
    end;
    resStr.Add(Format(SQLTEMPLATE, [ddlitem.Table.getFullName, ddlitem.field.getSafeColName, tmpStr]));
    Result := resStr.Text;
  finally
    resStr.Free;
  end;
end;

function TSql2014logAnalyzer.GenSql_CreateCheck(ddlitem: TDDL_Create_Check): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s ADD CONSTRAINT [%s] CHECK(%s) ';
var
  DDLtable: TDDLItem;
  tableL: TdbTableItem;
  resStr:Tstringlist;
  TmpStr:string;
begin
  Result := '';
  DDLtable := ddl.GetItem(ddlitem.tableid);
  if DDLtable <> nil then
  begin
    tableL := TDDL_Create_Table(DDLtable).TableObj;
  end
  else
  begin
    tableL := FLogSource.Fdbc.dict.tables.GetItemById(ddlitem.tableid);
  end;

  if tableL = nil then
  begin
    TmpStr := 'objId:'+ IntToStr(ddlitem.objId) + WIN_EOL;
    TmpStr := TmpStr +'objName:'+ ddlitem.objName+ WIN_EOL;
    TmpStr := TmpStr +'tableid:'+ IntToStr(ddlitem.tableid)+ WIN_EOL;
    TmpStr := TmpStr +'value:'+ ddlitem.value+ WIN_EOL;
    FLogSource.Loger.Add('GenSql_CreateCheck fail! ->' + TmpStr, LOG_ERROR or LOG_IMPORTANT);

    Exit;
  end;

  resStr:=Tstringlist.Create;
  try
    resStr.Add('--Create Check key');
    resStr.Add('--Tableid:'+inttostr(ddlitem.tableid));
    resStr.Add('--id:'+inttostr(ddlitem.objId));
    resStr.Add('--Name:'+ddlitem.objName);
    resStr.Add(Format(SQLTEMPLATE, [tableL.getFullName, ddlitem.objName, ddlitem.value]));
    Result := resStr.Text;
  finally
    resStr.Free;
  end;
end;

function TSql2014logAnalyzer.GenSql_CreateUniqueKey(ddlitem: TDDL_Create_UniqueKey): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s ADD CONSTRAINT [%s] UNIQUE %s (%s) ';
var
  DDLtable: TDDLItem;
  tableL: TdbTableItem;
  colName: string;
  CLUSTEREDType:string;
  cols:TObjectList;
  I: Integer;
  TempItem:TDDL_Idxs_ColsItem;
  dbfield:TdbFieldItem;
  resStr:Tstringlist;
  TmpStr:string;
begin
  Result := '';
  DDLtable := ddl.GetItem(ddlitem.tableid);
  if DDLtable <> nil then
  begin
    tableL := TDDL_Create_Table(DDLtable).TableObj;
  end
  else
  begin
    tableL := FLogSource.Fdbc.dict.tables.GetItemById(ddlitem.tableid);
  end;

  if tableL = nil then
  begin
    TmpStr := 'objId:'+ IntToStr(ddlitem.objId) + WIN_EOL;
    TmpStr := TmpStr +'objName:'+ ddlitem.objName+ WIN_EOL;
    TmpStr := TmpStr +'tableid:'+ IntToStr(ddlitem.tableid)+ WIN_EOL;
    TmpStr := TmpStr +'colid:'+ IntToStr(ddlitem.colid)+ WIN_EOL;
    TmpStr := TmpStr +'value:'+ ddlitem.value+ WIN_EOL;
    TmpStr := TmpStr +'isCLUSTERED:'+ BoolToStr(ddlitem.isCLUSTERED,True)+ WIN_EOL;
    FLogSource.Loger.Add('GenSql_CreateUniqueKey fail! ->' + TmpStr, LOG_ERROR or LOG_IMPORTANT);

    Exit;
  end;

  cols := IDXs.GetById(ddlitem.tableid);
  if (cols <> nil) and (cols.Count > 0) then
  begin
    colName := '';
    for I := 0 to cols.Count - 1 do
    begin
      TempItem := TDDL_Idxs_ColsItem(cols[I]);
      dbfield := tableL.Fields.GetItemById(TempItem.ColId);
      if dbfield <> nil then
      begin
        colName := colName + ',' + dbfield.getSafeColName + ' ' + TempItem.orderType;
      end;
    end;
    if colName<>'' then
      Delete(colName, 1, 1);
  end;

  if ddlitem.isCLUSTERED then
    CLUSTEREDType := 'CLUSTERED'
  else
    CLUSTEREDType := 'NONCLUSTERED';

  resStr:=Tstringlist.Create;
  try
    resStr.Add('--Create Unique key');
    resStr.Add('--Tableid:'+inttostr(ddlitem.tableid));
    resStr.Add('--id:'+inttostr(ddlitem.objId));
    resStr.Add('--Name:'+ddlitem.objName);
    resStr.Add(Format(SQLTEMPLATE, [tableL.getFullName, ddlitem.objName, CLUSTEREDType, colName]));
    Result := resStr.Text;
  finally
    resStr.Free;
  end;
end;

function TSql2014logAnalyzer.GenSql_CreatePrimaryKey(ddlitem: TDDL_Create_PrimaryKey): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s ADD CONSTRAINT [%s] PRIMARY KEY %s (%s) ';
var
  DDLtable: TDDLItem;
  tableL: TdbTableItem;
  tableName: string;
  colName: string;
  CLUSTEREDType:string;
  cols:TObjectList;
  I: Integer;
  TempItem:TDDL_Idxs_ColsItem;
  dbfield:TdbFieldItem;
  resStr:Tstringlist;

  hasError:Boolean;
  idxObj :TDDL_IDX_stats;
begin
  hasError := False;
  DDLtable := ddl.GetItem(ddlitem.tableid);
  if DDLtable <> nil then
  begin
    tableL := TDDL_Create_Table(DDLtable).TableObj;
  end
  else
  begin
    tableL := FLogSource.Fdbc.dict.tables.GetItemById(ddlitem.tableid);
  end;


  for I := 0 to IDXstats.Count-1 do
  begin
    idxObj := TDDL_IDX_stats(IDXstats[i]);
    if (ddlitem.tableid = idxObj.tableId) and (ddlitem.objName=idxObj.idxName) then
    begin
      ddlitem.isCLUSTERED := idxObj.isCLUSTERED;
    end;
  end;


  cols := IDXs.GetById(ddlitem.tableid);
  if (cols = nil) or (cols.Count = 0) then
  begin
    colName := '#';
  end
  else
  begin
    colName := '';
    if tableL = nil then
    begin
      hasError := True;
      for I := 0 to cols.Count - 1 do
      begin
        TempItem := TDDL_Idxs_ColsItem(cols[I]);
        colName := colName + ',' + inttostr(TempItem.idxId) + ' ' + TempItem.orderType;
      end;
    end
    else
    begin
      for I := 0 to cols.Count - 1 do
      begin
        TempItem := TDDL_Idxs_ColsItem(cols[I]);
        dbfield := tableL.Fields.GetItemById(TempItem.ColId);
        if dbfield = nil then
        begin
          hasError := True;
          colName := colName + ',' + inttostr(TempItem.idxId) + ' ' + TempItem.orderType;
        end
        else
        begin
          colName := colName + ',' + dbfield.getSafeColName + ' ' + TempItem.orderType;
        end;
      end;
      Delete(colName, 1, 1);
    end;
  end;

  if tableL=nil then
  begin
    tableName := '#'+inttostr(ddlitem.tableid);
    hasError := True;
  end else begin
    tableName := tableL.getFullName;
  end;
  if ddlitem.isCLUSTERED then
    CLUSTEREDType := 'CLUSTERED'
  else
    CLUSTEREDType := 'NONCLUSTERED';

  resStr:=Tstringlist.Create;
  try
    resStr.Add('--Create primary key');
    resStr.Add('--Tableid:'+inttostr(ddlitem.tableid));
    resStr.Add('--Pkid:'+inttostr(ddlitem.objId));
    resStr.Add('--PkName:'+ddlitem.objName);
    if hasError then
    begin
      resStr.Add('/*')
    end;
    resStr.Add(Format(SQLTEMPLATE, [tableName, ddlitem.objName, CLUSTEREDType, colName]));
    if hasError then
    begin
      resStr.Add('*/')
    end;
    Result := resStr.Text;
  finally
    resStr.Free;
  end;
end;

function TSql2014logAnalyzer.GenSql_CreateTable(ddlitem: TDDLItem): string;
const
  SQLTEMPLATE = 'CREATE TABLE %s(%s);';
var
  table: TDDL_Create_Table;
  colsStr: TStringList;
  I: Integer;
  tmpStr: string;
  FieldItem: TdbFieldItem;
begin
  table := TDDL_Create_Table(ddlitem);
  colsStr := TStringList.Create;
  try
    colsStr.Add(Format('-- Table id :%d', [table.TableObj.TableId]));
    colsStr.Add(Format('CREATE TABLE %s(', [table.TableObj.getFullName]));
    for I := 0 to table.TableObj.Fields.Count - 1 do
    begin
      FieldItem:=TdbFieldItem(table.TableObj.Fields[I]);
      tmpStr := FieldItem.getSafeColName + ' ';
      tmpStr := tmpStr + FieldItem.getTypeStr + ' ';
      if (FieldItem.collation_name<>'') then
      begin
        tmpStr := tmpStr + 'COLLATE '+ FieldItem.collation_name + ' ';
      end;
      if FieldItem.is_nullable then
      begin
        tmpStr := tmpStr + 'NULL';
      end
      else
      begin
        tmpStr := tmpStr + 'NOT NULL';
      end;
      if (FieldItem.Idt_seed>0) and (FieldItem.Idt_increment>0) then
      begin
        tmpStr := tmpStr + Format(' IDENTITY(%d,%d)',[FieldItem.Idt_seed, FieldItem.Idt_increment]);
      end;
      if I <> table.TableObj.Fields.Count - 1 then
      begin
        tmpStr := tmpStr + ', '
      end;
      colsStr.Add(tmpStr);
    end;
    colsStr.Add(');');
    Result := colsStr.Text;
  finally
    colsStr.Free;
  end;
end;

function TSql2014logAnalyzer.GenSql_CreateDefault(ddlitem: TDDLItem): string;
const
  SQLTEMPLATE = 'ALTER TABLE %s add constraint [%s] default %s for %s;';
var
  DDLtable: TDDLItem;
  tableL: TdbTableItem;
  DefObj: TDDL_Create_Def;
  ResStr: TStringList;
  tableName: string;
  colName: string;
begin
  DefObj := TDDL_Create_Def(ddlitem);
  DDLtable := ddl.GetItem(DefObj.tableid);
  if DDLtable <> nil then
  begin
    tableL := TDDL_Create_Table(DDLtable).TableObj;
  end
  else
  begin
    tableL := FLogSource.Fdbc.dict.tables.GetItemById(DefObj.tableid);
  end;

  ResStr := TStringList.Create;
  try
    if tableL = nil then
    begin
      tableName := '#' + IntToStr(DefObj.tableid);
      colName := '#' + IntToStr(DefObj.colid);
      ResStr.Add('-- generate Default constraint fail. the table object has been loss from database.');
      ResStr.Add(Format('-- Table id :%d', [DefObj.tableid]));
      ResStr.Add(Format('-- Constraint id :%d', [DefObj.objId]));
      ResStr.Add('/*');
      ResStr.Add(Format(SQLTEMPLATE, [tableName, DefObj.objName, DefObj.value, colName]));
      ResStr.Add('*/');
    end
    else
    begin
      ResStr.Add(Format('-- Constraint id :%d', [DefObj.objId]));
      tableName := tableL.getFullName;
      colName := tableL.Fields.GetItemById(DefObj.colid).getSafeColName;
      ResStr.Add(Format(SQLTEMPLATE, [tableName, DefObj.objName, DefObj.value, colName]));
    end;
    Result := ResStr.Text;
  finally
    ResStr.Free;
  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_D(DataRow: Tsql2014Opt);
begin
  if DataRow.Table.TableNmae = 'sysschobjs' then
  begin
    //删除表,存储过程、视图 、默认值等对象
    PriseDDLPkg_D_sysschobjs(DataRow);
  end
  else if DataRow.Table.TableNmae = 'syscolpars' then
  begin
    //删除表列
    PriseDDLPkg_D_syscolpars(DataRow);
  end else if DataRow.Table.TableNmae = 'sysidxstats' then
  begin
    //index 信息
    PriseDDLPkg_sysidxstats(DataRow);
  end
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_D_syscolpars(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  TableId: Integer;
  ColName: string;
  ColObj: TDDL_Delete_Column;
begin
  TableId := 0;
  ColName := '';

  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'id' then
    begin
      TableId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'name' then
    begin
      ColName := Hvu.GetFieldStrValue(pdd);
    end;
  end;

  ColObj := TDDL_Delete_Column.Create;
  ColObj.TableId := TableId;
  ColObj.objName := ColName;
  DDL.Add(ColObj);
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_U(DataRow: Tsql2014Opt);
begin
  if DataRow.Table.TableNmae = 'sysschobjs' then
  begin
    PriseDDLPkg_U_sysschobjs(DataRow);
  end
  else if DataRow.Table.TableNmae = 'syscolpars' then
  begin
    //修改列
    PriseDDLPkg_U_syscolpars(DataRow);
  end else if DataRow.Table.TableNmae = 'sysrscols' then
  begin
    //修改列
    PriseDDLPkg_U_sysrscols(DataRow);
  end else if DataRow.Table.TableNmae = 'sysrowsets' then
  begin
    PriseDDLPkg_U_sysrowsets(DataRow)
  end
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_U_sysrowsets(DataRow: Tsql2014Opt);
var
  rowsetid: Uint64;
  rcrows: Uint64;
  tableId:Integer;
  ttt:TDDL_Truncate_table;
begin
  if TryStrToUInt64(DataRow.new_data.getFieldStrValue('rowsetid'), rowsetid) and
     TryStrToUInt64(DataRow.new_data.getFieldStrValue('rcrows'), rcrows) and
    (rcrows = 0)
  then begin
    if FLogSource.Fdbc.dict.tables.Parti2ObjId.TryGetValue(rowsetid, tableId) then
    begin
      ttt := TDDL_Truncate_table.Create;
      ttt.Table := FLogSource.Fdbc.dict.tables.GetItemById(tableId);
      DDL.Add(ttt);
    end;
  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_U_sysschobjs(DataRow: Tsql2014Opt);
var
  ObjId: Integer;
  oldName,newName:string;
  renameObj:TDDL_Update_RenameObj;
  DDLtable: TDDLItem;
  table: TdbTableItem;
begin
  if TryStrToInt(DataRow.new_data.getFieldStrValue('id'), ObjId) then
  begin
    newName := DataRow.new_data.getFieldStrValue('name');
    oldName := DataRow.old_data.getFieldStrValue('name');
    if oldName <> newName then
    begin
      //ObjReName
      DDLtable := ddl.GetItem(ObjId);
      if DDLtable <> nil then
      begin
        table := TDDL_Create_Table(DDLtable).TableObj;
      end
      else
      begin
        table := FLogSource.Fdbc.dict.tables.GetItemById(ObjId);
      end;

      renameObj := TDDL_Update_RenameObj.Create;
      renameObj.oldName := '[' + table.Owner + '].[' + oldName.Replace(']', ']]') + ']';
      renameObj.newName := newName;
      renameObj.ObjId := ObjId;
      renameObj.subType := DataRow.new_data.getFieldStrValue('type');
      DDL.Add(renameObj);
    end;
  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_U_syscolpars(DataRow: Tsql2014Opt);
var
  ddlitem: TDDLItem;
  FieldItem: TdbFieldItem;
  table:TdbTableItem;
  //tmpVar
  collation_id: Integer;
  ObjId: Integer;
  ddl_col:TDDL_Update_Column;
  I:Integer;
  pdd: PdbFieldValue;
  OldCol:TdbFieldItem;
  oldName,newName:string;
  renameObj:TDDL_Update_RenameObj;
  citem:TSQLCollationItem;
begin
  if TryStrToInt(DataRow.new_data.getFieldStrValue('id'), ObjId) then
  begin
    newName := DataRow.new_data.getFieldStrValue('name');
    oldName := DataRow.old_data.getFieldStrValue('name');
    if oldName <> newName then
    begin
      //ObjReName
      ddlitem := ddl.GetItem(ObjId);
      if ddlitem <> nil then
      begin
        table := TDDL_Create_Table(ddlitem).TableObj;
      end
      else
      begin
        table := FLogSource.Fdbc.dict.tables.GetItemById(ObjId);
      end;

      renameObj := TDDL_Update_RenameObj.Create;
      renameObj.oldName := table.getFullName+'.['+oldName.Replace(']',']]')+']';
      renameObj.newName := newName;
      renameObj.ObjId := table.TableId;
      renameObj.colId := ObjId;
      renameObj.subType := 'column';
      DDL.Add(renameObj);
      exit;
    end;

    FieldItem := TdbFieldItem.Create;
    FieldItem.Col_id := StrToInt(DataRow.new_data.getFieldStrValue('colid'));
    FieldItem.ColName := newName;
    FieldItem.type_id := StrToInt(DataRow.new_data.getFieldStrValue('xtype')) and $FF;
    FieldItem.Max_length := StrToInt(DataRow.new_data.getFieldStrValue('length'));
    FieldItem.procision := StrToInt(DataRow.new_data.getFieldStrValue('prec'));
    FieldItem.scale := StrToInt(DataRow.new_data.getFieldStrValue('scale'));
    FieldItem.is_nullable := (StrToInt(DataRow.new_data.getFieldStrValue('status')) and 1) = 0;
    collation_id := StrToInt(DataRow.new_data.getFieldStrValue('collationid'));
    citem := FLogSource.getCollationById(collation_id);
    if citem<>nil then
    begin
      FieldItem.collation_name := citem.Name;
      FieldItem.CodePage := citem.CodePage;
    end;

    for I := DataRow.new_data.fields.Count - 1 downto 0 do
    begin
      pdd := PdbFieldValue(DataRow.new_data.fields[I]);
      if LowerCase(pdd.field.ColName) = 'idtval' then
      begin
        FieldItem.Idt_seed := PDWORD(@pdd.value[0])^;
        FieldItem.Idt_increment := PDWORD(@pdd.value[4])^;
        Break;
      end;
    end;

    ddlitem := DDL.GetItem(ObjId);
    if (ddlitem <> nil) and (ddlitem.xType = 'u') then
    begin
      //表修改字段
      OldCol := TDDL_Create_Table(ddlitem).TableObj.Fields.GetItemById(FieldItem.Col_id);
      if OldCol<>nil then
      begin
        OldCol.ColName := FieldItem.ColName;
        OldCol.type_id := FieldItem.type_id;
        OldCol.Max_length := FieldItem.Max_length;

        OldCol.procision := FieldItem.procision;
        OldCol.scale := FieldItem.scale;
        OldCol.collation_name := FieldItem.collation_name;

        OldCol.CodePage := FieldItem.CodePage;
        OldCol.Idt_seed := FieldItem.Idt_seed;
        OldCol.Idt_increment := FieldItem.Idt_increment;
        if OldCol.Idt_increment>0 then
          TDDL_Create_Table(ddlitem).TableObj.hasIdentity := True;
      end;
      FieldItem.free;
    end
    else
    begin
      table := FLogSource.Fdbc.dict.tables.GetItemById(ObjId);
      if table<>nil then
      begin
        ddl_col := TDDL_Update_Column.Create;
        ddl_col.Table := table;
        ddl_col.field := FieldItem;
        DDL.Add(ddl_col);
      end else begin
        FieldItem.Free;
        //不是表不存在
        FLogSource.Loger.Add('Error Message:PriseDDLPkg_U_syscolpars table not exists!tableid:%d',[ObjId]);
      end;
    end;
  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_U_sysrscols(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  rowsetid: int64;
  ColId: Integer;
  statusCode: Integer;
  ObjId: Integer;
  DataOffset: Integer;
  Nullbit: Integer;
  ddlitem: TDDLItem;
  FieldItem: TdbFieldItem;
  TableItem:TdbTableItem;
  ctable: TDDL_Create_Table;
  rsC:TDDL_RsCols;
begin
  rowsetid := 0;
  ColId := 0;
  statusCode := 0;
  DataOffset := 0;
  Nullbit := 0;
  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'rsid' then
    begin
      rowsetid := StrToInt64(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'rscolid' then
    begin
      ColId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'status' then
    begin
      statusCode := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'offset' then
    begin
      DataOffset := Hvu.getShort(pdd.value, 0, 2);
    end
    else if pdd_field_ColName = 'nullbit' then
    begin
      Nullbit := Hvu.getShort(pdd.value, 0, 2);
    end;
  end;
  if tmp_Parti.TryGetValue(rowsetid, ObjId) then
  begin
    ddlitem := DDL.GetItem(ObjId);
    if (ddlitem <> nil) and (ddlitem.xType = 'u') then
    begin
      ctable := TDDL_Create_Table(ddlitem);
      FieldItem := ctable.TableObj.Fields.GetItemById(ColId);
      if FieldItem <> nil then
      begin
        FieldItem.nullMap := Nullbit - 1;
        FieldItem.is_nullable := (statusCode and $80) = 0;
        FieldItem.leaf_pos := DataOffset;
      end;
    end;
  end
  else
  begin
    //直接修改表，alter table xxx xxx xxx xx;
    TableItem := FLogSource.Fdbc.dict.tables.GetItemByPartitionId(rowsetid);
    if (TableItem <> nil) and (ColId < 65535) then
    begin
      rsC := TDDL_RsCols.Create;
      rsC.rowsetid := rowsetid;
      rsC.ColId := ColId;
      rsC.statusCode := statusCode;
      rsC.DataOffset := DataOffset;
      rsC.Nullbit := Nullbit;
      rsC.TableObj := TableItem;
      Rscols.Add(rsC);
    end else begin
      //忽略的partition
    end;
  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg(DataRow: Tsql2014Opt);
var
  rowsetid: int64;
  ObjId: Integer;
  idminor:Integer;
  auid:Uint64;
begin
  if DataRow.Table.TableNmae = 'sysschobjs' then
  begin
    //新增表,存储过程、视图 、默认值等对象
    PriseDDLPkg_sysschobjs(DataRow);
  end
  else if DataRow.Table.TableNmae = 'syscolpars' then
  begin
    PriseDDLPkg_syscolpars(DataRow);
  end
  else if DataRow.Table.TableNmae = 'sysrowsets' then
  begin
    idminor := StrToInt64(DataRow.new_data.getFieldStrValue('idminor'));
    if idminor <= 1 then  //Composite ID
    begin
      rowsetid := StrToInt64(DataRow.new_data.getFieldStrValue('rowsetid'));
      ObjId := StrToInt(DataRow.new_data.getFieldStrValue('idmajor'));

      tmp_Parti.Add(rowsetid, ObjId);
    end;
  end
  else if DataRow.Table.TableNmae = 'sysallocunits' then
  begin
    auid := StrToInt64(DataRow.new_data.getFieldStrValue('auid'));
    rowsetid := StrToInt64(DataRow.new_data.getFieldStrValue('ownerid'));
    if tmp_Parti.TryGetValue(rowsetid, ObjId) then
    begin
      tmp_Alloc.Add(auid, ObjId);
    end else if FLogSource.Fdbc.dict.tables.Parti2ObjId.TryGetValue(rowsetid, ObjId) then
      tmp_Alloc.Add(auid, ObjId);
  end
  else if DataRow.Table.TableNmae = 'sysrscols' then
  begin
    PriseDDLPkg_sysrscols(DataRow);
  end
  else if DataRow.Table.TableNmae = 'sysobjvalues' then
  begin
    //默认值——值
    PriseDDLPkg_sysobjvalues(DataRow);
  end else if DataRow.Table.TableNmae = 'sysiscols' then
  begin
    //index fields
    PriseDDLPkg_sysiscols(DataRow);
  end else if DataRow.Table.TableNmae = 'sysidxstats' then
  begin
    //index 信息
    PriseDDLPkg_sysidxstats(DataRow);
  end;

end;

procedure TSql2014logAnalyzer.PriseDDLPkg_syscolpars(DataRow: Tsql2014Opt);
var
  ddlitem: TDDLItem;
  FieldItem: TdbFieldItem;
  table:TdbTableItem;
  //tmpVar
  collation_id: Integer;
  ObjId: Integer;
  ddl_col:TDDL_Create_Column;
  I:Integer;
  pdd: PdbFieldValue;
  citem:TSQLCollationItem;
begin
  if TryStrToInt(DataRow.new_data.getFieldStrValue('id'), ObjId) then
  begin
    ddlitem := DDL.GetItem(ObjId);
    FieldItem := TdbFieldItem.Create;
    FieldItem.Col_id := StrToInt(DataRow.new_data.getFieldStrValue('colid'));
    FieldItem.ColName := DataRow.new_data.getFieldStrValue('name');
    FieldItem.type_id := StrToInt(DataRow.new_data.getFieldStrValue('xtype')) and $FF;
    FieldItem.Max_length := StrToInt(DataRow.new_data.getFieldStrValue('length'));
    FieldItem.procision := StrToInt(DataRow.new_data.getFieldStrValue('prec'));
    FieldItem.scale := StrToInt(DataRow.new_data.getFieldStrValue('scale'));
    FieldItem.is_nullable := (StrToInt(DataRow.new_data.getFieldStrValue('status')) and 1) = 0;
    collation_id := StrToInt(DataRow.new_data.getFieldStrValue('collationid'));
    citem := FLogSource.getCollationById(collation_id);
    if citem <> nil then
    begin
      FieldItem.collation_name := citem.Name;
      FieldItem.CodePage := citem.CodePage;
    end;

    for I := DataRow.new_data.fields.Count - 1 downto 0 do
    begin
      pdd := PdbFieldValue(DataRow.new_data.fields[I]);
      if (LowerCase(pdd.field.ColName) = 'idtval') and (length(pdd.value) > 7) then
      begin
        FieldItem.Idt_seed := PDWORD(@pdd.value[0])^;
        FieldItem.Idt_increment := PDWORD(@pdd.value[4])^;
        Break;
      end;
    end;

    if (ddlitem <> nil) and (ddlitem.xType = 'u') then
    begin
      //表添加字段
      TDDL_Create_Table(ddlitem).TableObj.Fields.addField(FieldItem);
    end
    else
    begin
      table := FLogSource.Fdbc.dict.tables.GetItemById(ObjId);
      if table<>nil then
      begin
        ddl_col := TDDL_Create_Column.Create;
        ddl_col.Table := table;
        ddl_col.field := FieldItem;
        DDL.Add(ddl_col);
      end else begin
        FieldItem.Free;
        //不是创建表，也不是新增列
        raise Exception.Create('Error Message:PriseDDLPkg_syscolpars not Create table Or add Column');
      end;
    end;
  end;

end;

procedure TSql2014logAnalyzer.PriseDDLPkg_sysidxstats(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  objId: Integer;
  idxName:string;
  status:integer;
  idxtype:integer;

  idxObj:TDDL_IDX_stats;
begin
  objId := 0;
  idxName := '';
  status := 0;
  idxtype := 0;
  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'id' then
    begin
      objId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end else if pdd_field_ColName = 'name' then
    begin
      idxName := Hvu.GetFieldStrValue(pdd);
    end else if pdd_field_ColName = 'status' then
    begin
      status := StrToInt(Hvu.GetFieldStrValue(pdd));
    end else if pdd_field_ColName = 'type' then
    begin
      idxtype := StrToInt(Hvu.GetFieldStrValue(pdd));
    end;
  end;

  idxObj := TDDL_IDX_stats.Create;
  idxObj.tableId := objId;
  idxObj.idxName := idxName;
  idxObj.isUnique := (status and $8) > 0;
  idxObj.isCLUSTERED := idxtype = 1;
  IDXstats.Add(idxObj);
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_sysiscols(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  objId: Integer;
  indexId:Integer;
  status:Integer;
  fieldId:Integer;

begin
  objId := 0;
  indexId := 0;
  status := 0;
  fieldId := 0;

  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'idmajor' then
    begin
      objId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end else if pdd_field_ColName = 'idminor' then
    begin
      indexId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end else if pdd_field_ColName = 'status' then
    begin
      status := StrToInt(Hvu.GetFieldStrValue(pdd));
    end else if pdd_field_ColName = 'intprop' then
    begin
      fieldId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end;
  end;
  IDXs.Add(objId, indexId, fieldId, (status and 4) > 0);
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_sysobjvalues(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  valClass,objId: Integer;
  value: string;
  ddlitem: TDDLItem;
  DefObj: TDDL_Create_Def;
  chkObj :TDDL_Create_Check;
begin
  objId := 0;
  value := '';

  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'valClass' then
    begin
      //1 default val
      valClass := SmallInt(pdd.value[0]);
    end else
    if pdd_field_ColName = 'objid' then
    begin
      objId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'imageval' then
    begin
      value := Hvu.GetFieldStrValue(pdd);
    end;
  end;

  ddlitem := DDL.GetItem(objId);
  if ddlitem=nil then
  begin
    //raise Exception.Create('Error Message:PriseDDLPkg_sysrscols.1');
    //可能是索引键。
  end else begin
    if ddlitem.xType = 'd' then
    begin
      DefObj := TDDL_Create_Def(ddlitem);
      DefObj.value := hexToAnsiiData(value);
    end else if ddlitem.xType = 'c' then
    begin
      //check
      chkObj := TDDL_Create_Check(ddlitem);
      chkObj.value := hexToAnsiiData(value);
    end
    else if ddlitem.xType = 'u' then begin

    end else
    begin
      raise Exception.Create('Error Message:PriseDDLPkg_sysrscols.2');
    end;
  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_D_sysschobjs(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  ObjId: Integer;
  ObjName: string;
  nsid: Integer;
  ObjType: string;
  pid: Integer;
//  initprop: Integer; //如果对象是表值为表总列数，如果是默认值为列id

  table: TDDL_Delete_Table;
  DefObj: TDDL_Delete_Constraint;
  DefObjkey : TDDL_Delete_Constraint_key;
begin
  ObjId := 0;
  ObjName := '';
  nsid := 0;
  ObjType := '';
  pid := 0;
//  initprop := 0;

  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'id' then
    begin
      ObjId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'name' then
    begin
      ObjName := Hvu.GetFieldStrValue(pdd);
    end
    else if pdd_field_ColName = 'nsid' then
    begin
      nsid := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'type' then
    begin
      ObjType := Hvu.GetFieldStrValue(pdd);
    end
    else if pdd_field_ColName = 'pid' then
    begin
      pid := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'intprop' then
    begin
//      initprop := StrToInt(Hvu_GetFieldStrValue(pdd.field, pdd.value));
    end;
  end;
  ObjType := Trim(LowerCase(ObjType));

  if ObjType = 'u' then
  begin
    //表
    table := TDDL_Delete_Table.Create;
    table.objId := ObjId;
    table.objName := ObjName;
    table.Owner := FLogSource.Fdbc.GetSchemasName(nsid);
    DDL.Add(table);
  end
  else if ObjType = 'v' then
  begin
    //todo:视图

  end
  else if ObjType = 'p' then
  begin
    //todo:过程


  end
  else if (ObjType = 'pk') or (ObjType = 'uq') then
  begin
    //primary key ,unique key
    DefObjkey := TDDL_Delete_Constraint_key.Create;
    DefObjkey.subType := ObjType;
    DefObjkey.objId := ObjId;
    DefObjkey.objName := ObjName;
    DefObjkey.tableid := pid;
    DDL.Add(DefObjkey);
  end
  else if (ObjType = 'd') or (ObjType = 'pk') or (ObjType = 'uq') or (ObjType = 'c') or (ObjType = 'fk') then
  begin
    //default   ,primary key   ,unique key    ,check   ,FOREIGN key
    DefObj := TDDL_Delete_Constraint.Create;
    DefObj.subType := ObjType;
    DefObj.objId := ObjId;
    DefObj.objName := ObjName;
    DefObj.tableid := pid;
    DDL.Add(DefObj);
  end
  else if ObjType = 'tr' then
  begin
  //todo:Trigger

  end
  else
  begin
  //未知对象

  end;

end;

procedure TSql2014logAnalyzer.PriseDDLPkg_sysschobjs(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  ObjId: Integer;
  ObjName: string;
  nsid: Integer;
  ObjType: string;
  pid: Integer;
  initprop: Integer; //如果对象是表值为表总列数，如果是默认值为列id

  table: TDDL_Create_Table;
  DefObj: TDDL_Create_Def;
  pkObj:TDDL_Create_PrimaryKey;
  uqObj : TDDL_Create_UniqueKey;
  chkObj :TDDL_Create_Check;
begin
  ObjId := 0;
  ObjName := '';
  nsid := 0;
  ObjType := '';
  pid := 0;
  initprop := 0;

  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'id' then
    begin
      ObjId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'name' then
    begin
      ObjName := Hvu.GetFieldStrValue(pdd);
    end
    else if pdd_field_ColName = 'nsid' then
    begin
      nsid := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'type' then
    begin
      ObjType := Hvu.GetFieldStrValue(pdd);
    end
    else if pdd_field_ColName = 'pid' then
    begin
      pid := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'intprop' then
    begin
      initprop := StrToInt(Hvu.GetFieldStrValue(pdd));
    end;
  end;
  ObjType := Trim(LowerCase(ObjType));

  if ObjType = 'u' then
  begin
    //表
    table := TDDL_Create_Table.Create;
    table.TableObj.TableId := ObjId;
    table.TableObj.TableNmae := ObjName;
    table.TableObj.Owner := FLogSource.Fdbc.GetSchemasName(nsid);
    DDL.Add(table);
  end
  else if ObjType = 'v' then
  begin
    //todo:视图

  end
  else if ObjType = 'p' then
  begin
    //todo:过程


  end
  else if ObjType = 'c' then
  begin
    //todo:check
    chkObj := TDDL_Create_Check.Create;
    chkObj.objId := ObjId;
    chkObj.objName := ObjName;
    chkObj.tableid := pid;
    DDL.Add(chkObj);
  end
  else if ObjType = 'd' then
  begin
  //default
    DefObj := TDDL_Create_Def.Create;
    DefObj.objId := ObjId;
    DefObj.objName := ObjName;
    DefObj.tableid := pid;
    DefObj.colid := initprop;
    DDL.Add(DefObj);
  end
  else if ObjType = 'pk' then
  begin
    //primary key
    pkObj := TDDL_Create_PrimaryKey.Create;
    pkObj.objId := ObjId;
    pkObj.objName := ObjName;
    pkObj.tableid := pid;
    DDL.Add(pkObj);
  end
  else if ObjType = 'tr' then
  begin
  //todo:Trigger

  end
  else if ObjType = 'uq' then
  begin
    //Unique key
    uqObj := TDDL_Create_UniqueKey.Create;
    uqObj.objId := ObjId;
    uqObj.objName := ObjName;
    uqObj.tableid := pid;
    DDL.Add(uqObj);
  end
  else if ObjType = 'fk' then
  begin
  //todo:FOREIGN key


  end
  else
  begin
  //未知对象

  end;
end;

procedure TSql2014logAnalyzer.PriseDDLPkg_sysrscols(DataRow: Tsql2014Opt);
var
  I: Integer;
  pdd: PdbFieldValue;
  pdd_field_ColName: string;
  rowsetid: int64;
  ColId: Integer;
  statusCode: Integer;
  ObjId: Integer;
  DataOffset: Integer;
  Nullbit: Integer;
  ddlitem: TDDLItem;
  FieldItem: TdbFieldItem;
  TableItem:TdbTableItem;
  ctable: TDDL_Create_Table;
  rsC:TDDL_RsCols;
begin
  rowsetid := 0;
  ColId := 0;
  statusCode := 0;
  DataOffset := 0;
  Nullbit := 0;
  for I := 0 to DataRow.new_data.Fields.Count - 1 do
  begin
    pdd := PdbFieldValue(DataRow.new_data.Fields[I]);
    pdd_field_ColName := LowerCase(pdd.field.ColName);
    if pdd_field_ColName = 'rsid' then
    begin
      rowsetid := StrToInt64(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'rscolid' then
    begin
      ColId := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'status' then
    begin
      statusCode := StrToInt(Hvu.GetFieldStrValue(pdd));
    end
    else if pdd_field_ColName = 'offset' then
    begin
      DataOffset := Hvu.getShort(pdd.value, 0, 2);
    end
    else if pdd_field_ColName = 'nullbit' then
    begin
      Nullbit := Hvu.getShort(pdd.value, 0, 2);
    end;
  end;
  if tmp_Parti.TryGetValue(rowsetid, ObjId) then
  begin
    ddlitem := DDL.GetItem(ObjId);
    if (ddlitem <> nil) and (ddlitem.xType = 'u') then
    begin
      ctable := TDDL_Create_Table(ddlitem);
      FieldItem := ctable.TableObj.Fields.GetItemById(ColId);
      if FieldItem <> nil then
      begin
        FieldItem.nullMap := Nullbit - 1;
        FieldItem.is_nullable := (statusCode and $80) = 0;
        FieldItem.leaf_pos := DataOffset;
      end;
    end;
  end
  else
  begin
    //直接修改表，alter table xxx xxx xxx xx;
    TableItem := FLogSource.Fdbc.dict.tables.GetItemByPartitionId(rowsetid);
    if (TableItem <> nil) and (ColId < 65535) then
    begin
      rsC := TDDL_RsCols.Create;
      rsC.rowsetid := rowsetid;
      rsC.ColId := ColId;
      rsC.statusCode := statusCode;
      rsC.DataOffset := DataOffset;
      rsC.Nullbit := Nullbit;
      rsC.TableObj := TableItem;
      Rscols.Add(rsC);
    end else begin
      //忽略的partition
    end;
  end;
end;

function TSql2014logAnalyzer.getDataFrom_TEXT_MIX(idx: TBytes): TBytes;
var
  MIXDATAPkg: PLogMIXDATAPkg;
begin
  MIXDATAPkg := @idx[0];
  //TODO:这里解析有问题(长度可能0x10、0x18.最后8位是pageid
  //0400000001000000 384E00005A1F0000 AC0D000001000000
  //000051C300000000 B500000001000000
  Result := getDataFrom_TEXT_MIX_DATA(PPage_Id(@idx[Length(idx) - 8])^);
end;

function TSql2014logAnalyzer.getDataFrom_TEXT_MIX_DATA(Page: TPage_Id): TBytes;
var
  I,J: Integer;
  DataRow :Tsql2014Opt;
  MPD:PMIX_Page_DATA;
  MPD_0:PMIX_Page_DATA_0;
  MPD_2:PMIX_Page_DATA_2;
  MPD_3:PMIX_Page_DATA_3;
  MPD_5:PMIX_Page_DATA_5;
  nsize:Cardinal;
  tmpData:TBytes;
begin
  for I := 0 to FRows.Count - 1 do
  begin
    DataRow := Tsql2014Opt(FRows[i]);
    if DataRow.isMixData and (DataRow.R0 <> nil) and (DataRow.page.FID = Page.FID) and (DataRow.page.PID = Page.PID) and (DataRow.page.solt = Page.solt) then
    begin
      MPD := PMIX_Page_DATA(DataRow.R0);
      if MPD.MixType = 0 then
      begin
        //小于0x40的值全部在后面,大于0x40小于2x1F00的MixDataType = 5 ,大于1F00的 MixDataType = 2
        MPD_0 := PMIX_Page_DATA_0(DataRow.R0);
        SetLength(Result, MPD_0.dataLen);
        Move(MPD_0.data[0], Result[0], MPD_0.dataLen);
      end
      else if MPD.MixType = 2 then
      begin
        //page指针列表
        //UNKNOWN(2){?0x01F5} +pagecount(4)+pageid(6)+slotID(2)
        MPD_2 := PMIX_Page_DATA_2(DataRow.R0);
        nsize := 0;
        for J := 0 to MPD_2.pageCount - 1 do
        begin
          tmpData := getDataFrom_TEXT_MIX_DATA(MPD_2.Idxs[J].Pageid);
          SetLength(Result, nsize + Length(tmpData));
          Move(tmpData[0], Result[nsize], Length(tmpData));
          nsize := nsize + Length(tmpData);
        end;
      end
      else if MPD.MixType = 3 then
      begin
        //后面紧跟的全部是数据
        MPD_3 := PMIX_Page_DATA_3(DataRow.R0);
        nsize := MPD_3.a.Recordlen - SizeOf(TMIX_Page_DATA);
        SetLength(Result, nsize);
        Move(MPD_3.data[0], Result[0], nsize);
      end
      else if MPD.MixType = 5 then
      begin
        //data 指针
        //UNKNOWN(6)+dataversion(4)+dataLen(4)+pageid(6)+slotID(2)
        MPD_5 := PMIX_Page_DATA_5(DataRow.R0);
        Result := getDataFrom_TEXT_MIX_DATA(MPD_5.Pageid)
      end
//      else if MPD.MixType = 8 then
//      begin
//        //貌似可以忽略
//
//
//
//      end
      else
      begin
        FLogSource.Loger.Add('MIX_DATA:'+inttostr(MPD.MixType)+'>' + DumpMemory2Str(DataRow.R0, MPD.Recordlen), LOG_DATA or LOG_WARNING);
      end;
      Break;
    end;
  end;
end;

{ Tsql2014RowData }

constructor Tsql2014RowData.Create(logAnalyzer:TSql2014logAnalyzer);
begin
  fields := TList.Create;
  FlogAnalyzer := logAnalyzer;
end;

destructor Tsql2014RowData.Destroy;
var
  I: Integer;
  pdd: PdbFieldValue;
begin
  for I := 0 to fields.Count - 1 do
  begin
    pdd := PdbFieldValue(fields[I]);
    SetLength(pdd.value, 0);
    Dispose(pdd);
  end;
  fields.free;
  inherited;
end;

function Tsql2014RowData.getField(FieldName: string): PdbFieldValue;
var
  I: Integer;
  pdd: PdbFieldValue;
begin
  Result := nil;
  FieldName := LowerCase(FieldName);
  for I := 0 to fields.Count - 1 do
  begin
    pdd := PdbFieldValue(fields[I]);
    if LowerCase(pdd.field.ColName) = FieldName then
    begin
      Result := pdd;
      Exit;
    end;
  end;
end;

function Tsql2014RowData.getField(col_id: Integer): PdbFieldValue;
var
  I: Integer;
  pdd: PdbFieldValue;
begin
  Result := nil;
  for I := 0 to fields.Count - 1 do
  begin
    pdd := PdbFieldValue(fields[I]);
    if pdd.field.Col_id = col_id then
    begin
      Result := pdd;
      Exit;
    end;
  end;
end;

function Tsql2014RowData.getFieldStrValue(FieldName: string): string;
var
  I: Integer;
  pdd: PdbFieldValue;
begin
  //没有的字段默认null
  Result := 'NULL';
  FieldName := LowerCase(FieldName);
  for I := 0 to fields.Count - 1 do
  begin
    pdd := PdbFieldValue(fields[I]);
    if LowerCase(pdd.field.ColName) = FieldName then
    begin
      Result := FlogAnalyzer.Hvu.GetFieldStrValue(pdd);
      Break;
    end;
  end;
end;

{ MIX_DATA_Item }

constructor TMIX_DATA_Item.Create;
begin

end;

destructor TMIX_DATA_Item.Destroy;
begin
  SetLength(data, 0);
  inherited;
end;

{ TMIX_DATAs }

procedure TMIX_DATAs.add(idx: QWORD; pageid: TPage_Id; data: TBytes);
var
  item :TMIX_DATA_Item;
begin
  item := TMIX_DATA_Item.Create;
  item.Idx := idx;
  item.pageid := pageid;
  item.data := data;
  FItems.Add(item);
end;

constructor TMIX_DATAs.Create;
begin
  FItems := TObjectList.Create;
end;

destructor TMIX_DATAs.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TMIX_DATAs.GetItem_Idx(Key: Qword): TMIX_DATA_Item;
var
  I: Integer;
  item: TMIX_DATA_Item;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
  begin
    item := TMIX_DATA_Item(FItems[I]);
    if item.Idx = Key then
    begin
      Result := item;
    end;
  end;
end;

function TMIX_DATAs.GetItem_Pageid(pageid: TPage_Id): TMIX_DATA_Item;
var
  I: Integer;
  item: TMIX_DATA_Item;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
  begin
    item := TMIX_DATA_Item(FItems[I]);
    if (item.pageid.PID = pageid.PID) and (item.pageid.FID = pageid.FID) and (item.pageid.solt = pageid.solt) then
    begin
      Result := item;
    end;
  end;
end;

{ TsqlRawBuf }

constructor Tsql2014Opt.Create;
begin
  ___SourceId := 0;
  R0 := nil;
  R1 := nil;
  old_data := nil;
  new_data := nil;
  UniqueClusteredKeys := nil;

  deleteFromUpdate := False;
  isMixData := False;
end;

destructor Tsql2014Opt.Destroy;
begin
  if R0<>nil then
    FreeMemory(R0);

  if R1<>nil then
    FreeMemory(R1);

  if old_data<>nil then
     old_data.Free;
  if new_data<>nil then
     new_data.Free;

  inherited;
end;

{ TPageidGroup }

function TPageidGroup.Add(value: DWORD): Cardinal;
begin
  if fSize >= Length(Fbuff) then
  begin
    SetLength(Fbuff, Length(Fbuff) + Fcapacity);
  end;

  Fbuff[fSize] := value;
  Result := fSize;
  fSize := fSize + 1;
end;

constructor TPageidGroup.Create(pageid:TPage_Id; capacity: Cardinal);
begin
  Fcapacity := capacity;
  fSize := 0;
  SetLength(Fbuff, capacity);
  Fid := pageid.FID;
  Pid := pageid.PID;
end;

destructor TPageidGroup.Destroy;
begin
  SetLength(Fbuff, 0);
  inherited;
end;

function TPageidGroup.GetItem(Index: Integer): Cardinal;
begin
  Result := Fbuff[Index];
end;

{ TSql2014logAnalyzerThread }

constructor TSql2014logAnalyzerThread.Create(logsource:TLogSource;Transpkg: TTransPkg);
begin
  inherited Create(True);
  FTranspkg := Transpkg;
  Flogsource:=logsource;
  isdone := False;
  startIdx := 0;
  stopIdx := 0;

  FOpts := TObjectList.Create;
  FMixPending:=TList.Create;
end;

destructor TSql2014logAnalyzerThread.Destroy;
begin
  FMixPending.Free;
  FOpts.Free;
  inherited;
end;

procedure TSql2014logAnalyzerThread.Execute;
var
  I,J:Integer;
  TTpi :TTransPkgItem;
  tmpPg: TPageidGroup;
  DataRow_buf:Tsql2014Opt;
  TmpBinReader: TbinDataReader;
begin
  Flogsource.Loger.Add('------>TSql2014logAnalyzerThread run..%d-%d', [startIdx, stopIdx]);
  for I := startIdx to stopIdx - 1 do
  begin
    tmpPg := TPageidGroup(idsLst[I]);
    for J := 0 to tmpPg.Count-1 do
    begin
      CurProcesspkgIdx := tmpPg.Fbuff[J];
      TTpi := TTransPkgItem(FTranspkg.Items[CurProcesspkgIdx]);
      PriseRowLog(TTpi);
    end;
  end;

  for I := 0 to FOpts.Count - 1 do
  begin
    DataRow_buf := Tsql2014Opt(FOpts[i]);
    if DataRow_buf.deleteFlag or DataRow_buf.isMixData then
    begin
      Continue;
    end;
    if DataRow_buf.R0<>nil then
    begin
      TmpBinReader := TbinDataReader.Create(DataRow_buf.R0, $2000);
      try
        DataRow_buf.new_data := PriseRowLog_InsertDeleteRowData(DataRow_buf.table, TmpBinReader);
      finally
        TmpBinReader.Free;
      end;
      if DataRow_buf.R1 <> nil then
      begin
        TmpBinReader := TbinDataReader.Create(DataRow_buf.R1, $2000);
        try
          DataRow_buf.old_data := PriseRowLog_InsertDeleteRowData(DataRow_buf.table, TmpBinReader);
        finally
          TmpBinReader.Free;
        end;
      end;
    end;

    if Length(DataRow_buf.UniqueClusteredKeys)>0 then
    begin
      DataRow_buf.UniqueClusteredKeysStr := PriseRowLog_UniqueClusteredKeys(DataRow_buf.UniqueClusteredKeys, DataRow_buf.table);
    end;
  end;

  isdone := True;
end;

procedure TSql2014logAnalyzerThread.PriseRowLog(tPkg: TTransPkgItem);
var
  Rl: PRawLog;
begin
  Rl := tPkg.Raw.data;
  try
    if Rl.OpCode = LOP_INSERT_ROWS then //新增
    begin
      PriseRowLog_Insert(tPkg);
    end
    else if Rl.OpCode = LOP_DELETE_ROWS then  //删除
    begin
      PriseRowLog_Delete(tPkg);
    end
    else if Rl.OpCode = LOP_MODIFY_ROW then  //修改单个块
    begin
      PriseRowLog_MODIFY_ROW(tPkg);
    end
    else if Rl.OpCode = LOP_MODIFY_COLUMNS then  //修改多个块
    begin
      PriseRowLog_MODIFY_COLUMNS(tPkg);
    end else if Rl.OpCode = LOP_FORMAT_PAGE then  //页初始化，select into是直接整页写入
    begin
      PriseRowLOP_FORMAT_PAGE(tPkg);
    end;
  except
    on E: Exception do
    begin
      FLogSource.Loger.Add(E.Message + '-->LSN:' + lsn2str(tPkg.LSN), LOG_ERROR);
    end;
  end;
end;

procedure TSql2014logAnalyzerThread.PriseRowLog_Insert(tPkg: TTransPkgItem);
var
  Rldo: PRawLog_DataOpt;
  R_: array of TBytes;
  R_Info: array of TRawElement;
  I: Integer;
  BinReader: TbinDataReader;
  TableId: Integer;
  DbTable: TdbTableItem;
  DataRow: Tsql2014Opt;
  TmpCPnt:UIntPtr;
  TmpSize:Cardinal;
begin
  DataRow := nil;
  Rldo := tPkg.Raw.data;
  if Rldo.normalData.ContextCode in [LCX_HEAP,//堆表写入(没有聚合索引的表
    LCX_CLUSTERED, //聚合写入
    LCX_TEXT_TREE, LCX_TEXT_MIX //行分块数据 image,text,ntext之类的
    ] then
  begin
    if (Rldo.normalData.FlagBits and 1)>0 then
    begin
      //Rollback tran
      //COMPENSATION    恢复事务中Delete的数据
      for I := FOpts.Count - 1 downto 0 do
      begin
        DataRow := Tsql2014Opt(FOpts[i]);
        if (DataRow.page.PID = Rldo.pageId.PID) and
          (DataRow.page.FID = Rldo.pageId.FID) and
          (DataRow.page.solt = Rldo.pageId.solt) then
        begin
          //撤销之前的数据
          if DataRow.OperaType = Opt_Insert then
          begin
            //insert的数据。delete然后回滚delete
            DataRow.deleteFlag := False;

            TmpCPnt :=  UIntPtr(Rldo)+ SizeOf(TRawLog_DataOpt) ;
            TmpSize := PWord(TmpCPnt)^;
            TmpCPnt := TmpCPnt + Rldo.NumElements*2;
            TmpCPnt := (TmpCPnt + 3) and $FFFFFFFC;

            //只读第一个块放进buf就是了
            if DataRow.R0<>nil then
              FreeMemory(DataRow.R0);
            DataRow.R0 := GetMemory($2000);
            Move(Pointer(TmpCPnt)^, DataRow.R0^, TmpSize);
          end else if DataRow.deleteFromUpdate then
          begin
            DataRow.OperaType := Opt_Update;
          end else
          begin
            //delete 然后回滚
            FOpts.Delete(i);
          end;

          Break;
        end
      end;
    end else begin
      SetLength(R_, Rldo.NumElements);
      SetLength(R_Info, Rldo.NumElements);
      BinReader := TbinDataReader.Create(tPkg.Raw);
      try
        BinReader.seek(SizeOf(TRawLog_DataOpt), soBeginning);
        for I := 0 to Rldo.NumElements - 1 do
        begin
          R_Info[I].Length := BinReader.readWord;
        end;
        BinReader.alignTo4;
        for I := 0 to Rldo.NumElements - 1 do
        begin
          if R_Info[I].Length > 0 then
          begin
            R_Info[I].Offset := BinReader.Position;
            R_[I] := BinReader.readBytes(R_Info[I].Length);
            BinReader.alignTo4;
          end;
        end;
        //一般是 3 块数据 (可以有N个块
        //1至n-2. 真实写入的数据
        //n-1. 0 聚合索引信息（对于Insert日志，此值保持null
        //n. 表信息 (LCX_TEXT_TREE可能不包含此信息
        if R_Info[Rldo.NumElements - 1].Length <> 0 then
        begin
          BinReader.SetRange(R_Info[Rldo.NumElements - 1].Offset, R_Info[Rldo.NumElements - 1].Length);
          BinReader.skip(6);
          TableId := BinReader.readInt;
          DbTable := FLogSource.GetTableById(TableId);
          if DbTable = nil then
          begin
            //忽略的表
            Exit;
          end;
        end else begin
          //LCX_TEXT_TREE
          if (Rldo.normalData.ContextCode = LCX_TEXT_TREE) or
             (Rldo.normalData.ContextCode = LCX_TEXT_MIX) then
          begin
            DbTable := nil;
          end else begin
            //Move Page
            exit
          end;
        end;

        if (PByte(UIntPtr(Rldo) + R_Info[0].offset)^ and $02) = 2 then
        begin
          //FORWARDED_RECORD
          exit;
        end;

        DataRow := Tsql2014Opt.Create;
        DataRow.___sourceId := CurProcesspkgIdx;
        DataRow.OperaType := Opt_Insert;
        DataRow.page := Rldo.pageId;
        DataRow.table := DbTable;
        DataRow.R0 := GetMemory($2000);
        Move(Pointer(UIntPtr(Rldo)+R_Info[0].Offset)^, DataRow.R0^, R_Info[0].Length);
        if Rldo.normalData.ContextCode in [LCX_TEXT_TREE, LCX_TEXT_MIX] then
        begin
          DataRow.isMixData := True;
        end;
        FOpts.Add(DataRow);
      finally
         BinReader.Free;
      end;
    end;
  end;
end;

procedure TSql2014logAnalyzerThread.PriseRowLog_Delete(tPkg: TTransPkgItem);
var
  Rldo: PRawLog_DataOpt;
  BinReader: TbinDataReader;
  R_: array of TBytes;
  R_Info: array of TRawElement;
  I: Integer;
  TableId: Integer;
  DbTable: TdbTableItem;
  DataRow: Tsql2014Opt;
  TmpCPnt:UIntPtr;
  TmpSize:Cardinal;
begin
  DataRow := nil;
  Rldo := tPkg.Raw.data;
  case Rldo.normalData.ContextCode of
    LCX_MARK_AS_GHOST, LCX_CLUSTERED, LCX_HEAP:
      begin
        if (Rldo.normalData.FlagBits and 1) > 0 then
        begin
            //rollback tran
            //COMPENSATION    删除事务中insert的数据
          for I := FOpts.Count - 1 downto 0 do
          begin
            DataRow := Tsql2014Opt(FOpts[I]);
            if (DataRow.page.PID = Rldo.pageId.PID) and (DataRow.page.FID = Rldo.pageId.FID) and (DataRow.page.solt = Rldo.pageId.solt) then
            begin
              //撤销之前的数据
              FOpts.Delete(I);
              Break;
            end
          end;
        end
        else
        begin
            //删除前，先查找下之前有没有对本行数据的操作（insert或Update，有则取消之前操作
          for I := FOpts.Count - 1 downto 0 do
          begin
            DataRow := Tsql2014Opt(FOpts[I]);
            if (DataRow.page.PID = Rldo.pageId.PID) and (DataRow.page.FID = Rldo.pageId.FID) and (DataRow.page.solt = Rldo.pageId.solt) then
            begin
                //撤销之前的数据
              if DataRow.OperaType = Opt_Insert then
              begin
                DataRow.deleteFlag := True;
                  //同一个事务中先insert然后再delete(
                Exit;
              end
              else
              begin
                 //同一个事务中先update然后再delete(

                //操作性质变更
                DataRow.deleteFromUpdate := True;     //如果此删除回滚，用于还原之前的Update状态
                DataRow.OperaType := Opt_Delete;
                  //替换R0
                TmpCPnt := UIntPtr(Rldo) + SizeOf(TRawLog_DataOpt);
                TmpSize := PWord(TmpCPnt)^;
                TmpCPnt := TmpCPnt + Rldo.NumElements * 2;
                TmpCPnt := (TmpCPnt + 3) and $FFFFFFFC;

                  //只读第一个块放进buf就是了
                if DataRow.R0 <> nil then
                  FreeMemory(DataRow.R0);
                DataRow.R0 := GetMemory($2000);
                Move(Pointer(TmpCPnt)^, DataRow.R0^, TmpSize);
                Exit;
              end;
            end
          end;

          SetLength(R_, Rldo.NumElements);
          SetLength(R_Info, Rldo.NumElements);
          BinReader := TbinDataReader.Create(tPkg.Raw);
          try
            BinReader.seek(SizeOf(TRawLog_DataOpt), soBeginning);
            for I := 0 to Rldo.NumElements - 1 do
            begin
              R_Info[I].Length := BinReader.readWord;
            end;
            BinReader.alignTo4;
            for I := 0 to Rldo.NumElements - 1 do
            begin
              if R_Info[I].Length > 0 then
              begin
                R_Info[I].offset := BinReader.Position;
                R_[I] := BinReader.readBytes(R_Info[I].Length);
                BinReader.alignTo4;
              end;
            end;
            //一般是 2 块数据
            //1. 删除的行数据
            //2. 表信息
            if (Pbyte(UIntPtr(Rldo) + R_Info[0].offset)^ and $F) > 0 then
            begin
              //not primary record
              Exit;
            end;

            BinReader.SetRange(R_Info[1].offset, R_Info[1].Length);
            BinReader.skip(6);
            TableId := BinReader.readInt;
            DbTable := FLogSource.GetTableById(TableId);
            if DbTable = nil then
            begin
              //忽略的表
              Exit;
            end;

            //开始读取R0
            DataRow := Tsql2014Opt.Create;
            DataRow.OperaType := Opt_Delete;
            DataRow.page := Rldo.pageId;
            DataRow.table := DbTable;
            DataRow.R0 := GetMemory($2000);
            Move(Pointer(UIntPtr(Rldo) + R_Info[0].offset)^, DataRow.R0^, R_Info[0].Length);
            FOpts.Add(DataRow);
          finally
            if BinReader <> nil then
              BinReader.Free;
          end;

        end;
      end;
    LCX_TEXT_MIX:
      begin
        //可以忽略的。删除行数据的时候这个会自动删除掉
      end;
  end;
end;

procedure TSql2014logAnalyzerThread.applyUpdateChange(srcData, pdata: Pointer; offset, size_old, size_new, datarowCnt: Integer);
var
  tmpdata:Pointer;
  tmpLen:Integer;
begin
  //回滚一个修改
  if size_old = size_new then
  begin
    Move(pdata^, Pointer(uintptr(srcData) + offset)^, size_old);
  end
  else begin
    if size_old < size_new then
    begin
      //数据后移
      tmpLen := datarowCnt - offset;
      if tmpLen > 0 then
      begin
        tmpdata := AllocMem(tmpLen);
        Move(Pointer(uintptr(srcData) + offset)^, tmpdata^, tmpLen);
        Move(tmpdata^, Pointer(uintptr(srcData) + offset + (size_new - size_old))^, tmpLen);
        FreeMem(tmpdata);
      end;
      Move(pdata^, Pointer(uintptr(srcData) + offset)^, size_new);
    end else begin
      //前移
      tmpLen := datarowCnt - offset;
      tmpdata := AllocMem(tmpLen);
      Move(Pointer(uintptr(srcData) + offset)^, tmpdata^, tmpLen);
      Move(Pointer(uintptr(tmpdata) + (size_old - size_new))^, Pointer(uintptr(srcData) + offset)^, tmpLen - (size_old - size_new));
      Move(pdata^, Pointer(uintptr(srcData) + offset)^, size_new);
      FreeMem(tmpdata);
    end;
    if Pbyte(srcData)^ = $0008 then
    begin
      //mix data
      tmpLen := datarowCnt + size_new - size_old;
      PWord(uintptr(srcData) + 2)^ := tmpLen;
    end;
  end;
end;

procedure TSql2014logAnalyzerThread.PriseRowLog_MODIFY_ROW(tPkg: TTransPkgItem);
var
  Rldo: PRawLog_DataOpt;
  R_: array of TBytes;
  R_Info: array of TRawElement;
  BinReader: TbinDataReader;
  I:Integer;
  OriginRowData:TBytes;
  TableId: Integer;
  DbTable: TdbTableItem;
  tmpdata:Pointer;
  DataRow_buf: Tsql2014Opt;
  RawDataLen:Integer;
  Rawssssss:TTransPkgItem;
begin
  BinReader := nil;
  DataRow_buf := nil;
  Rldo := tPkg.Raw.data;
  try
    case Rldo.normalData.ContextCode of
      LCX_HEAP, //堆表写入
      LCX_CLUSTERED, //聚合写入
      LCX_TEXT_TREE, LCX_TEXT_MIX:
        begin
          SetLength(R_, Rldo.NumElements);
          SetLength(R_Info, Rldo.NumElements);
          BinReader := TbinDataReader.Create(tPkg.Raw);
          BinReader.seek(SizeOf(TRawLog_DataOpt), soBeginning);
          for I := 0 to Rldo.NumElements - 1 do
          begin
            R_Info[I].Length := BinReader.readWord;
          end;
          BinReader.alignTo4;
          for I := 0 to Rldo.NumElements - 1 do
          begin
            if R_Info[I].Length > 0 then
            begin
              R_Info[I].Offset := BinReader.Position;
              R_[I] := BinReader.readBytes(R_Info[I].Length);
              BinReader.alignTo4;
            end;
          end;
          //一般是 6 块数据
          //0, 旧数据
          //1. 新数据
          //2. 聚合索引信息
          //3. 表信息
          //4. 0
          //5. 0
          if (Rldo.normalData.FlagBits and 1) > 0 then
          begin
            //COMPENSATION
            for I := FOpts.Count - 1 downto 0 do
            begin
              DataRow_buf := Tsql2014Opt(FOpts[i]);
              if (DataRow_buf.page.PID = Rldo.pageId.PID) and
                (DataRow_buf.page.FID = Rldo.pageId.FID) and
                (DataRow_buf.page.solt = Rldo.pageId.solt) then
              begin
                //找到页，修正页数据
                if (DataRow_buf.OperaType = Opt_Update) or (DataRow_buf.OperaType=Opt_Insert) then
                begin
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  applyUpdateChange(DataRow_buf.R0, R_[1], Rldo.OffsetInRow, Rldo.ModifySize, R_Info[1].Length, RawDataLen);
                end else if DataRow_buf.OperaType=Opt_Insert then
                begin
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  applyUpdateChange(DataRow_buf.R0, R_[1], Rldo.OffsetInRow, Rldo.ModifySize, R_Info[1].Length, RawDataLen);
                end;
                Break;
              end
            end;
          end else begin
            for I := FOpts.Count - 1 downto 0 do
            begin
              DataRow_buf := Tsql2014Opt(FOpts[i]);
              if (DataRow_buf.page.PID = Rldo.pageId.PID) and
                (DataRow_buf.page.FID = Rldo.pageId.FID) and
                (DataRow_buf.page.solt = Rldo.pageId.solt) then
              begin
                if DataRow_buf.OperaType = Opt_Update then
                begin
                  //Update后再update
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  applyUpdateChange(DataRow_buf.R0, R_[1], Rldo.OffsetInRow, Rldo.ModifySize, R_Info[1].Length, RawDataLen);
                end
                else if DataRow_buf.OperaType = Opt_Insert then
                begin
                  //先insert再update的
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  applyUpdateChange(DataRow_buf.R0, R_[1], Rldo.OffsetInRow, R_Info[0].Length, R_Info[1].Length, RawDataLen);
                end
                else if DataRow_buf.OperaType = Opt_Delete then
                begin
                  //这肯定是删除了数据然后又回滚了的（R0中包含了当前行的完整数据
                  //^^^^^delete然后回滚，操作会被删除掉，到不了这里
//                  DataRow_buf.OperaType := Opt_Update;
//                  DataRow_buf.deleteFlag := False;
//                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
//                  applyUpdateChange(DataRow_buf.R0, R_[1], Rldo.OffsetInRow, R_Info[0].Length, R_Info[1].Length, RawDataLen);
                end;
                exit;
              end
            end;

            BinReader.SetRange(R_Info[3].Offset, R_Info[3].Length);
            BinReader.skip(6);
            TableId := BinReader.readInt;
            DbTable := FLogSource.GetTableById(TableId);
            if DbTable = nil then
            begin
              //忽略的表
              Exit;
            end;

            if FLogSource.FFFFIsDebug then
            begin
              for I := 0 to FLogSource.pageDatalist.Count - 1 do
              begin
                Rawssssss := TTransPkgItem(FLogSource.pageDatalist[I]);
                if (Rawssssss.LSN.LSN_1 = tPkg.LSN.LSN_1) and (Rawssssss.LSN.LSN_2 = tPkg.LSN.LSN_2) and (Rawssssss.LSN.LSN_3 = tPkg.LSN.LSN_3) then
                begin
                  SetLength(OriginRowData, Rawssssss.Raw.dataSize);
                  CopyMemory(@OriginRowData[0], Rawssssss.Raw.data, Rawssssss.Raw.dataSize);
                end;
              end;
            end
            else
            begin
              OriginRowData := pc__PageCache.getUpdateSoltData(FLogSource.Fdbc, tPkg.LSN, Rldo.pageId, FTranspkg);
              if OriginRowData = nil then
                OriginRowData := getUpdateSoltData(FLogSource.Fdbc, Rldo.normalData.PreviousLSN);
            end;

            if OriginRowData = nil then
            begin
              FLogSource.Loger.Add('获取行原始数据失败！' + lsn2str(tPkg.LSN) + ',pLSN:' + lsn2str(Rldo.normalData.PreviousLSN), LOG_WARNING or LOG_IMPORTANT);
              Exit;
            end
            else if OriginRowData[0] = 4 then
            begin
              //FORWARDING_STUB
              Exit;
            end;

            DataRow_buf := Tsql2014Opt.Create;
            try
              if (DbTable.UniqueClusteredKeys.Count>0) and (R_Info[2].Length > 0) then
              begin
                //读取UniqueClusteredKeys
                BinReader.SetRange(R_Info[2].Offset, R_Info[2].Length);
                DataRow_buf.UniqueClusteredKeys := BinReader.readBytes(R_Info[2].Length);
              end;

              DataRow_buf.OperaType := Opt_Update;
              DataRow_buf.page := Rldo.pageId;
              DataRow_buf.table := DbTable;

              //before
              tmpdata := GetMemory($2000);
              Move(OriginRowData[0], tmpdata^, Length(OriginRowData));
              RawDataLen := PageRowCalcLength(tmpdata);
              applyUpdateChange(tmpdata, R_[0], Rldo.OffsetInRow, R_Info[1].Length, R_Info[0].Length, RawDataLen);
              DataRow_buf.R1 := tmpdata;
              //after
              tmpdata := GetMemory($2000);
              Move(OriginRowData[0], tmpdata^, Length(OriginRowData));
              DataRow_buf.R0 := tmpdata;
              if Rldo.normalData.ContextCode in [LCX_TEXT_TREE, LCX_TEXT_MIX] then
              begin
                DataRow_buf.isMixData := True;
              end;
              FOpts.Add(DataRow_buf);
            except
              DataRow_buf.Free;
            end;
            SetLength(OriginRowData, 0);
          end;
        end;
    else
    end;
  finally
    if BinReader <> nil then
      BinReader.Free;
  end;
end;

procedure TSql2014logAnalyzerThread.PriseRowLog_MODIFY_COLUMNS(tPkg: TTransPkgItem);
var
  Rldo: PRawLog_DataOpt;
  R_: array of TBytes;
  R_Info: array of TRawElement;
  BinReader: TbinDataReader;
  I, J:Integer;
  OriginRowData:TBytes;
  OffsetInRow:Word;
  TableId: Integer;
  DbTable: TdbTableItem;
  DataRow_buf: Tsql2014Opt;
  tmpdata:Pointer;
  RawDataLen:Integer;
  tmpLen:Word;
  Rawssssss :TTransPkgItem;
begin
  BinReader := nil;
  Rldo := tPkg.Raw.data;
  try
    case Rldo.normalData.ContextCode of
      LCX_HEAP, //堆表写入
      LCX_CLUSTERED, //聚合写入
      LCX_TEXT_TREE, LCX_TEXT_MIX:
        begin
          SetLength(R_, Rldo.NumElements);
          SetLength(R_Info, Rldo.NumElements);
          BinReader := TbinDataReader.Create(tPkg.Raw);
          BinReader.seek(SizeOf(TRawLog_DataOpt), soBeginning);
          for I := 0 to Rldo.NumElements - 1 do
          begin
            R_Info[I].Length := BinReader.readWord;
          end;
          BinReader.alignTo4;
          for I := 0 to Rldo.NumElements - 1 do
          begin
            if R_Info[I].Length > 0 then
            begin
              R_Info[I].Offset := BinReader.Position;
              R_[I] := BinReader.readBytes(R_Info[I].Length);
              BinReader.alignTo4;
            end;
          end;
          (*
          0:更新的Offset
          1:更新的大小
          2:聚集索引信息
          3:锁信息，object_id和 lock_key
          --之后是修改的内容，类似Log_MODIFY_ROW的r0和r1
          每2个为一组，至少有2组
          *)

          if (Rldo.normalData.FlagBits and 1) > 0 then
          begin
            //COMPENSATION
            for I := FOpts.Count - 1 downto 0 do
            begin
              DataRow_buf := Tsql2014Opt(FOpts[i]);
              if (DataRow_buf.page.PID = Rldo.pageId.PID) and
                (DataRow_buf.page.FID = Rldo.pageId.FID) and
                (DataRow_buf.page.solt = Rldo.pageId.solt) then
              begin
                //找到页，修正页数据
                if DataRow_buf.OperaType = Opt_Update then
                begin
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  for J := 0 to ((Rldo.NumElements - 4) div 2) - 1 do
                  begin
                    OffsetInRow := Pword(UIntPtr(R_[0]) + J * 4)^;
                    tmpLen := Pword(UIntPtr(R_[1]) + J * 2)^;
                    applyUpdateChange(DataRow_buf.R0, R_[4 + J * 2 + 1], OffsetInRow, tmpLen, R_Info[4 + J * 2 + 1].Length, RawDataLen);
                    RawDataLen := RawDataLen + (R_Info[4 + J * 2 + 1].Length - tmpLen);
                  end;
                end else if DataRow_buf.OperaType=Opt_Insert then
                begin
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  for J := 0 to ((Rldo.NumElements - 4) div 2) - 1 do
                  begin
                    OffsetInRow := Pword(UIntPtr(R_[0]) + J * 4)^;
                    tmpLen := Pword(UIntPtr(R_[1]) + J * 2)^;
                    applyUpdateChange(DataRow_buf.R0, R_[4 + J * 2 + 1], OffsetInRow, tmpLen, R_Info[4 + J * 2 + 1].Length, RawDataLen);
                    RawDataLen := RawDataLen + (R_Info[4 + J * 2 + 1].Length - tmpLen);
                  end;
                end;
                Break;
              end
            end;
          end else begin
            for I := FOpts.Count - 1 downto 0 do
            begin
              DataRow_buf := Tsql2014Opt(FOpts[i]);
              if (DataRow_buf.page.PID = Rldo.pageId.PID) and
                (DataRow_buf.page.FID = Rldo.pageId.FID) and
                (DataRow_buf.page.solt = Rldo.pageId.solt) then
              begin
                //找到页，修正页数据
                if DataRow_buf.OperaType = Opt_Update then
                begin
                  if (DataRow_buf.R0<>nil) then
                  begin
                    RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                    for J := 0 to ((Rldo.NumElements - 4) div 2) - 1 do
                    begin
                      OffsetInRow := Pword(UIntPtr(R_[0]) + J * 4 + 2)^;
                      applyUpdateChange(DataRow_buf.R0, R_[4 + J * 2 + 1], OffsetInRow, R_Info[4 + J * 2].Length, R_Info[4 + J * 2 + 1].Length, RawDataLen);
                      RawDataLen := RawDataLen + (R_Info[4 + J * 2 + 1].Length - R_Info[4 + J * 2].Length);
                    end;
                  end;
                end else if DataRow_buf.OperaType=Opt_Insert then
                begin
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  for J := 0 to ((Rldo.NumElements - 4) div 2) - 1 do
                  begin
                    OffsetInRow := Pword(UIntPtr(R_[0]) + J * 4 + 2)^;
                    applyUpdateChange(DataRow_buf.R0, R_[4 + J * 2 + 1], OffsetInRow, R_Info[4 + J * 2].Length, R_Info[4 + J * 2 + 1].Length, RawDataLen);
                    RawDataLen := RawDataLen + (R_Info[4 + J * 2 + 1].Length - R_Info[4 + J * 2].Length);
                  end;
                end else  if DataRow_buf.OperaType=Opt_Delete then
                begin
                  //这肯定是删除了数据然后又回滚了的（R0中包含了当前行的完整数据
                  DataRow_buf.OperaType := Opt_Update;
                  DataRow_buf.deleteFlag := False;
                  RawDataLen := PageRowCalcLength(DataRow_buf.R0);
                  for J := 0 to ((Rldo.NumElements - 4) div 2) - 1 do
                  begin
                    OffsetInRow := Pword(UIntPtr(R_[0]) + J*4 + 2)^;
                    applyUpdateChange(DataRow_buf.R0, R_[4 + J * 2 + 1], OffsetInRow,
                      R_Info[4 + J * 2].Length, R_Info[4 + J * 2 + 1].Length, RawDataLen);
                    RawDataLen := RawDataLen + (R_Info[4 + J * 2 + 1].Length - R_Info[4 + J * 2].Length);
                  end;
                end;
                exit;
              end
            end;

            BinReader.SetRange(R_Info[3].Offset, R_Info[3].Length);
            BinReader.skip(6);
            TableId := BinReader.readInt;
            DbTable := FLogSource.GetTableById(TableId);
            if DbTable = nil then
            begin
              //忽略的表
              Exit;
            end;

            if FLogSource.FFFFIsDebug then
            begin
              for I := 0 to FLogSource.pageDatalist.Count-1 do
              begin
                Rawssssss := TTransPkgItem(FLogSource.pageDatalist[I]);
                if (Rawssssss.LSN.LSN_1 = tPkg.LSN.LSN_1) and (Rawssssss.LSN.LSN_2 = tPkg.LSN.LSN_2) and (Rawssssss.LSN.LSN_3 = tPkg.LSN.LSN_3) then
                begin
                  SetLength(OriginRowData, Rawssssss.Raw.dataSize);
                  CopyMemory(@OriginRowData[0], Rawssssss.Raw.data, Rawssssss.Raw.dataSize);
                end;
              end;
            end else begin
              OriginRowData := pc__PageCache.getUpdateSoltData(FLogSource.Fdbc, tPkg.LSN, Rldo.pageId, FTranspkg);
              if OriginRowData = nil then
                OriginRowData := getUpdateSoltData(FLogSource.Fdbc, Rldo.normalData.PreviousLSN);
            end;
            if OriginRowData = nil then
            begin
              FLogSource.Loger.Add('获取行原始数据失败！' + lsn2str(tPkg.LSN) + ',pLSN:' + lsn2str(Rldo.normalData.PreviousLSN), LOG_WARNING or LOG_IMPORTANT);
              Exit;
            end else if OriginRowData[0] = 4 then
            begin
              //FORWARDING_STUB
              DataRow_buf.Free;
              Exit;
            end;

            DataRow_buf := Tsql2014Opt.Create;
            try
              if (DbTable.UniqueClusteredKeys.Count>0) and (R_Info[2].Length > 0) then
              begin
                //读取UniqueClusteredKeys
                BinReader.SetRange(R_Info[2].Offset, R_Info[2].Length);
                DataRow_buf.UniqueClusteredKeys := BinReader.readBytes(R_Info[2].Length);
              end;
              //OriginRowData 是修改后的行数据
              DataRow_buf.OperaType := Opt_Update;
              DataRow_buf.page := Rldo.pageId;
              DataRow_buf.table := DbTable;

              //after
              tmpdata := GetMemory($2000);
              Move(OriginRowData[0], tmpdata^, Length(OriginRowData));
              DataRow_buf.R0 := tmpdata;

              //before、回滚到修改之前的状态
              tmpdata := GetMemory($2000);
              Move(OriginRowData[0], tmpdata^, Length(OriginRowData));
              RawDataLen := PageRowCalcLength(tmpdata);
              for I := 0 to ((Rldo.NumElements - 4) div 2) - 1 do
              begin
                OffsetInRow := Pword(UIntPtr(R_[0]) + I * 4)^;
                applyUpdateChange(tmpdata, R_[4 + I * 2], OffsetInRow, R_Info[4 + I * 2 + 1].Length, R_Info[4 + I * 2].Length, RawDataLen);
                RawDataLen := RawDataLen + (R_Info[4 + I * 2].Length - R_Info[4 + I * 2 + 1].Length);
              end;
              DataRow_buf.R1 := tmpdata;
              FOpts.Add(DataRow_buf);
            except
              DataRow_buf.Free;
            end;
          end;
        end;
    else
    end;
  finally
    if BinReader <> nil then
      BinReader.Free;
  end;
end;

function TSql2014logAnalyzerThread.PriseRowLog_InsertDeleteRowData(DbTable: TdbTableItem; BinReader: TbinDataReader): Tsql2014RowData;
var
  I: Integer;
  InsertRowFlag: Word;
  TmpInt: Integer;
  ColCnt: Word;
  DataRow: Tsql2014RowData;
  nullMap: TBytes;
  VarFieldValEndOffset: array of Word;
  VarFieldValBase: Cardinal;  //var 字段值开始位置
  boolbit: Integer;
  aField: TdbFieldItem;
  Idx, b: Integer;
  val_begin, val_len: Cardinal;
  fieldval: PdbFieldValue;
begin
  InsertRowFlag := BinReader.readWord;
  //DONE: 这里应该效验InsertRowFlag的特性  https://funning.fun/index.php/2018/11/28/sqlserver-datarow/
  TmpInt := BinReader.readWord; //列数量的 Offset
  BinReader.seek(TmpInt, soBeginning);
  ColCnt := BinReader.readWord;
  if ColCnt <> DbTable.Fields.Count then
  begin
    raise Exception.Create('实际列数与日志不匹配！这可能是修改表后造成的！放弃解析！');
  end;
  DataRow := Tsql2014RowData.Create(Self.FAnalyzerMain);
  if (InsertRowFlag and $10) > 0 then
  begin
    //nullMap := BinReader.readBytes((DbTable.Fields.Count + 7) shr 3);
    nullMap := BinReader.readBytes((ColCnt + 7) shr 3);
  end
  else
  begin
    //不包含NullData
    nullMap := nil;
  end;
  if (InsertRowFlag and $20) > 0 then
  begin
    TmpInt := BinReader.readWord; //var 字段数量
  end
  else
  begin
    //不包含varData
    TmpInt := 0;
  end;
  SetLength(VarFieldValEndOffset, TmpInt);
  for I := 0 to TmpInt - 1 do
  begin
    VarFieldValEndOffset[I] := BinReader.readWord;
  end;
  VarFieldValBase := BinReader.getRangePosition;
  boolbit := 0;
  for I := 0 to DbTable.Fields.Count - 1 do
  begin
    aField := DbTable.Fields[I];
    if not aField.isLogSkipCol then
    begin
      New(fieldval);
      fieldval.field := aField;

      if aField.is_nullable then
      begin
        Idx := aField.nullMap shr 3;
        b := aField.nullMap and 7;
        if (nullMap[Idx] and (1 shl b)) > 0 then  //值为null
        begin
          fieldval.value := nil;
          fieldval.isNull := True;
          DataRow.Fields.Add(fieldval);
          Continue;
        end;
      end;

      fieldval.isNull := False;
      if aField.leaf_pos < 0 then
      begin
        // var Field
        Idx := 0 - aField.leaf_pos - 1;
        if Idx < Length(VarFieldValEndOffset) then
        begin
          if Idx = 0 then
          begin
            val_begin := VarFieldValBase;
          end
          else
          begin
            val_begin := (VarFieldValEndOffset[Idx - 1] and $7FFF);
          end;
          val_len := (VarFieldValEndOffset[Idx] and $7FFF) - val_begin;
          if val_len = 0 then
          begin
            //空字符串
            SetLength(fieldval.value,0);
          end
          else
          begin
            try
              BinReader.seek(val_begin, soBeginning);
              if (VarFieldValEndOffset[Idx] and $8000) > 0 then
              begin
                //如果最高位是1说明数据在LCX_TEXT_MIX包中
                fieldval.value := BinReader.readBytes(val_len);
                //fieldval.value := getDataFrom_TEXT_MIX(fieldval.value);
                FMixPending.Add(fieldval);
              end
              else
              begin
                fieldval.value := BinReader.readBytes(val_len);
              end;
            except
              on exx: Exception do
              begin
                Dispose(fieldval);
                raise exx;
              end;
            end;
          end;
        end else begin
          //空字符串
          SetLength(fieldval.value,0);
        end;
      end
      else
      begin
        //fixed Field
        BinReader.seek(aField.leaf_pos, soBeginning);
        try
          fieldval.value := BinReader.readBytes(aField.Max_length);
          if aField.type_id = MsTypes.BIT then
          begin
            if ((1 shl boolbit) and fieldval.value[0]) > 0 then
            begin
              fieldval.value[0] := 1;
            end
            else
            begin
              fieldval.value[0] := 0;
            end;
            boolbit := boolbit + 1;
            if boolbit = 8 then
              boolbit := 0;
          end;
        except
          on exx: Exception do
          begin
            Dispose(fieldval);
            raise exx;
          end;
        end;

      end;
      DataRow.Fields.Add(fieldval);
    end;
  end;
  Result := DataRow;
end;

function TSql2014logAnalyzerThread.PriseRowLog_UniqueClusteredKeys(uckdata: TBytes;DbTable: TdbTableItem):string;
var
  flag:Byte;
  I, J: Integer;
  field: TdbFieldItem;
  fieldval: PdbFieldValue;
  values: TList;
  varFCnt:Integer;
  varFxIdx:array of Word;
  fieldCnt:Word;
  tmpCardinal:Cardinal;
  BinReader: TbinDataReader;
begin
  BinReader := TbinDataReader.Create(@uckdata[0], Length(uckdata));
  flag := BinReader.readByte;
  Result := '';
  varFCnt := 0;
  values := TList.Create;
  try
    for I := 0 to DbTable.UniqueClusteredKeys.Count - 1 do
    begin
      field := DbTable.UniqueClusteredKeys[I];
      if (field.leaf_pos > 0) then
      begin
        New(fieldval);
        fieldval.isNull := False;
        fieldval.field := field;
        fieldval.value := BinReader.readBytes(field.Max_length);
        values.Add(fieldval);
      end
      else
      begin
        if varFCnt = 0 then
        begin
          //field Cnt
          fieldCnt := BinReader.readWord;
          //效验索引字段数量
          if fieldCnt <> DbTable.UniqueClusteredKeys.Count then
          begin
          //有问题数据，跳出
            Exit;
          end;
          //nullmap
          BinReader.skip((fieldCnt + 7) shr 3);
          if (flag and $20) = 0 then
          begin
            // ?? 不包含var字段 值
            Exit;
          end;
          //var 字段数量
          fieldCnt := BinReader.readWord;
          SetLength(varFxIdx, fieldCnt);
          tmpCardinal := BinReader.getRangePosition + fieldCnt * 2;
          for j := 0 to fieldCnt -1 do
          begin
            varFxIdx[i] := BinReader.readWord - tmpCardinal;
            tmpCardinal := varFxIdx[i];
          end;
        end;
        New(fieldval);
        fieldval.isNull := False;
        fieldval.field := field;
        fieldval.value := BinReader.readBytes(varFxIdx[varFCnt]);
        values.Add(fieldval);
        varFCnt := varFCnt + 1;
      end;
    end;
    for I := 0 to values.Count - 1 do
    begin
      fieldval := values[I];
      Result := Result + Format('and %s=%s ', [fieldval.field.getSafeColName,
        FAnalyzerMain.Hvu.GetFieldStrValueWithQuoteIfNeed(fieldval)]);
    end;
    if values.Count>0 then
    begin
      Delete(Result, 1, 4);  //"and "
    end;
  finally
    for I := 0 to values.Count - 1 do
    begin
      Dispose(PdbFieldValue(values[I]));
    end;
    values.Free;
    BinReader.free;
  end;
end;

procedure TSql2014logAnalyzerThread.PriseRowLOP_FORMAT_PAGE(tPkg: TTransPkgItem);
var
  rlfp:PRawLOP_FORMAT_PAGE;
  BinReader: TbinDataReader;
  R_: array of TBytes;
  R_Info: array of TRawElement;
  I:Integer;
  PHr:PPage_Header;
  RawDataOffset:Word;
  tmpData:UIntPtr;
  dataLen:Cardinal;
  DataRow_buf: Tsql2014Opt;
  DbTable: TdbTableItem;
  ObjId:Integer;
  AllocUnitId:UInt64;
begin
  rlfp := tPkg.Raw.data;
  if (rlfp.PageOption=0) and (rlfp.NumElements > 0) then
  begin
    //copy include data
    if (rlfp.PageType = 1) or (rlfp.PageType = 3) or (rlfp.PageType = 4)  then
    begin
      //data page
      SetLength(R_, rlfp.NumElements);
      SetLength(R_Info, rlfp.NumElements);
      BinReader := TbinDataReader.Create(tPkg.Raw);
      BinReader.seek(SizeOf(TRawLOP_FORMAT_PAGE), soBeginning);
      for I := 0 to rlfp.NumElements - 1 do
      begin
        R_Info[I].Length := BinReader.readWord;
      end;
      BinReader.alignTo4;
      for I := 0 to rlfp.NumElements - 1 do
      begin
        if R_Info[I].Length > 0 then
        begin
          R_Info[I].Offset := BinReader.Position;
          R_[I] := BinReader.readBytes(R_Info[I].Length);
          BinReader.alignTo4;
        end;
      end;
      BinReader.Free;
      if R_Info[0].Length > SizeOf(TPage_Header) then
      begin
        PHr := @R_[0][0];
        if PHr.m_slotCnt>0 then
        begin
          AllocUnitId := (UInt64(rlfp.AllocUnitId_fid) shl 48) or (UInt64(rlfp.AllocUnitId) shl 16);
          if not FLogSource.Fdbc.dict.tables.Alloc2ObjId.TryGetValue(AllocUnitId, ObjId) then
          begin
            Exit;
          end;
          DbTable := FLogSource.GetTableById(ObjId);
          if DbTable = nil then
          begin
            //忽略的表
            Exit;
          end;

          if (rlfp.NumElements = 1) or (R_Info[1].Length = 0) then
          begin
            tmpData := Uintptr(PHr) + R_Info[0].Length;
          end
          else
          begin
            tmpData := Uintptr(@R_[1][0]) + R_Info[1].Length;
          end;
          for I := 0 to PHr.m_slotCnt - 1 do
          begin
            RawDataOffset := PWORD(tmpData - i * 2 - 2)^;
            dataLen := PageRowCalcLength(@R_[0][RawDataOffset]);

            DataRow_buf := Tsql2014Opt.Create;
            DataRow_buf.OperaType := Opt_Insert;
            DataRow_buf.page := rlfp.pageId;
            DataRow_buf.table := DbTable;
            DataRow_buf.R0 := GetMemory($2000);
            Move(R_[0][RawDataOffset], DataRow_buf.R0^, dataLen);
            if rlfp.PageType in [LCX_TEXT_TREE, LCX_TEXT_MIX] then
            begin
              DataRow_buf.isMixData := True;
            end;
            FOpts.Add(DataRow_buf);
          end;
        end;
      end;
    end;
  end;
end;



end.

