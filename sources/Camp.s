; Camp.s : キャンプ
;


; モジュール宣言
;
    .module Camp

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
    .include    "Menu.inc"
    .include	"Camp.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; キャンプを初期化する
;
_CampInitialize::
    
    ; レジスタの保存
    
    ; キャンプの初期化
    ld      hl, #(_camp + 0x0000)
    ld      de, #(_camp + 0x0001)
    ld      bc, #(CAMP_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir
    
    ; レジスタの復帰
    
    ; 終了
    ret

; キャンプを更新する
;
_CampUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_camp + CAMP_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; キャンプを描画する
;
_CampRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; キャンプを読み込む
;
_CampLoad::

    ; レジスタの保存

    ; a < 0/1 = 町／ダンジョン

    ; 場所の保存
    push    af

    ; キャンプの設定
    ld      hl, #(_camp + 0x0000)
    ld      de, #(_camp + 0x0001)
    ld      bc, #(CAMP_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir

    ; 項目の設定
    ld      a, #CAMP_ITEM_SPELL
    ld      (_camp + CAMP_ITEM_0), a
    ld      a, #CAMP_ITEM_POTION
    ld      (_camp + CAMP_ITEM_1), a

    ; 場所の復帰
    pop     af

    ; 場所別の項目の追加
    or      a
    jr      nz, 10$
    ld      a, #CAMP_ITEM_LOAD
    ld      (_camp + CAMP_ITEM_2), a
    ld      a, #CAMP_ITEM_SAVE
    ld      (_camp + CAMP_ITEM_3), a
    ld      a, #0x04
    ld      (_camp + CAMP_ITEM_SIZE), a
    jr      19$
10$:
    ld      a, #CAMP_ITEM_ORDER
    ld      (_camp + CAMP_ITEM_2), a
    ld      a, #0x03
    ld      (_camp + CAMP_ITEM_SIZE), a
;   jr      19$
19$:

    ; パーティの人数の取得
    call    _PlayerGetPartyNumber
    ld      (_camp + CAMP_PARTY), a

    ; 処理の設定
    ld      hl, #CampMenu
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
CampNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; メニューを選択する
;
CampMenu:

    ; レジスタの保存

    ; 初期化
    ld      a, (_camp + CAMP_STATE)
    or      a
    jr      nz, 09$

    ; メニューの読み込み
    ld      de, #((5 << 8) | 9)
    ld      b, #0
    ld      a, (_camp + CAMP_ITEM_SIZE)
    ld      c, a
    ld      a, (_camp + CAMP_MENU)
    call    _MenuLoad

    ; メニューの表示
    call    CampPrintMenu

    ; 初期化の完了
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_camp + CAMP_STATE)
    dec     a
    jr      nz, 20$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jp      c, 90$

    ; メニューの決定
    call    _MenuIsSelect
    jp      nc, 99$

    ; 項目の取得
    call    _MenuGetItem
    ld      (_camp + CAMP_MENU), a
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_camp + CAMP_ITEM_0)
    add     hl, de
    ld      a, (hl)

    ; 呪文
110$:
    cp      #CAMP_ITEM_SPELL
    jr      nz, 120$
    ld      hl, #CampSpell
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
    jr      99$

    ; 薬
120$:
    cp      #CAMP_ITEM_POTION
    jr      nz, 130$
    call    _PlayerGetPotion
    or      a
    jr      nz, 121$
    call    CampPrintMenuError
    jr      190$
121$:
    ld      hl, #CampPotion
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
    jr      99$

    ; 並べ替え
130$:
    cp      #CAMP_ITEM_ORDER
    jr      nz, 140$
    ld      hl, #CampOrder
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
    jr      99$

    ; 読み込み
140$:
    cp      #CAMP_ITEM_LOAD
    jr      nz, 150$
    ld      hl, #CampLoad
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
    jr      99$

    ; 保存
150$:
;   cp      #CAMP_ITEM_SAVE
;   jr      nz, 160$
    ld      hl, #CampSave
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
    jr      99$

    ; エラーメッセージ
190$:
    ld      hl, #(_camp + CAMP_STATE)
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
    ld      (_camp + CAMP_STATE), a
    jr      99$

    ; メニューの完了
