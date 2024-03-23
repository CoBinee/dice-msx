; Town.s : 町
;


; モジュール宣言
;
    .module Town

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Town.inc"
    .include    "Player.inc"
    .include    "Menu.inc"
    .include    "Camp.inc"

; 外部変数宣言
;
    .globl  _patternTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 町を初期化する
;
_TownInitialize::
    
    ; レジスタの保存
    
    ; 町の初期化
    ld      hl, #townDefault
    ld      de, #_town
    ld      bc, #TOWN_LENGTH
    ldir
    
    ; 処理の設定
    ld      hl, #TownNull
    ld      (_town + TOWN_PROC_L), hl
    xor     a
    ld      (_town + TOWN_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 町を更新する
;
_TownUpdate::
    
    ; レジスタの保存
    
    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_town + TOWN_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 町を描画する
;
_TownRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 町を読み込む
;
_TownLoad::

    ; レジスタの保存

    ; パターンジェネレータの転送
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
    ld      bc, #0x0800
    call    LDIRVM

    ; カラーテーブルの転送
    ld      hl, #(APP_COLOR_TABLE + 0x0800)
    ld      a, #((VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x0800
    call    FILVRM
    
    ; パターンネームのクリア
    ld      hl, #(_patternName + 0x0100)
    ld      de, #(_patternName + 0x0101)
    ld      bc, #(0x0100 - 0x0001)
    ld      (hl), #0x00
    ldir

    ; 処理の更新
    ld      hl, #TownPlaza
    ld      (_town + TOWN_PROC_L), hl
    xor     a
    ld      (_town + TOWN_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 条件別の処理の更新を行う
;
TownCase:

    ; レジスタの保存
    push    hl
    push    de

    ; hl < 処理
    ; a  < 条件

    ; 処理の更新
    add     a, a
    ld      e, a
    ld      d, #0x00
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (_town + TOWN_PROC_L), de
    xor     a
    ld      (_town + TOWN_STATE), a

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 何もしない
;
TownNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 広場にいる
;
TownPlaza:

    ; レジスタの保存

    ; 初期化
    ld      a, (_town + TOWN_STATE)
    or      a
    jr      nz, 09$

    ; パーティのクリア
    call    _PlayerClearParty

    ; パーティの編成
    ld      a, #PLAYER_CHARACTER_LORD
    call    _PlayerAddParty
    ld      a, #PLAYER_CHARACTER_FIGHTER
    call    _PlayerAddParty
    ld      a, #PLAYER_CHARACTER_PRIEST
    call    _PlayerAddParty
    ld      a, #PLAYER_CHARACTER_THIEF
    call    _PlayerAddParty
    ld      a, #PLAYER_CHARACTER_MAGE
    call    _PlayerAddParty

    ; メニューの読み込み
    ld      de, #((5 << 8) | 8)
    ld      bc, #((0 << 8) | TOWN_PLAZA_LENGTH)
    ld      a, (_town + TOWN_PLAZA)
    call    _MenuLoad

    ; 広場の表示
    call    TownPrintPlaza

    ; 初期化の完了
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
09$:

    ; メニューの更新
100$:
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
110$:
    call    _MenuIsCancel
    jr      nc, 120$

    ; 状態の更新
    xor     a
    ld      (_town + TOWN_STATE), a
    jr      90$

    ; メニューの決定
120$:
    call    _MenuIsSelect
    jr      nc, 90$

    ; メニュー別の処理
    call    _MenuGetItem
    ld      (_town + TOWN_PLAZA), a
    ld      hl, #townPlazaCase
    call    TownCase
;   jr      90$

    ; 広場の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 宿に泊まる
;
TownInn:

    ; レジスタの保存

    ; 初期化
    ld      a, (_town + TOWN_STATE)
    or      a
    jr      nz, 09$

    ; 最大レベルの取得
    ld      b, #0x00
    ld      c, #PLAYER_LEVEL_MINIMUM
00$:
    ld      a, b
    call    _PlayerIsCharacterLive
    jr      nc, 01$
    ld      a, b
    call    _PlayerGetCharacterLevel
    cp      c
    jr      c, 01$
    ld      c, a
01$:
    inc     b
    ld      a, b
    cp      #PLAYER_CHARACTER_ENTRY
    jr      c, 00$

    ; 宿泊費の取得
    ld      hl, #0
    ld      de, #10
    ld      b, c
02$:
    add     hl, de
    djnz    02$
    ld      (_town + TOWN_COST_L), hl

    ; メニューの読み込み
    ld      de, #((7 << 8) | 4)
    ld      bc, #((0 << 8) | TOWN_INN_QUERY_LENGTH)
    xor     a
    call    _MenuLoad

    ; 宿の表示
    call    TownPrintInnQuery

    ; 初期化の完了
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
09$:

    ; 0x01 : 確認
10$:
    ld      a, (_town + TOWN_STATE)
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

    ; キャンセル
    call    _MenuGetItem
    cp      #TOWN_INN_QUERY_CANCEL
    jr      z, 80$

    ; 支払い
    ld      hl, (_town + TOWN_COST_L)
    call    _PlayerUseGold
    jr      nc, 11$

    ; 泊まった
    call    _PlayerRestCharacter
    call    TownPrintInnResult
    jr      19$

    ; 所持金が足りなかった
11$:
    call    TownPrintInnError
;   jr      19$

    ; 状態の更新
19$:
    ld      hl, #(_town + TOWN_STATE)
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
    ld      hl, #TownPlaza
    ld      (_town + TOWN_PROC_L), hl
    xor     a
    ld      (_town + TOWN_STATE), a
;   jr      90$

    ; 宿の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 寺院で蘇生する
;
TownTemple:

    ; レジスタの保存

    ; 初期化
    ld      a, (_town + TOWN_STATE)
    or      a
    jr      nz, 09$

    ; メニューの読み込み
    ld      de, #((18 << 8) | 1)
    ld      bc, #((0 << 8) | TOWN_TEMPLE_SELECT_LENGTH)
    xor     a
    call    _MenuLoad

    ; 寺院の表示
    call    TownPrintTempleSelect

    ; 初期化の完了
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_town + TOWN_STATE)
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

    ; 生存確認
    call    _MenuGetItem
    call    _PlayerGetPartyCharacter
    ld      (_town + TOWN_TARGET), a
    call    _PlayerIsCharacterLive
    jr      nc, 11$

    ; 生きている
    call    TownPrintTempleError_0

    ; 状態の更新
    ld      a, #0x03
    ld      (_town + TOWN_STATE), a
    jr      90$

    ; 費用の取得
11$:
    ld      a, (_town + TOWN_TARGET)
    call    _PlayerGetCharacterLevel
    ld      b, a
    ld      hl, #0
    ld      de, #20
12$:
    add     hl, de
    djnz    12$
    ld      (_town + TOWN_COST_L), hl

    ; メニューの読み込み
    ld      de, #((8 << 8) | 6)
    ld      bc, #((0 << 8) | TOWN_TEMPLE_QUERY_LENGTH)
    xor     a
    call    _MenuLoad

    ; 寺院の表示
    call    TownPrintTempleQuery

    ; 状態の更新
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 確認
20$:
    dec     a
    jr      nz, 30$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jr      c, 70$

    ; メニューの決定
    call    _MenuIsSelect
    jr      nc, 90$

    ; キャンセル
    call    _MenuGetItem
    cp      #TOWN_TEMPLE_QUERY_CANCEL
    jr      z, 70$

    ; 支払い
    ld      hl, (_town + TOWN_COST_L)
    call    _PlayerUseGold
    jr      nc, 21$

    ; 蘇生
    ld      a, (_town + TOWN_TARGET)
    call    _PlayerReviveCharacter
    call    TownPrintTempleResult
    jr      22$

    ; 所持金が足りない
21$:
    call    TownPrintTempleError_1
;   jr      22$

    ; 状態の更新
22$:
    ld      hl, #(_town + TOWN_STATE)
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
;   jr      70$

    ; やり直し
70$:
    xor     a
    ld      (_town + TOWN_STATE), a
    jr      90$

    ; 戻る
80$:
    ld      hl, #TownPlaza
    ld      (_town + TOWN_PROC_L), hl
    xor     a
    ld      (_town + TOWN_STATE), a
;   jr      90$

    ; キャンプの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; キャンプを張る
;
TownCamp:

    ; レジスタの保存

    ; 初期化
    ld      a, (_town + TOWN_STATE)
    or      a
    jr      nz, 09$

    ; キャンプの読み込み
    xor     a
    call    _CampLoad

    ; 初期化の完了
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
09$:

    ; キャンプの更新
    call    _CampUpdate
    call    _CampRender

    ; キャンプの完了
    call    _CampIsDone
    jr      nc, 19$

    ; 戻る
    ld      hl, #TownPlaza
    ld      (_town + TOWN_PROC_L), hl
    xor     a
    ld      (_town + TOWN_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 探索に出かける
;
TownDungeon:

    ; レジスタの保存

    ; 初期化
    ld      a, (_town + TOWN_STATE)
    or      a
    jr      nz, 09$

    ; パーティのクリア
    call    _PlayerClearParty

    ; メニューの初期化
    ld      hl, #(_town + TOWN_PARAM_0)
    ld      (hl), #PLAYER_CHARACTER_LORD
    inc     hl
    ld      (hl), #PLAYER_CHARACTER_FIGHTER
    inc     hl
    ld      (hl), #PLAYER_CHARACTER_PRIEST
    inc     hl
    ld      (hl), #PLAYER_CHARACTER_THIEF
    inc     hl
    ld      (hl), #PLAYER_CHARACTER_MAGE
    xor     a
    ld      (_town + TOWN_PARAM_5), a
    ld      (_town + TOWN_PARAM_6), a
    ld      a, (_town + TOWN_PLAZA)
    cp      #TOWN_PLAZA_DUNGEON
    ld      a, #PLAYER_PARTY_DUNGEON
    jr      z, 00$
    ld      a, #PLAYER_PARTY_CASTLE
00$:
    ld      (_town + TOWN_PARAM_7), a

    ; 初期化の完了
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択の設定
10$:
    ld      a, (_town + TOWN_STATE)
    dec     a
    jr      nz, 20$

    ; メニューの読み込み
    ld      de, #((5 << 8) | 9)
    ld      bc, #((0 << 8) | TOWN_DUNGEON_SELECT_LENGTH)
    ld      a, (_town + TOWN_PARAM_5)
    call    _MenuLoad

    ; ダンジョンの表示
    call    TownPrintDungeonSelect

    ; 状態の更新
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
    jp      90$

    ; 0x02 : 選択
20$:
    dec     a
    jp      nz, 30$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender
    call    _MenuGetItem
    ld      (_town + TOWN_PARAM_5), a

    ; メニューのキャンセル
210$:
    call    _MenuIsCancel
    jr      nc, 220$

    ; すべてをキャンセル
    ld      a, (_town + TOWN_PARAM_6)
    or      a
    jp      z, 80$

    ; キャラクターを戻す
    call    _PlayerRemoveParty
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_town + TOWN_PARAM_0 - 0x0001)
    add     hl, de
    ld      (hl), a
    ld      hl, #(_town + TOWN_PARAM_6)
    dec     (hl)
    jr      290$

    ; メニューの決定
220$:
    call    _MenuIsSelect
    jr      nc, 299$

    ; グループの決定
    ld      a, (_town + TOWN_PARAM_5)
    cp      #TOWN_DUNGEON_SELECT_OK
    jr      nz, 221$
    ld      a, (_town + TOWN_PARAM_6)
    or      a
    jr      nz, 230$
    jr      290$

    ; パーティに加える
221$:
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_town + TOWN_PARAM_0)
    add     hl, de
    ld      a, (hl)
    or      a
    jr      z, 290$
    ld      c, a
    call    _PlayerIsCharacterLive
    jr      nc, 222$
    ld      a, c
    call    _PlayerAddParty
    ld      (hl), #PLAYER_CHARACTER_NULL
    ld      hl, #(_town + TOWN_PARAM_6)
    inc     (hl)
    ld      a, (_town + TOWN_PARAM_7)
    cp      (hl)
    jr      nz, 290$
    jr      230$

    ; 死んでいる
