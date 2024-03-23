; Battle.s : 戦闘
;


; モジュール宣言
;
    .module Battle

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include    "Player.inc"
    .include    "Enemy.inc"
    .include    "Dice.inc"
    .include    "Menu.inc"
    .include	"Battle.inc"

; 外部変数宣言
;
    .globl  _spriteTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 戦闘を初期化する
;
_BattleInitialize::
    
    ; レジスタの保存
    
    ; 戦闘の初期化
    ld      hl, #(_battle + 0x0000)
    ld      de, #(_battle + 0x0001)
    ld      bc, #(BATTLE_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 戦闘を更新する
;
_BattleUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_battle + BATTLE_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 戦闘を描画する
;
_BattleRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 戦闘を読み込む
;
_BattleLoad::

    ; レジスタの保存

    ; a < エネミーのグループ

    ; グループの保存
    push    af

    ; パターンネームの転送
    ld      hl, #(APP_PATTERN_NAME_TABLE + 0x0100)
    ld      a, #____
    ld      bc, #0x0100
    call    FILVRM

    ; スプライトジェネレータの転送
    ld      hl, #(_spriteTable + 0x0800)
    ld      de, #(APP_SPRITE_GENERATOR_TABLE + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM

    ; 戦闘の設定
    ld      hl, #(_battle + 0x0000)
    ld      de, #(_battle + 0x0001)
    ld      bc, #(BATTLE_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir

    ; パーティの人数の取得
    call    _PlayerGetPartyNumber
    ld      (_battle + BATTLE_PARTY), a

    ; 最初の順番の取得
    ld      hl, #(_battle + BATTLE_ORDER)
    ld      c, a
10$:
    ld      a, (hl)
    call    _PlayerGetPartyCharacter
    call    _PlayerIsCharacterLive
    jr      c, 19$
    ld      a, (hl)
    inc     a
    ld      (hl), a
    cp      c
    jr      c, 10$
    ld      (hl), #0x00
    jr      10$
19$:

    ; グループの復帰
    pop     af

    ; エネミーの読み込み
    call    _EnemyLoad

    ; 処理の設定
    ld      hl, #BattleEncount
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
BattleNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; エネミーと遭遇する
;
BattleEncount:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; 戦闘の表示
    call    BattlePrintScreen

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; エネミーのアニメーション
    call    _EnemyAnimate
    jr      nc, 19$

    ; 処理の更新
    ld      hl, #BattleMenu
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; メニューを選択する
;
BattleMenu:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; チートのクリア
    xor     a
    ld      (_battle + BATTLE_CHEAT), a

    ; メニューの読み込み
    ld      de, #((7 << 8) | 1)
    ld      bc, #((8 << 8) | 3)
    ld      a, (_battle + BATTLE_MENU)
    call    _MenuLoad

    ; メニューの表示
    call    BattlePrintMenu

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_battle + BATTLE_STATE)
    dec     a
    jp      nz, 20$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jp      c, 90$

    ; メニューの決定
    call    _MenuIsSelect
    jr      c, 100$

    ; チート
    call    _DiceIsCheat
    jp      nc, 99$
    ld      (_battle + BATTLE_CHEAT), a
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    jr      111$

    ; メニューの取得
100$:
    call    _MenuGetItem
    ld      (_battle + BATTLE_MENU), a

    ; 攻撃
110$:
    cp      #BATTLE_MENU_ATTACK
    jr      nz, 120$
111$:
    ld      hl, #BattleAttack
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      99$

    ; 呪文
120$:
    cp      #BATTLE_MENU_SPELL
    jr      nz, 130$
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    ld      c, a
    call    _PlayerGetCharacterSpell
    ld      b, a
    or      a
    jr      nz, 121$
    call    BattlePrintMenuError_0
    jr      190$
121$:
    ld      a, c
    call    _PlayerGetCharacterMagic
    or      a
    jr      nz, 122$
    call    BattlePrintMenuError_1
    jr      190$
122$:
    ld      a, b
    cp      #PLAYER_SPELL_HEAL
    jr      nz, 123$
    ld      hl, #BattleHeal
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      99$

123$:
;   cp      #PLAYER_SPELL_FIREBALL
;   jr      nz, 124$
    ld      hl, #BattleFireball
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      99$

    ; 薬