90$:
    ld      hl, #(_camp + CAMP_FLAG)
    set     #CAMP_FLAG_DONE_BIT, (hl)
    ld      hl, #CampNull
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
99$:

    ; レジスタの復帰

    ; 終了
    ret

; 呪文を唱える
;
CampSpell:

    ; レジスタの保存

    ; 初期化
    ld      a, (_camp + CAMP_STATE)
    or      a
    jr      nz, 09$

    ; メニューの読み込み
    ld      de, #((18 << 8) | 1)
    ld      b, #0x00
    ld      a, (_camp + CAMP_PARTY)
    ld      c, a
    xor     a
    call    _MenuLoad

    ; 術者の表示
    call    CampPrintSpellCaster

    ; 初期化の完了
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
09$:

    ; 0x01 : 術者
10$:
    ld      a, (_camp + CAMP_STATE)
    dec     a
    jr      nz, 20$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jp      c, 80$

    ; メニューの決定
    call    _MenuIsSelect
    jp      nc, 90$

    ; 術者の取得
    call    _MenuGetItem
    call    _PlayerGetPartyCharacter
    ld      (_camp + CAMP_CASTER), a

    ; 死んでいる
    ld      a, (_camp + CAMP_CASTER)
    call    _PlayerIsCharacterLive
    jr      c, 11$
    call    CampPrintSpellError_0_0
    ld      a, #0x03
    ld      (_camp + CAMP_STATE), a
    jp      90$

    ; 呪文を唱えられない
11$:
    ld      a, (_camp + CAMP_CASTER)
    call    _PlayerGetCharacterSpell
    cp      #PLAYER_SPELL_HEAL
    jr      z, 12$
    call    CampPrintSpellError_1
    ld      a, #0x03
    ld      (_camp + CAMP_STATE), a
    jp      90$

    ; 呪文の準備
12$:
    ld      a, (_camp + CAMP_CASTER)
    call    _PlayerGetCharacterMagic
    or      a
    jr      nz, 13$
    call    CampPrintSpellError_2
    ld      a, #0x03
    ld      (_camp + CAMP_STATE), a
    jp      90$

    ; 呪文の準備
13$:
    ld      de, #((18 << 8) | 1)
    ld      b, #0x00
    ld      a, (_camp + CAMP_PARTY)
    ld      c, a
    xor     a
    call    _MenuLoad
    call    CampPrintSpellTarget

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 対象
20$:
    dec     a
    jr      nz, 30$

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
    ld      (_camp + CAMP_TARGET), a

    ; 死んでいる
    ld      a, (_camp + CAMP_TARGET)
    call    _PlayerIsCharacterLive
    jr      c, 21$
    call    CampPrintSpellError_0_1
    ld      a, #0x03
    ld      (_camp + CAMP_STATE), a
    jr      90$

    ; 呪文を唱える
21$:
    ld      a, (_camp + CAMP_CASTER)
    ld      c, #1
    call    _PlayerCastCharacter
    ld      a, (_camp + CAMP_CASTER)
    call    _PlayerGetCharacterHeal
    ld      (_camp + CAMP_VALUE), a
    ld      c, a
    ld      a, (_camp + CAMP_TARGET)
    call    _PlayerHealCharacter
    call    CampPrintSpellResult

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
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
;   jr      80$

    ; 戻る
80$:
    ld      hl, #CampMenu
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
;   jr      90$

    ; 呪文の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 薬を使う
;
CampPotion:

    ; レジスタの保存

    ; 初期化
    ld      a, (_camp + CAMP_STATE)
    or      a
    jr      nz, 09$

    ; メニューの読み込み
    ld      de, #((18 << 8) | 1)
    ld      b, #0x00
    ld      a, (_camp + CAMP_PARTY)
    ld      c, a
    xor     a
    call    _MenuLoad

    ; 薬の表示
    call    CampPrintPotionTarget

    ; 初期化の完了
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
09$:

    ; 0x01 : 対象
10$:
    ld      a, (_camp + CAMP_STATE)
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
    ld      (_camp + CAMP_TARGET), a

    ; 死んでいる
    ld      a, (_camp + CAMP_TARGET)
    call    _PlayerIsCharacterLive
    jr      c, 11$
    call    CampPrintPotionError
    jr      19$

    ; 薬を使う
