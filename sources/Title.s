; Title.s : タイトル
;


; モジュール宣言
;
    .module Title

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include	"Title.inc"

; 外部変数宣言
;
    .globl  _patternTable
    .globl  _logoTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; タイトルを初期化する
;
_TitleInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName
    
    ; タイトルの初期化
    ld      hl, #titleDefault
    ld      de, #_title
    ld      bc, #TITLE_LENGTH
    ldir

    ; パターンジェネレータの転送
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0000)
    ld      bc, #0x05c0
    call    LDIRVM
    ld      hl, #_logoTable
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0000 + 0x05c0)
    ld      bc, #0x0240
    call    LDIRVM
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
    ld      bc, #0x05c0
    call    LDIRVM
    ld      hl, #_logoTable
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800 + 0x05c0)
    ld      bc, #0x0240
    call    LDIRVM
    ld      hl, #(_patternTable + 0x0000)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x1000)
    ld      bc, #0x05c0
    call    LDIRVM
    ld      hl, #_logoTable
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x1000 + 0x05c0)
    ld      bc, #0x0240
    call    LDIRVM

    ; カラーテーブルの転送
    ld      hl, #(APP_COLOR_TABLE + 0x0000)
    ld      a, #((VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x05c0
    call    FILVRM
    ld      hl, #(APP_COLOR_TABLE + 0x0000 + 0x05c0)
    ld      a, #((VDP_COLOR_LIGHT_BLUE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x0240
    call    FILVRM
    ld      hl, #(APP_COLOR_TABLE + 0x0800)
    ld      a, #((VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x05c0
    call    FILVRM
    ld      hl, #(APP_COLOR_TABLE + 0x0800 + 0x05c0)
    ld      a, #((VDP_COLOR_LIGHT_BLUE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x0240
    call    FILVRM
    ld      hl, #(APP_COLOR_TABLE + 0x1000)
    ld      a, #((VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x05c0
    call    FILVRM
    ld      hl, #(APP_COLOR_TABLE + 0x1000 + 0x05c0)
    ld      a, #((VDP_COLOR_LIGHT_BLUE << 4) | VDP_COLOR_BLACK)
    ld      bc, #0x0240
    call    FILVRM
    
    ; 転送の設定
    ld      hl, #_SystemUpdatePatternName
    ld      (_transfer), hl

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; 処理の設定
    ld      hl, #TitlePrologue
    ld      (_title + TITLE_PROC_L), hl
    xor     a
    ld      (_title + TITLE_STATE), a

    ; 状態の設定
    ld      a, #APP_STATE_TITLE_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; タイトルを更新する
;
_TitleUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_title + TITLE_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; フレームの更新
    ld      hl, #(_title + TITLE_FRAME)
    inc     (hl)

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
TitleNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; プロローグを見せる
;
TitlePrologue:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    or      a
    jr      nz, 09$

    ; カウントの設定
    xor     a
    ld      (_title + TITLE_COUNT), a

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; SPACE　キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 10$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    jp      80$

    ; 0x01 : 画面の設定
10$:
    ld      a, (_title + TITLE_STATE)
    dec     a
    jr      nz, 20$

    ; 文字列の設定
    ld      a, (_title + TITLE_COUNT)
    or      a
    ld      hl, #titlePrologueString_0
    jr      z, 11$
    ld      hl, #titlePrologueString_1
11$:
    ld      (_title + TITLE_STRING_L), hl

    ; アニメーションの設定
    ld      a, #0x01
    ld      (_title + TITLE_ANIMATION), a

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
    jp      90$

    ; 0x02 : 画面の表示
20$:
    dec     a
    jr      nz, 30$

    ; アニメーションの更新
    ld      hl, #(_title + TITLE_ANIMATION)
    dec     (hl)
    jr      nz, 90$

    ; 文字列の描画
    ld      hl, (_title + TITLE_STRING_L)
    ld      a, (hl)
    cp      #0xff
    jr      z, 21$
    ld      d, a
    inc     hl
    ld      c, (hl)
    inc     hl
    ld      b, (hl)
    inc     hl
    ld      (_title + TITLE_STRING_L), hl
    ld      l, c
    ld      h, b
    call    TitleCentering
    call    TitlePrintString

    ; アニメーションの設定
    ld      a, #TITLE_ANIMATION_LINE
    ld      (_title + TITLE_ANIMATION), a
    jr      90$

    ; 表示の完了
