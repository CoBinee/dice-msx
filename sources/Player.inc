; Player.inc : プレイヤ
;


; マクロの定義
;

; プレイヤ
PLAYER_GOLD_L                   =   0x00
PLAYER_GOLD_H                   =   0x01
PLAYER_POTION                   =   0x02
PLAYER_LENGTH                   =   0x03

; 所持金
PLAYER_GOLD_NULL                =   0
PLAYER_GOLD_MAXIMUM             =   9999

; 薬
PLAYER_POTION_NULL              =   0
PLAYER_POTION_MAXIMUM           =   20

; キャラクタ
PLAYER_CHARACTER_CLASS          =   0x00
PLAYER_CHARACTER_LEVEL          =   0x01
PLAYER_CHARACTER_LIFE           =   0x02
PLAYER_CHARACTER_LIFE_BASE      =   0x03
PLAYER_CHARACTER_MAGIC          =   0x04
PLAYER_CHARACTER_MAGIC_BASE     =   0x05
PLAYER_CHARACTER_EXPERIENCE_L   =   0x06
PLAYER_CHARACTER_EXPERIENCE_H   =   0x07
PLAYER_CHARACTER_SPELL          =   0x08
PLAYER_CHARACTER_HEAL           =   0x09
PLAYER_CHARACTER_NAME_L         =   0x0a
PLAYER_CHARACTER_NAME_H         =   0x0b
PLAYER_CHARACTER_LENGTH         =   0x10

PLAYER_CHARACTER_NULL           =   0x00
PLAYER_CHARACTER_LORD           =   0x01
PLAYER_CHARACTER_FIGHTER        =   0x02
PLAYER_CHARACTER_PRIEST         =   0x03
PLAYER_CHARACTER_THIEF          =   0x04
PLAYER_CHARACTER_MAGE           =   0x05
PLAYER_CHARACTER_ENTRY          =   0x06

; クラス
PLAYER_CLASS_NULL               =   0x00
PLAYER_CLASS_LORD               =   0x01
PLAYER_CLASS_FIGHTER            =   0x02
PLAYER_CLASS_PRIEST             =   0x03
PLAYER_CLASS_THIEF              =   0x04
PLAYER_CLASS_MAGE               =   0x05

; レベル
PLAYER_LEVEL_NULL               =   0
PLAYER_LEVEL_MINIMUM            =   1
PLAYER_LEVEL_MAXIMUM            =   50

; 体力
PLAYER_LIFE_NULL                =   0
PLAYER_LIFE_MAXIMUM             =   99

; 魔力
PLAYER_MAGIC_NULL               =   0
PLAYER_MAGIC_MAXIMUM            =   99

; 経験値
PLAYER_EXPERIENCE_NULL          =   0
PLAYER_EXPERIENCE_MAXIMUM       =   999

; 呪文
PLAYER_SPELL_NULL               =   0x00
PLAYER_SPELL_HEAL               =   0x01
PLAYER_SPELL_FIREBALL           =   0x02

; 回復力
PLAYER_HEAL_NULL                =   0x00
PLAYER_HEAL_POTION              =   99

; 名前
PLAYER_NAME_NULL                =   0x00
PLAYER_NAME_LENGTH              =   0x06

; パーティ
PLAYER_PARTY_0                  =   0x00
PLAYER_PARTY_1                  =   0x01
PLAYER_PARTY_2                  =   0x02
PLAYER_PARTY_3                  =   0x03
PLAYER_PARTY_4                  =   0x04
PLAYER_PARTY_LENGTH             =   0x05
PLAYER_PARTY_DUNGEON            =   0x04
PLAYER_PARTY_CASTLE             =   0x05

; 外部関数宣言
;

    .globl  _PlayerInitialize
    .globl  _PlayerGetGold
    .globl  _PlayerSetGold
    .globl  _PlayerUseGold
    .globl  _PlayerAddGold
    .globl  _PlayerGetPotion
    .globl  _PlayerSetPotion
    .globl  _PlayerUsePotion
    .globl  _PlayerAddPotion
    .globl  _PlayerGetCharacterLevel
    .globl  _PlayerGetCharacterClass
    .globl  _PlayerGetCharacterLife
    .globl  _PlayerGetCharacterMagic
    .globl  _PlayerGetCharacterExperience
    .globl  _PlayerGetCharacterSpell
    .globl  _PlayerGetCharacterHeal
    .globl  _PlayerGetCharacterName
    .globl  _PlayerSetCharacterLevel
    .globl  _PlayerSetCharacterLife
    .globl  _PlayerSetCharacterMagic
    .globl  _PlayerSetCharacterExperience
    .globl  _PlayerIsCharacterLive
    .globl  _PlayerRestCharacter
    .globl  _PlayerHealCharacter
    .globl  _PlayerReviveCharacter
    .globl  _PlayerCastCharacter
    .globl  _PlayerTakeCharacterDamage
    .globl  _PlayerAddCharacterExperience
    .globl  _PlayerDownCharacterLevel
    .globl  _PlayerClearParty
    .globl  _PlayerAddParty
    .globl  _PlayerRemoveParty
    .globl  _PlayerGetPartyCharacter
    .globl  _PlayerGetPartyNumber
    .globl  _PlayerIsPartyLive
    .globl  _PlayerPrintParty
    .globl  _PlayerPrintItem

; 外部変数宣言
;

    .globl  _player
    .globl  _playerCharacter
    .globl  _playerParty