11$:
    call    _PlayerUsePotion
    ld      c, #PLAYER_HEAL_POTION
    ld      a, (_camp + CAMP_TARGET)
    call    _PlayerHealCharacter
    call    CampPrintPotionResult

    ; 状態の更新
19$:
    ld      hl, #(_camp + CAMP_STATE)
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
;   jr      80$

    ; 戻る
80$:
    ld      hl, #CampMenu
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
;   jr      90$

    ; 薬の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 隊列を並べ替える
;
CampOrder:

    ; レジスタの保存

    ; 初期化
    ld      a, (_camp + CAMP_STATE)
    or      a
    jr      nz, 09$

    ; パーティの取得
    ld      hl, #(_camp + CAMP_PARTY_0)
    ld      de, #(_camp + CAMP_ORDER_0)
    ld      c, #0x00
    ld      a, (_camp + CAMP_PARTY)
    ld      b, a
00$:
    ld      a, c
    call    _PlayerGetPartyCharacter
    ld      (hl), a
    ld      (de), a
    inc     hl
    inc     de
    inc     c
    djnz    00$

    ; パーティのクリア
    call    _PlayerClearParty

    ; メニューの初期化
    xor     a
    ld      (_camp + CAMP_TARGET), a
    ld      (_camp + CAMP_VALUE), a

    ; 初期化の完了
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択の設定
10$:
    ld      a, (_camp + CAMP_STATE)
    dec     a
    jr      nz, 20$

    ; メニューの読み込み
    ld      de, #((8 << 8) | 12)
    ld      b, #0x00
    ld      a, (_camp + CAMP_PARTY)
    ld      c, a
    ld      a, (_camp + CAMP_TARGET)
    call    _MenuLoad

    ; 並べ替えの表示
    call    CampPrintOrder

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 選択
20$:
;   dec     a
;   jr      nz, 30$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender
    call    _MenuGetItem
    ld      (_camp + CAMP_TARGET), a

    ; メニューのキャンセル
210$:
    call    _MenuIsCancel
    jr      nc, 220$

    ; キャラクターを戻す
    ld      a, (_camp + CAMP_VALUE)
    or      a
    jr      z, 213$
    call    _PlayerRemoveParty
    ld      c, a
    ld      hl, #(_camp + CAMP_PARTY_0)
    ld      de, #(_camp + CAMP_ORDER_0)
    ld      a, (_camp + CAMP_PARTY)
    ld      b, a
    ld      a, c
211$:
    cp      (hl)
    jr      z, 212$
    inc     hl
    inc     de
    djnz    211$
212$:
    ld      (de), a
    ld      hl, #(_camp + CAMP_VALUE)
    dec     (hl)
    ld      hl, #(_camp + CAMP_STATE)
    dec     (hl)
    jr      90$

    ; すべてをキャンセル
213$:
    ld      hl, #(_camp + CAMP_PARTY_0)
    ld      a, (_camp + CAMP_PARTY)
    ld      b, a
214$:
    ld      a, (hl)
    call    _PlayerAddParty
    inc     hl
    djnz    214$
    jr      80$

    ; メニューの決定
220$:
    call    _MenuIsSelect
    jr      nc, 90$

    ; パーティに加える
    ld      a, (_camp + CAMP_TARGET)
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_camp + CAMP_ORDER_0)
    add     hl, de
    ld      a, (hl)
    or      a
    jr      z, 229$
    call    _PlayerAddParty
    ld      (hl), #PLAYER_CHARACTER_NULL
    ld      hl, #(_camp + CAMP_VALUE)
    inc     (hl)
    ld      a, (_camp + CAMP_PARTY)
    cp      (hl)
    jr      z, 80$

    ; 状態の更新
229$:
    ld      hl, #(_camp + CAMP_STATE)
    dec     (hl)
    jr      90$

    ; 戻る
80$:
    ld      hl, #CampMenu
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
;   jr      90$

    ; 並べ替えの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; テープから読み込む
;
CampLoad:

    ; レジスタの保存

    ; 初期化
    ld      a, (_camp + CAMP_STATE)
    or      a
    jr      nz, 09$

    ; 読み込みの表示
    call    CampPrintLoadPrepare

    ; 初期化の完了
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
09$:

    ; 0x01 : 準備
