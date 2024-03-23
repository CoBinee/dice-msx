; Enemy.inc : エネミー
;


; マクロの定義
;

; エネミー
ENEMY_TYPE                      =   0x00
ENEMY_STATE                     =   0x01
ENEMY_FLAG                      =   0x02
ENEMY_LIFE                      =   0x03
ENEMY_EXPERIENCE                =   0x04
ENEMY_ANIMATION                 =   0x05
ENEMY_NAME_L                    =   0x06
ENEMY_NAME_H                    =   0x07
ENEMY_PATTERN_L                 =   0x08
ENEMY_PATTERN_H                 =   0x09
ENEMY_LOCATE_L                  =   0x0a
ENEMY_LOCATE_H                  =   0x0b
ENEMY_COLOR                     =   0x0c
ENEMY_LENGTH                    =   0x10

; 種類
ENEMY_TYPE_NULL                 =   0x00
ENEMY_TYPE_WOLF                 =   0x01
ENEMY_TYPE_BEAR                 =   0x02
ENEMY_TYPE_BEAST                =   0x03
ENEMY_TYPE_GHOST                =   0x04
ENEMY_TYPE_GIANT                =   0x05
ENEMY_TYPE_DRAGON               =   0x06
ENEMY_TYPE_ITYASJAR             =   0x07

; 状態
ENEMY_STATE_NULL                =   0x00

; フラグ
ENEMY_FLAG_NULL                 =   0x00

; 体力
ENEMY_LIFE_NULL                 =   0x00

; 経験値
ENEMY_EXPERIENCE_NULL           =   0x00

; アニメーション
ENEMY_ANIMATION_NULL            =   0x00
ENEMY_ANIMATION_ENCOUNT         =   (0x07 * 0x02)

; 名前
ENEMY_NAME_NULL                 =   0x00
ENEMY_NAME_LENGTH               =   0x0a

; パターン
ENEMY_PATTERN_NULL              =   0x00

; 表示位置
ENEMY_LOCATE_NULL               =   0x00

; 色
ENEMY_COLOR_NULL                =   0x00

; エントリ
ENEMY_ENTRY                     =   0x04

; グループ
ENEMY_GROUP_NULL                =   0x00
ENEMY_GROUP_ROOM_1              =   0x01
ENEMY_GROUP_ROOM_2              =   0x02
ENEMY_GROUP_ROOM_3              =   0x03
ENEMY_GROUP_CASTLE_1            =   0x04
ENEMY_GROUP_CASTLE_2            =   0x05
ENEMY_GROUP_CASTLE_3            =   0x06

; 外部関数宣言
;

    .globl  _EnemyInitialize
    .globl  _EnemyLoad
    .globl  _EnemyGetTarget
    .globl  _EnemyGetTargetType
    .globl  _EnemyGetTargetName
    .globl  _EnemyIsTargetLive
    .globl  _EnemyTakeTargetDamage
    .globl  _EnemyGetGroupNumber
    .globl  _EnemyGetGroupExperience
    .globl  _EnemyIsGroupLive
    .globl  _EnemyPrintGroup
    .globl  _EnemyAnimate

; 外部変数宣言
;

    .globl  _enemy
