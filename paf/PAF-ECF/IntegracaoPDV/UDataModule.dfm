object FDataModule: TFDataModule
  OldCreateOrder = False
  Left = 773
  Top = 179
  Height = 201
  Width = 299
  object StoredProcedure: TSQLStoredProc
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftFloat
        Precision = 4
        Name = 'PQTDE'
        ParamType = ptInput
      end
      item
        DataType = ftDate
        Precision = 4
        Name = 'PDATA'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Precision = 4
        Name = 'PID'
        ParamType = ptInput
      end>
    SQLConnection = ConexaoBalcao
    StoredProcName = 'ALTERA_QTDE_PRODUTO'
    Left = 176
    Top = 24
  end
  object ConexaoBalcao: TSQLConnection
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'Database=mini'
      'HostName=localhost'
      'Password=root'
      'User_Name=root')
    VendorLib = 'libmysql.dll'
    Left = 56
    Top = 32
  end
end