10$:
    ld      a, (_camp + CAMP_STATE)
    dec     a
    jr      nz, 20$

    ; SHIFT キーの入力
    ld      a, (_input + INPUT_BUTTON_SHIFT)
    dec     a
    jr      nz, 11$
    ld      a, #SOUND_SE_CANCEL
    call    _SoundPlaySe
    jr      80$

    ; SPACE キーの入力
11$:
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
;   ld      a, #SOUND_SE_OK
;   call    _SoundPlaySe

    ; 読み込みの表示
    call    CampPrintLoadTape

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 読み込み
20$:
    dec     a
    jr      nz, 30$

    ; ファイルの読み込み
    call    CampLoadFile

    ; 読み込みの表示
    call    CampPrintLoadResult

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
    jr      90$

    ; 0x03 : 完了
30$:
    dec     a
    jr      nz, 40$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; メニューの完了
    ld      hl, #(_camp + CAMP_FLAG)
    set     #CAMP_FLAG_DONE_BIT, (hl)
    ld      hl, #CampNull
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
    jr      90$

    ; 0x04 : エラー
40$:
;   dec     a
;   jr      nz, 50$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
;   jr      80$

    ; 戻る
80$:
    ld      hl, #CampMenu
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
;   jr      90$

    ; 読み込みの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; テープに保存する
;
CampSave:

    ; レジスタの保存

    ; 初期化
    ld      a, (_camp + CAMP_STATE)
    or      a
    jr      nz, 09$

    ; 保存の表示
    call    CampPrintSavePrepare

    ; 初期化の完了
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
09$:

    ; 0x01 : 準備
10$:
    ld      a, (_camp + CAMP_STATE)
    dec     a
    jr      nz, 20$

    ; SHIFT キーの入力
    ld      a, (_input + INPUT_BUTTON_SHIFT)
    dec     a
    jr      nz, 11$
    ld      a, #SOUND_SE_CANCEL
    call    _SoundPlaySe
    jr      80$

    ; SPACE キーの入力
11$:
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
;   ld      a, #SOUND_SE_OK
;   call    _SoundPlaySe

    ; 保存の表示
    call    CampPrintSaveTape

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 保存
20$:
    dec     a
    jr      nz, 30$

    ; ファイルの書き込み
    call    CampSaveFile

    ; 保存の表示
    call    CampPrintSaveResult

    ; 状態の更新
    ld      hl, #(_camp + CAMP_STATE)
    inc     (hl)
    jr      90$

    ; 0x03 : 完了
30$:
    dec     a
    jr      nz, 40$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    jr      80$

    ; 0x04 : エラー
40$:
;   dec     a
;   jr      nz, 50$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
;   jr      80$

    ; 戻る
80$:
    ld      hl, #CampMenu
    ld      (_camp + CAMP_PROC_L), hl
    xor     a
    ld      (_camp + CAMP_STATE), a
;   jr      90$

    ; 保存の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; キャンプが完了したかどうかを判定する
;
_CampIsDone::

    ; レジスタの保存

    ; cf > 1 = 完了

    ; 完了の判定
    ld      a, (_camp + CAMP_FLAG)
    bit     #CAMP_FLAG_DONE_BIT, a
    jr      z, 10$
    scf
    jr      19$
10$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ファイルを読み込む
;
CampLoadFile:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; cf > 1 = エラー

    ; ヘッダの読み込み
    call    TAPION
    jp      c, 80$
    ld      hl, #campFileHeader
    ld      b, #CAMP_FILE_HEADER_LENGTH
10$:
    push    bc
    push    hl
    call    TAPIN
    pop     hl
    pop     bc
    jr      c, 80$
    ld      (hl), a
    inc     hl
    djnz    10$
    call    TAPIOF
    jr      c, 80$

    ; データの読み込み
    call    TAPION
    jr      c, 80$
    ld      hl, #campFileData
    ld      b, #CAMP_FILE_DATA_LENGTH
20$:
    push    bc
    push    hl
    call    TAPIN
    pop     hl
    pop     bc
    jr      c, 80$
    ld      (hl), a
    inc     hl
    djnz    20$
    call    TAPIOF
    jr      c, 80$

    ; ヘッダの確認
    ld      hl, #campFileHeader
    ld      de, #campFileHeaderDefault
    ld      b, #CAMP_FILE_HEADER_LENGTH