222$:
    call    TownPrintDungeonError

    ; 状態の更新
    ld      a, #0x04
    ld      (_town + TOWN_STATE), a
    jr      90$

    ; メンバーの確定
230$:

    ; メニューの読み込み
    ld      de, #((11 << 8) | 11)
    ld      bc, #((0 << 8) | TOWN_DUNGEON_QUERY_LENGTH)
    xor     a
    call    _MenuLoad

    ; ダンジョンの表示
    call    TownPrintDungeonSelect
    call    TownPrintDungeonQuery

    ; 状態の更新
    ld      hl, #(_town + TOWN_STATE)
    inc     (hl)
    jr      90$

    ; メニューの再選択
290$:
    ld      hl, #(_town + TOWN_STATE)
    dec     (hl)
299$:
    jr      90$

    ; 0x03 : 確認
30$:
    dec     a
    jr      nz, 40$

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jr      c, 80$

    ; メニューの決定
    call    _MenuIsSelect
    jr      nc, 90$

    ; キャンセル
    call    _MenuGetItem
    cp      #TOWN_DUNGEON_QUERY_CANCEL
    jr      z, 80$

    ; ダンジョンへ
    ld      a, (_town + TOWN_PLAZA)
    cp      #TOWN_PLAZA_DUNGEON
    ld      a, #GAME_GOTO_DUNGEON
    jr      z, 31$
    ld      a, #GAME_GOTO_CASTLE
