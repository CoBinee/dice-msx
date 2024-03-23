; Enemy.s : エネミー
;


; モジュール宣言
;
    .module Enemy

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Enemy.inc"

; 外部変数宣言
;
    .globl  _monsterTable_1
    .globl  _monsterTable_2
    .globl  _monsterTable_3
    .globl  _monsterTable_4
    .globl  _monsterTable_5
    .globl  _monsterTable_6
    .globl  _monsterTable_7

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; エネミーを初期化する
;
_EnemyInitialize::
    
    ; レジスタの保存
    
    ; エネミーの初期化
    ld      hl, #(_enemy + 0x0000)
    ld      de, #(_enemy + 0x0001)
    ld      bc, #(ENEMY_LENGTH * ENEMY_ENTRY - 0x0001)
    ld      (hl), #0x00
    ldir

    ; レジスタの復帰
    
    ; 終了
    ret

; エネミーを読み込む
;
_EnemyLoad::

    ; レジスタの保存
    
    ; a < グループ

    ; エネミーのクリア
    ld      hl, #(_enemy + 0x0000)
    ld      de, #(_enemy + 0x0001)
    ld      bc, #(ENEMY_LENGTH * ENEMY_ENTRY - 0x0001)
    ld      (hl), #0x00
    ldir

    ; エネミーの設定
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #enemyGroup
    add     hl, de
    ld      de, #_enemy
    ld      bc, #((ENEMY_ENTRY << 8) | 0x00)
20$:
    ld      a, (hl)
    or      a
    jr      z, 29$
    push    bc
    push    hl
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      c, a
    ld      b, #0x00
    ld      hl, #enemyDefault
    add     hl, bc
    ld      bc, #ENEMY_LENGTH
    ldir
    pop     hl
    inc     hl
    pop     bc
    inc     c
    djnz    20$
29$:

    ; 表示位置の設定
    ld      a, c
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #enemyLocate
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      ix, #_enemy
    ld      b, c
30$:
    push    bc
    ld      ENEMY_LOCATE_L(ix), e
    ld      ENEMY_LOCATE_H(ix), d
    ld      hl, #0x0008
    add     hl, de
    ex      de, hl
    ld      bc, #ENEMY_LENGTH
    add     ix, bc
    pop     bc
    djnz    30$

    ; パターンジェネレータの読み込み
    ld      ix, #_enemy
    ld      hl, #(APP_COLOR_TABLE + 0x0800)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
    ld      b, #ENEMY_ENTRY
40$:
    push    bc
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 49$
    push    hl
    push    de
    push    hl
    ld      l, ENEMY_PATTERN_L(ix)
    ld      h, ENEMY_PATTERN_H(ix)
    ld      bc, #0x01c0
    call    LDIRVM
    pop     hl
    ld      a, ENEMY_COLOR(ix)
    ld      bc, #0x01c0
    call    FILVRM
    ld      bc, #0x0200
    pop     hl
    add     hl, bc
    ex      de, hl
    pop     hl
    add     hl, bc
49$:
    ld      bc, #ENEMY_LENGTH
    add     ix, bc
    pop     bc
    djnz    40$

    ; レジスタの復帰

    ; 終了
    ret

; エネミーを取得する
;
EnemyGet:

    ; レジスタの保存
    push    de

    ; a  < 対象
    ; ix > エネミー

    ; エネミーの取得
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      ix, #_enemy
    add     ix, de

    ; レジスタの復帰
    pop     de

    ; 終了
    ret

; 攻撃の対象を取得する
;
_EnemyGetTarget::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; a  < 対象の開始
    ; a  > 対象
    ; cf > 1 = 対象が存在する

    ;　対象の取得
    cp      #ENEMY_ENTRY
    jr      nc, 18$
    ld      b, a
    call    EnemyGet
    ld      de, #ENEMY_LENGTH
10$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 11$
    ld      a, ENEMY_LIFE(ix)
    or      a
    jr      nz, 12$
11$:
    add     ix, de
    inc     b
    ld      a, b
    cp      #ENEMY_ENTRY
    jr      c, 10$
    jr      18$
12$:
    ld      a, b
    scf
    jr      19$
18$:
    or      a
19$:
    
    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; 攻撃対象のエネミーの種類を取得する