130$:
;   cp      #BATTLE_MENU_POTION
;   jr      nz, 140$
    call    _PlayerGetPotion
    or      a
    jr      nz, 131$
    call    BattlePrintMenuError_2
    jr      190$
131$:
    ld      hl, #BattlePotion
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      99$

    ; エラーメッセージ
190$:
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      99$

    ; 0x02 : エラー
20$:
;   dec     a
;   jr      nz, 30$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 99$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      99$

    ; メニューの完了
90$:
    xor     a
    ld      (_battle + BATTLE_STATE), a
99$:

    ; レジスタの復帰

    ; 終了
    ret

; 攻撃する
;
BattleAttack:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; ダイスの読み込み
    ld      de, #((DICE_TYPE_BATTLE << 8) | 0x01)
    call    _DiceLoad
    ld      a, (_battle + BATTLE_CHEAT)
    call    _DiceCheat

    ; 対象の取得
    xor     a
    call    _EnemyGetTarget
    ld      (_battle + BATTLE_TARGET), a

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : ダイスを振る
10$:
    ld      a, (_battle + BATTLE_STATE)
    dec     a
    jp      nz, 20$

    ; ダイスの更新
    call    _DiceUpdate
    call    _DiceRender

    ; ダイスの取得
    xor     a
    call    _DiceGetFace
    or      a
    jp      z, 90$
    ld      (_battle + BATTLE_ATTACK), a

    ; 1 : エネミーに 1 のダメージ
110$:
    dec     a
    jr      nz, 120$
111$:
    ld      a, #1
    ld      (_battle + BATTLE_VALUE), a
    ld      d, a
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyTakeTargetDamage
    call    BattlePrintAttackResultPtoE
    jp      190$

    ; 2 : エネミーに 2 のダメージ
120$:
    dec     a
    jr      nz, 130$
    ld      a, #2
    ld      (_battle + BATTLE_VALUE), a
    ld      d, a
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyTakeTargetDamage
    call    BattlePrintAttackResultPtoE
    jp      190$

    ; 3 : エネミーに 3 のダメージ
130$:
    dec     a
    jr      nz, 140$
    ld      a, #3
    ld      (_battle + BATTLE_VALUE), a
    ld      d, a
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyTakeTargetDamage
    call    BattlePrintAttackResultPtoE
    jr      190$

    ; 4 : プレイヤ、エネミー共に 1 のダメージ
140$:
    dec     a
    jr      nz, 150$
    call    180$
    jr      c, 111$
    ld      a, #1
    ld      (_battle + BATTLE_VALUE), a
    ld      d, a
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyTakeTargetDamage
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerTakeCharacterDamage
    call    BattlePrintAttackResultEach
    jr      190$

    ; 5 : プレイヤに 1 のダメージ
150$:
    dec     a
    jr      nz, 160$
    call    180$
    ld      a, #0x01
    sbc     #0x00
    ld      (_battle + BATTLE_VALUE), a
    ld      d, a
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerTakeCharacterDamage
    call    BattlePrintAttackResultEtoP
    jr      190$

    ; 6 : プレイヤに 2 のダメージ
160$:
;   dec     a
;   jr      nz, 170$
    call    180$
    ld      a, #0x02
    sbc     #0x00
    ld      (_battle + BATTLE_VALUE), a
    ld      d, a
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerTakeCharacterDamage
    call    BattlePrintAttackResultEtoP
    jr      190$

    ; 神官と幽霊の判定
180$:
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetType
    cp      #ENEMY_TYPE_GHOST
    jr      nz, 181$
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterClass
    cp      #PLAYER_CLASS_PRIEST
    jr      nz, 181$
    scf
    jr  189$
181$:
    or      a
189$:
    ret

    ; 状態の更新
190$:
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 結果
20$:
;   dec     a
;   jr      nz, 30$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 次へ
    ld      hl, #BattleTurn
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      90$

    ; 攻撃の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 治癒を唱える
