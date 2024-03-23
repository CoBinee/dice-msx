; Menu.inc : メニュー
;


; マクロの定義
;

; スプライト
MENU_SPRITE_NULL                =   0x00

; メニュー
MENU_STATE                      =   0x00
MENU_FLAG                       =   0x01
MENU_POSITION_X                 =   0x02
MENU_POSITION_Y                 =   0x03
MENU_SIZE                       =   0x04
MENU_SPACE                      =   0x05
MENU_CURSOR                     =   0x06
MENU_LENGTH                     =   0x07

; 状態
MENU_STATE_NULL                 =   0x00

; フラグ
MENU_FLAG_NULL                  =   0x00
MENU_FLAG_CANCEL_BIT            =   0x06
MENU_FLAG_CANCEL                =   (1 << MENU_FLAG_CANCEL_BIT)
MENU_FLAG_SELECT_BIT            =   0x07
MENU_FLAG_SELECT                =   (1 << MENU_FLAG_SELECT_BIT)

; 位置
MENU_POSITION_NULL              =   0x00

; サイズ
MENU_SIZE_NULL                  =   0x00

; 間隔
MENU_SPACE_NULL                 =   0x00

; カーソル
MENU_CURSOR_NULL                =   0x00

; 外部関数宣言
;

    .globl  _MenuInitialize
    .globl  _MenuUpdate
    .globl  _MenuRender
    .globl  _MenuLoad
    .globl  _MenuIsSelect
    .globl  _MenuIsCancel
    .globl  _MenuGetItem

; 外部変数宣言
;

    .globl  _menu