31$:
    ld      (_game + GAME_GOTO), a
    jr      90$

    ; 0x04 : 選べない
40$:
;   dec     a
;   jr      nz, 50$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 状態の更新
    ld      a, #0x01
    ld      (_town + TOWN_STATE), a
    jr      90$

    ; 戻る
80$:
    ld      hl, #TownPlaza
    ld      (_town + TOWN_PROC_L), hl
    xor     a
    ld      (_town + TOWN_STATE), a
;   jr      90$

    ; ダンジョンの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 広場を表示する
;
TownPrintPlaza:

    ; レジスタの保存

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 名称の表示
    ld      hl, #townPlazaNameString
    ld      d, #0
    call    _GamePrintMessage

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メニューの表示
    ld      de, #(_patternName + 4 * 0x0020 + 7)
    ld      bc, #((7 << 8) | 18)
    call    _GamePrintFrame
    ld      hl, #townPlazaMenuString
    ld      de, #(_patternName + 5 * 0x0020 + 9)
    call    _GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

; 宿を表示する
;
TownPrintInnQuery:

    ; レジスタの保存

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 名称の表示
    ld      hl, #townInnNameString
    ld      d, #0
    call    _GamePrintMessage

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メニューの表示
    ld      de, #(_patternName + 4 * 0x0020 + 3)
    ld      bc, #((6 << 8) | 26)
    call    _GamePrintFrame
    ld      hl, #townInnQueryString_0
    call    _GameSetString
    ld      hl, (_town + TOWN_COST_L)
    call    _GameConcatValue
    ld      hl, #townInnQueryString_1
    call    _GameConcatString
    ld      de, #(_patternName + 5 * 0x0020 + 4)
    call    _GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

TownPrintInnResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メッセージの表示
    ld      hl, #townInnResultString
    ld      d, #8
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

TownPrintInnError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #townInnErrorString
    ld      d, #8
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 寺院を表示する
;
TownPrintTempleSelect:

    ; レジスタの保存

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 名称の表示
    ld      hl, #townTempleNameString
    ld      d, #0
    call    _GamePrintMessage

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メッセージの表示
    ld      hl, #townTempleSelectString
    ld      d, #4
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

TownPrintTempleQuery:

    ; レジスタの保存

    ; メニューの表示
    ld      de, #(_patternName + 5 * 0x0020 + 5)
    ld      bc, #((6 << 8) | 22)
    call    _GamePrintFrame
    call    _GameClearString
    ld      hl, (_town + TOWN_COST_L)
    call    _GameConcatValue
    ld      hl, #townTempleQueryString
    call    _GameConcatString
    ld      de, #(_patternName + 6 * 0x0020 + 6)
    call    _GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

TownPrintTempleResult:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メッセージの表示
    ld      a, (_town + TOWN_TARGET)
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #townTempleResultString
    call    _GameConcatString
    ld      d, #9
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

TownPrintTempleError_0:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #townTempleErrorString_0
    ld      d, #5
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

TownPrintTempleError_1:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #townTempleErrorString_1
    ld      d, #9
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; ダンジョンを表示する
;
TownPrintDungeonSelect:

    ; レジスタの保存

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 名称の表示
    ld      a, (_town + TOWN_PLAZA)
    cp      #TOWN_PLAZA_DUNGEON
    ld      hl, #townDungeonNameString
    jr      z, 10$
    ld      hl, #townCastleNameString