;
BattleHeal:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; フラグのクリア
    ld      hl, #(_battle + BATTLE_FLAG)
    res     #BATTLE_FLAG_ERROR_BIT, (hl)

    ; メニューの読み込み
    ld      de, #((18 << 8) | 1)
    ld      b, #0x00
    ld      a, (_battle + BATTLE_PARTY)
    ld      c, a
    xor     a
    call    _MenuLoad

    ; 治癒の表示
    call    BattlePrintHealTarget

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : 対象
10$:
    ld      a, (_battle + BATTLE_STATE)
    dec     a
    jr      nz, 20$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jr      c, 80$

    ; メニューの決定
    call    _MenuIsSelect
    jr      nc, 90$

    ; 対象の取得
    call    _MenuGetItem
    call    _PlayerGetPartyCharacter
    ld      (_battle + BATTLE_TARGET), a

    ; 死んでいる
    ld      a, (_battle + BATTLE_TARGET)
    call    _PlayerIsCharacterLive
    jr      c, 11$
    call    BattlePrintHealError
    ld      hl, #(_battle + BATTLE_FLAG)
    set     #BATTLE_FLAG_ERROR_BIT, (hl)
    jr      19$

    ; 治癒を唱える
11$:
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    ld      b, a
    ld      c, #1
    call    _PlayerCastCharacter
    ld      a, b
    call    _PlayerGetCharacterHeal
    ld      (_battle + BATTLE_VALUE), a
    ld      c, a
    ld      a, (_battle + BATTLE_TARGET)
    call    _PlayerHealCharacter
    call    BattlePrintHealResult

    ; 状態の更新
19$:
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 結果
20$:
;   dec     a
;   jr      nz, 30$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; エラー
    ld      a, (_battle + BATTLE_FLAG)
    bit     #BATTLE_FLAG_ERROR_BIT, a
    jr      nz, 80$

    ; 次へ
    ld      hl, #BattleTurn
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      90$

    ; 戻る
80$:
    ld      hl, #BattleMenu
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
;   jr      90$

    ; 治癒の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 火球を唱える
;
BattleFireball:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; 対象の設定
    xor     a
    ld      (_battle + BATTLE_TARGET), a

    ; 魔力の設定
    ld      a, #0x01
    ld      (_battle + BATTLE_MAGIC_COST), a
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterMagic
    ld      (_battle + BATTLE_MAGIC_MAXIMUM), a

    ; メニューの読み込み
    ld      de, #((7 << 8) | 1)
    ld      bc, #((0 << 8) | 1)
    xor     a
    call    _MenuLoad

    ; 火球の表示
    call    BattlePrintFireballMagic
    
    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : 消費魔力
10$:
    ld      a, (_battle + BATTLE_STATE)
    dec     a
    jr      nz, 20$

    ; 魔力の増減
    ld      hl, #(_battle + BATTLE_MAGIC_COST)
    ld      a, (_input + INPUT_KEY_LEFT)
    dec     a
    jr      nz, 11$
    ld      a, (hl)
    cp      #(1 + 1)
    jr      c, 12$
    dec     (hl)
    jr      12$
11$:
    ld      a, (_input + INPUT_KEY_RIGHT)
    dec     a
    jr      nz, 12$
    ld      a, (_battle + BATTLE_MAGIC_MAXIMUM)
    ld      c, a
    ld      a, (hl)
    cp      c
    jr      nc, 12$
    inc     (hl)
12$:
    call    BattlePrintFireballPoint

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jr      c, 80$

    ; メニューの決定
    call    _MenuIsSelect
    jr      nc, 90$

    ; 火球を唱える
    ld      a, (_battle + BATTLE_MAGIC_COST)
    ld      c, a
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerCastCharacter
    xor     a
    call    _EnemyGetTarget
    ld      (_battle + BATTLE_TARGET), a
    ld      a, c
    add     a, a
    ld      (_battle + BATTLE_VALUE), a

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : ダメージ
20$:
    dec     a
    jr      nz, 30$

    ; ダメージを与える
    ld      a, (_battle + BATTLE_VALUE)
    ld      d, a
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyTakeTargetDamage
    call    BattlePrintFireballResult

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$
    
    ; 0x03 : 結果
30$:
;   dec     a
;   jr      nz, 40$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 次の対象の取得
    ld      a, (_battle + BATTLE_TARGET)
    inc     a
    call    _EnemyGetTarget
    jr      nc, 39$
    ld      (_battle + BATTLE_TARGET), a

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    dec     (hl)
    jr      90$

    ; 次へ
