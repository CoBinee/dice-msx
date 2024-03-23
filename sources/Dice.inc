; Dice.inc : ダイス
;


; マクロの定義
;

; ダイス
DICE_PROC_L                     =   0x00
DICE_PROC_H                     =   0x01
DICE_STATE                      =   0x02
DICE_FLAG                       =   0x03
DICE_TYPE                       =   0x04
DICE_FACE                       =   0x05
DICE_CHEAT                      =   0x06
DICE_ROLL_X                     =   0x07
DICE_ROLL_Y                     =   0x08
DICE_OFFSET_X                   =   0x09
DICE_OFFSET_Y                   =   0x0a
DICE_ANIMATION                  =   0x0b
DICE_SPRITE_L                   =   0x0c
DICE_SPRITE_H                   =   0x0d
DICE_LENGTH                     =   0x0e

; 処理
DICE_PROC_NULL                  =   0x00

; 状態
DICE_STATE_NULL                 =   0x00

; フラグ
DICE_FLAG_NULL                  =   0x00
DICE_FLAG_DONE_BIT              =   0x07
DICE_FLAG_DONE                  =   (1 << DICE_FLAG_DONE_BIT)

; 種類
DICE_TYPE_NULL                  =   0x00
DICE_TYPE_MAZE                  =   0x01
DICE_TYPE_BATTLE                =   0x02
DICE_TYPE_TREASURE              =   0x03

; 面
DICE_FACE_NULL                  =   0x00
DICE_FACE_1                     =   0x01
DICE_FACE_2                     =   0x02
DICE_FACE_3                     =   0x03
DICE_FACE_4                     =   0x04
DICE_FACE_5                     =   0x05
DICE_FACE_6                     =   0x06

; チート
DICE_CHEAT_NULL                 =   0x00

; ロール
DICE_ROLL_NULL                  =   0x00

; オフセット
DICE_OFFSET_NULL                =   0x00

; アニメーション
DICE_ANIMATION_NULL             =   0x00
DICE_ANIMATION_ROLL             =   0x20
DICE_ANIMATION_DONE             =   0x10

; スプライト
DICE_SPRITE_NULL                =   0x00

; エントリ
DICE_ENTRY                      =   0x04

; 外部関数宣言
;

    .globl  _DiceInitialize
    .globl  _DiceUpdate
    .globl  _DiceRender
    .globl  _DiceLoad
    .globl  _DiceGetFace
    .globl  _DiceCheat
    .globl  _DiceIsCheat

; 外部変数宣言
;

    .globl  _dice