30$:
    ld      a, (de)
    cp      (hl)
    jr      nz, 80$
    inc     hl
    inc     de
    djnz    30$

    ; データの確認
    ld      hl, #(campFileData + CAMP_FILE_DATA_GOLD_L)
    ld      bc, #(CAMP_FILE_DATA_LENGTH - 0x0001)
    call    _SystemCalcCrc
    ld      c, a
    ld      a, (campFileData + CAMP_FILE_DATA_CRC)
    cp      c
    jr      nz, 80$
    ld      hl, #(campFileData + CAMP_FILE_DATA_GOLD_L)
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ex      de, hl
    call    _PlayerSetGold
    ex      de, hl
    ld      a, (hl)
    inc     hl
    call    _PlayerSetPotion
    ld      b, #PLAYER_CHARACTER_LORD
40$:
    ld      c, (hl)
    inc     hl
    ld      a, b
    call    _PlayerSetCharacterLevel
    ld      c, (hl)
    inc     hl
    ld      a, b
    call    _PlayerSetCharacterLife
    ld      c, (hl)
    inc     hl
    ld      a, b
    call    _PlayerSetCharacterMagic
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ex      de, hl
    ld      a, b
    call    _PlayerSetCharacterExperience
    ex      de, hl
    inc     b
    ld      a, b
    cp      #PLAYER_CHARACTER_ENTRY
    jr      c, 40$

    ; 読み込みの完了
    or      a
    jr      90$

    ; エラー
80$:
    scf
;   jr      90$

    ; 終了
90$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; ファイルを書き込む
;
CampSaveFile:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; cf > 1 = エラー

    ; データの生成
    ld      de, #(campFileData + CAMP_FILE_DATA_GOLD_L)
    call    _PlayerGetGold
    ld      a, l
    ld      (de), a
    inc     de
    ld      a, h
    ld      (de), a
    inc     de
    call    _PlayerGetPotion
    ld      (de), a
    inc     de
    ld      c, #PLAYER_CHARACTER_LORD
10$:
    ld      a, c
    call    _PlayerGetCharacterLevel
    ld      (de), a
    inc     de
    ld      a, c
    call    _PlayerGetCharacterLife
    ld      (de), a
    inc     de
    ld      a, c
    call    _PlayerGetCharacterMagic
    ld      (de), a
    inc     de
    ld      a, c
    call    _PlayerGetCharacterExperience
    ld      a, l
    ld      (de), a
    inc     de
    ld      a, h
    ld      (de), a
    inc     de
    inc     c
    ld      a, c
    cp      #PLAYER_CHARACTER_ENTRY
    jr      c, 10$
    ld      hl, #(campFileData + CAMP_FILE_DATA_GOLD_L)
    ld      bc, #(CAMP_FILE_DATA_LENGTH - 0x0001)
    call    _SystemCalcCrc
    ld      (campFileData + CAMP_FILE_DATA_CRC), a

    ; ヘッダの書き込み
    ld      a, #0x01
    call    TAPOON
    jr      c, 80$
    ld      hl, #campFileHeaderDefault
    ld      b, #CAMP_FILE_HEADER_LENGTH
20$:
    push    bc
    push    hl
    ld      a, (hl)
    call    TAPOUT
    pop     hl
    pop     bc
    jr      c, 80$
    inc     hl
    djnz    20$
    call    TAPOOF
    jr      c, 80$

    ; データの書き込み
    xor     a
    call    TAPOON
    jr      c, 80$
    ld      hl, #campFileData
    ld      b, #CAMP_FILE_DATA_LENGTH
30$:
    push    bc
    push    hl
    ld      a, (hl)
    call    TAPOUT
    pop     hl
    pop     bc
    jr      c, 80$
    inc     hl
    djnz    30$
    call    TAPOOF
    jr      c, 80$

    ; 書き込みの完了
    or      a
    jr      90$

    ; エラー
80$:
    scf
;   jr      90$

    ; 終了
