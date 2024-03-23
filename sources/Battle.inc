; Battle.inc : 戦闘
;


; マクロの定義
;

; スプライト
BATTLE_SPRITE_NULL              =   0x00

; 戦闘
BATTLE_PROC_L                   =   0x00
BATTLE_PROC_H                   =   0x01
BATTLE_STATE                    =   0x02
BATTLE_FLAG                     =   0x03
BATTLE_PARTY                    =   0x04
BATTLE_ORDER                    =   0x05
BATTLE_TARGET                   =   0x06
BATTLE_VALUE                    =   0x07
BATTLE_MENU                     =   0x08
BATTLE_ATTACK                   =   0x09
BATTLE_MAGIC_COST               =   0x0a
BATTLE_MAGIC_MAXIMUM            =   0x0b
BATTLE_TREASURE_GOLD            =   0x0c
BATTLE_TREASURE_POTION          =   0x0d
BATTLE_CHEAT                    =   0x0e
BATTLE_DONE                     =   0x0f
BATTLE_LENGTH                   =   0x10

; 処理
BATTLE_PROC_NULL                =   0x00

; 状態
BATTLE_STATE_NULL               =   0x00

; フラグ
BATTLE_FLAG_NULL                =   0x00
BATTLE_FLAG_ERROR_BIT           =   0x00
BATTLE_FLAG_ERROR               =   (1 << BATTLE_FLAG_ERROR_BIT)

; パーティの人数
BATTLE_PARTY_NULL               =   0x00

; 順番
BATTLE_ORDER_NULL               =   0x00

; 対象
BATTLE_TARGET_NULL              =   0x00

; 値
BATTLE_VALUE_NULL               =   0x00

; 攻撃
BATTLE_ATTACK_NULL              =   0x00

; チート
BATTLE_CHEAT_NULL               =   0x00

; 魔力
BATTLE_MAGIC_NULL               =   0x00

; 完了
BATTLE_DONE_NULL                =   0x00
BATTLE_DONE_DEAD                =   0x01
BATTLE_DONE_END                 =   0x02

; メニュー
BATTLE_MENU_NULL                =   0x00
BATTLE_MENU_ATTACK              =   0x00
BATTLE_MENU_SPELL               =   0x01
BATTLE_MENU_POTION              =   0x02
BATTLE_MENU_LENGTH              =   0x03

; 呪文
BATTLE_SPELL_TARGET_NULL        =   0x00
BATTLE_SPELL_TARGET_0           =   0x00
BATTLE_SPELL_TARGET_1           =   0x01
BATTLE_SPELL_TARGET_2           =   0x02
BATTLE_SPELL_TARGET_3           =   0x03
BATTLE_SPELL_TARGET_4           =   0x04
BATTLE_SPELL_TARGET_LENGTH      =   0x05

; 薬
BATTLE_POTION_TARGET_NULL       =   0x00
BATTLE_POTION_TARGET_0          =   0x00
BATTLE_POTION_TARGET_1          =   0x01
BATTLE_POTION_TARGET_2          =   0x02
BATTLE_POTION_TARGET_3          =   0x03
BATTLE_POTION_TARGET_4          =   0x04
BATTLE_POTION_TARGET_LENGTH     =   0x05

; 外部関数宣言
;

    .globl  _BattleInitialize
    .globl  _BattleUpdate
    .globl  _BattleRender
    .globl  _BattleLoad
    .globl  _BattleIsDead
    .globl  _BattleIsEnd

; 外部変数宣言
;

    .globl  _battle
