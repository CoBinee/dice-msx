; Camp.inc : キャンプ
;


; マクロの定義
;

; スプライト
CAMP_SPRITE_NULL                =   0x00

; キャンプ
CAMP_PROC_L                     =   0x00
CAMP_PROC_H                     =   0x01
CAMP_STATE                      =   0x02
CAMP_FLAG                       =   0x03
CAMP_MENU                       =   0x04
CAMP_ITEM_0                     =   0x05
CAMP_ITEM_1                     =   0x06
CAMP_ITEM_2                     =   0x07
CAMP_ITEM_3                     =   0x08
CAMP_ITEM_SIZE                  =   0x09
CAMP_CASTER                     =   0x0a
CAMP_TARGET                     =   0x0b
CAMP_VALUE                      =   0x0c
CAMP_PARTY                      =   0x0d
CAMP_PARTY_0                    =   0x0e
CAMP_PARTY_1                    =   0x0f
CAMP_PARTY_2                    =   0x10
CAMP_PARTY_3                    =   0x11
CAMP_PARTY_4                    =   0x12
CAMP_ORDER_0                    =   0x13
CAMP_ORDER_1                    =   0x14
CAMP_ORDER_2                    =   0x15
CAMP_ORDER_3                    =   0x16
CAMP_ORDER_4                    =   0x17
CAMP_LENGTH                     =   0x18

; 処理
CAMP_PROC_NULL                  =   0x00

; 状態
CAMP_STATE_NULL                 =   0x00

; フラグ
CAMP_FLAG_NULL                  =   0x00
CAMP_FLAG_DONE_BIT              =   0x07
CAMP_FLAG_DONE                  =   (1 << CAMP_FLAG_DONE_BIT)

; メニュー
CAMP_MENU_NULL                  =   0x00

; 項目
CAMP_ITEM_NULL                  =   0x00
CAMP_ITEM_SPELL                 =   0x01
CAMP_ITEM_POTION                =   0x02
CAMP_ITEM_ORDER                 =   0x03
CAMP_ITEM_LOAD                  =   0x04
CAMP_ITEM_SAVE                  =   0x05

; 術者
CAMP_CASTER_NULL                =   0x00

; 対象
CAMP_TARGET_NULL                =   0x00

; 値
CAMP_VALUE_NULL                 =   0x00

; パーティの人数
CAMP_PARTY_NULL                 =   0x00

; 順番
CAMP_ORDER_NULL                 =   0x00

; 呪文
CAMP_SPELL_CASTER_NULL          =   0x00
CAMP_SPELL_CASTER_0             =   0x00
CAMP_SPELL_CASTER_1             =   0x01
CAMP_SPELL_CASTER_2             =   0x02
CAMP_SPELL_CASTER_3             =   0x03
CAMP_SPELL_CASTER_4             =   0x04
CAMP_SPELL_CASTER_LENGTH        =   0x05
CAMP_SPELL_TARGET_NULL          =   0x00
CAMP_SPELL_TARGET_0             =   0x00
CAMP_SPELL_TARGET_1             =   0x01
CAMP_SPELL_TARGET_2             =   0x02
CAMP_SPELL_TARGET_3             =   0x03
CAMP_SPELL_TARGET_4             =   0x04
CAMP_SPELL_TARGET_LENGTH        =   0x05

; 薬
CAMP_POTION_TARGET_NULL         =   0x00
CAMP_POTION_TARGET_0            =   0x00
CAMP_POTION_TARGET_1            =   0x01
CAMP_POTION_TARGET_2            =   0x02
CAMP_POTION_TARGET_3            =   0x03
CAMP_POTION_TARGET_4            =   0x04
CAMP_POTION_TARGET_LENGTH       =   0x05

; ファイル
CAMP_FILE_HEADER_LENGTH         =   0x10
CAMP_FILE_DATA_CRC              =   0x00
CAMP_FILE_DATA_GOLD_L           =   0x01
CAMP_FILE_DATA_GOLD_H           =   0x02
CAMP_FILE_DATA_POTION           =   0x03
CAMP_FILE_DATA_0_LEVEL          =   0x04
CAMP_FILE_DATA_0_LIFE           =   0x05
CAMP_FILE_DATA_0_MAGIC          =   0x06
CAMP_FILE_DATA_0_EXPERIENCE_L   =   0x07
CAMP_FILE_DATA_0_EXPERIENCE_H   =   0x08
CAMP_FILE_DATA_1_LEVEL          =   0x09
CAMP_FILE_DATA_1_LIFE           =   0x0a
CAMP_FILE_DATA_1_MAGIC          =   0x0b
CAMP_FILE_DATA_1_EXPERIENCE_L   =   0x0c
CAMP_FILE_DATA_1_EXPERIENCE_H   =   0x0d
CAMP_FILE_DATA_2_LEVEL          =   0x0e
CAMP_FILE_DATA_2_LIFE           =   0x0f
CAMP_FILE_DATA_2_MAGIC          =   0x10
CAMP_FILE_DATA_2_EXPERIENCE_L   =   0x11
CAMP_FILE_DATA_2_EXPERIENCE_H   =   0x12
CAMP_FILE_DATA_3_LEVEL          =   0x13
CAMP_FILE_DATA_3_LIFE           =   0x14
CAMP_FILE_DATA_3_MAGIC          =   0x15
CAMP_FILE_DATA_3_EXPERIENCE_L   =   0x16
CAMP_FILE_DATA_3_EXPERIENCE_H   =   0x17
CAMP_FILE_DATA_4_LEVEL          =   0x18
CAMP_FILE_DATA_4_LIFE           =   0x19
CAMP_FILE_DATA_4_MAGIC          =   0x1a
CAMP_FILE_DATA_4_EXPERIENCE_L   =   0x1b
CAMP_FILE_DATA_4_EXPERIENCE_H   =   0x1c
CAMP_FILE_DATA_LENGTH           =   0x1d

; 外部関数宣言
;

    .globl  _CampInitialize
    .globl  _CampUpdate
    .globl  _CampRender
    .globl  _CampLoad
    .globl  _CampIsDone

; 外部変数宣言
;

    .globl  _camp