90$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; メニューを表示する
;
CampPrintMenu:

    ; レジスタの保存

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 名称の表示
    ld      hl, #campNameString
    ld      d, #0
    call    _GamePrintMessage

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メニューの表示
    ld      de, #(_patternName + 4 * 0x0020 + 8)
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #0x02
    ld      b, a
    ld      c, #16
    call    _GamePrintFrame
    call    _GameClearString
    ld      hl, #(_camp + CAMP_ITEM_0)
    ld      a, (_camp + CAMP_ITEM_SIZE)
    ld      b, a
10$:
    push    hl
    ld      a, (hl)
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #campMenuString
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    call    _GameConcatString
    pop     hl
    inc     hl
    djnz    10$
    call    _GameGetString
    ld      de, #(_patternName + 5 * 0x0020 + 10)
    call    _GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

CampPrintMenuError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campMenuErrorString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #4
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 呪文を表示する
;
CampPrintSpellCaster:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSpellCasterString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #4
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSpellTarget:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSpellTargetString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSpellResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メッセージの表示
    ld      a, (_camp + CAMP_TARGET)
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #campSpellResultString_0
    call    _GameConcatString
    ld      a, (_camp + CAMP_VALUE)
    ld      l, a
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #campSpellResultString_1
    call    _GameConcatString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #6
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSpellError_0_0:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSpellErrorString_0
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSpellError_0_1:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSpellErrorString_0
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #6
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSpellError_1:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSpellErrorString_1
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSpellError_2:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSpellErrorString_2
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 薬を表示する
;
CampPrintPotionTarget:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campPotionTargetString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #4
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintPotionResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メッセージの表示
    ld      a, (_camp + CAMP_TARGET)
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #campPotionResultString
    call    _GameConcatString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintPotionError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campPotionErrorString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 並べ替えを表示する
;
CampPrintOrder:

    ; レジスタの保存

    ; メニューの表示
    ld      de, #(_patternName + 7 * 0x0020 + 11)
    ld      a, (_camp + CAMP_PARTY)
    add     a, #0x02
    ld      b, a
    ld      c, #10
    call    _GamePrintFrame
    call    _GameClearString
    ld      hl, #(_camp + CAMP_ORDER_0)
    ld      a, (_camp + CAMP_PARTY)
    ld      b, #0x05
10$:
    push    hl
    ld      a, (hl)
    or      a
    jr      z, 11$
    call    _PlayerGetCharacterName
    call    _GameConcatString
11$:
    ld      hl, #campOrderString
    call    _GameConcatString
    pop     hl
    inc     hl
    djnz    10$
    call    _GameGetString
    ld      de, #(_patternName + 8 * 0x0020 + 13)
    call    _GamePrintString
    
    ; パーティの表示
    call    _PlayerPrintParty

;   ; 所持品の表示
;   call    _PlayerPrintItem

    ; レジスタの復帰

    ; 終了
    ret

; 読み込みを表示する
;
CampPrintLoadPrepare:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campLoadPrepareString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #4
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintLoadTape:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campLoadTapeString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintLoadResult:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campLoadResultString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #6
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintLoadError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campLoadErrorString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #6
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 保存を表示する
;
CampPrintSavePrepare:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSavePrepareString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #4
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSaveTape:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSaveTapeString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #5
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSaveResult:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSaveResultString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #6
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

CampPrintSaveError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #campSaveErrorString
    ld      a, (_camp + CAMP_ITEM_SIZE)
    add     a, #6
    ld      d, a
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 名前
campNameString:

    .db     _KKI, _Kya, _K_N, _KHU, _KPS, _COL, 0x00

; メニュー
;
campMenuString:

    .dw     0x0000
    .dw     campMenuSpellString
    .dw     campMenuPotionString
    .dw     campMenuOrderString
    .dw     campMenuLoadString
    .dw     campMenuSaveString

campMenuNullString:

    .db     0x00

campMenuSpellString:

    .db     _HSI, _KSN, _Hyu, _HMO, _H_N, _HWO, ____, _HTO, _HNA, _H_E, _HRU, __LF, 0x00

campMenuPotionString:

    .db     _HKU, _HSU, _HRI, _HWO, ____, _HTU, _HKA, _H_U, __LF, 0x00

campMenuOrderString:

    .db     _HNA, _HRA, _HHE, _KSN, _HKA, _H_E, _HRU, __LF, 0x00

campMenuLoadString:

    .db     _KTE, _KSN, _MNS, _KTA, _HWO, ____, _HYO, _HMI, _HKO, _HMU, __LF, 0x00

