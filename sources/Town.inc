; Town.inc : 町
;


; マクロの定義
;

; スプライト
TOWN_SPRITE_NULL                =   0x00

; 町
TOWN_PROC_L                     =   0x00
TOWN_PROC_H                     =   0x01
TOWN_STATE                      =   0x02
TOWN_FLAG                       =   0x03
TOWN_ANIMATION                  =   0x04
TOWN_PLAZA                      =   0x05
TOWN_TARGET                     =   0x06
TOWN_COST_L                     =   0x07
TOWN_COST_H                     =   0x08
TOWN_PARAM_0                    =   0x09
TOWN_PARAM_1                    =   0x0a
TOWN_PARAM_2                    =   0x0b
TOWN_PARAM_3                    =   0x0c
TOWN_PARAM_4                    =   0x0d
TOWN_PARAM_5                    =   0x0e
TOWN_PARAM_6                    =   0x0f
TOWN_PARAM_7                    =   0x10
TOWN_LENGTH                     =   0x11

; 処理
TOWN_PROC_NULL                  =   0x00

; 状態
TOWN_STATE_NULL                 =   0x00

; フラグ
TOWN_FLAG_NULL                  =   0x00

; アニメーション
TOWN_ANIMATION_NULL             =   0x00

; 対象
TOWN_TARGET_NULL                =   0x00

; 費用
TOWN_COST_NULL                  =   0x00

; パラメータ
TOWN_PARAM_NULL                 =   0x00

; 広場
TOWN_PLAZA_NULL                 =   0x00
TOWN_PLAZA_INN                  =   0x00
TOWN_PLAZA_TEMPLE               =   0x01
TOWN_PLAZA_CAMP                 =   0x02
TOWN_PLAZA_DUNGEON              =   0x03
TOWN_PLAZA_CASTLE               =   0x04
TOWN_PLAZA_LENGTH               =   0x05

; 宿
TOWN_INN_QUERY_NULL             =   0x00
TOWN_INN_QUERY_OK               =   0x00
TOWN_INN_QUERY_CANCEL           =   0x01
TOWN_INN_QUERY_LENGTH           =   0x02

; 寺院
TOWN_TEMPLE_SELECT_NULL         =   0x00
TOWN_TEMPLE_SELECT_0            =   0x00
TOWN_TEMPLE_SELECT_1            =   0x01
TOWN_TEMPLE_SELECT_2            =   0x02
TOWN_TEMPLE_SELECT_3            =   0x03
TOWN_TEMPLE_SELECT_4            =   0x04
TOWN_TEMPLE_SELECT_LENGTH       =   0x05
TOWN_TEMPLE_QUERY_NULL          =   0x00
TOWN_TEMPLE_QUERY_OK            =   0x00
TOWN_TEMPLE_QUERY_CANCEL        =   0x01
TOWN_TEMPLE_QUERY_LENGTH        =   0x02

; キャンプ

; ダンジョン
TOWN_DUNGEON_SELECT_NULL        =   0x00
TOWN_DUNGEON_SELECT_0           =   0x00
TOWN_DUNGEON_SELECT_1           =   0x01
TOWN_DUNGEON_SELECT_2           =   0x02
TOWN_DUNGEON_SELECT_3           =   0x03
TOWN_DUNGEON_SELECT_4           =   0x04
TOWN_DUNGEON_SELECT_OK          =   0x05
TOWN_DUNGEON_SELECT_LENGTH      =   0x06
TOWN_DUNGEON_QUERY_NULL         =   0x00
TOWN_DUNGEON_QUERY_OK           =   0x00
TOWN_DUNGEON_QUERY_CANCEL       =   0x01
TOWN_DUNGEON_QUERY_LENGTH       =   0x02

; 城

; 外部関数宣言
;

    .globl  _TownInitialize
    .globl  _TownUpdate
    .globl  _TownRender
    .globl  _TownLoad

; 外部変数宣言
;

    .globl  _town
