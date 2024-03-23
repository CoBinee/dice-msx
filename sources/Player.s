; Player.s : プレイヤ
;


; モジュール宣言
;
    .module Player

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Player.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; プレイヤを初期化する
;
_PlayerInitialize::
    
    ; レジスタの保存
    
    ; プレイヤの初期化
    ld      hl, #playerDefault
    ld      de, #_player
    ld      bc, #PLAYER_LENGTH
    ldir

    ; キャラクタの初期化
    ld      hl, #playerCharacterDefault
    ld      de, #_playerCharacter
    ld      bc, #(PLAYER_CHARACTER_LENGTH * PLAYER_CHARACTER_ENTRY)
    ldir

    ; パーティの初期化
    call    _PlayerClearParty
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 所持金を取得する
;
_PlayerGetGold::

    ; レジスタの保存

    ; hl > 所持金

    ; 所持金の取得
    ld      hl, (_player + PLAYER_GOLD_L)

    ; レジスタの復帰

    ; 終了
    ret

; 所持金を設定する
;
_PlayerSetGold::

    ; レジスタの保存

    ; hl < 所持金

    ; 所持金の取得
    ld      (_player + PLAYER_GOLD_L), hl

    ; レジスタの復帰

    ; 終了
    ret

; 所持金を消費する
;
_PlayerUseGold::

    ; レジスタの保存
    push    hl
    push    de

    ; hl < 所持金
    ; cf > 1 = 消費できた

    ; 所持金の取得
    ld      de, (_player + PLAYER_GOLD_L)
    ex      de, hl
    or      a
    sbc     hl, de
    jr      c, 18$
    ld      (_player + PLAYER_GOLD_L), hl
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 所持金を加える
;
_PlayerAddGold::

    ; レジスタの保存
    push    hl
    push    de

    ; hl < 所持金

    ; 所持金の加算
    ld      de, (_player + PLAYER_GOLD_L)
    add     hl, de
    ld      de, #PLAYER_GOLD_MAXIMUM
    or      a
    sbc     hl, de
    jr      nc, 10$
    add     hl, de
    jr      11$
10$:
    ex      de, hl
11$:
    ld      (_player + PLAYER_GOLD_L), hl

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 薬を取得する
;
_PlayerGetPotion::

    ; レジスタの保存

    ; a > 薬

    ; 薬の取得
    ld      a, (_player + PLAYER_POTION)

    ; レジスタの復帰

    ; 終了
    ret

; 薬を設定する
;
_PlayerSetPotion::

    ; レジスタの保存

    ; a < 薬

    ; 薬の取得
    ld      (_player + PLAYER_POTION), a

    ; レジスタの復帰

    ; 終了
    ret

; 薬を消費する
;
_PlayerUsePotion::

    ; レジスタの保存
    push    hl

    ; cf > 1 = 消費できた

    ; 薬の取得
    ld      hl, #(_player + PLAYER_POTION)
    ld      a, (hl)
    or      a
    jr      z, 19$
    dec     (hl)
    scf
    jr      19$
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 薬を加える
;
_PlayerAddPotion::

    ; レジスタの保存
    push    hl

    ; a < 薬

    ; 薬の加算
    ld      hl, #(_player + PLAYER_POTION)
    add     a, (hl)
    cp      #PLAYER_POTION_MAXIMUM
    jr      c, 10$
    ld      a, #PLAYER_POTION_MAXIMUM
10$:
    ld      (hl), a

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; キャラクタを取得する
;
PlayerGetCharacter:

    ; レジスタの保存
    push    de

    ; a  < キャラクタ
    ; ix > キャラクタ

    ; キャラクタの取得
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      ix, #_playerCharacter
    add     ix, de

    ; レジスタの復帰
    pop     de

    ; 終了
    ret