39$:
    ld      hl, #BattleTurn
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      90$

    ; 戻る
80$:
    ld      hl, #BattleMenu
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
;   jr      90$

    ; 火球の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 薬を使う
;
BattlePotion:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; フラグのクリア
    ld      hl, #(_battle + BATTLE_FLAG)
    res     #BATTLE_FLAG_ERROR_BIT, (hl)

    ; メニューの読み込み
    ld      de, #((18 << 8) | 1)
    ld      b, #0x00
    ld      a, (_battle + BATTLE_PARTY)
    ld      c, a
    xor     a
    call    _MenuLoad

    ; 薬の表示
    call    BattlePrintPotionTarget

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : 対象
10$:
    ld      a, (_battle + BATTLE_STATE)
    dec     a
    jr      nz, 20$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jr      c, 80$

    ; メニューの決定
    call    _MenuIsSelect
    jr      nc, 90$

    ; 対象の取得
    call    _MenuGetItem
    call    _PlayerGetPartyCharacter
    ld      (_battle + BATTLE_TARGET), a

    ; 死んでいる
    ld      a, (_battle + BATTLE_TARGET)
    call    _PlayerIsCharacterLive
    jr      c, 11$
    call    BattlePrintPotionError
    ld      hl, #(_battle + BATTLE_FLAG)
    set     #BATTLE_FLAG_ERROR_BIT, (hl)
    jr      19$

    ; 薬を使う
11$:
    call    _PlayerUsePotion
    ld      c, #PLAYER_HEAL_POTION
    ld      a, (_battle + BATTLE_TARGET)
    call    _PlayerHealCharacter
    call    BattlePrintPotionResult

    ; 状態の更新
19$:
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 結果
20$:
;   dec     a
;   jr      nz, 30$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; エラー
    ld      a, (_battle + BATTLE_FLAG)
    bit     #BATTLE_FLAG_ERROR_BIT, a
    jr      nz, 80$

    ; 次へ
    ld      hl, #BattleTurn
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      90$

    ; 戻る
80$:
    ld      hl, #BattleMenu
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
;   jr      90$

    ; 薬の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; １ターンを終了する
;
BattleTurn:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; 戦闘の表示
    call    BattlePrintScreen

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; エネミーのアニメーション
    call    _EnemyAnimate
    jr      nc, 90$

    ; プレイヤの全滅
    call    _PlayerIsPartyLive
    ld      hl, #BattleDead
    jr      nc, 19$

    ; エネミーの全滅
    call    _EnemyIsGroupLive
    ld      hl, #BattleEnd
    jr      nc, 19$

    ; 次の順番
    ld      a, (_battle + BATTLE_PARTY)
    ld      c, a
10$:
    ld      a, (_battle + BATTLE_ORDER)
    inc     a
    cp      c
    jr      c, 11$
    xor     a
11$:
    ld      (_battle + BATTLE_ORDER), a
    call    _PlayerGetPartyCharacter
    call    _PlayerIsCharacterLive
    jr      nc, 10$

    ; メニューのクリア
    xor     a
    ld      (_battle + BATTLE_MENU), a
    ld      hl, #BattleMenu
;   jr      19$

    ; 処理の更新
19$:
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
    jr      90$

    ; ターンの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤが全滅した
;
BattleDead:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; 全滅の表示
    call    BattlePrintDead

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 完了の設定
    ld      a, #BATTLE_DONE_DEAD
    ld      (_battle + BATTLE_DONE), a

    ; 処理の更新
    ld      hl, #BattleNull
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 戦闘が終了した
;
BattleEnd:

    ; レジスタの保存

    ; 初期化
    ld      a, (_battle + BATTLE_STATE)
    or      a
    jr      nz, 09$

    ; チートのクリア
    xor     a
    ld      (_battle + BATTLE_CHEAT), a

    ; 戦闘終了の表示
    call    BattlePrintEnd

    ; 初期化の完了
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : 戦闘の終了
10$:
    ld      a, (_battle + BATTLE_STATE)
    dec     a
    jr      nz, 20$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 順番の設定
    ld      a, #-1
    ld      (_battle + BATTLE_ORDER), a

    ; 経験値の取得
    call    _EnemyGetGroupExperience
    ld      (_battle + BATTLE_VALUE), a

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
19$:
    jp      90$

    ; 0x02 : 経験値の獲得