21$:

    ; アニメーションの設定
    ld      a, #TITLE_ANIMATION_PAGE
    ld      (_title + TITLE_ANIMATION), a

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x03 : 画面の待機
30$:
    dec     a
    jr      nz, 40$

    ; アニメーションの更新
    ld      hl, #(_title + TITLE_ANIMATION)
    dec     (hl)
    jr      nz, 90$

    ; アニメーションの設定
    xor     a
    ld      (_title + TITLE_ANIMATION), a

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x04 : 画面の消去
40$:
    dec     a
    jr      nz, 50$

    ; １行の消去
    ld      hl, #(_title + TITLE_ANIMATION)
    ld      d, (hl)
    call    TitleEraseLine

    ; アニメーションの更新
    inc     (hl)
    ld      a, (hl)
    cp      #0x18
    jr      c, 90$

    ; アニメーションの設定
    ld      a, #TITLE_ANIMATION_NEXT
    ld      (_title + TITLE_ANIMATION), a

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x05 : 画面の完了
50$:
;   dec     a
;   jr      nz, 60$

    ; アニメーションの更新
    ld      hl, #(_title + TITLE_ANIMATION)
    dec     (hl)
    jr      nz, 90$

    ; カウントの更新
    ld      hl, #(_title + TITLE_COUNT)
    inc     (hl)
    ld      a, (hl)
    cp      #0x02
    jr      nc, 80$

    ; 状態の更新
    ld      a, #0x01
    ld      (_title + TITLE_STATE), a
    jr      90$

    ; 処理の更新
80$:
    ld      hl, #TitleIdle
    ld      (_title + TITLE_PROC_L), hl
    xor     a
    ld      (_title + TITLE_STATE), a
;   jr      90$

    ; プロローグの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; タイトルを待機する
;
TitleIdle:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    or      a
    jr      nz, 09$

    ; 待機の表示
    call    TitlePrintIdlePatternName

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; 0x01 : 待機
10$:
    ld      a, (_title + TITLE_STATE)
    dec     a
    jr      nz, 20$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_BOOT
    call    _SoundPlaySe

    ; アニメーションの設定
    ld      a, #TITLE_ANIMATION_START
    ld      (_title + TITLE_ANIMATION), a

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 開始
20$:
;   dec     a
;   jr      nz, 30$

    ; アニメーションの更新
    ld      hl, #(_title + TITLE_ANIMATION)
    dec     (hl)
    jr      nz, 90$

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 状態の設定
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
    jr      99$
    
    ; 待機の完了
90$:
   call    TitlePrintIdleSprite
99$:

    ; レジスタの復帰

    ; 終了
    ret

; VRAM へ転送する
;
TitleTransfer:

    ; レジスタの保存

    ; d < ポート #0
    ; e < ポート #1

    ; レジスタの復帰

    ; 終了
    ret

; センタリングした表示位置を取得する
;
TitleCentering:

    ; レジスタの保存
    push    hl

    ; hl < 文字列
    ; d  < Y 位置
    ; de > 表示位置
    
    ; 文字列長の取得
    ld      e, #0x00
10$:
    ld      a, (hl)
    or      a
    jr      z, 11$
    inc     e
    inc     hl
    jr      10$
11$:
    ld      a, e
    inc     a
    and     #0xfe
    sub     #0x20
    neg
    srl     a
    ld      e, a

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
TitlePrintString:

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

; １行消す
;
TitleEraseLine:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; d < Y 位置

    ; １行消去
    xor     a
    srl     d
    rra
    srl     d
    rra
    srl     d
    rra
    ld      e, a
    ld      hl, #_patternName
    add     hl, de
    xor     a
    ld      b, #0x20
10$:
    ld      (hl), a
    inc     hl
    djnz    10$

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 待機を表示する
;
TitlePrintIdlePatternName:

    ; レジスタの保存

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; ロゴの表示
    ld      hl, #(_patternName + 6 * 0x0020 + 4)
    ld      de, #(0x0020 - 0x0018)
    ld      a, #0xb8
    ld      c, #0x03
10$:
    ld      b, #0x18
11$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    11$
    add     hl, de
    dec     c
    jr      nz, 10$

    ; ジャンルの表示
    ld      hl, #titleIdleGenreString
    ld      d, #4
    call    TitleCentering
    call    TitlePrintString

    ; 開始の表示
    ld      hl, #titleIdleStartString
    ld      d, #16
    call    TitleCentering
    call    TitlePrintString

    ; レジスタの復帰

    ; 終了
    ret

TitlePrintIdleSprite:

    ; レジスタの保存

    ; スプライトの描画
    ld      hl, #titleIdleSprite
    ld      de, #_sprite
    ld      bc, #(0x0d * 0x04)
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; タイトルの初期値
;
titleDefault:

    .dw     TITLE_PROC_NULL
    .db     TITLE_STATE_NULL
    .db     TITLE_FLAG_NULL
    .db     TITLE_FRAME_NULL
    .db     TITLE_COUNT_NULL
    .dw     TITLE_STRING_NULL
    .db     TITLE_ANIMATION_NULL

; プロローグ
;
titlePrologueString_0:

    .db     4
    .dw     titlePrologueString_0_0
    .db     7
    .dw     titlePrologueString_0_1
    .db     9
    .dw     titlePrologueString_0_2
    .db     11
    .dw     titlePrologueString_0_3
    .db     14
    .dw     titlePrologueString_0_4
    .db     16
    .dw     titlePrologueString_0_5
    .db     0xff

titlePrologueString_0_0:

    .db     _LES, ____, _HNA, _HSE, _KSN, _HTA, _HTA, _HKA, _H_U, _HNO, _HKA, ____, _HKA, _HYO, _HWA, _HKI, _HNI, _H_N, _HKE, _KSN, _H_N, _HYO, ____, _GRT, 0x00

