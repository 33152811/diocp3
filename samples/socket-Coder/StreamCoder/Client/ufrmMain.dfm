object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'diocp3 coder client'
  ClientHeight = 314
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmoRecvMessage: TMemo
    Left = 8
    Top = 184
    Width = 521
    Height = 113
    Lines.Strings = (
      'iocp tcp client demo')
    TabOrder = 0
  end
  object btnConnect: TButton
    Left = 264
    Top = 9
    Width = 75
    Height = 25
    Caption = 'btnConnect'
    TabOrder = 1
    OnClick = btnConnectClick
  end
  object edtHost: TEdit
    Left = 8
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object edtPort: TEdit
    Left = 156
    Top = 13
    Width = 100
    Height = 21
    TabOrder = 3
    Text = '9983'
  end
  object btnSendObject: TButton
    Left = 544
    Top = 87
    Width = 105
    Height = 25
    Caption = 'btnSendObject'
    TabOrder = 4
    OnClick = btnSendObjectClick
  end
  object btnGetFile: TButton
    Left = 508
    Top = 6
    Width = 100
    Height = 25
    Caption = 'btnGetFile'
    TabOrder = 5
    OnClick = btnGetFileClick
  end
  object edtFileID: TEdit
    Left = 360
    Top = 8
    Width = 142
    Height = 21
    TabOrder = 6
    Text = 'demoFile.jpg'
  end
  object mmoData: TMemo
    Left = 8
    Top = 89
    Width = 521
    Height = 89
    Lines.Strings = (
      'this message will send to server')
    TabOrder = 7
  end
end