20$:
    dec     a
    jr      nz, 30$

    ; 生存者の取得
    ld      a, (_battle + BATTLE_PARTY)
    ld      c, a
21$:
    ld      a, (_battle + BATTLE_ORDER)
    inc     a
    ld      (_battle + BATTLE_ORDER), a
    cp      c
    jr      nc, 22$
    call    _PlayerGetPartyCharacter
    call    _PlayerIsCharacterLive
    jr      nc, 21$
    jr      23$
22$:
    ld      a, #0x04
    ld      (_battle + BATTLE_STATE), a
    jp      90$

    ; 経験値の獲得
23$:
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    ld      d, a
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #battleEndExperienceString_0
    call    _GameConcatString
    ld      a, (_battle + BATTLE_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleEndExperienceString_1
    call    _GameConcatString
    ld      a, (_battle + BATTLE_VALUE)
    ld      c, a
    ld      a, d
    call    _PlayerAddCharacterExperience
    jr      nc, 24$
    ld      a, d
    call    _PlayerGetCharacterName
    call    _GameConcatString
    ld      hl, #battleEndExperienceString_2
    call    _GameConcatString
24$:
    call    BattlePrintEndExperience

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jp      90$

    ; 0x03 : 経験値の獲得待ち
30$:
    dec     a
    jr      nz, 40$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      z, 31$

    ; チート
    call    _DiceIsCheat
    jp      nc, 90$
    ld      (_battle + BATTLE_CHEAT), a

    ; 状態の更新
31$:
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    ld      hl, #(_battle + BATTLE_STATE)
    dec     (hl)
    jp      90$

    ; 0x04 : 財宝の設定
40$:
    dec     a
    jr      nz, 50$

    ; スプライトジェネレータの転送
    ld      hl, #(_spriteTable + 0x0c00)
    ld      de, #(APP_SPRITE_GENERATOR_TABLE + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM

    ; ダイスの読み込み
    call    _EnemyGetGroupNumber
    ld      (_battle + BATTLE_VALUE), a
    ld      d, #DICE_TYPE_TREASURE
    ld      e, a
    call    _DiceLoad
    ld      a, (_battle + BATTLE_CHEAT)
    call    _DiceCheat

    ; メッセージのクリア
    call    BattlePrintFrame

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x05 : ダイスを振る
50$:
    dec     a
    jr      nz, 60$

    ; ダイスの更新
    call    _DiceUpdate
    call    _DiceRender

    ; ダイスの取得
    ld      a, (_battle + BATTLE_VALUE)
    ld      b, a
    dec     a
    call    _DiceGetFace
    or      a
    jr      z, 90$

    ; 財宝の取得
    ld      de, #0x0000
    ld      c, #0x00
51$:
    ld      a, c
    call    _DiceGetFace
    push    de
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #battleTreasure
    add     hl, de
    pop     de
    ld      a, (hl)
    add     a, d
    ld      d, a
    inc     hl
    ld      a, (hl)
    add     a, e
    ld      e, a
    inc     c
    djnz    51$
    ld      a, d
    ld      (_battle + BATTLE_TREASURE_GOLD), a
    ld      l, d
    ld      h, #0x00
    call    _PlayerAddGold
    ld      a, e
    ld      (_battle + BATTLE_TREASURE_POTION), a
    call    _PlayerAddPotion
    
    ; 財宝の表示
    call    BattlePrintEndTreasure

    ; 状態の更新
    ld      hl, #(_battle + BATTLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x06 : 財宝の獲得
60$:
;   dec     a
;   jr      nz, 70$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$

    ; 完了の設定
    ld      a, #BATTLE_DONE_END
    ld      (_battle + BATTLE_DONE), a

    ; 処理の更新
    ld      hl, #BattleNull
    ld      (_battle + BATTLE_PROC_L), hl
    xor     a
    ld      (_battle + BATTLE_STATE), a
;   jr      90$

    ; 戦闘終了の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 戦闘が完了したかどうかを判定する
;
_BattleIsDead::

    ; レジスタの保存

    ; cf > 戦闘が終了した

    ; 完了の判定
    ld      a, (_battle + BATTLE_DONE)
    cp      #BATTLE_DONE_DEAD
    jr      nz, 10$
    scf
    jr      19$
10$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

_BattleIsEnd::

    ; レジスタの保存

    ; cf > 戦闘が終了した

    ; 完了の判定
    ld      a, (_battle + BATTLE_DONE)
    cp      #BATTLE_DONE_END
    jr      nz, 10$
    scf
    jr      19$
10$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 戦闘画面を表示する
;
BattlePrintScreen:

    ; レジスタの保存

    ; 画面のクリア
    ld      a, #____
    call    _SystemClearPatternName

    ; パーティの表示
    call    _PlayerPrintParty

    ; グループの表示
    call    _EnemyPrintGroup

    ; メッセージの表示
    call    BattlePrintFrame

    ; レジスタの復帰

    ; 終了
    ret

; メニューを表示する
;
BattlePrintMenu:

    ; レジスタの保存

    ; 画面のクリア
    ld      a, #____
    call    _SystemClearPatternName

    ; パーティの表示
    call    _PlayerPrintParty

    ; グループの表示
    call    _EnemyPrintGroup

    ; メニューの表示
    call    BattlePrintFrame
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #battleMenuString_0
    call    _GameConcatString
    call    _PlayerGetPotion
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleMenuString_1
    call    _GameConcatString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString

    ; エネミーの表示
    call    _EnemyAnimate

    ; レジスタの復帰

    ; 終了
    ret

BattlePrintMenuError_0:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #battleMenuErrorString_0
    ld      d, #5
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintMenuError_1:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #battleMenuErrorString_1
    ld      d, #5
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintMenuError_2:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #battleMenuErrorString_2
    ld      d, #5
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 攻撃を表示する
;
BattlePrintAttackResultPtoE:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #battleAttackResultString_0
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetName
    call    _GameConcatString
    ld      hl, #battleAttackResultString_1
    call    _GameConcatString
    ld      a, (_battle + BATTLE_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleAttackResultString_3
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyIsTargetLive
    jr      c, 10$
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetName
    call    _GameConcatString
    ld      hl, #battleAttackResultString_4
    call    _GameConcatString
10$:
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintAttackResultEtoP:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetName
    call    _GameConcatString
    ld      hl, #battleAttackResultString_0
    call    _GameConcatString
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName    
    call    _GameSetString
    ld      hl, #battleAttackResultString_1
    call    _GameConcatString
    ld      a, (_battle + BATTLE_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleAttackResultString_3
    call    _GameConcatString
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerIsCharacterLive
    jr      c, 10$
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName    
    call    _GameConcatString
    ld      hl, #battleAttackResultString_4
    call    _GameConcatString
10$:
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintAttackResultEach:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      hl, #battleAttackResultString_2
    call    _GameSetString
    ld      a, (_battle + BATTLE_TARGET)
    ld      a, (_battle + BATTLE_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleAttackResultString_3
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyIsTargetLive
    jr      c, 10$
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetName
    call    _GameConcatString
    ld      hl, #battleAttackResultString_4
    call    _GameConcatString
10$:
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerIsCharacterLive
    jr      c, 11$
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName    
    call    _GameConcatString
    ld      hl, #battleAttackResultString_4
    call    _GameConcatString
11$:
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

; 治癒を表示する
;
BattlePrintHealTarget:

    ; レジスタの保存

    ; メッセージの表示
    call    BattlePrintFrame
    ld      hl, #battleHealTargetString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintHealResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #battleHealResultString_0
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TARGET)
    call    _PlayerGetCharacterName
    call    _GameConcatString
    ld      hl, #battleHealResultString_1
    call    _GameConcatString
    ld      a, (_battle + BATTLE_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleHealResultString_2
    call    _GameConcatString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintHealError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #battleHealErrorString
    ld      d, #5
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 火球を表示する
;
BattlePrintFireballMagic:

    ; レジスタの保存

    ; メッセージの表示
    call    BattlePrintFrame
    ld      hl, #battleFireballMagicString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintFireballPoint:

    ; レジスタの保存

    ; メッセージの表示
    ld      a, (_battle + BATTLE_MAGIC_COST)
    ld      l, a
    ld      h, #0x00
    ld      de, #(_patternName + 7 * 0x0020 + 2)
    ld      b, #0x02
    call    _GamePrintValue
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintFireballResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      a, (_battle + BATTLE_ORDER)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #battleFireballResultString_0
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetName
    call    _GameConcatString
    ld      hl, #battleFireballResultString_1
    call    _GameConcatString
    ld      a, (_battle + BATTLE_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleFireballResultString_2
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyIsTargetLive
    jr      c, 10$
    ld      a, (_battle + BATTLE_TARGET)
    call    _EnemyGetTargetName
    call    _GameConcatString
    ld      hl, #battleFireballResultString_3
    call    _GameConcatString
10$:
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

; 薬を表示する
;
BattlePrintPotionTarget:

    ; レジスタの保存

    ; メッセージの表示
    call    BattlePrintFrame
    ld      hl, #battlePotionTargetString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintPotionResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      a, (_battle + BATTLE_TARGET)
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #battlePotionResultString
    call    _GameConcatString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintPotionError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #battlePotionErrorString
    ld      d, #5
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 全滅を表示する
;
BattlePrintDead:

    ; レジスタの保存

    ; メッセージの表示
    call    BattlePrintFrame
    ld      hl, #battleDeadString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

; 戦闘終了を表示する
;
BattlePrintEnd:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    ld      hl, #battleEndString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintEndExperience:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; メッセージの表示
    call    BattlePrintFrame
    call    _GameGetString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

BattlePrintEndTreasure:

    ; レジスタの保存

    ; メッセージの表示    
    call    BattlePrintFrame
    call    _GameClearString
    ld      a, (_battle + BATTLE_TREASURE_GOLD)
    or      a
    jr      z, 10$
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleEndTreasureString_0
    call    _GameConcatString
    ld      a, (_battle + BATTLE_TREASURE_POTION)
    or      a
    jr      z, 11$
    ld      hl, #battleEndTreasureString_1
    call    _GameConcatString
10$:
    ld      a, (_battle + BATTLE_TREASURE_POTION)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #battleEndTreasureString_2
    call    _GameConcatString
11$:
    ld      hl, #battleEndTreasureString_3
    call    _GameConcatString
    ld      de, #(_patternName + 5 * 0x0020 + 1)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

; 戦闘のメッセージ枠を表示する
;
BattlePrintFrame:

    ; レジスタの保存

    ; 枠の表示
    ld      de, #(_patternName + 4 * 0x0020 + 0)
    ld      bc, #((5 << 8) | 32)
    call    _GamePrintFrame

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; メニュー
;
battleMenuString_0:

    .db     _HHA, ____, _HTO, _KSN, _H_U, _HSI, _HMA, _HSU, _HKA, _QUE, __LF
    .db     __LF
    .db     ____, _HKO, _H_U, _HKE, _KSN, _HKI, ____, ____, ____, _HSI, _KSN, _Hyu, _HMO, _H_N, ____, ____, ____, _HKU, _HSU, _HRI, _LRB, 0x00

battleMenuString_1:

    .db     _RRB, 0x00

battleMenuErrorString_0:

    .db     _HTO, _HNA, _H_E, _HRA, _HRE, _HNA, _H_I, 0x00

battleMenuErrorString_1:

    .db     ___M, ___P, _HKA, _KSN, ____, _HTA, _HRI, _HNA, _H_I, 0x00

battleMenuErrorString_2:

    .db     _HKU, _HSU, _HRI, _HKA, _KSN, ____, _HNA, _H_I, 0x00

; 攻撃
;
battleAttackResultString_0:

    .db     _HNO, _HKO, _H_U, _HKE, _KSN, _HKI, _HKA, _KSN, ____, _KHI, _Ktu, _KTO, _HSI, _HTA, __LF, 0x00
    
battleAttackResultString_1:

    .db     _HNI, ____, 0x00

battleAttackResultString_2:

    .db     _HTA, _HKA, _KSN, _H_I, _HNO, _HKO, _H_U, _HKE, _KSN, _HKI, _HKA, _KSN, _KHI, _Ktu, _KTO, _HSI, ____, 0x00

battleAttackResultString_3:

    .db     ____, _HNO, _KTA, _KSN, _KME, _MNS, _KSI, _KSN, __LF, 0x00

battleAttackResultString_4:

    .db     _HHA, ____, _HSI, _H_N, _HTA, _KSN, __LF, 0x00

; 治癒
;
battleHealTargetString:

    .db     _HTA, _KSN, _HRE, _HNI, _HTI, _HYU, _HWO, ____, _HTO, _HNA, _H_E, _HMA, _HSU, _HKA, _QUE, 0x00

battleHealResultString_0:

    .db     _HHA, _HTI, _HYU, _HWO, ____, _HTO, _HNA, _H_E, _HTA, __LF, 0x00
    
battleHealResultString_1:

    .db     _HNO, ___H, ___P, _HKA, _KSN, ____, 0x00
    
battleHealResultString_2:

    .db     ____, _HKA, _H_I, _HHU, _HKU, _HSI, _HTA, 0x00

battleHealErrorString:

    .db     _HSI, _H_N, _HTE, _KSN, _H_I, _HRU, 0x00

; 火球
;
battleFireballMagicString:

    .db     _HKA, _HKI, _Hyu, _H_U, _HTE, _KSN, _HSI, _Hyo, _H_U, _HHI, _HSU, _HRU, ___M, ___P, _HWO, ____, _HKI, _HME, _HTE, _HKU, _HTA, _KSN, _HSA, _H_I, __LF
    .db     __LF
    .db     ____, ____, ____, ___M, ___P, 0x00

battleFireballResultString_0:

    .db     _HHA, _HKA, _HKI, _Hyu, _H_U, _HWO, ____, _HTO, _HNA, _H_E, _HTA, __LF, 0x00
    
battleFireballResultString_1:

    .db     _HNI, ____, 0x00

battleFireballResultString_2:

    .db     ____, _HNO, _KTA, _KSN, _KME, _MNS, _KSI, _KSN, __LF, 0x00
    
battleFireballResultString_3:

    .db     _HHA, ____, _HSI, _H_N, _HTA, _KSN, 0x00
    
; 薬
;
battlePotionTargetString:

    .db     _HTA, _KSN, _HRE, _HNI, _HKU, _HSU, _HRI, _HWO, ____, _HTU, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

battlePotionResultString:

    .db     _HNO, ___H, ___P, _HKA, _KSN, ____, _HSE, _KSN, _H_N, _HKA, _H_I, _HSI, _HTA, 0x00

battlePotionErrorString:

    .db     _HSI, _H_N, _HTE, _KSN, _H_I, _HRU, 0x00

; 全滅
;
battleDeadString:

    .db     _HSE, _KSN, _H_N, _H_I, _H_N, ____, _HKI, _KSN, _Hya, _HKU, _HSA, _HTU, _HSA, _HRE, _HTA, 0x00

; 戦闘終了
;
battleEndString:

    .db     _HTA, _HTA, _HKA, _H_I, _HNI, ____, _HSI, _Hyo, _H_U, _HRI, _HSI, _HTA, 0x00

battleEndExperienceString_0:

    .db     _HHA, ____, 0x00

battleEndExperienceString_1:

    .db     ____, ___X, ___P, _HWO, ____, _HKA, _HKU, _HTO, _HKU, _HSI, _HTA, __LF, 0x00

battleEndExperienceString_2:

    .db     _HHA, _KRE, _KHE, _KSN, _KRU, _HKA, _KSN, ____, _H_A, _HKA, _KSN, _Htu, _HTA, __LF, 0x00

battleEndTreasureString_0:

    .db     ____, ___G, ___P, 0x00

battleEndTreasureString_1:

    .db     _HTO, ____, 0x00

battleEndTreasureString_2:

    .db     ____, _HKO, _HNO, _HKU, _HSU, _HRI, 0x00
    
battleEndTreasureString_3:

    .db     _HWO, ____, _HTE, _HNI, _H_I, _HRE, _HTA, __LF, 0x00

; 財宝
;
battleTreasure:

    .db      0, 0
    .db      5, 0
    .db     10, 0
    .db     15, 0
    .db     20, 0
    .db     30, 0
    .db      0, 1


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 戦闘
;
_battle::

    .ds     BATTLE_LENGTH