10$:
    ld      d, #0
    call    _GamePrintMessage

    ; メニューの表示
    ld      de, #(_patternName + 4 * 0x0020 + 8)
    ld      bc, #((8 << 8) | 16)
    call    _GamePrintFrame
    call    _GameClearString
    ld      hl, #(_town + TOWN_PARAM_0)
    ld      b, #0x05
20$:
    push    hl
    ld      a, (hl)
    or      a
    jr      z, 21$
    call    _PlayerGetCharacterName
    call    _GameConcatString
21$:
    ld      hl, #townDungeonSelectString_0
    call    _GameConcatString
    pop     hl
    inc     hl
    djnz    20$
    ld      hl, #townDungeonSelectString_1
    call    _GameConcatString
    ld      de, #(_patternName + 5 * 0x0020 + 10)
    call    _GamePrintString
    
    ; パーティの表示
    call    _PlayerPrintParty

;   ; 所持品の表示
;   call    _PlayerPrintItem

    ; レジスタの復帰

    ; 終了
    ret

TownPrintDungeonQuery:

    ; レジスタの保存

    ; メニューの表示
    ld      de, #(_patternName + 10 * 0x0020 + 10)
    ld      bc, #((4 << 8) | 12)
    call    _GamePrintFrame
    ld      hl, #townDungeonQueryString
    ld      de, #(_patternName + 11 * 0x0020 + 12)
    call    _GamePrintString
    
    ; レジスタの復帰

    ; 終了
    ret

TownPrintDungeonError:

    ; レジスタの保存

    ; メッセージの表示
    ld      hl, #townDungeonErrorString
    ld      d, #10
    call    _GamePrintMessage
    
    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 町の初期値
;
townDefault:

    .dw     TOWN_PROC_NULL
    .db     TOWN_STATE_NULL
    .db     TOWN_FLAG_NULL
    .db     TOWN_ANIMATION_NULL
    .db     TOWN_PLAZA_INN ; TOWN_PLAZA_NULL
    .db     TOWN_TARGET_NULL
    .dw     TOWN_COST_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL
    .db     TOWN_PARAM_NULL

; 広場
;
townPlazaCase:

    .dw     TownInn
    .dw     TownTemple
    .dw     TownCamp
    .dw     TownDungeon
    .dw     TownDungeon

townPlazaNameString:

    .db     _KHO, _KWA, _K_I, _KTO, _KRA, _K_I, _K_N, _COL, 0x00