; キャラクタのレベルを取得する
;
_PlayerGetCharacterLevel::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; a > レベル

    ; レベルの取得
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LEVEL(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタのクラスを取得する
;
_PlayerGetCharacterClass::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; a > クラス

    ; レベルの取得
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_CLASS(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの体力を取得する
;
_PlayerGetCharacterLife::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; a > 体力

    ; レベルの取得
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LIFE(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの魔力を取得する
;
_PlayerGetCharacterMagic::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; a > 魔力

    ; レベルの取得
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_MAGIC(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの経験値を取得する
;
_PlayerGetCharacterExperience::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; hl > 経験値

    ; レベルの取得
    call    PlayerGetCharacter
    ld      l, PLAYER_CHARACTER_EXPERIENCE_L(ix)
    ld      h, PLAYER_CHARACTER_EXPERIENCE_H(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの呪文を取得する
;
_PlayerGetCharacterSpell::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; a > 呪文

    ; 呪文の取得
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_SPELL(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの回復力を取得する
;
_PlayerGetCharacterHeal::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; a > 回復力

    ; 呪文の取得
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_HEAL(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの名前を取得する
;
_PlayerGetCharacterName::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; hl > 名前

    ; レベルの取得
    call    PlayerGetCharacter
    ld      l, PLAYER_CHARACTER_NAME_L(ix)
    ld      h, PLAYER_CHARACTER_NAME_H(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタのレベルを設定する
;
_PlayerSetCharacterLevel::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; c < レベル

    ; レベルの取得
    call    PlayerGetCharacter
    ld      PLAYER_CHARACTER_LEVEL(ix), c

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの体力を設定する
;
_PlayerSetCharacterLife::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; c < 体力

    ; レベルの取得
    call    PlayerGetCharacter
    ld      PLAYER_CHARACTER_LIFE(ix), c

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの魔力を設定する
;
_PlayerSetCharacterMagic::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ
    ; c < 魔力

    ; レベルの取得
    call    PlayerGetCharacter
    ld      PLAYER_CHARACTER_MAGIC(ix), c

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの経験値を設定する
;
_PlayerSetCharacterExperience::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; hl < 経験値

    ; レベルの取得
    call    PlayerGetCharacter
    ld      PLAYER_CHARACTER_EXPERIENCE_L(ix), l
    ld      PLAYER_CHARACTER_EXPERIENCE_H(ix), h

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタの生存しているかどうかを判定する
;
_PlayerIsCharacterLive::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; cf > 1 = 生存

    ; 生存の判定
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LIFE(ix)
    or      a
    jr      z, 19$
    scf
19$:

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタを休息させる
;
_PlayerRestCharacter::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; 体力と魔力の回復
    ld      ix, #_playerCharacter
    ld      de, #PLAYER_CHARACTER_LENGTH
    ld      b, #PLAYER_CHARACTER_ENTRY
10$:
    ld      a, PLAYER_CHARACTER_LIFE(ix)
    or      a
    jr      z, 19$
    ld      a, PLAYER_CHARACTER_LIFE_BASE(ix)
    add     a, PLAYER_CHARACTER_LEVEL(ix)
    dec     a
    ld      PLAYER_CHARACTER_LIFE(ix), a
    ld      a, PLAYER_CHARACTER_MAGIC_BASE(ix)
    or      a
    jr      z, 19$
    add     a, PLAYER_CHARACTER_LEVEL(ix)
    dec     a
    ld      PLAYER_CHARACTER_MAGIC(ix), a
19$:
    add     ix, de
    djnz    10$

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; キャラクタを回復させる
;
_PlayerHealCharacter::

    ; レジスタの保存
    push    bc
    push    ix

    ; a < キャラクタ
    ; c < 回復力

    ; 回復
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LIFE_BASE(ix)
    add     a, PLAYER_CHARACTER_LEVEL(ix)
    dec     a
    ld      b, a
    ld      a, PLAYER_CHARACTER_LIFE(ix)
    add     a, c
    cp      b
    jr      c, 10$
    ld      a, b
10$:
    ld      PLAYER_CHARACTER_LIFE(ix), a

    ; レジスタの復帰
    pop     ix
    pop     bc

    ; 終了
    ret

; キャラクタを生き返らせる
;
_PlayerReviveCharacter::

    ; レジスタの保存
    push    ix

    ; a < キャラクタ

    ; 蘇生
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LIFE_BASE(ix)
    add     a, PLAYER_CHARACTER_LEVEL(ix)
    dec     a
    ld      PLAYER_CHARACTER_LIFE(ix), a
    ld      a, PLAYER_CHARACTER_MAGIC_BASE(ix)
    or      a
    jr      z, 19$
    add     a, PLAYER_CHARACTER_LEVEL(ix)
    dec     a
    ld      PLAYER_CHARACTER_MAGIC(ix), a
19$:

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; 魔力を消費する
;
_PlayerCastCharacter::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; c  < 魔力
    ; cf > 1 = 消費した

    ; 魔力の消費
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_MAGIC(ix)
    sub     c
    jr      c, 10$
    ld      PLAYER_CHARACTER_MAGIC(ix), a
    scf
    jr      19$
10$:
    or      a
19$:

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタがダメージを食らう
;
_PlayerTakeCharacterDamage::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; d  < ダメージ
    ; cf > 1 = 生存

    ; ダメージを与える
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LIFE(ix)
    sub     d
    jr      nc, 10$
    xor     a
10$:
    ld      PLAYER_CHARACTER_LIFE(ix), a
    or      a
    jr      nz, 18$
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; キャラクタに経験値を加える
;
_PlayerAddCharacterExperience::

    ; レジスタの保存
    push    hl
    push    bc
    push    de
    push    ix

    ; a  < キャラクタ
    ; c  < 経験値
    ; cf > 1 = レベルアップした

    ; 経験値の加算
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LEVEL(ix)
    cp      #PLAYER_LEVEL_MAXIMUM
    jr      nc, 18$
    ld      hl, #0
    ld      de, #10
    ld      b, a
10$:
    add     hl, de
    djnz    10$
    ex      de, hl
    ld      b, #0x00
    ld      l, PLAYER_CHARACTER_EXPERIENCE_L(ix)
    ld      h, PLAYER_CHARACTER_EXPERIENCE_H(ix)
    add     hl, bc
    or      a
    sbc     hl, de
    jr      nc, 11$
    add     hl, de
    ld      PLAYER_CHARACTER_EXPERIENCE_L(ix), l
    ld      PLAYER_CHARACTER_EXPERIENCE_H(ix), h
    jr      18$
11$:
    inc     PLAYER_CHARACTER_LEVEL(ix)
    ld      a, PLAYER_CHARACTER_LEVEL(ix)
    cp      #PLAYER_LEVEL_MAXIMUM
    jr      c, 12$
    ld      hl, #0
12$:
    ld      PLAYER_CHARACTER_EXPERIENCE_L(ix), l
    ld      PLAYER_CHARACTER_EXPERIENCE_H(ix), h
    inc     PLAYER_CHARACTER_LIFE(ix)
    ld      a, PLAYER_CHARACTER_MAGIC_BASE(ix)
    or      a
    jr      z, 13$
    inc     PLAYER_CHARACTER_MAGIC(ix)
13$:
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; キャラクタのレベルが１下がる
;
_PlayerDownCharacterLevel::

    ; レジスタの保存
    push    hl
    push    ix

    ; a  < キャラクタ
    ; cf > 1 = レベルダウンした

    ; ダメージを与える
    call    PlayerGetCharacter
    ld      a, PLAYER_CHARACTER_LEVEL(ix)
    cp      #(PLAYER_LEVEL_MINIMUM + 0x01)
    jr      c, 18$
    dec     PLAYER_CHARACTER_LEVEL(ix)
    ld      l, PLAYER_CHARACTER_EXPERIENCE_L(ix)
    ld      h, PLAYER_CHARACTER_EXPERIENCE_H(ix)
    srl     h
    rr      l
    ld      PLAYER_CHARACTER_EXPERIENCE_L(ix), l
    ld      PLAYER_CHARACTER_EXPERIENCE_H(ix), h
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰
    pop     ix
    pop     hl

    ; 終了
    ret

; パーティをクリアする
;
_PlayerClearParty::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; パーティのクリア
    ld      hl, #(_playerParty + 0x0000)
    ld      de, #(_playerParty + 0x0001)
    ld      bc, #(PLAYER_PARTY_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; パーティにキャラクタを追加する
;
_PlayerAddParty::

    ; レジスタの保存
    push    hl
    push    bc

    ; a < キャラクタ

    ; パーティへの追加
    ld      hl, #_playerParty
    ld      c, a
    ld      b, #PLAYER_PARTY_LENGTH
10$:
    ld      a, (hl)
    or      a
    jr      z, 11$
    inc     hl
    djnz    10$
    jr      19$
11$:
    ld      (hl), c
19$:

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; パーティからキャラクタを外す
;
_PlayerRemoveParty::

    ; レジスタの保存
    push    hl
    push    bc

    ; a > キャラクタ

    ; パーティへの追加
    ld      hl, #(_playerParty + PLAYER_PARTY_LENGTH - 0x0001)
    ld      b, #PLAYER_PARTY_LENGTH
10$:
    ld      a, (hl)
    or      a
    jr      nz, 11$
    dec     hl
    djnz    10$
    jr      19$
11$:
    ld      (hl), #PLAYER_CHARACTER_NULL
19$:

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; パーティ内のキャラクタを取得する
;
_PlayerGetPartyCharacter::

    ; レジスタの保存
    push    hl
    push    de

    ; a < 順番
    ; a > キャラクタ

    ; キャラクタの取得
    ld      e, a
    ld      d, #0x00
    ld      hl, #_playerParty
    add     hl, de
    ld      a, (hl)

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; パーティの人数を取得する
;
_PlayerGetPartyNumber::

    ; レジスタの保存
    push    hl
    push    bc

    ; a > 人数

    ; 人数の取得
    ld      hl, #_playerParty
    ld      bc, #((PLAYER_PARTY_LENGTH << 8) | 0x00)
10$:
    ld      a, (hl)
    or      a
    jr      z, 11$
    inc     hl
    inc     c
    djnz    10$
11$:
    ld      a, c

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; パーティが生存しているかを判定する
;
_PlayerIsPartyLive::

    ; レジスタの保存
    push    bc

    ; cf > 1 = 生存

    ; 生存の確認
    ld      bc, #((PLAYER_PARTY_LENGTH << 8) | 0x00)
10$:
    ld      a, c
    call    _PlayerGetPartyCharacter
    call    _PlayerIsCharacterLive
    jr      c, 11$
    inc     c
    djnz    10$
    or      a
    jr      19$
11$:
    scf
19$:

    ; レジスタの復帰
    pop     bc

    ; 終了
    ret

; パーティを表示する
;
_PlayerPrintParty::

    ; レジスタの保存
    push    hl
    push    bc
    push    de
    push    ix

    ; 枠の描画
    ld      de, #(_patternName + 16 * 0x0020 + 0)
    ld      bc, #((8 << 8) | 32)
    call    _GamePrintFrame

    ; ヘッダの描画
    ld      hl, #playerPartyHeadString
    ld      de, #(_patternName + 17 * 0x0020 + 2)
    call    _GamePrintString

    ; キャラクタの描画
    ld      hl, #_playerParty
    ld      de, #(_patternName + 18 * 0x0020 + 2)
    ld      b, #PLAYER_PARTY_LENGTH
30$:
    ld      a, (hl)
    or      a
    jr      z, 39$
    push    hl
    push    bc
    push    de
    push    de
    call    PlayerGetCharacter
    ld      l, PLAYER_CHARACTER_NAME_L(ix)
    ld      h, PLAYER_CHARACTER_NAME_H(ix)
    call    _GamePrintString
    pop     de
    ld      hl, #0x0009
    add     hl, de
    ex      de, hl
    ld      a, PLAYER_CHARACTER_CLASS(ix)
    add     a, a
    add     a, a
    ld      c, a
    ld      b, #0x00
    ld      hl, #playerClassNameString
    add     hl, bc
    call    _GamePrintString
    inc     de
    ld      l, PLAYER_CHARACTER_LEVEL(ix)
    ld      h, #0x00
    ld      b, #0x02
    call    _GamePrintValue
    inc     de
    ld      l, PLAYER_CHARACTER_LIFE(ix)
;   ld      h, #0x00
;   ld      b, #0x02
    call    _GamePrintValue
    ld      hl, #playerPartyLifeString
    call    _GamePrintString
    ld      a, PLAYER_CHARACTER_LEVEL(ix)
    add     a, PLAYER_CHARACTER_LIFE_BASE(ix)
    dec     a
    ld      l, a
    ld      h, #0x00
;   ld      b, #0x02
    call    _GamePrintValue
    inc     de
    ld      l, PLAYER_CHARACTER_MAGIC(ix)
;   ld      h, #0x00
;   ld      b, #0x02
    call    _GamePrintValue
    inc     de
    ld      a, PLAYER_CHARACTER_LIFE(ix)
    or      a
    jr      z, 31$
    ld      l, PLAYER_CHARACTER_EXPERIENCE_L(ix)
    ld      h, PLAYER_CHARACTER_EXPERIENCE_H(ix)
    ld      b, #0x03
    call    _GamePrintValue
    jr      32$
31$:
    ld      hl, #playerPartyDeadString
    call    _GamePrintString
32$:
    pop     de
    pop     bc
    pop     hl
39$:
    inc     hl
    push    hl
    ld      hl, #0x0020
    add     hl, de
    ex      de, hl
    pop     hl
    djnz    30$

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 所持品を表示する
;
_PlayerPrintItem::

    ; レジスタの保存

    ; ウィンドウの描画
    ld      de, #(_patternName + 12 * 0x0020 + 0)
    ld      bc, #((4 << 8) | 10)
    call    _GamePrintFrame
    ld      hl, #playerItemString
    ld      de, #(_patternName + 13 * 0x0020 + 1)
    call    _GamePrintString

    ; 所持金の描画
    ld      hl, (_player + PLAYER_GOLD_L)
    ld      de, #(_patternName + 13 * 0x0020 + 5)
    ld      b, #4
    call    _GamePrintValue

    ; 薬の描画
    ld      a, (_player + PLAYER_POTION)
    ld      l, a
    ld      h, #0x00
    ld      de, #(_patternName + 14 * 0x0020 + 7)
    ld      b, #2
    call    _GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; プレイヤの初期値
;
playerDefault:

    .dw     0 ; PLAYER_GOLD_NULL
    .db     0 ; PLAYER_POTION_NULL

; キャラクタの初期値
;
playerCharacterDefault:

    ; ー
    .db     PLAYER_CLASS_NULL
    .db     PLAYER_LEVEL_NULL
    .db     PLAYER_LIFE_NULL
    .db     PLAYER_LIFE_NULL
    .db     PLAYER_MAGIC_NULL
    .db     PLAYER_MAGIC_NULL
    .dw     PLAYER_EXPERIENCE_NULL
    .db     PLAYER_SPELL_NULL
    .db     PLAYER_HEAL_NULL
    .dw     playerNameString + PLAYER_CHARACTER_NULL * PLAYER_NAME_LENGTH
    .db     0x00, 0x00, 0x00, 0x00
    ; 聖戦士
    .db     PLAYER_CLASS_LORD
    .db     1 ; PLAYER_LEVEL_NULL
    .db     4 ; PLAYER_LIFE_NULL
    .db     4 ; PLAYER_LIFE_NULL
    .db     1 ; PLAYER_MAGIC_NULL
    .db     1 ; PLAYER_MAGIC_NULL
    .dw     0 ; PLAYER_EXPERIENCE_NULL
    .db     PLAYER_SPELL_HEAL ; PLAYER_SPELL_NULL
    .db     4 ; PLAYER_HEAL_NULL
    .dw     playerNameString + PLAYER_CHARACTER_LORD * PLAYER_NAME_LENGTH
    .db     0x00, 0x00, 0x00, 0x00
    ; 戦士
    .db     PLAYER_CLASS_FIGHTER
    .db     1 ; PLAYER_LEVEL_NULL
    .db     5 ; PLAYER_LIFE_NULL
    .db     5 ; PLAYER_LIFE_NULL
    .db     0 ; PLAYER_MAGIC_NULL
    .db     0 ; PLAYER_MAGIC_NULL
    .dw     0 ; PLAYER_EXPERIENCE_NULL
    .db     PLAYER_SPELL_NULL
    .db     PLAYER_HEAL_NULL
    .dw     playerNameString + PLAYER_CHARACTER_FIGHTER * PLAYER_NAME_LENGTH
    .db     0x00, 0x00, 0x00, 0x00
    ; 神官
    .db     PLAYER_CLASS_PRIEST
    .db     1 ; PLAYER_LEVEL_NULL
    .db     3 ; PLAYER_LIFE_NULL
    .db     3 ; PLAYER_LIFE_NULL
    .db     2 ; PLAYER_MAGIC_NULL
    .db     2 ; PLAYER_MAGIC_NULL
    .dw     0 ; PLAYER_EXPERIENCE_NULL
    .db     PLAYER_SPELL_HEAL ; PLAYER_SPELL_NULL
    .db     5 ; PLAYER_HEAL_NULL
    .dw     playerNameString + PLAYER_CHARACTER_PRIEST * PLAYER_NAME_LENGTH
    .db     0x00, 0x00, 0x00, 0x00
    ; 盗賊
    .db     PLAYER_CLASS_THIEF
    .db     1 ; PLAYER_LEVEL_NULL
    .db     3 ; PLAYER_LIFE_NULL
    .db     3 ; PLAYER_LIFE_NULL
    .db     0 ; PLAYER_MAGIC_NULL
    .db     0 ; PLAYER_MAGIC_NULL
    .dw     0 ; PLAYER_EXPERIENCE_NULL
    .db     PLAYER_SPELL_NULL
    .db     PLAYER_HEAL_NULL
    .dw     playerNameString + PLAYER_CHARACTER_THIEF * PLAYER_NAME_LENGTH
    .db     0x00, 0x00, 0x00, 0x00
    ; 魔法使い
    .db     PLAYER_CLASS_MAGE
    .db     1 ; PLAYER_LEVEL_NULL
    .db     2 ; PLAYER_LIFE_NULL
    .db     2 ; PLAYER_LIFE_NULL
    .db     2 ; PLAYER_MAGIC_NULL
    .db     2 ; PLAYER_MAGIC_NULL
    .dw     0 ; PLAYER_EXPERIENCE_NULL
    .db     PLAYER_SPELL_FIREBALL ; PLAYER_SPELL_NULL
    .db     PLAYER_HEAL_NULL
    .dw     playerNameString + PLAYER_CHARACTER_MAGE * PLAYER_NAME_LENGTH
    .db     0x00, 0x00, 0x00, 0x00

; クラス
;
playerClassNameString:

    .db     ____, ____, ____, 0x00
    .db     ___L, ___O, ___R, 0x00
    .db     ___F, ___I, ___G, 0x00
    .db     ___P, ___R, ___I, 0x00
    .db     ___T, ___H, ___I, 0x00
    .db     ___M, ___A, ___G, 0x00

; 名前
;
playerNameString:

    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     _K_A, _KRE, _Ktu, _KKU, _KSU, 0x00
    .db     _KSA, _KMI, _Kyu, _K_E, _KRU, 0x00
    .db     _KSE, _KRI, _KSU, 0x00, 0x00, 0x00
    .db     _KRI, _K_I, _KKU, 0x00, 0x00, 0x00
    .db     _KRA, _KRU, _KHU, 0x00, 0x00, 0x00

; パーティ
;
playerPartyHeadString:

    .db     ___N, ___A, ___M, ___E, ____, ____, ____, ____, ____, ___C, ___L, ___S, ____, ___L, ___V, ____, ___H, ___P, ____, ____, ____, ____, ___M, ___P, ____, ___X, ___P, 0x00

playerPartyLifeString:

    .db     _SLA, 0x00

playerPartyDeadString:

    .db     ___D, ___E, ___A, ___D, 0x00

; 所持品
;
playerItemString:

    .db     _H_O, _HKA, _HNE, __LF
    .db     _HKU, _HSU, _HRI, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; プレイヤ
;
_player::
    
    .ds     PLAYER_LENGTH

; キャラクタ
;
_playerCharacter::

    .ds     PLAYER_CHARACTER_LENGTH * PLAYER_CHARACTER_ENTRY

; パーティ
;
_playerParty::

    .ds     PLAYER_PARTY_LENGTH