campMenuSaveString:

    .db     _KTE, _KSN, _MNS, _KTA, _HWO, ____, _HHO, _HSO, _KSN, _H_N, _HSU, _HRU, __LF, 0x00

campMenuErrorString:

    .db     _HKU, _HSU, _HRI, _HKA, _KSN, ____, _HNA, _H_I, __LF, 0x00

; 呪文
;
campSpellCasterString:

    .db     _HTA, _KSN, _HRE, _HKA, _KSN, _HTI, _HYU, _HWO, ____, _HTO, _HNA, _H_E, _HMA, _HSU, _HKA, _QUE, 0x00

campSpellTargetString:

    .db     _HTA, _KSN, _HRE, _HNI, ____, _HTO, _HNA, _H_E, _HMA, _HSU, _HKA, _QUE, 0x00

campSpellResultString_0:

    .db     _HNO, ___H, ___P, _HKA, _KSN, ____, 0x00
    
campSpellResultString_1:

    .db     ____, _HKA, _H_I, _HHU, _HKU, _HSI, _HTA, 0x00

campSpellErrorString_0:

    .db     _HSI, _H_N, _HTE, _KSN, _H_I, _HRU, 0x00

campSpellErrorString_1:

    .db     _HTO, _HNA, _H_E, _HRA, _HRE, _HNA, _H_I, 0x00

campSpellErrorString_2:

    .db     ___M, ___P, _HKA, _KSN, ____, _HTA, _HRI, _HNA, _H_I, 0x00

; 薬
;
campPotionTargetString:

    .db     _HTA, _KSN, _HRE, _HNI, _HKU, _HSU, _HRI, _HWO, ____, _HTU, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

campPotionResultString:

    .db     _HNO, ___H, ___P, _HKA, _KSN, ____, _HSE, _KSN, _H_N, _HKA, _H_I, _HSI, _HTA, 0x00

campPotionErrorString:

    .db     _HSI, _H_N, _HTE, _KSN, _H_I, _HRU, 0x00

; 並べ替え
;
campOrderString:

    .db     __LF, 0x00

; 読み込み
;
campLoadPrepareString:

    .db     _KTE, _MNS, _KHU, _KPS, _HWO, _HSI, _KSN, _Hyu, _H_N, _HHI, _KSN, _HSI, _HTE, _HKU, _HTA, _KSN, _HSA, _H_I, 0x00

campLoadTapeString:

    .db     _HYO, _HMI, _HKO, _HMI, _HTI, _Hyu, _H_U, 0x00
    
campLoadResultString:

    .db     _HYO, _HMI, _HKO, _HMI, _HKA, _KSN, ____, _HKA, _H_N, _HRI, _Hyo, _H_U, _HSI, _HTA, 0x00
    
campLoadErrorString:

    .db     _HYO, _HMI, _HKO, _HMI, _HKA, _KSN, ____, _HSI, _Htu, _HHA, _KPS, _H_I, _HSI, _HTA, 0x00
    
; 保存
;
campSavePrepareString:

    .db     _KTE, _MNS, _KHU, _KPS, _HWO, _HSI, _KSN, _Hyu, _H_N, _HHI, _KSN, _HSI, _HTE, _HKU, _HTA, _KSN, _HSA, _H_I, 0x00

campSaveTapeString:

    .db     _HHO, _HSO, _KSN, _H_N, _HTI, _Hyu, _H_U, 0x00
    
campSaveResultString:

    .db     _HHO, _HSO, _KSN, _H_N, _HKA,_KSN,  ____, _HKA, _H_N, _HRI, _Hyo, _H_U, _HSI, _HTA, 0x00
    
campSaveErrorString:

    .db     _HHO, _HSO, _KSN, _H_N, _HKA, _KSN, ____, _HSI, _Htu, _HHA, _KPS, _H_I, _HSI, _HSI, _HTA, 0x00

; ファイル
;
campFileHeaderDefault:

    .db     0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
    .ascii  "DICEQT"


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; キャンプ
;
_camp::

    .ds     CAMP_LENGTH

; ファイル
;
campFileHeader:

    .ds     CAMP_FILE_HEADER_LENGTH

campFileData:

    .ds     CAMP_FILE_DATA_LENGTH
