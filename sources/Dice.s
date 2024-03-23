; Dice.s : ダイス
;


; モジュール宣言
;
    .module Dice

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Math.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Dice.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ダイスを初期化する
;
_DiceInitialize::
    
    ; レジスタの保存
    
    ; ダイスの初期化
    ld      hl, #(_dice + 0x0000)
    ld      de, #(_dice + 0x0001)
    ld      bc, #(DICE_LENGTH * DICE_ENTRY - 0x0001)
    ld      (hl), #0x00
    ldir

    ; スプライトの初期化
    xor     a
    ld      (diceSpriteRotate), a

    ; レジスタの復帰
    
    ; 終了
    ret

; ダイスを更新する
;
_DiceUpdate::

    ; レジスタの保存

    ; ダイスの走査
    ld      ix, #_dice
    ld      b, #DICE_ENTRY
10$:
    push    bc

    ; 種類別の処理
    ld      l, DICE_PROC_L(ix)
    ld      h, DICE_PROC_H(ix)
    ld      a, h
    or      l
    jr      z, 19$
    ld      de, #11$
    push    de
    jp      (hl)
;   pop     hl
11$:

    ; 次のダイスへ
19$:
    ld      bc, #DICE_LENGTH
    add     ix, bc
    pop     bc
    djnz    10$

    ; レジスタの復帰

    ; 終了
    ret

; ダイスを描画する
;
_DiceRender::

    ; レジスタの保存

    ; ダイスの走査
    ld      ix, #_dice
    ld      a, (diceSpriteRotate)
    ld      e, a
    ld      d, #0x00
    ld      b, #DICE_ENTRY
10$:
    push    bc

    ; 描画の確認
    ld      a, DICE_PROC_H(ix)
    or      DICE_PROC_L(ix)
    jr      z, 19$
    ld      a, DICE_FACE(ix)
    or      a
    jr      z, 19$

    ; 位置の確認
    ld      a, DICE_ROLL_X(ix)
    add     a, DICE_OFFSET_X(ix)
    cp      #0xd0
    jr      c, 11$
    cp      #0xf8
    jr      c, 19$
11$:
    ld      c, a

    ; スプライトの描画
    ld      l, DICE_SPRITE_L(ix)
    ld      h, DICE_SPRITE_H(ix)
    ld      b, #0x04
12$:
    push    de
    push    hl
    ld      hl, #_sprite
    add     hl, de
    ex      de, hl
    pop     hl
    ld      a, (hl)
    add     a, DICE_ROLL_Y(ix)
    add     a, DICE_OFFSET_Y(ix)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, c
    add     a, #0x20
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    or      #0x80
    ld      (de), a
    inc     hl
;   inc     de
    pop     de

    ; スプライトのローテート
    ld      a, e
    add     a, #0x04
    and     #(DICE_ENTRY * 0x04 * 0x04 - 0x01)
    ld      e, a
    djnz    12$

    ; 次のダイスへ
19$:
    ld      bc, #DICE_LENGTH
    add     ix, bc
    pop     bc
    djnz    10$

    ; スプライトの更新
    ld      a, (diceSpriteRotate)
    add     a, #0x04
    and     #(DICE_ENTRY * 0x04 - 0x01)
    ld      (diceSpriteRotate), a

    ; レジスタの復帰

    ; 終了
    ret

; ダイスを読み込む
;
_DiceLoad::

    ; レジスタの保存

    ; d < ダイスの種類
    ; e < ダイスの数

    ; ダイスのクリア
    push    de
    ld      hl, #(_dice + 0x0000)
    ld      de, #(_dice + 0x0001)
    ld      bc, #(DICE_LENGTH * DICE_ENTRY)
    ld      (hl), #0x00
    ldir
    pop     de

    ; ダイスの設定
    ld      c, d
    ld      b, e
    ld      ix, #_dice
    ld      hl, #diceOffset
10$:
    ld      de, #DiceWait
    ld      DICE_PROC_L(ix), e
    ld      DICE_PROC_H(ix), d
    ld      DICE_TYPE(ix), c
    ld      a, (hl)
    ld      DICE_OFFSET_X(ix), a
    inc     hl
    ld      a, (hl)
    ld      DICE_OFFSET_Y(ix), a
    inc     hl
    ld      a, #DICE_ENTRY
    sub     b
    add     a, a
    inc     a
    ld      DICE_ANIMATION(ix), a
    ld      de, #DICE_LENGTH
    add     ix, de
    djnz    10$

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
DiceNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ダイスを待機させる
;
DiceWait:

    ; レジスタの保存

    ; 初期化
    ld      a, DICE_STATE(ix)
    or      a
    jr      nz, 09$

    ; 初期化の完了
    inc     DICE_STATE(ix)
