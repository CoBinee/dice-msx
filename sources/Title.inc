; Title.inc : タイトル
;


; マクロの定義
;

; スプライト
TITLE_SPRITE_NULL               =   0x00

; タイトル
TITLE_PROC_L                    =   0x00
TITLE_PROC_H                    =   0x01
TITLE_STATE                     =   0x02
TITLE_FLAG                      =   0x03
TITLE_FRAME                     =   0x04
TITLE_COUNT                     =   0x05
TITLE_STRING_L                  =   0x06
TITLE_STRING_H                  =   0x07
TITLE_ANIMATION                 =   0x08
TITLE_LENGTH                    =   0x09

; 処理
TITLE_PROC_NULL                 =   0x00

; 状態
TITLE_STATE_NULL                =   0x00

; フラグ
TITLE_FLAG_NULL                 =   0x00

; フレーム
TITLE_FRAME_NULL                =   0x00

; カウント
TITLE_COUNT_NULL                =   0x00

; 文字列
TITLE_STRING_NULL               =   0x00

; アニメーション
TITLE_ANIMATION_NULL            =   0x00
TITLE_ANIMATION_LINE            =   0x30
TITLE_ANIMATION_PAGE            =   0x60
TITLE_ANIMATION_NEXT            =   0x18
TITLE_ANIMATION_START           =   0x30

; 外部関数宣言
;

    .globl  _TitleInitialize
    .globl  _TitleUpdate
    
; 外部変数宣言
;

    .globl  _title
