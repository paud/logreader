object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 569
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button3: TButton
    Left = 375
    Top = 23
    Width = 114
    Height = 34
    Caption = 'DBConnectionCfg'
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button8: TButton
    Left = 656
    Top = 52
    Width = 75
    Height = 25
    Caption = 'C_picker'
    TabOrder = 1
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 656
    Top = 83
    Width = 75
    Height = 25
    Caption = 'S_Picker'
    TabOrder = 2
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 656
    Top = 8
    Width = 75
    Height = 25
    Caption = 'RefreshDict'
    TabOrder = 3
    OnClick = Button10Click
  end
  object GroupBox1: TGroupBox
    Left = 567
    Top = 139
    Width = 176
    Height = 153
    Caption = 'Test'
    TabOrder = 4
    object Button7: TButton
      Left = 3
      Top = 16
      Width = 75
      Height = 25
      Caption = 'copyFile'
      TabOrder = 0
      OnClick = Button7Click
    end
    object Button12: TButton
      Left = 3
      Top = 88
      Width = 75
      Height = 25
      Caption = 'save'
      TabOrder = 1
      OnClick = Button12Click
    end
    object Button13: TButton
      Left = 84
      Top = 88
      Width = 75
      Height = 25
      Caption = 'load'
      TabOrder = 2
      OnClick = Button13Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 23
    Width = 361
    Height = 338
    Caption = #21152#36733#24050#23384#22312
    TabOrder = 5
    object Button1: TButton
      Left = 15
      Top = 18
      Width = 122
      Height = 47
      Caption = #24320#22987#25235#26085#24535
      TabOrder = 0
    end
    object Button2: TButton
      Left = 143
      Top = 18
      Width = 122
      Height = 47
      Caption = #20572#27490#35299#26512#26085#24535
      TabOrder = 1
    end
    object Mom_ExistsCfg: TMemo
      Left = 15
      Top = 71
      Width = 330
      Height = 89
      Lines.Strings = (
        'Mom_ExistsCfg')
      ScrollBars = ssBoth
      TabOrder = 2
      WordWrap = False
    end
    object ReloadList: TButton
      Left = 15
      Top = 165
      Width = 58
      Height = 17
      Caption = 'ReloadList'
      TabOrder = 3
      OnClick = ReloadListClick
    end
    object ListView1: TListView
      Left = 3
      Top = 188
      Width = 355
      Height = 115
      Columns = <
        item
          Caption = 'id'
        end
        item
          Caption = 'Svr'
          Width = 160
        end
        item
          Caption = 'dbName'
          Width = 100
        end
        item
          Caption = 'status'
          Width = 20
        end>
      ReadOnly = True
      RowSelect = True
      SmallImages = ImageList1
      TabOrder = 4
      ViewStyle = vsReport
    end
    object Button4: TButton
      Left = 3
      Top = 308
      Width = 75
      Height = 25
      Caption = 'start'
      TabOrder = 5
      OnClick = Button4Click
    end
    object Button6: TButton
      Left = 194
      Top = 308
      Width = 63
      Height = 20
      Caption = 'GetlsnData'
      TabOrder = 6
      OnClick = Button6Click
    end
    object Button11: TButton
      Left = 84
      Top = 308
      Width = 75
      Height = 25
      Caption = 'stop'
      TabOrder = 7
      OnClick = Button11Click
    end
  end
  object Button5: TButton
    Left = 375
    Top = 267
    Width = 75
    Height = 25
    Caption = 'addLog'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 395
    Width = 735
    Height = 150
    Lines.Strings = (
      'Memo1')
    TabOrder = 7
  end
  object Button14: TButton
    Left = 375
    Top = 298
    Width = 114
    Height = 39
    Caption = 'CompareDictFromdb'
    TabOrder = 8
    OnClick = Button14Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 368
    Width = 281
    Height = 21
    TabOrder = 9
    Text = '0000003f:00000038:0001'
  end
  object Button15: TButton
    Left = 495
    Top = 298
    Width = 106
    Height = 39
    Caption = 'AllTables'
    TabOrder = 10
    OnClick = Button15Click
  end
  object Button16: TButton
    Left = 384
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Button16'
    TabOrder = 11
    OnClick = Button16Click
  end
  object Button17: TButton
    Left = 688
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Button17'
    TabOrder = 12
  end
  object ImageList1: TImageList
    Left = 400
    Top = 224
    Bitmap = {
      494C01010B001800900010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      000000000000000000000000000000000000FFFFFF00FFFFFF00F6821000F580
      0C00F4851600F67B0000F37B0500FFFFFF00FFFFFF00F47C0500F57A0000F284
      1600F17F0C00F0801000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CDCDCD00CBCBCB00CBCBCB00CBCBCB00CDCDCD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0069B3D600047FBD00047FBD00047FBD00047FBD00047FBD00047FBD0069B3
      D600FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FBCFA400F77B
      0000F37A0000F2790000F0780000F4B57600F7B67600F2790000F0780000EF78
      0000ED770000F6CDA400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBCB
      CB006F77C4002F3EBD002B3BBE002B3ABE002B3BBE002F3EBD006F77C400CBCB
      CB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0069B3
      D6003DAAD60088E1F60088E1F60088E1F60088E1F60088E1F60088E1F6003DAA
      D60069B3D600FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00F77D
      0500F67B0000F2790000EF780000EB821900F5861900F2790000EF780000EB76
      0000E7760500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009FA4C7002B3B
      BE004A5BE2006175FC00697DFF00697CFF00697DFF006175FC004A5BE2002B3B
      BE009FA4C700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0069B3D6003CA9
      D60088E1F70053D3F3003BCDF1009DE6F8009DE6F8003BCDF10053D3F30088E1
      F7003DAAD60069B3D600FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FBCB
      9B00F97C0000F77B0000F2790000ED770000F97C0000F77B0000F2790000ED77
      0000F5C79B00FFFFFF00FFFFFF00FFFFFF00FFFFFF009FA4C7002F3FC200596D
      F6006276FF006074FE005F73FE005F73FD005F73FE006074FE006276FF00596D
      F6002F3FC2009FA4C700FFFFFF00FFFFFF00FFFFFF0069B3D6003BA8D50089E2
      F70055D5F3003BCEF1003BCEF100025BA100025BA2003BCEF1003BCEF10054D4
      F30089E2F7003FABD70069B3D600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F87C0100ED780400DC6F0200D97B1E00CD690400E1740600E7740200F179
      0100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002C3CBF005669F4005D71
      FC005B6FFA005A6EF9005A6EF9005A6EF9005A6EF9005A6EF9005B6FFA005D71
      FC005669F4002C3CBF00FFFFFF00FFFFFF0069B3D6003CA8D5008BE3F7005AD7
      F3003DD0F1003DD0F1003DD0F10002589F0002589F003DD0F1003DD0F1003DD0
      F10054D6F3008BE3F70040ACD70069B3D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00F9E6
      D400DB6F0300E77F1F00F3862900FB9A4500F4843100EB832400D7781B00CE75
      1E00FFFFFF00FFFFFF00FFFFFF00FFFFFF007078C5004256DE00576DFB005369
      F8005268F7005267F7005267F7005267F7005267F7005267F7005268F7005369
      F800576DFB004256DE007078C500FFFFFF00047FBD008CE3F7005CD8F4003FD1
      F2003FD1F2003FD1F2003FD1F2009FE8F9009FE8F9003FD1F2003FD1F2003FD1
      F2003FD1F20056D6F4008CE3F700047FBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00EB99
      4900F78C3000FC903F00FD9A4A00FD8F3600FC8C3800FB964400FB974500E079
      1C00F1D7BC00FFFFFF00FFFFFF00FFFFFF003040BD004E64F4004C63F700425A
      F4003E56F4003D55F4003D55F4003D55F4003D55F4003D55F4003E56F400425A
      F4004C63F7004E64F4003040BD00FFFFFF00047FBD008DE4F70042D2F20041D2
      F20041D2F20041D2F20041D2F20001559D0001559D0041D2F20041D2F20041D2
      F20041D2F20042D2F2008DE4F700047FBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F0A15200F27E
      1C00FC994E00FA883200F77D2700F77B2500F67C1F00F67C2000FA933E00EF8A
      2C00D5751E00E8B78700FFFFFF00FFFFFF002C3CBF005369F8003E56F300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF003E56F3005369F8002C3CBF00FFFFFF00047FBD008FE5F80045D3F30044D3
      F30044D3F30044D3F30044D3F30001559D0001539C0044D3F30044D3F30044D3
      F30044D3F30045D3F3008FE5F800047FBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F27B0600FD9D
      5600FD974400F67D2F00FA7E2700FA7E2600FB7E1F00FA7D2300F77C2500FD9A
      4300F5923D00DD822A00FFFFFF00FFFFFF002B3BBF006378F700334DF000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00334DF0006378F7002B3BBF00FFFFFF00047FBD0090E6F80047D5F40046D5
      F40046D5F40046D5F40046D5F40001559D0001549C0046D5F40046D5F40046D5
      F40046D5F40047D5F40090E6F800047FBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F7871D00FD9F
      5A00FD964800F37C2900FB7F2D00FC802800FB7F2700FA7F2000F77C2500FC8B
      3500F7831F00E59B5100FFFFFF00FFFFFF002A39BF008696F8002F4BEE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF002F4BEE008696F8002A39BF00FFFFFF00047FBD0092E6F80049D6F40048D6
      F40048D6F40048D6F40048D6F40001569D0001559D0048D6F40048D6F40048D6
      F40048D6F40049D6F40091E6F800047FBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F3800E00FD8D
      3F00FB8C3F00EF7B2B00FA802900FC802D00FC802800FA7F2700F57C2100FD90
      3D00F7913F00DB7F2700FFFFFF00FFFFFF002D3DBF00A1ACF4003852ED002D48
      EC002B46EB002A46EB002A46EB002A46EB002A46EB002A46EB002B46EB002D48
      EC003852ED00A1ACF4002D3DBF00FFFFFF000580BC00B5EEFA006ADEF7004AD7
      F5004AD7F5004AD7F5004AD7F50002589F0001579E004AD7F5004AD7F5004AD7
      F5004AD7F50069DEF700B7EFFB00047FBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F8800800FDA3
      6000FD975700F57E3300F57E3100FA7F3000FA802900F97E2800F77E2900FC93
      4400FB882B00E7832500FFFFFF00FFFFFF00828AD9006F7CDD008494F5002E4A
      E900334DE900354FEA003650EA003650EA003650EA00354FEA00334DE9002E4A
      E9008494F5006F7CDD00828AD900FFFFFF006CB3D70050ABD500B7EFFA006CE0
      F7004CD9F5004CD9F5004CD9F500025BA1000259A0004CD9F5004CD9F5004CD9
      F5006BE0F700B9F0FB0050ABD50069B3D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F7B67600FC7F
      1A00FD8F4300FC914D00F5803400EE7B2D00F07B3100F57F2D00FA904100FB96
      4A00EF7C0B00FAE2CB00FFFFFF00FFFFFF00FFFFFF002737BF009AA7F0007F90
      F300324CE9002D49E700304CE800314CE800304CE8002D49E700324CE9007F90
      F3009AA7F0002737BF00FFFFFF00FFFFFF00FFFFFF006CB3D70050ABD500B8F0
      FA0070E1F7004EDAF5004EDAF5004EDAF5004EDAF5004EDAF5004EDAF5006DE0
      F700B9F1FB0050ABD50069B3D600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00F7B1
      6C00FD8F3000FD9F5900FD985100FD9D5600FD9E5F00FB974B00FD9E5100F981
      1300F4C79B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C4C8EC002F3FC30097A3
      EF009EACF7006075ED003E57E9002441E5003E57E9006075ED009EACF70097A3
      EF002F3FC300C4C8EC00FFFFFF00FFFFFF00FFFFFF00FFFFFF006CB3D7004EAA
      D400B9F0FB0072E1F80050DAF60050DAF60050DAF60050DAF6006DE0F800B9F1
      FC0050ABD50069B3D600FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F8830C00F57A0000FD8E2E00FD944400FD984000F97D0A00FC841000EF86
      1D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C4C7EC002737
      BF006A77DC009EA9F200AFBAF800AFBBF800AFBAF8009EA9F2006A77DC002737
      BF00C4C7EC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006CB3
      D7004CA9D400CEF4FC00D0F5FD00D0F5FD00D0F5FD00D0F5FD00D0F5FD0051AB
      D50069B3D600FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00F8C18B00F37C0500FA851500FAD7B500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00828AD9002D3DC0002737BF002737BF002737BF002D3DC000828AD900FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF006CB3D7000580BC00047FBD00047FBD00047FBD00047FBD00047FBD0069B3
      D600FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CDCDCD00CBCBCB00CBCBCB00CBCBCB00CDCDCD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBCB
      CB006F77C4002F3EBD002B3BBE002B3ABE002B3BBE002F3EBD006F77C400CBCB
      CB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00215C3D0075948300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00547B
      68001D4F35001D4C33001C4B3300FFFFFF00FFFFFF00547B68001D4F35001D4C
      33001C4B3300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009FA4C7002B3B
      BE004A5BE2006174FB00687BFF00677AFF00687BFF006174FB004A5BE2002B3B
      BE009FA4C700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00246543002A7C510070928100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007C84
      E5004852E0004852E000464FDC00414BDC003E48DA003D47DA003844DB003844
      DB00676EDF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005680
      6B002F8B5A00349F67001D4D3400FFFFFF00FFFFFF0056806B002F8B5A00349F
      67001D4D3400FFFFFF00FFFFFF00FFFFFF00FFFFFF009FA4C7002F3FC200596D
      F6006175FF005B70FE005368FD004F65FD005368FD005B70FE006175FF00596D
      F6002F3FC2009FA4C700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00266D480038AF71002B7F53006F938000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00717C
      E8008997FA008997FA008495FF007F90FC007D8EFA007D8DF7007D8BF2007D8B
      F200424DDE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005785
      6E0030905E0034A269001E523700FFFFFF00FFFFFF0057856E0030905E0034A2
      69001E523700FFFFFF00FFFFFF00FFFFFF00FFFFFF002C3CBF005669F4005D71
      FC00596DFA004D63F900A4AFF900FFFFFF00A4AFF9004D63F900596DFA005D71
      FC005669F4002C3CBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0029784F003AB5740039B373002C8255006A937D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00717C
      E800A2B2FC004F6EFF004B69FF004664FF00415EFF003C5AFF003755FF008493
      FA00424DDE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00598A
      70003196620036A76C0020583B00FFFFFF00FFFFFF00598A70003196620036A7
      6C0020583B00FFFFFF00FFFFFF00FFFFFF007078C5004356DE00586DFB00566B
      F8005368F700455CF600FFFFFF00FFFFFF00FFFFFF00455CF6005368F700566B
      F800586DFB004356DE007078C500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF002B81540044BC7D0037AD6F003BB675002D84560068927D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B84
      E600A6BBFF005A79FF005573FF00506EFF004B69FF004664FF00415EFF008799
      FF004C55DD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005B8F
      7400339D660037AB6E00225F3F00FFFFFF00FFFFFF005B8F7400339D660037AB
      6E00225F3F00FFFFFF00FFFFFF00FFFFFF003040BD004F64F4005168F7005066
      F5004E64F500425AF400A4AFF900FFFFFF00A4AFF900425AF4004E64F5005066
      F5005168F7004F64F4003040BD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF002F8E5C0050C2860038AF710039B172003EB878002E895A0064917900FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00838A
      E800ABBEFF006583FF005F7EFF005A79FF005574FF00506FFF004B69FF008A9B
      FF00515BDF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005093
      6F0038AF710038B0710024654300FFFFFF00FFFFFF0050936F0038AF710038B0
      710024654300FFFFFF00FFFFFF00FFFFFF002D3CBF004E65F8004C62F4004C62
      F3004B61F300455CF3003750F2003049F1003750F200455CF3004B61F3004C62
      F3004C62F4004E65F8002D3CBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00329863005EC791003DB777003EB8780047BE800030925F003C7C5B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008992
      E900B1C4FF006E8EFF006989FF006583FF005F7EFF005A79FF005573FF0090A1
      FF005962E100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005AA2
      7C003EB878003AB57400266D4800FFFFFF00FFFFFF005AA27C003EB878003AB5
      7400266D4800FFFFFF00FFFFFF00FFFFFF002C3BBF005F74F700455DF200475E
      F100465DF1004058F1006F81F300FFFFFF006F81F3004058F100465DF100475E
      F100455DF2005F74F7002C3BBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0034A369006BCC9B0054C389005EC7910034A2690074A88D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009198
      EA00B8CDFF007899FF007393FF006E8EFF006989FF006583FF00607EFF0098AA
      FF00626AE200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005FA2
      7E0038AE700041BA7B0028754D00FFFFFF00FFFFFF005FA27E0038AE700041BA
      7B0028754D00FFFFFF00FFFFFF00FFFFFF002A3ABF007084F7003F58EF00415B
      EF004059EF003751EE00A3AFF700FFFFFF00A3AFF7003751EE004059EF00415B
      EF003F58EF007084F7002A3ABF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0037AC6F0079D1A4006ECD9C0038B072007DB79A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0096A0
      EE00BCCDFC0081A2FF007C9EFF007899FF007493FF006F8EFF006989FF009EAD
      FB006873E500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0062A9
      84003AB574004ABF82002A7D5200FFFFFF00FFFFFF0062A984003AB574004ABF
      82002A7D5200FFFFFF00FFFFFF00FFFFFF002E3EBF0093A1F4003751EE003B55
      ED003B55ED002E49EB00DADFFB00FFFFFF00DADFFB002E49EB003B55ED003B55
      ED003751EE0093A1F4002E3EBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF003AB474007DD2A60046BD7F008CC8A900FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0096A0
      EE00C2D3FC00C2D3FC00C1D6FF00BDD1FF00BBCFFF00B9CEFF00B7C8FC00B7C8
      FC006873E500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0063AE
      870042BA7B0055C48A002C855600FFFFFF00FFFFFF0063AE870042BA7B0055C4
      8A002C855600FFFFFF00FFFFFF00FFFFFF00828AD900838EE2006A7FF200314D
      EA00334EE9002642E800FFFFFF00FFFFFF00FFFFFF002642E800334EE900314D
      EA006A7FF200838EE200828AD900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF003EB878003AB4750095D3B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AFB5
      EE009FA8EF009FA8EF009FA6ED009BA3ED0099A1ED00969EEB00929BED00929B
      ED009AA0EB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0065B4
      8A004BC0830060C892002F8F5D00FFFFFF00FFFFFF0065B48A004BC0830060C8
      92002F8F5D00FFFFFF00FFFFFF00FFFFFF00FFFFFF002F3FC200ADB7F500667A
      F0002845E7001F3DE600BCC4FB00FFFFFF00BCC4FB001F3DE6002845E700667A
      F000ADB7F5002F3FC200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0045B97C0096D7B400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0066BB
      8F0034A16800339B650032966100FFFFFF00FFFFFF0066BB8F0034A16800339B
      650032966100FFFFFF00FFFFFF00FFFFFF00FFFFFF00C4C7EC003F4EC800A0AC
      F1008D9CF4004A62EA001D3AE5001231E3001D3AE5004A62EA008D9CF400A0AC
      F1003F4EC800C4C7EC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C4C7EC002F40
      C2006A77DC009EAAF200ADB9F800ADB8F800ADB9F8009EAAF2006A77DC002F40
      C200C4C7EC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00828AD9002D3DC0002737BF002737BF002737BF002D3DC000828AD900FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007F7C7B0078787800737373006F6F6F006A6A
      6A006666660063636300535353004A4A4A00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CCCCCC00CBCBCB00CBCBCB00CBCBCB00CDCDCD00DADADA00CBCB
      CB00CBCBCB00CBCBCB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00DCDCDC00CBCBCB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBCB
      CB00CECECE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400B8B8B800F2F2F200D8D8D800CDCD
      CD00CFCFCF00EBEBEB008E8E8E0048484800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00AFA4970096826C0096816A0096816A009A846900A68F67005F67AF001F30
      AF002131AD002233AD006670BA00FFFFFF00FFFFFF00FFFFFF00D8D8D800CBCB
      CB00CBCBCB00C7C6C600888A8C00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCB
      CB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00329E
      DE003B9FDB00D1D1D100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008D8D8D00828282007D7D7D00757575006B6B
      6B00696969005D5D5D00555555004E4E4E00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF009A866F00D7CDBD00E3DAC800E3DAC600ECE1C5006B72B3001F37C400385E
      FB003961FE003960FA00283EC1006670BA00FFFFFF00C4C3C100B7B2A900B0AA
      9E00B0AA9C0097999B00C8C8CB00848D9700BA823E00B7824200B6834400B884
      4500CBCBCB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005FAF
      DF00329DDE003F9FD800CBCBCB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DBDBDB00CBCBCB00CBCBCB00CBCB
      CB00B5ACA200B09C840096775200CABCA100A27F4D000C22B3003F63FE003C61
      FB003A5EF9003D61FB004366FD001E30AD00BBB7B000B4AEA200C5BEB300D4CB
      C200E2D8CF00EDE3DD00959CA500B77D3500F8C07300F2BA6D00EFB66500E5B5
      6D00B7834400CBCBCB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B5DB
      F100329BDD0067C6EE00369FDE00BAC5CC00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A4A3A1009B9B9B0095959500909090008B8B
      8B0086868600818181007170700061606000A99B8D009A86700098836D009682
      6C0096816C0095806B00957F6B0096816900A28966000B20B100A9BBFF00FFFF
      FF00FFFFFF00FFFFFF00ACBDFF001B2DAC00B1AB9F00C8C1B600CFC7BF00D6CC
      C500DED5CC00E8E1DE00B4792F00F3C88D00F6C07800F2BB7000EBBF8000B17D
      3F00EFB35D00B9844200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00319ADB0083D7F30089E4FA00349CDC00B9C4CB00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A6A6A600CBCBCB00F6F6F600E2E2E200D9D9
      D900DADADA00F0F0F000A5A5A500646464009D897300CCB69800F4F9F000F1F7
      EF00F1F7EF00F0F6EF00F0F6EF00F1F7EF00FEFFEC00051DB3005878FF005877
      FF005473FE005877FF005E7BFF001D2EAD00B0AB9E00C7C0B600CDC4BB00D3CA
      C200DBD2CA00E6E0DD00B1773000F8D09C00F8C27D00F2CB9400AF7A3A00F4B9
      6A00DEB27200BC813900CBCBCB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0067B0E00057BEEA00A9F5FF007BDEF800369CDC0095B9D000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5A5A500C6C6C600F3F3F300D5D5
      D500EFEFEF00B1B1B1007F7D7B00FFFFFF009C897400CEBDA300D4984900D597
      4200DA9E4500DEA54500E4AB4600E9B14600F0B4430071617F002641D2006B87
      FF00738CFF006E88FF00334ACA007A85D000B0AA9E00CAC3B900EAE5DD00F7F3
      EB00FFFCF600FFFFFF00B0762E00FFDAAC00FBD7A700AD783600F9C27900E8C1
      8800B87D3500C0C2CA00898C8F00CBCBCB00FFFFFF00FFFFFF00CBCBCB00CBCB
      CB00A0BCCE0042A9E200BDF5FE0081E7FB0076DBF600379BDC0097B9CF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A0A09F00C1C1C100F1F1
      F100BCBCBC008A868300FFFFFF00FFFFFF009E8B7600D2C5B100E5973200E99F
      3700EEA12B00F3A72A00FAAF2C00FFB62C00FFB52B00FFB42300725E7B000421
      BC000922B6000B22B3005B5A9400FFFFFF00BFBBB400F9F3ED00D8D1C900C2B8
      B000C0B7AF00C6BFBB00B1752B00FFE7BE00AD773400FFCB8800F0CC9B00B77C
      3400C4C4C1009B9EA200CDCBCA0089898900FFFFFF00FFFFFF00389BDC0048AC
      E40045A9E2003FA5E100BDF3FD007FE4F8007AE3FA0070D9F50042A5E00081B1
      D200DCDCDC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009B9B9A00BEBE
      BE0094918E00FFFFFF00FFFFFF00FFFFFF00A08C7800D5CCBA00E2933000E8A2
      4200EDAD4D00F2B04700F5B24100F7B23B00F6AD2F00F5A82900F6A52400F5A0
      1C00F3961500E3D5B200AC957300FFFFFF00B9B5AD00A39A8F00BAB2A700CAC1
      B800DED5CC00E6DDD700EEE7E700AF742C00FFD69800FCDBB100B67B3200AAA5
      A000BCBAB300FFFFFF009B9C9D00D2D0CF00FFFFFF00FFFFFF003799DB009EF1
      FD0080E5F90073E0F9006FDEF7006DDCF7006EDDF70071E0F90070DFF80040A6
      E0006AAAD500DBDBDB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009797
      9700FFFFFF00FFFFFF00FFFFFF00FFFFFF00A18D7800DAD4C400DE8F2D00E49D
      3E00E9A84800EEB05000F1B55600F4BB5D00F4BE6600F2BE6C00F2BE7300F0BE
      7700EEB67000DBD2BD00A38E7700FFFFFF00B1AB9F00C9C2B900CFC7BF00D5CC
      C400DCD3CA00E3DAD200EBE2DD00E8E3E100B1752B00B5782E00BCBFC6008588
      8C00B7B0A300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0059A5DB0085DC
      F50089E5F80068DAF60068DAF600B9F0FC00B8F2FD00B4F2FC00A9F1FD00ABF1
      FC0044A9E20068AAD600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A38F7A00DFDCCD00DA892900E098
      3C00E5A14400E9AA4B00ECAE5200EEB25900EEB45F00EDB56500EBB76B00E9B5
      7000E8B06D00DDD6C500A38E7900FFFFFF00B0AB9E00C7C0B600CCC4BB00D3C9
      C100DAD0C700E1D7CF00ECE1DB00E5DCD600DED7D200D9D2CD0094979A00C9C8
      C70086878800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0097C5E6006DC5
      EC009CE8FA005FD6F40061D7F40046B4E6003191D8003595DA003797DA003A99
      DB003E9CDC00409EDD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A48F7B00E4E3D700D7822500DC92
      3900E19B4100E4A24800E7A74E00E9AB5500E9AE5B00E9AF6100E8B06800E6B1
      6D00E6AC6A00E1DDCD00A38F7B00FFFFFF00AFAA9D00C8C1B700E8E3DB00F5F0
      E800FDF8F200FCF8F100FBF7F100FCF8F100FDF9F300F7F2EC00EEE6DD009395
      9600D1CFCF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D7E9F6004CAE
      E400B0EEFB0066D8F40057D3F300ACEDFB0063B4E5008DB4D000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A6917C00E8EBDE00D1792100D68A
      3300DC923D00DF9A4300E29E4A00E4A35000E5A65700E5A85D00E4AA6300E3A9
      6800E2A66700E5E4D500A5917B00FFFFFF00AEA89C00FBF5EF00EEE7DE00E0D8
      CE00DDD5CC00DDD4CB00DDD4CB00DDD4CB00DDD5CC00E0D8CF00EFE8DE00FCF8
      EF00AEA89A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003B9A
      DA00ACEEFB0082DDF5004CCEF10082DFF600ABE6F8003996D900D2D3D500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A6927D00EDF1E500CC6F1400D07B
      2300D6842D00D98C3300DC913B00DF964300DE994900E09D5000DE9F5700DF9F
      5E00DE9E6000E9EADC00A6927D00FFFFFF00AFA99D00E1D8CE00E1D7CE00DFD6
      CC00DFD5CB00DFD5CB00DFD5CB00DFD5CB00DFD5CB00DFD6CC00E1D7CE00E1D8
      CE00AFA99D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005DA5
      DA008BDAF300ACEAF9003FCBF00045CDF000BBF0FB006DBAE70057A1D500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AA958000F3F7EA00F0F6EC00F0F7
      EE00F0F7EE00EFF6EE00EFF6ED00EFF5EC00EFF5EC00EFF5EB00EFF4EB00EFF4
      E900F0F4E700F2F3E400AA958000FFFFFF00CECBC300B6B0A400D6CFC400E6DE
      D500EFE7DD00EEE6DC00EEE6DC00EEE6DC00EFE7DD00E6DED500D6CFC400B6B0
      A400CECBC300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0097C4
      E5006CC5EB00D7FAFF00CDF6FD00C3F3FD00D2F8FF00C6F1FB00409ADA00A3BC
      CE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C4B7A800AC978200AB968100AA96
      8100AA968100AA968100AA968100AA968100AA958100AA958100AA958100AA95
      8100AB968100AC978200C4B7A800FFFFFF00FFFFFF00EDECEA00C3BEB500AEA9
      9C00AEA89C00AEA89C00AEA89C00AEA89C00AEA89C00AEA99C00C3BEB500EDEC
      EA00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D3E6
      F500439ADA003F97D9003E96D9003E96D9003E97D9004099DA00459CDB00489E
      DC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object MainMenu1: TMainMenu
    Left = 504
    Top = 40
    object N1: TMenuItem
      Caption = #31243#24207
      object N2: TMenuItem
        Caption = #36864#20986
        OnClick = N2Click
      end
    end
  end
end