09$:

    ; アニメーションの更新
    dec     DICE_ANIMATION(ix)
    jr      nz, 19$

    ; 処理の更新
    ld      hl, #DiceRoll
    ld      DICE_PROC_L(ix), l
    ld      DICE_PROC_H(ix), h
    ld      DICE_STATE(ix), #0x00
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ダイスを振る
;
DiceRoll:

    ; レジスタの保存

    ; 初期化
    ld      a, DICE_STATE(ix)
    or      a
    jr      nz, 09$

    ; アニメーションの設定
    ld      DICE_ANIMATION(ix), #0x00

    ; キーボードバッファのクリア
    call    KILBUF

    ; 初期化の完了
    inc     DICE_STATE(ix)
09$:

    ; 振る
10$:
    call    _SystemGetRandom
    rlca
    and     #0x07
    cp      #0x06
    jr      nc, 10$
    inc     a
    ld      DICE_FACE(ix), a

    ; チート
    ld      a, DICE_ANIMATION(ix)
    cp      #(DICE_ANIMATION_ROLL - 0x01)
    jr      c, 19$
    ld      a, DICE_CHEAT(ix)
    or      a
    jr      z, 19$
    ld      DICE_FACE(ix), a
19$:

    ; 転がす
    ld      a, DICE_ANIMATION(ix)
    add     a, a
    call    _MathGetSin
    srl     d
    rr      e
    ld      a, e
    srl     e
    add     a, e
    ld      DICE_ROLL_X(ix), a
    ld      a, DICE_ANIMATION(ix)
    and     #0x07
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    call    _MathGetSin
    ld      a, DICE_ANIMATION(ix)
    and     #0x18
    rrca
    ld      b, a
    ld      a, #0x10
    sub     b
    ld      b, a
    ld      hl, #0x0000
20$:
    add     hl, de
    djnz    20$
    ld      a, h
    neg
    ld      DICE_ROLL_Y(ix), a

    ; スプライトの設定
    ld      a, DICE_TYPE(ix)
    dec     a
    ld      e, #0x00
    srl     a
    rr      e
    ld      d, a
    ld      a, DICE_FACE(ix)
    dec     a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      l, a
    ld      h, #0x00
    add     hl, de
    ld      de, #diceSprite
    add     hl, de
    ld      DICE_SPRITE_L(ix), l
    ld      DICE_SPRITE_H(ix), h

    ; アニメーションの更新
    inc     DICE_ANIMATION(ix)
    ld      a, DICE_ANIMATION(ix)
    cp      #DICE_ANIMATION_ROLL
    jr      c, 99$

    ; 状態の更新
    ld      hl, #DiceDone
    ld      DICE_PROC_L(ix), l
    ld      DICE_PROC_H(ix), h
    ld      DICE_STATE(ix), #0x00
99$:

    ; レジスタの復帰

    ; 終了
    ret

; ダイスが止まる
;
DiceDone:

    ; レジスタの保存

    ; 初期化
    ld      a, DICE_STATE(ix)
    or      a
    jr      nz, 09$

    ; アニメーションの設定
    ld      DICE_ANIMATION(ix), #DICE_ANIMATION_DONE

    ; 初期化の完了
    inc     DICE_STATE(ix)
09$:

    ; アニメーションの更新
    ld      a, DICE_ANIMATION(ix)
    or      a
    jr      z, 19$
    dec     DICE_ANIMATION(ix)
    jr      nz, 19$

    ; フラグの設定
    set     #DICE_FLAG_DONE_BIT, DICE_FLAG(ix)
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ダイスの面を取得する
;
_DiceGetFace::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; a < ダイスのインデックス
    ; a > ダイスの面

    ; ダイスの取得
    ld      ix, #_dice
    ld      de, #DICE_LENGTH
    or      a
    jr      z, 19$
    ld      b, a
10$:
    add     ix, de
    djnz    10$
19$:

    ; 面の取得
    xor     a
    bit     #DICE_FLAG_DONE_BIT, DICE_FLAG(ix)
    jr      z, 29$
    ld      a, DICE_FACE(ix)
29$:

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; チートを設定する
;
_DiceCheat::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; a < チートする面

    ; チートの設定
    ld      ix, #_dice
    ld      de, #DICE_LENGTH
    ld      c, a
    ld      b, #DICE_ENTRY
10$:
    ld      a, DICE_TYPE(ix)
    or      a
    jr      z, 11$
    ld      DICE_CHEAT(ix), c
11$:
    add     ix, de
    djnz    10$

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; チートするかどうかを判定する
;
_DiceIsCheat::

    ; レジスタの保存

    ; cf > 1 = チートする
    ; a  > チートする面
    
    ; 1 〜 6 で仕込む
10$:
    call    CHSNS
    jr      z, 18$
    call    CHGET
    sub     #'1
    jr      c, 10$
    cp      #0x06
    jr      nc, 10$
    inc     a
    scf
    jr      19$
18$:
    xor     a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; オフセット
;
diceOffset:

    .db     -18,  88
    .db      -8, 120
    .db       0,  72
    .db     -36, 104