townPlazaMenuString:

    .db     _HYA, _HTO, _KSN, _HNI, ____, _HTO, _HMA, _HRU, __LF
    .db     _HSI, _KSN, _H_I, _H_N, _HNI, ____, _H_I, _HKU, __LF
    .db     _KKI, _Kya, _K_N, _KHU, _KPS, _HWO, ____, _HHA, _HRU, __LF
    .db     _KTA, _KSN, _K_N, _KSI, _KSN, _Kyo, _K_N, _HWO, ____, _HTA, _H_N, _HSA, _HKU, _HSU, _HRU, __LF
    .db     _K_I, _KSI, _Kya, _KSU, _KYA, _KRU, _HNI, ____, _H_I, _HTO, _KSN, _HMU, __LF
    .db     0x00

; 宿
;
townInnNameString:

    .db     _KRI, _KRA, _Ktu, _KKU, _KSU, _K_I, _K_N, _COL, 0x00

townInnQueryString_0:

    .db     _HHI, _HTO, _HHA, _KSN, _H_N, ____, 0x00

townInnQueryString_1:
    .db     ____, ___G, ___P, _HTE, _KSN, ____, _HTO, _HMA, _HRI, _HMA, _HSU, _HKA, _QUE, __LF
    .db     __LF
    .db     ____, _HTO, _HMA, _HRU, __LF
    .db     ____, _HYA, _HME, _HRU, __LF
    .db     0x00

townInnResultString:

    .db     ___H, ___P, _HTO, ___M, ___P, _HKA, _KSN, ____, _HSE, _KSN, _H_N, _HKA, _H_I, _HSI, _HTA, 0x00

townInnErrorString:

    .db     _H_O, _HKA, _HNE, _HKA, _KSN, ____, _HTA, _HRI, _HNA, _H_I, 0x00

; 寺院
;
townTempleNameString:

    .db     _KKA, _MNS, _KMU, _HSI, _KSN, _H_I, _H_N, _COL, 0x00

townTempleSelectString:

    .db     _HTA, _KSN, _HRE, _HWO, ____, _H_I, _HKI, _HKA, _H_E, _HRA, _HSE, _HMA, _HSU, _HKA, _QUE, 0x00

townTempleQueryString:

    .db     ____, ___G, ___P, _HTE, _KSN, ____, _H_I, _HKI, _HKA, _H_E, _HRA, _HSE, _HMA, _HSU, _HKA, _QUE, __LF
    .db     __LF
    .db     ____, _H_I, _HKI, _HKA, _H_E, _HRA, _HSE, _HRU, __LF
    .db     ____, _HYA, _HME, _HRU, __LF
    .db     0x00

townTempleResultString:

    .db     _HKA, _KSN, ____, _H_I, _HKI, _HKA, _H_E, _Htu, _HTA, 0x00

townTempleErrorString_0:

    .db     _H_I, _HKI, _HTE, _H_I, _HRU, 0x00

townTempleErrorString_1:

    .db     _H_O, _HKA, _HNE, _HKA, _KSN, ____, _HTA, _HRI, _HNA, _H_I, 0x00

; キャンプ
;

; ダンジョン
;
townDungeonNameString:

    .db     _KTA, _KSN, _K_N, _KSI, _KSN, _Kyo, _K_N, _COL, 0x00

townDungeonSelectString_0:

    .db     __LF, 0x00

townDungeonSelectString_1:

    .db     _KKU, _KSN, _KRU, _MNS, _KHU, _KPS, _HNO, ____, _HKE, _Htu, _HTE, _H_I, 0x00

townDungeonQueryString:

    .db     _HTA, _H_N, _HSA, _HKU, _HNI, ____, _HTE, _KSN, _HRU, __LF
    .db     _HYA, _HME, _HRU, __LF
    .db     0x00

townDungeonErrorString:

    .db     _HSI, _H_N, _HTE, _KSN, _H_I, _HRU, 0x00

; 城
;
townCastleNameString:

    .db     _HHA, _HKU, _HRI, _Hyu, _H_U, _HNO, _HSI, _HRO, _COL, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 町
;
_town::

    .ds     TOWN_LENGTH

