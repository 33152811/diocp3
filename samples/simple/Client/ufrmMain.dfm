object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'diocp3 coder client'
  ClientHeight = 314
  ClientWidth = 562
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
    Top = 80
    Width = 521
    Height = 217
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
  object btnSendBuf: TButton
    Left = 360
    Top = 9
    Width = 105
    Height = 25
    Caption = 'btnSendBuf'
    TabOrder = 4
    OnClick = btnSendBufClick
  end
  object edtData: TEdit
    Left = 8
    Top = 53
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'edtData'
  end
  object btnOnlySend: TButton
    Left = 156
    Top = 49
    Width = 75
    Height = 25
    Caption = 'btnOnlySend'
    TabOrder = 6
    OnClick = btnOnlySendClick
  end
end