; スプライト
;
diceSprite:

    ; 迷宮
    .db     -0x08 - 0x01, -0x08, 0x80, VDP_COLOR_WHITE          ; 1
    .db     -0x08 - 0x01, -0x08, 0xa0, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0xc0, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0xe0, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x84, VDP_COLOR_WHITE          ; 2
    .db     -0x08 - 0x01, -0x08, 0xa4, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0xc4, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0xe4, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x88, VDP_COLOR_WHITE          ; 3
    .db     -0x08 - 0x01, -0x08, 0xa8, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0xc8, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0xe8, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x8c, VDP_COLOR_WHITE          ; 4
    .db     -0x08 - 0x01, -0x08, 0xac, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0xcc, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0xec, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x90, VDP_COLOR_WHITE          ; 5
    .db     -0x08 - 0x01, -0x08, 0xb0, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0xd0, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0xf0, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x94, VDP_COLOR_WHITE          ; 6
    .db     -0x08 - 0x01, -0x08, 0xb4, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0xd4, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0xf4, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT    ; -
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT    ; -
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    ; 戦闘
    .db     -0x08 - 0x01, -0x08, 0x80, VDP_COLOR_WHITE          ; 1
    .db     -0x08 - 0x01, -0x08, 0xa0, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xc0, VDP_COLOR_MEDIUM_GREEN
    .db     -0x08 - 0x01, -0x08, 0xe0, VDP_COLOR_DARK_BLUE
    .db     -0x08 - 0x01, -0x08, 0x84, VDP_COLOR_WHITE          ; 2
    .db     -0x08 - 0x01, -0x08, 0xa4, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xc4, VDP_COLOR_MEDIUM_GREEN
    .db     -0x08 - 0x01, -0x08, 0xe4, VDP_COLOR_DARK_BLUE
    .db     -0x08 - 0x01, -0x08, 0x88, VDP_COLOR_WHITE          ; 3
    .db     -0x08 - 0x01, -0x08, 0xa8, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xc8, VDP_COLOR_MEDIUM_GREEN
    .db     -0x08 - 0x01, -0x08, 0xe8, VDP_COLOR_DARK_BLUE
    .db     -0x08 - 0x01, -0x08, 0x8c, VDP_COLOR_WHITE          ; 4
    .db     -0x08 - 0x01, -0x08, 0xac, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xcc, VDP_COLOR_MEDIUM_GREEN
    .db     -0x08 - 0x01, -0x08, 0xec, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x90, VDP_COLOR_WHITE          ; 5
    .db     -0x08 - 0x01, -0x08, 0xb0, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xd0, VDP_COLOR_LIGHT_RED
    .db     -0x08 - 0x01, -0x08, 0xf0, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x94, VDP_COLOR_WHITE          ; 6
    .db     -0x08 - 0x01, -0x08, 0xb4, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xd4, VDP_COLOR_LIGHT_RED
    .db     -0x08 - 0x01, -0x08, 0xf4, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT    ; -
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT    ; -
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    ; 財宝
    .db     -0x08 - 0x01, -0x08, 0x80, VDP_COLOR_WHITE          ; 1
    .db     -0x08 - 0x01, -0x08, 0xa0, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xc0, VDP_COLOR_GRAY
    .db     -0x08 - 0x01, -0x08, 0xe0, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0x84, VDP_COLOR_WHITE          ; 2
    .db     -0x08 - 0x01, -0x08, 0xa4, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xc4, VDP_COLOR_GRAY
    .db     -0x08 - 0x01, -0x08, 0xe4, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0x88, VDP_COLOR_WHITE          ; 3
    .db     -0x08 - 0x01, -0x08, 0xa8, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xc8, VDP_COLOR_GRAY
    .db     -0x08 - 0x01, -0x08, 0xe8, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0x8c, VDP_COLOR_WHITE          ; 4
    .db     -0x08 - 0x01, -0x08, 0xac, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xcc, VDP_COLOR_GRAY
    .db     -0x08 - 0x01, -0x08, 0xec, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0x90, VDP_COLOR_WHITE          ; 5
    .db     -0x08 - 0x01, -0x08, 0xb0, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xd0, VDP_COLOR_GRAY
    .db     -0x08 - 0x01, -0x08, 0xf0, VDP_COLOR_BLACK
    .db     -0x08 - 0x01, -0x08, 0x94, VDP_COLOR_WHITE          ; 6
    .db     -0x08 - 0x01, -0x08, 0xb4, VDP_COLOR_DARK_YELLOW
    .db     -0x08 - 0x01, -0x08, 0xd4, VDP_COLOR_GRAY
    .db     -0x08 - 0x01, -0x08, 0xf4, VDP_COLOR_CYAN
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT    ; -
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT    ; -
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x08 - 0x01, -0x08, 0x00, VDP_COLOR_TRANSPARENT


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ダイス
;
_dice::
    
    .ds     DICE_LENGTH * DICE_ENTRY

; スプライト
;
diceSpriteRotate:

    .ds     0x01

