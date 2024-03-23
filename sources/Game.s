; Game.s : ゲーム
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include	"Game.inc"
    .include    "Town.inc"
    .include    "Dungeon.inc"
    .include    "Player.inc"
    .include    "Dice.inc"
    .include    "Maze.inc"
    .include    "Menu.inc"
    .include    "Camp.inc"
    .include    "Battle.inc"

; 外部変数宣言
;
    .globl  _patternTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ゲームを初期化する
;
_GameInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName
    
    ; ゲームの初期化
    ld      hl, #gameDefault
    ld      de, #_game
    ld      bc, #GAME_LENGTH
    ldir

    ; 町の初期化
    call    _TownInitialize

    ; ダンジョンの初期化
    call    _DungeonInitialize

    ; プレイヤの初期化
    call    _PlayerInitialize

    ; ダイスの初期化
    call    _DiceInitialize

    ; 迷路の初期化
    call    _MazeInitialize

    ; メニューの初期化
    call    _MenuInitialize

    ; キャンプの初期化
    call    _CampInitialize

    ; 戦闘の初期化
    call    _BattleInitialize

    ; パターンジェネレータの転送
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0000)
    ld      bc, #0x0800
    call    LDIRVM
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
    ld      bc, #0x0800
    call    LDIRVM
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x1000)
    ld      bc, #0x0800
    call    LDIRVM

    ; カラーテーブルの転送
    ld      hl, #APP_COLOR_TABLE
    ld      a, #((VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x1800
    call    FILVRM
    
    ; 転送の設定
    ld      hl, #_SystemUpdatePatternName
    ld      (_transfer), hl

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; 処理の設定
    ld      hl, #GameTown
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 状態の設定
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを更新する
;
_GameUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_game + GAME_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; フレームの更新
    ld      hl, #(_game + GAME_FRAME)
    inc     (hl)

    ; 状態の遷移
    ld      a, (_game + GAME_GOTO)
    or      a
    jr      z, 99$
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameGoto
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (_game + GAME_PROC_L), de
    xor     a
    ld      (_game + GAME_STATE), a
    ld      (_game + GAME_GOTO), a
99$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
GameNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ゲームを待機する
;
GameIdle:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; レジスタの復帰

    ; 終了
    ret

; 町に滞在する
;
GameTown:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 町の読み込み
    call    _TownLoad

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 町の更新
    call    _TownUpdate

    ; 町の描画
    call    _TownRender

    ; レジスタの復帰

    ; 終了
    ret

; ダンジョンを探索する
;
GameDungeon:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 探索の読み込み
    xor     a
    call    _DungeonLoad

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 探索の更新
    call    _DungeonUpdate

    ; 探索の描画
    call    _DungeonRender

    ; レジスタの復帰

    ; 終了
    ret

; ドラゴンに挑む
;
GameCastle:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 探索の読み込み
    ld      a, #0x01
    call    _DungeonLoad

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 探索の更新
    call    _DungeonUpdate

    ; 探索の描画
    call    _DungeonRender

    ; レジスタの復帰

    ; 終了
    ret

; VRAM へ転送する
;
GameTransfer:

    ; レジスタの保存

    ; d < ポート #0
    ; e < ポート #1

    ; レジスタの復帰

    ; 終了
    ret

; 文字列をクリアする
;
_GameClearString::

    ; レジスタの保存

    ; 文字列のクリア
    xor     a
    ld      (_gameString), a

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を取得する
;
_GameGetString::

    ; レジスタの保存

    ; hl > 文字列

    ; 文字列の取得
    ld      hl, #_gameString

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を設定する
;
_GameSetString::

    ; レジスタの保存
    push    de

    ; hl < 文字列
    ; hl > 文字列

    ; 文字列の複写
    ld      de, #_gameString
10$:
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    or      a
    jr      nz, 10$
    ld      hl, #_gameString

    ; レジスタの復帰
    pop     de

    ; 終了
    ret

; 文字列を連結する
;
_GameConcatString::

    ; レジスタの保存
    push    de

    ; hl < 文字列
    ; hl > 文字列

    ; 文字列の複写
    ld      de, #_gameString
10$:
    ld      a, (de)
    or      a
    jr      z, 11$
    inc     de
    jr      10$
11$:
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    or      a
    jr      nz, 11$
    ld      hl, #_gameString

    ; レジスタの復帰
    pop     de

    ; 終了
    ret

; 数値を連結する
;
_GameConcatValue::

    ; レジスタの保存
    push    bc
    push    de

    ; hl < 数値
    ; hl > 文字列

    ; 数値の文字列化
    ld      de, #gameValue
    call    _AppGetDecimal16

    ; 文字列の複写
    ld      de, #_gameString
10$:
    ld      a, (de)
    or      a
    jr      z, 11$
    inc     de
    jr      10$
11$:
    ld      hl, #gameValue
    ld      b, #0x04
12$:
    ld      a, (hl)
    or      a
    jr      nz, 13$
    inc     hl
    djnz    12$
