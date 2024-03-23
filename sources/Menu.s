; Menu.s : メニュー
;


; モジュール宣言
;
    .module Menu

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Menu.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; メニューを初期化する
;
_MenuInitialize::
    
    ; レジスタの保存
    
    ; メニューの初期化
    ld      hl, #(_menu + 0x0000)
    ld      de, #(_menu + 0x0001)
    ld      bc, #(MENU_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir
    
    ; レジスタの復帰
    
    ; 終了
    ret

; メニューを更新する
;
_MenuUpdate::
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_menu + MENU_STATE)
    or      a
    jr      nz, 09$

    ; キーバッファのクリア
    call    KILBUF

    ; 初期化の完了
    ld      hl, #(_menu + MENU_STATE)
    inc     (hl)
09$:

    ; 選択あるいはキャンセル済み
    ld      hl, #(_menu + MENU_FLAG)
    ld      a, (hl)
    and     #(MENU_FLAG_SELECT | MENU_FLAG_CANCEL)
    jr      nz, 190$

    ; 選択
100$:
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 110$
    set     #MENU_FLAG_SELECT_BIT, (hl)
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    jr      190$

    ; キャンセル
110$:
    ld      a, (_input + INPUT_BUTTON_SHIFT)
    dec     a
    jr      nz, 120$
    set     #MENU_FLAG_CANCEL_BIT, (hl)
    ld      a, #SOUND_SE_CANCEL
    call    _SoundPlaySe
    jr      190$

    ; 縦メニュー
120$:
    ld      a, (_menu + MENU_SPACE)
    or      a
    jr      nz, 130$
    ld      a, (_input + INPUT_KEY_UP)
    dec     a
    jr      z, 140$
    ld      a, (_input + INPUT_KEY_DOWN)
    dec     a
    jr      z, 150$
    jr      190$

    ; 横メニュー
130$:
    ld      a, (_input + INPUT_KEY_LEFT)
    dec     a
    jr      z, 140$
    ld      a, (_input + INPUT_KEY_RIGHT)
    dec     a
    jr      z, 150$
    jr      190$

    ; カーソルの移動（ー）
140$:
    ld      a, (_menu + MENU_CURSOR)
    or      a
    jr      z, 141$
    dec     a
    ld      (_menu + MENU_CURSOR), a
141$:
    jr      190$
    
    ; カーソルの移動（＋）
150$:
    ld      a, (_menu + MENU_SIZE)
    ld      e, a
    ld      a, (_menu + MENU_CURSOR)
    inc     a
    cp      e
    jr      nc, 151$
    ld      (_menu + MENU_CURSOR), a
151$:
;   jr      190$
    
    ; メニューの完了
190$:

    ; レジスタの復帰
    
    ; 終了
    ret

; メニューを描画する
;
_MenuRender::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; カーソルの描画
    ld      hl, #(_sprite + 0x007c)
    ld      de, (_menu + MENU_POSITION_X)
    ld      a, (_menu + MENU_SPACE)
    or      a
    jr      nz, 10$
    ld      a, (_menu + MENU_CURSOR)
    add     a, d
    ld      d, a
    jr      12$
10$:
    ld      c, a
    ld      a, (_menu + MENU_CURSOR)
    ld      b, a
    ld      a, e
11$:
    add     a, c
    djnz    11$
    ld      e, a
12$:
    ld      a, d
    add     a, a
    add     a, a
    add     a, a
    dec     a
    ld      (hl), a
    inc     hl
    ld      a, e
    add     a, a
    add     a, a
    add     a, a
    ld      (hl), a
    inc     hl
    ld      (hl), #0x18
    inc     hl
    ld      (hl), #VDP_COLOR_DARK_RED
;   icn     hl

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; メニューを読み込む
;
_MenuLoad::

    ; レジスタの保存

    ; de < Y/X 位置
    ; c  < 項目数
    ; b  < 横の間隔
    ; a  < 初期の選択

    ; パラメータの保持
    ld      (_menu + MENU_POSITION_X), de
    cp      c
    jr      c, 10$
    xor     a
10$:
    ld      (_menu + MENU_CURSOR), a
    ld      a, c
    ld      (_menu + MENU_SIZE), a
    ld      a, b
    ld      (_menu + MENU_SPACE), a
    xor     a
    ld      (_menu + MENU_STATE), a
    ld      (_menu + MENU_FLAG), a

    ; レジスタの復帰

    ; 終了
    ret

; メニューが選択されたかどうかを判定する
;
_MenuIsSelect::

    ; レジスタの保存

    ; cf > 1 = 選択

    ; 選択の判定
    ld      a, (_menu + MENU_FLAG)
    bit     #MENU_FLAG_SELECT_BIT, a
    jr      z, 18$
    scf
    jr      19$
18$:
    or      a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; メニューがキャンセルされたどうかを判定する
;
_MenuIsCancel::

    ; レジスタの保存

    ; cf > 1 = キャンセル

    ; キャンセルの判定
    ld      a, (_menu + MENU_FLAG)
    bit     #MENU_FLAG_CANCEL_BIT, a
    jr      z, 18$
    scf
    jr      19$
18$:
    or      a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 選択された項目を取得する
;
_MenuGetItem::

    ; レジスタの保存

    ; a > 項目

    ; 項目の取得
    ld      a, (_menu + MENU_CURSOR)

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; メニュー
;
_menu::

    .ds     MENU_LENGTH