;
_EnemyGetTargetType::

    ; レジスタの保存
    push    ix

    ; a < 対象
    ; a > 種類

    ; 名前の取得
    call    EnemyGet
    ld      a, ENEMY_TYPE(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; 攻撃対象のエネミーの名前を取得する
;
_EnemyGetTargetName::

    ; レジスタの保存
    push    ix

    ; a  < 対象
    ; hl > 名前

    ; 名前の取得
    call    EnemyGet
    ld      l, ENEMY_NAME_L(ix)
    ld      h, ENEMY_NAME_H(ix)

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; 攻撃対象のエネミーが生存しているかどうかを判定する
;
_EnemyIsTargetLive::

    ; レジスタの保存
    push    ix

    ; a  < キャラクタ
    ; cf > 1 = 生存

    ; 生存の判定
    call    EnemyGet
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 19$
    ld      a, ENEMY_LIFE(ix)
    or      a
    jr      z, 19$
    scf
19$:

    ; レジスタの復帰
    pop     ix

    ; 終了
    ret

; 攻撃対象のエネミーにダメージを与える
;
_EnemyTakeTargetDamage::

    ; レジスタの保存
    push    ix

    ; a  < 対象
    ; d  < ダメージ
    ; cf > 1 = 生存

    ; ダメージを与える
    call    EnemyGet
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 18$
    ld      a, ENEMY_LIFE(ix)
    sub     d
    jr      nc, 10$
    xor     a
10$:
    ld      ENEMY_LIFE(ix), a
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

; グループのエネミー数を取得する
;
_EnemyGetGroupNumber::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; a > エネミー数

    ; 経験値の取得
    ld      ix, #_enemy
    ld      de, #ENEMY_LENGTH
    ld      bc, #((ENEMY_ENTRY << 8) | 0x00)
10$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 11$
    inc     c
11$:
    add     ix, de
    djnz    10$
    ld      a, c

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; エネミーのグループの総経験値を取得する
;
_EnemyGetGroupExperience::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; a > 経験値

    ; 経験値の取得
    ld      ix, #_enemy
    ld      de, #ENEMY_LENGTH
    ld      bc, #((ENEMY_ENTRY << 8) | 0x00)
10$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 11$
    ld      a, ENEMY_EXPERIENCE(ix)
    add     a, c
    ld      c, a
11$:
    add     ix, de
    djnz    10$
    ld      a, c

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; エネミーのグループが生存しているかどうかを判定する
;
_EnemyIsGroupLive::

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; cf > 1 = 生存

    ; 生存の確認
    ld      ix, #_enemy
    ld      de, #ENEMY_LENGTH
    ld      b, #ENEMY_ENTRY
10$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 11$
    ld      a, ENEMY_LIFE(ix)
    or      a
    jr      nz, 12$
11$:
    add     ix, de
    djnz    10$
    or      a
    jr      19$
12$:
    scf
19$:

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; エネミーのグループを表示する
;
_EnemyPrintGroup::

    ; レジスタの保存
    push    hl
    push    bc
    push    de
    push    ix

    ; 枠の表示
    ld      de, #(_patternName + 0 * 0x0020 + 1)
    ld      bc, #((5 << 8) | 30)
    call    _GamePrintFrame

    ; グループの表示
    call    _GameClearString
    ld      ix, #_enemy
    ld      b, #ENEMY_ENTRY
20$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 28$
    ld      a, ENEMY_LIFE(ix)
    or      a
    jr      z, 28$
    ld      l, ENEMY_NAME_L(ix)
    ld      h, ENEMY_NAME_H(ix)
    call    _GameConcatString
    ld      de, #ENEMY_LENGTH
    ld      a, ENEMY_TYPE(ix)
    ld      c, #0x01
21$:
    add     ix, de
    dec     b
    jr      z, 22$
    cp      ENEMY_TYPE(ix)
    jr      nz, 22$
    inc     c
    jr      21$
22$:
    ld      a, c
    cp      #0x02
    jr      c, 23$
    ld      hl, #enemyGroupString_0
    call    _GameConcatString
    ld      l, c
    ld      h, #0x00
    call    _GameConcatValue
    ld      hl, #enemyGroupString_1
    call    _GameConcatString
23$:
    ld      hl, #enemyGroupString_2
    call    _GameConcatString
    ld      a, b
    or      a
    jr      nz, 20$
    jr      29$
28$:
    ld      de, #ENEMY_LENGTH
    add     ix, de
    djnz    20$
;   jr      29$
29$:
    call    _GameGetString
    ld      de, #(_patternName + 1 * 0x0020 + 3)
    call    _GamePrintString

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; エネミーをアニメーションさせる
;
_EnemyAnimate::

    ; レジスタの保存
    push    hl
    push    bc
    push    de
    push    ix

    ; cf > 1 = アニメーションの完了

    ; アニメーションの更新
    ld      ix, #_enemy
    ld      de, #ENEMY_LENGTH
    ld      bc, #((ENEMY_ENTRY << 8) | 0x00)
10$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 19$
    ld      a, ENEMY_LIFE(ix)
    or      a
    jr      z, 12$
    ld      a, ENEMY_ANIMATION(ix)
    cp      #ENEMY_ANIMATION_ENCOUNT
    jr      nc, 11$
    inc     a
11$:
    ld      ENEMY_ANIMATION(ix), a
    cp      #ENEMY_ANIMATION_ENCOUNT
    jr      c, 18$
    jr      19$
12$:
    ld      a, ENEMY_ANIMATION(ix)
    or      a
    jr      z, 13$
    dec     a
13$:
    ld      ENEMY_ANIMATION(ix), a
    or      a
    jr      nz, 18$
    jr      19$
18$:
    inc     c
;   jr      19$
19$:
    add     ix, de
    djnz    10$
    push    bc

    ; クリア
    ld      hl, #(_patternName + 9 * 0x0020 + 0x0000)
    ld      de, #(_patternName + 9 * 0x0020 + 0x0001)
    ld      bc, #(0x00e0 - 0x0001)
    ld      (hl), #____
    ldir

    ; パターンの描画
    ld      ix, #_enemy
    ld      bc, #((ENEMY_ENTRY << 8) | 0x00)
30$:
    push    bc
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 39$
    ld      l, ENEMY_LOCATE_L(ix)
    ld      h, ENEMY_LOCATE_H(ix)
    ld      a, ENEMY_ANIMATION(ix)
    srl     a
    jr      z, 39$
    ld      b, a
    sub     #0x07
    neg
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    add     hl, de
    ld      a, c
31$:
    push    bc
    ld      b, #0x08
32$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    32$
    ld      bc, #(0x0020 - 0x0008)
    add     hl, bc
    pop     bc
    djnz    31$
39$:
    ld      bc, #ENEMY_LENGTH
    add     ix, bc
    pop     bc
    ld      a, c
    add     a, #0x40
    ld      c, a
    djnz    30$

    ; アニメーションの完了
    pop     bc
    ld      a, c
    or      a
    jr      nz, 49$
    scf
49$:

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 定数の定義
;

; エネミーの初期値
;
enemyDefault:

    ; ー
    .db     ENEMY_TYPE_NULL
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     ENEMY_LIFE_NULL
    .db     ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_NULL * ENEMY_NAME_LENGTH
    .dw     ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
    .db     (VDP_COLOR_BLACK << 4) | VDP_COLOR_BLACK
    .db     0x00, 0x00, 0x00
    ; 狼
    .db     ENEMY_TYPE_WOLF
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     1 ; ENEMY_LIFE_NULL
    .db     2 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_WOLF * ENEMY_NAME_LENGTH
    .dw     _monsterTable_1 ; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_LIGHT_YELLOW << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_BLACK << 4) | VDP_COLOR_LIGHT_YELLOW
    .db     0x00, 0x00, 0x00
    ; 人喰い熊
    .db     ENEMY_TYPE_BEAR
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     2 ; ENEMY_LIFE_NULL
    .db     2 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_BEAR * ENEMY_NAME_LENGTH
    .dw     _monsterTable_2 ; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_MEDIUM_RED << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_BLACK << 4) | VDP_COLOR_MEDIUM_RED
    .db     0x00, 0x00, 0x00
    ; 獣人
    .db     ENEMY_TYPE_BEAST
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     3 ; ENEMY_LIFE_NULL
    .db     3 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_BEAST * ENEMY_NAME_LENGTH
    .dw     _monsterTable_3 ; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_DARK_YELLOW << 4) | VDP_COLOR_DARK_GREEN
    .db     (VDP_COLOR_BLACK << 4) | VDP_COLOR_DARK_GREEN
    .db     0x00, 0x00, 0x00
    ; 幽霊
    .db     ENEMY_TYPE_GHOST
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     4 ; ENEMY_LIFE_NULL
    .db     3 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_GHOST * ENEMY_NAME_LENGTH
    .dw     _monsterTable_4 ; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_CYAN << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_BLACK << 4) | VDP_COLOR_CYAN
    .db     0x00, 0x00, 0x00
    ; 穴居巨人
    .db     ENEMY_TYPE_GIANT
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     5 ; ENEMY_LIFE_NULL
    .db     4 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_GIANT * ENEMY_NAME_LENGTH
    .dw     _monsterTable_5 ; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_MAGENTA << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_BLACK << 4) | VDP_COLOR_MAGENTA
    .db     0x00, 0x00, 0x00
    ; 白霜竜
    .db     ENEMY_TYPE_DRAGON
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     6 ; ENEMY_LIFE_NULL
    .db     5 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_DRAGON * ENEMY_NAME_LENGTH
    .dw     _monsterTable_6 ; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_WHITE << 4) | VDP_COLOR_LIGHT_BLUE
    .db     (VDP_COLOR_LIGHT_BLUE << 4) | VDP_COLOR_BLACK
    .db     0x00, 0x00, 0x00
    ; イシャスヤル
    .db     ENEMY_TYPE_ITYASJAR
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     45 ; ENEMY_LIFE_NULL
    .db     20 ; ENEMY_EXPERIENCE_NULL
    .db     ENEMY_ANIMATION_NULL
    .dw     enemyNameString + ENEMY_TYPE_ITYASJAR * ENEMY_NAME_LENGTH
    .dw     _monsterTable_7; ENEMY_PATTERN_NULL
    .dw     ENEMY_LOCATE_NULL