13$:
    inc     b
14$:
    ld      a, (hl)
    add     a, #___0
    ld      (de), a
    inc     hl
    inc     de
    djnz    14$
    xor     a
    ld      (de), a
    ld      hl, #_gameString

    ; レジスタの復帰
    pop     de
    pop     bc

    ; 終了
    ret

; 表示位置を取得する
;
_GameLocate::

    ; レジスタの保存
    push    hl

    ; de < Y/X 位置
    ; de > 表示位置

    ; 表示位置の取得
    xor     a
    srl     d
    rra
    srl     d
    rra
    srl     d
    rra
    add     a, e
    ld      e, a
    ld      hl, #_patternName
    add     hl, de
    ex      de, hl

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 文字列を表示する
;
_GamePrintString::

    ; レジスタの保存
    push    hl
    push    bc

    ; hl < 文字列
    ; de < 表示位置
    ; de > 表示後の位置

    ; コードの描画
10$:
    ld      bc, #0x0020
11$:
    ld      a, (hl)
    or      a
    jr      z, 19$
    inc     hl
    cp      #__LF
    jr      z, 12$
    ld      (de), a
    inc     de
    dec     c
    jr      11$
12$:
    ex      de, hl
    add     hl, bc
    ex      de, hl
    jr      10$
19$:

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; 数値を表示する
;
_GamePrintValue::

    ; レジスタの保存
    push    hl
    push    bc
    
    ; hl < 数値
    ; de < 表示位置
    ; b  < 桁数
    ; de > 表示後の位置

    ; 数値の文字列化
    push    de
    ld      de, #gameValue
    call    _AppGetDecimal16
    pop     de

    ; 文字列の描画
    push    de
    ld      a, #0x05
    sub     b
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameValue
    add     hl, de
    pop     de
    dec     b
10$:
    ld      a, (hl)
    or      a
    jr      nz, 11$
    ld      (de), a
    inc     hl
    inc     de
    djnz    10$
11$:
    inc     b
12$:
    ld      a, (hl)
    add     a, #___0
    ld      (de), a
    inc     hl
    inc     de
    djnz    12$

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; 枠を表示する
;
_GamePrintFrame::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; de < 表示位置
    ; bc < Y/X サイズ

    ;  大きさの調整
    dec     c
    dec     c
    dec     b
    dec     b

    ; 枠の描画
    ex      de, hl
    push    hl
    ld      (hl), #_FLT
    inc     hl
    ld      e, c
    ld      a, #_F_T
10$:
    ld      (hl), a
    inc     hl
    dec     e
    jr      nz, 10$
    ld      (hl), #_FRT
;   inc     hl
    pop     hl
    ld      de, #0x0020
    add     hl, de
11$:
    push    hl
    ld      (hl), #_F_L
    inc     hl
    ld      e, c
    xor     a
12$:
    ld      (hl), a
    inc     hl
    dec     e
    jr      nz, 12$
    ld      (hl), #_F_R
;   inc     hl
    pop     hl
    ld      de, #0x0020
    add     hl, de
    djnz    11$
    ld      (hl), #_FLB
    inc     hl
    ld      e, c
    ld      a, #_F_B
13$:
    ld      (hl), a
    inc     hl
    dec     e
    jr      nz, 13$
    ld      (hl), #_FRB
;   inc     hl

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; メッセージを表示する
;
_GamePrintMessage::

    ; レジスタの保存
    push    bc
    push    de

    ; hl < 文字列
    ; d  < Y 位置

    ; 文字列の長さの取得
    push    hl
    ld      c, #0x02
10$:
    ld      a, (hl)
    or      a
    jr      z, 11$
    inc     hl
    inc     c
    jr      10$
11$:
    ld      a, c
    inc     a
    and     #0xfe
    ld      c, a
    pop     hl

    ; 位置の取得
    ld      a, #0x20
    sub     c
    srl     a
    ld      e, a

    ; 枠の描画
    call    _GameLocate
    ld      b, #0x03
    call    _GamePrintFrame

    ; 文字列の描画
    push    hl
    ld      hl, #0x0021
    add     hl, de
    ex      de, hl
    pop     hl
    call    _GamePrintString

    ; レジスタの復帰
    pop     de
    pop     bc

    ; 終了
    ret

; 定数の定義
;

; ゲームの初期値
;
gameDefault:

    .dw     GAME_PROC_NULL
    .db     GAME_STATE_NULL
    .db     GAME_FLAG_NULL
    .db     GAME_FRAME_NULL
    .db     GAME_COUNT_NULL
    .db     GAME_GOTO_NULL

; 遷移先
;
gameGoto:

    .dw     GameNull
    .dw     GameTown
    .dw     GameDungeon
    .dw     GameCastle


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ゲーム
;
_game::

    .ds     GAME_LENGTH

; 数値
;
gameValue:

    .ds     0x08

; 文字列
_gameString::

    .ds     0x0100