titlePrologueString_0_1:

    .db     _HTO, _HMO, _HKA, _KSN, _HMI, _HNA, _HSI, _HSI, _HTA, _HRE, _HHA, _KSN, _HKO, _HSO, ____, _HTA, _HTA, _HKA, _H_U, _HNO, _HTA, _KSN, ____, _HHA, _HKU, _HRI, _Hyu, _H_U, _HYO, _DOT, _DOT, _DOT, 0x00

titlePrologueString_0_2:

    .db     _H_I, _HMA, _HHA, _HWA, _HKA, _KSN, _HKI, _HSI, _HTA, _KSN, _H_N, _HNO, _HMA, _HKE, _HTA, _KSN, _DOT, _DOT, _DOT, 0x00

titlePrologueString_0_3:

    .db     _HTA, _KSN, _HKA, _KSN, _H_I, _HTU, _HNO, _HHI, _HKA, ____, _HKA, _HNA, _HRA, _HSU, _KSN, _HYA, _DOT, _DOT, _DOT, _HSE, _H_I, _HKI, _KSN, _HKA, _KSN, _DOT, _DOT, _DOT, 0x00

titlePrologueString_0_4:

    .db     _HSO, _HRE, _HKA, _KSN, _KSA, _KRI, _K_N, _HSE, _H_I, _HKI, _HSI, _HTA, _KSN, _H_N, _KSA, _MNS, _KMP, _KKU, _KSN, _KRI, _KHU, _KPS, _KSU, _HNO, 0x00

titlePrologueString_0_5:

    .db     _HSA, _H_I, _HKO, _KSN, _HNO, _HKO, _HTO, _HHA, _KSN, _HTE, _KSN, _H_A, _Htu, _HTA, 0x00

titlePrologueString_1:

    .db     7
    .dw     titlePrologueString_1_0
    .db     11
    .dw     titlePrologueString_1_1
    .db     13
    .dw     titlePrologueString_1_2
    .db     0xff

titlePrologueString_1_0:

    .db     _HSO, _HRE, _HKA, _HRA, ___1, ___0, _HNE, _H_N, 0x00

titlePrologueString_1_1:

    .db     _KSA, _MNS, _KMP, _KKU, _KSN, _KRI, _KHU, _KPS, _KSU, _HNO, _HKO, ____, _K_A, _KRE, _Ktu, _KKU, _KSU, _HKA, _KSN, 0x00

titlePrologueString_1_2:

    .db     _HHA, _HKU, _HRI, _Hyu, _H_U, _HNO, _HSI, _HRO, _HTI, _HKA, _HKU, _HNO, _HMA, _HTI, ____, _KHO, _KWA, _K_I, _KTO, _KRA, _K_I, _K_N, _HNI, _HTU, _H_I, _HTA, 0x00

; 待機
;
titleIdleGenreString:

    .db     _KSI, _K_N, _KHU, _KPS, _KRU, ____, _KHU, _K_a, _K_N, _KTA, _KSI, _KSN, _K_i, ____, _KTA, _KSN, _K_I, _KSU, _KKE, _KSN, _MNS, _KMU, 0x00

titleIdleStartString:

    .db     ____, _HTA, _KSN, _H_I, _HSU, _HKU, _H_E, _HSU, _HTO, _HWO, ____, _HHA, _HSI, _KSN, _HME, _HRU, 0x00

titleIdleSprite:

    .db     0x28 - 0x01, 0x60, 0x20, VDP_COLOR_MEDIUM_RED
    .db     0x28 - 0x01, 0x70, 0x24, VDP_COLOR_MEDIUM_RED
    .db     0x38 - 0x01, 0x60, 0x28, VDP_COLOR_MEDIUM_RED
    .db     0x38 - 0x01, 0x70, 0x2c, VDP_COLOR_MEDIUM_RED
    .db     0x28 - 0x01, 0x60, 0x30, VDP_COLOR_LIGHT_YELLOW
    .db     0x28 - 0x01, 0x70, 0x34, VDP_COLOR_LIGHT_YELLOW
    .db     0x38 - 0x01, 0x60, 0x38, VDP_COLOR_LIGHT_YELLOW
    .db     0x38 - 0x01, 0x70, 0x3c, VDP_COLOR_LIGHT_YELLOW
    .db     0x4c - 0x01, 0x88, 0x40, VDP_COLOR_MEDIUM_RED
    .db     0x4c - 0x01, 0x98, 0x44, VDP_COLOR_MEDIUM_RED
    .db     0x4c - 0x01, 0xa8, 0x48, VDP_COLOR_MEDIUM_RED
    .db     0x4c - 0x01, 0xb8, 0x4c, VDP_COLOR_MEDIUM_RED
    .db     0x80 - 0x01, 0x40, 0x18, VDP_COLOR_MEDIUM_RED


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; タイトル
;
_title::

    .ds     TITLE_LENGTH

; 数値
;
titleValue:

    .ds     0x08
