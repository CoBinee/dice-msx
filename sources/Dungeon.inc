; Dungeon.inc : ダンジョン
;


; マクロの定義
;

; スプライト
DUNGEON_SPRITE_NULL             =   0x00
DUNGEON_SPRITE_ARROW            =   0x00

; ダンジョン
DUNGEON_PROC_L                  =   0x00
DUNGEON_PROC_H                  =   0x01
DUNGEON_STATE                   =   0x02
DUNGEON_FLAG                    =   0x03
DUNGEON_MAZE_HERE               =   0x04
DUNGEON_MAZE_NEXT               =   0x05
DUNGEON_JUNCTION                =   0x06
DUNGEON_CASTLE                  =   0x07
DUNGEON_POSITION_X              =   0x08
DUNGEON_POSITION_Y              =   0x09
DUNGEON_DIRECTION               =   0x0a
DUNGEON_COMMAND                 =   0x0b
DUNGEON_ARROW                   =   0x0c
DUNGEON_TARGET                  =   0x0d
DUNGEON_ANIMATION               =   0x0e
DUNGEON_CHEAT                   =   0x0f
DUNGEON_LENGTH                  =   0x10

; 処理
DUNGEON_PROC_NULL               =   0x00

; 状態
DUNGEON_STATE_NULL              =   0x00

; フラグ
DUNGEON_FLAG_NULL               =   0x00
DUNGEON_FLAG_CASTLE_BIT         =   0x00
DUNGEON_FLAG_CASTLE             =   (1 << DUNGEON_FLAG_CASTLE_BIT)

; 迷路
DUNGEON_MAZE_NULL               =   0x00

; 分岐路
DUNGEON_JUNCTION_NULL           =   0x00
DUNGEON_JUNCTION_MAXIMUM        =   99

; 城
DUNGEON_CASTLE_NULL             =   0x00
DUNGEON_CASTLE_1                =   0x00
DUNGEON_CASTLE_2                =   0x01
DUNGEON_CASTLE_3                =   0x02
DUNGEON_CASTLE_LENGTH           =   0x03

; 位置
DUNGEON_POSITION_NULL           =   0x00

; 向き
DUNGEON_DIRECTION_NULL          =   0x00

; コマンド
DUNGEON_COMMAND_NULL            =   0x00
DUNGEON_COMMAND_FORWARD         =   0x01
DUNGEON_COMMAND_BACK            =   0x02
DUNGEON_COMMAND_LEFT            =   0x03
DUNGEON_COMMAND_RIGHT           =   0x04
DUNGEON_COMMAND_DONE            =   0xff

; 矢印
DUNGEON_ARROW_NULL              =   0x00
DUNGEON_ARROW_FORWARD           =   0x01
DUNGEON_ARROW_BACK              =   0x02
DUNGEON_ARROW_LEFT              =   0x03
DUNGEON_ARROW_RIGHT             =   0x04

; 対象
DUNGEON_TARGET_NULL             =   0x00

; アニメーション
DUNGEON_ANIMATION_NULL          =   0x00
DUNGEON_ANIMATION_ARROW         =   0x04
DUNGEON_ANIMATION_WALK          =   0x04
DUNGEON_ANIMATION_ENTER         =   0x30
DUNGEON_ANIMATION_EXIT          =   0x30
DUNGEON_ANIMATION_ENCOUNT       =   0x18
DUNGEON_ANIMATION_NEXT          =   0x08

; チート
DUNGEON_CHEAT_NULL              =   0x00

; 待機
DUNGEON_IDLE_NULL               =   0x00
DUNGEON_IDLE_ROLL               =   0x00
DUNGEON_IDLE_CAMP               =   0x01
DUNGEON_IDLE_LENGTH             =   0x02

; 外部関数宣言
;

    .globl  _DungeonInitialize
    .globl  _DungeonUpdate
    .globl  _DungeonRender
    .globl  _DungeonLoad

; 外部変数宣言
;

    .globl  _dungeon