;   .db     (VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE << 4) | VDP_COLOR_BLACK
    .db     0x00, 0x00, 0x00

; 名前
;
enemyNameString:

    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     _K_O, _K_O, _KKA, _KMI, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     _KHI, _KTO, _KKU, _K_I, _KKU, _KSN, _KMA, 0x00, 0x00, 0x00
    .db     _KSI, _KSN, _Kyu, _K_U, _KSI, _KSN, _K_N, 0x00, 0x00, 0x00
    .db     _KYU, _K_U, _KRE, _K_I, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     _KKE, _Ktu, _KKI, _Kyo, _KKI, _Kyo, _KSI, _KSN, _K_N, 0x00
    .db     _KSI, _KRA, _KSI, _KSN, _KMO, _KRI, _Kyu, _K_U, 0x00, 0x00
    .db     _K_I, _KSI, _Kya, _KSU, _KYA, _KRU, 0x00, 0x00, 0x00, 0x00

; グループ
;
enemyGroup:

    .db     ENEMY_TYPE_NULL,     ENEMY_TYPE_NULL,     ENEMY_TYPE_NULL,     ENEMY_TYPE_NULL
    .db     ENEMY_TYPE_BEAST,    ENEMY_TYPE_GHOST,    ENEMY_TYPE_NULL,     ENEMY_TYPE_NULL
    .db     ENEMY_TYPE_WOLF,     ENEMY_TYPE_BEAR,     ENEMY_TYPE_BEAST,    ENEMY_TYPE_NULL
    .db     ENEMY_TYPE_BEAST,    ENEMY_TYPE_GIANT,    ENEMY_TYPE_GIANT,    ENEMY_TYPE_DRAGON
    .db     ENEMY_TYPE_GIANT,    ENEMY_TYPE_GIANT,    ENEMY_TYPE_GIANT,    ENEMY_TYPE_NULL
    .db     ENEMY_TYPE_DRAGON,   ENEMY_TYPE_DRAGON,   ENEMY_TYPE_DRAGON,   ENEMY_TYPE_DRAGON
    .db     ENEMY_TYPE_ITYASJAR, ENEMY_TYPE_NULL,     ENEMY_TYPE_NULL,     ENEMY_TYPE_NULL

enemyGroupString_0:

    .db     ____, _LRB, 0x00

enemyGroupString_1:

    .db     _RRB, 0x00

enemyGroupString_2:

    .db     __LF, 0x00

; 表示位置
;
enemyLocate:

    .dw     _patternName + 9 * 0x0020 + 16
    .dw     _patternName + 9 * 0x0020 + 12
    .dw     _patternName + 9 * 0x0020 + 8
    .dw     _patternName + 9 * 0x0020 + 4
    .dw     _patternName + 9 * 0x0020 + 0


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; エネミー
;
_enemy::
    
    .ds     ENEMY_LENGTH * ENEMY_ENTRY

