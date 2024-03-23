; Game.inc : ゲーム
;


; マクロの定義
;

; スプライト
GAME_SPRITE_NULL                =   0x00
GAME_SPRITE_PLAYER              =   0x00
GAME_SPRITE_ENEMY               =   0x20

; ゲーム
GAME_PROC_L                     =   0x00
GAME_PROC_H                     =   0x01
GAME_STATE                      =   0x02
GAME_FLAG                       =   0x03
GAME_FRAME                      =   0x04
GAME_COUNT                      =   0x05
GAME_GOTO                       =   0x06
GAME_LENGTH                     =   0x07

; 処理
GAME_PROC_NULL                  =   0x00

; 状態
GAME_STATE_NULL                 =   0x00

; フラグ
GAME_FLAG_NULL                  =   0x00

; フレーム
GAME_FRAME_NULL                 =   0x00

; カウント
GAME_COUNT_NULL                 =   0x00

; 遷移先
GAME_GOTO_NULL                  =   0x00
GAME_GOTO_TOWN                  =   0x01
GAME_GOTO_DUNGEON               =   0x02
GAME_GOTO_CASTLE                =   0x03

; 外部関数宣言
;

    .globl  _GameInitialize
    .globl  _GameUpdate
    .globl  _GameClearString
    .globl  _GameGetString
    .globl  _GameSetString
    .globl  _GameConcatString
    .globl  _GameConcatValue
    .globl  _GameLocate
    .globl  _GamePrintString
    .globl  _GamePrintValue
    .globl  _GamePrintFrame
    .globl  _GamePrintMessage
    
; 外部変数宣言
;

    .globl  _game
    .globl  _gameString
