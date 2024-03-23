; Dungeon.s : ダンジョン
;


; モジュール宣言
;
    .module Dungeon

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Dungeon.inc"
    .include    "Player.inc"
    .include    "Enemy.inc"
    .include    "Dice.inc"
    .include    "Maze.inc"
    .include    "Menu.inc"
    .include    "Camp.inc"
    .include    "Battle.inc"

; 外部変数宣言
;
    .globl  _patternTable
    .globl  _spriteTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ダンジョンを初期化する
;
_DungeonInitialize::
    
    ; レジスタの保存
    
    ; ダンジョンの初期化
    ld      hl, #dungeonDefault
    ld      de, #_dungeon
    ld      bc, #DUNGEON_LENGTH
    ldir
    
    ; 処理の設定
    ld      hl, #DungeonNull
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ダンジョンを更新する
;
_DungeonUpdate::
    
    ; レジスタの保存
    
    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_dungeon + DUNGEON_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; ダンジョンを描画する
;
_DungeonRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ダンジョンを読み込む
;
_DungeonLoad::

    ; レジスタの保存
    
    ; a < 0/1 = ダンジョン／城

    ; 種類の保存
    push    af

    ; パターンネームの転送
    ld      hl, #(APP_PATTERN_NAME_TABLE + 0x0000)
    ld      a, #____
    ld      bc, #0x0300
    call    FILVRM

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
    
    ; ダンジョンの初期化
    ld      hl, #dungeonDefault
    ld      de, #_dungeon
    ld      bc, #DUNGEON_LENGTH
    ldir

    ; 種類の復帰
    pop     af

    ; フラグの設定
    or      a
    jr      z, 10$
    ld      hl, #(_dungeon + DUNGEON_FLAG)
    set     #DUNGEON_FLAG_CASTLE_BIT, (hl)
10$:
    
    ; 処理の更新
    ld      hl, #DungeonEnter
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
DungeonNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ダンジョンに入る
;
DungeonEnter:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; アニメーションの設定
    ld      a, #DUNGEON_ANIMATION_ENTER
    ld      (_dungeon + DUNGEON_ANIMATION), a

    ; 入り口の表示
    call    DungeonPrintEnter

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_dungeon + DUNGEON_ANIMATION)
    dec     (hl)
    jr      nz, 19$

    ; 処理の更新
    ld      hl, #DungeonIdle
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 待機する
;
DungeonIdle:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; 迷路の現在地の読み込み
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    call    _MazeLoad

    ; 位置の設定
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    call    _MazeGetHerePosition
    ld      (_dungeon + DUNGEON_POSITION_X), de

    ; 向きの設定
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    call    _MazeGetHereDirection
    ld      (_dungeon + DUNGEON_DIRECTION), a

    ; チートのクリア
    xor     a
    ld      (_dungeon + DUNGEON_CHEAT), a

    ; メニューの読み込み
    ld      de, #((5 << 8) | 11)
    ld      bc, #((0 << 8) | DUNGEON_IDLE_LENGTH)
    xor     a
    call    _MenuLoad

    ; 待機の表示
    call    DungeonPrintIdle

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; メニューの更新
    call    _MenuUpdate
    call    _MenuRender

    ; メニューのキャンセル
    call    _MenuIsCancel
    jr      nc, 10$
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
    jr      19$

    ; メニューの決定
10$:
    call    _MenuIsSelect
    jr      nc, 13$

    ; メニュー別の処理
    call    _MenuGetItem
    cp      #DUNGEON_IDLE_CAMP
    jr      z, 11$
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    jr      nz, 12$
    ld      hl, #DungeonRoll
    jr      18$
11$:
    ld      hl, #DungeonCamp
    jr      18$

    ; 城を進む
12$:
    ld      a, (_dungeon + DUNGEON_CASTLE)
    add     a, #MAZE_BLOCK_CASTLE_1
    ld      (_dungeon + DUNGEON_MAZE_NEXT), a
    ld      hl, #DungeonWalk
    jr      18$

    ; チート
13$:
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    jr      nz, 19$
    call    _DiceIsCheat
    jr      nc, 19$
    ld      (_dungeon + DUNGEON_CHEAT), a
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    ld      hl, #DungeonRoll
;   jr      18$

    ; 処理の更新
18$:
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ダイスを振る
;
DungeonRoll:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; スプライトジェネレータの転送
    ld      hl, #(_spriteTable + 0x0400)
    ld      de, #(APP_SPRITE_GENERATOR_TABLE + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM

    ; ダイスの読み込み
    ld      de, #((DICE_TYPE_MAZE << 8) | 0x01)
    call    _DiceLoad
    ld      a, (_dungeon + DUNGEON_CHEAT)
    call    _DiceCheat

    ; 迷路の表示
    call    DungeonPrintMaze

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; ダイスの更新
    call    _DiceUpdate
    call    _DiceRender

    ; ダイスの取得
    xor     a
    call    _DiceGetFace
    or      a
    jr      z, 90$
    ld      (_dungeon + DUNGEON_MAZE_NEXT), a

    ; 処理の更新
    ld      hl, #DungeonWalk
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a

    ; ダイスロールの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 迷路を歩く
;
DungeonWalk:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; 迷路の現在地の読み込み
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    call    _MazeLoad

    ; 位置の設定
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    call    _MazeGetHerePosition
    ld      (_dungeon + DUNGEON_POSITION_X), de

    ; 向きの設定
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    call    _MazeGetHereDirection
    ld      (_dungeon + DUNGEON_DIRECTION), a

    ; 迷路の目的地の読み込み
    ld      a, (_dungeon + DUNGEON_MAZE_NEXT)
    call    _MazeLoadNext

    ; 矢印の設定
    xor     a
    ld      (_dungeon + DUNGEON_ARROW), a

    ; アニメーションの設定
    xor     a
    ld      (_dungeon + DUNGEON_ANIMATION), a

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_dungeon + DUNGEON_ANIMATION)
    ld      a, (hl)
    or      a
    jr      z, 20$
    dec     a
    ld      (hl), a
    jp      nz, 90$
    ld      a, (_dungeon + DUNGEON_ARROW)
    or      a
    jr      z, 20$
    xor     a
    ld      (_dungeon + DUNGEON_ARROW), a
    jr      300$

    ; コマンドの取得
20$:
    call    DungeonGetCommand
    cp      #DUNGEON_COMMAND_DONE
    jr      z, 40$
    ld      (_dungeon + DUNGEON_COMMAND), a
    ld      (_dungeon + DUNGEON_ARROW), a
    ld      a, #DUNGEON_ANIMATION_ARROW
    ld      (_dungeon + DUNGEON_ANIMATION), a
    jp      90$

    ; コマンドの実行
300$:
    ld      de, (_dungeon + DUNGEON_POSITION_X)
    ld      a, (_dungeon + DUNGEON_DIRECTION)
    ld      b, a
    ld      a, (_dungeon + DUNGEON_COMMAND)
    ld      c, a
310$:
    dec     c
    jr      nz, 320$
    ld      a, b
    or      a
    jr      nz, 311$
    dec     d
    jr      370$
311$:
    dec     a
    jr      nz, 312$
    inc     e
    jr      370$
312$:
    dec     a
    jr      nz, 313$
    inc     d
    jr      370$
313$:
    dec     e
    jr      370$
320$:
    dec     c
    jr      nz, 330$
    ld      a, b
    or      a
    jr      nz, 321$
    inc     d
    jr      370$
321$:
    dec     a
    jr      nz, 322$
    dec     e
    jr      370$
322$:
    dec     a
    jr      nz, 323$
    dec     d
    jr      370$
323$:
    inc     e
    jr      370$
330$:
    dec     c
    jr      nz, 340$
    dec     b
    and     #0x03
    jr      380$
340$:
    dec     c
    jr      nz, 390$
    inc     b
    jr      380$
370$:
    call    _MazeIsWall
    jr      c, 390$
;   jr      380$
380$:
    ld      (_dungeon + DUNGEON_POSITION_X), de
    ld      a, b
    and     #0x03
    ld      (_dungeon + DUNGEON_DIRECTION), a
    ld      a, #DUNGEON_ANIMATION_WALK
    ld      (_dungeon + DUNGEON_ANIMATION), a

    ; 迷路の表示
    call    DungeonPrintMaze
390$:
    jr      90$

    ; 目的地の到達
40$:
    ld      a, (_dungeon + DUNGEON_MAZE_NEXT)
    ld      (_dungeon + DUNGEON_MAZE_HERE), a
    xor     a
    ld      (_dungeon + DUNGEON_MAZE_NEXT), a

    ; 目的地別の処理
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #dungeonWalkCase
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (_dungeon + DUNGEON_PROC_L), de
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a

    ; 歩きの完了
90$:

    ; 矢印の表示
    call    DungeonPrintArrow

    ; レジスタの復帰

    ; 終了
    ret

; 罠にかかる
;
DungeonTrap:

    ; レジスタの保存

    ; 0x00 : 初期化
00$:
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 10$

    ; チートのクリア
    xor     a
    ld      (_dungeon + DUNGEON_CHEAT), a

    ; 盗賊の不在
    call    _PlayerGetPartyNumber
    ld      b, a
    ld      c, #0x00
01$:
    ld      a, c
    call    _PlayerGetPartyCharacter
    ld      d, a
    call    _PlayerIsCharacterLive
    jr      nc, 02$
    ld      a, d
    call    _PlayerGetCharacterClass
    cp      #PLAYER_CLASS_THIEF
    jr      z, 03$
02$:
    inc     c
    djnz    01$
    call    DungeonPrintTrap
    ld      a, #0x04
    ld      (_dungeon + DUNGEON_STATE), a
    jp      90$

    ; 盗賊の存在
03$:
    ld      a, c
    ld      (_dungeon + DUNGEON_TARGET), a
    call    DungeonPrintTrapFind
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
    jp      90$

    ; 0x01 : 罠の確認
10$:
    dec     a
    jr      nz, 20$   

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      z, 11$

    ; チート
    call    _DiceIsCheat
    jp      nc, 90$
    ld      (_dungeon + DUNGEON_CHEAT), a
11$:
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; スプライトジェネレータの転送
    ld      hl, #(_spriteTable + 0x0800)
    ld      de, #(APP_SPRITE_GENERATOR_TABLE + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM

    ; ダイスの読み込み
    ld      de, #((DICE_TYPE_BATTLE << 8) | 0x01)
    call    _DiceLoad
    ld      a, (_dungeon + DUNGEON_CHEAT)
    call    _DiceCheat

    ; 状態の更新
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
    jp      90$

    ; 0x02 : ダイスを振る
20$:
    dec     a
    jr      nz, 30$

    ; ダイスの更新
    call    _DiceUpdate
    call    _DiceRender

    ; ダイスの取得
    xor     a
    call    _DiceGetFace
    or      a
    jp      z, 90$
    cp      #DICE_FACE_6
    jr      nz, 21$

    ; 罠にかかる
    call    DungeonPrintTrapMiss
    ld      a, #0x04
    ld      (_dungeon + DUNGEON_STATE), a
    jr      90$

    ; 罠を解除
21$:
    call    DungeonPrintTrapRelease

    ; 状態の更新
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
    jr      90$

    ; 0x03 : 罠の解除
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

    ; 0x04 : ダメージ
40$:
    dec     a
    jr      nz, 50$

    ; ダメージを与える
    call    _PlayerGetPartyNumber
    ld      b, a
    ld      c, #0x00
41$:
    ld      a, c
    call    _PlayerGetPartyCharacter
    ld      e, a
    call    _PlayerIsCharacterLive
    jr      nc, 43$
    ld      d, #0x01
    ld      a, e
    call    _PlayerGetCharacterClass
    cp      #PLAYER_CLASS_THIEF
    jr      nz, 42$
    inc     d
42$:
    ld      a, e
    call    _PlayerTakeCharacterDamage
43$:
    inc     c
    djnz    41$
    call    DungeonPrintTrapDamage

    ; 状態の更新
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
    jr      90$

    ; 罠にかかった
50$:
;   dec     a
;   jr      nz, 60$

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 90$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 生存の確認
    call    _PlayerIsPartyLive
    jr      c, 80$

    ; 全滅
    ld      hl, #DungeonDead
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
    jr      90$

    ; 出口の確認
80$:
    ld      hl, #(_dungeon + DUNGEON_JUNCTION)
    ld      a, (hl)
    or      a
    jr      nz, 81$
    ld      hl, #DungeonExit
    jr      82$
81$:
    dec     (hl)
    ld      a, #MAZE_BLOCK_TURN_BACK
    ld      (_dungeon + DUNGEON_MAZE_NEXT), a
    ld      hl, #DungeonWalk
82$:
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
;   jr      90$

    ; 罠の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 迷路が分岐する
;
DungeonJunction:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; 分岐路の更新
    ld      hl, #(_dungeon + DUNGEON_JUNCTION)
    ld      a, (hl)
    cp      #DUNGEON_JUNCTION_MAXIMUM
    jr      nc, 00$
    inc     (hl)
00$:

    ; 向きの設定
    ld      hl, #(_dungeon + DUNGEON_DIRECTION)
    ld      a, (hl)
    dec     a
    and     #0x03
    ld      (hl), a

    ; 矢印の設定
    ld      a, #DUNGEON_ARROW_LEFT
    ld      (_dungeon + DUNGEON_ARROW), a

    ; アニメーションの設定
    ld      a, #DUNGEON_ANIMATION_ARROW
    ld      (_dungeon + DUNGEON_ANIMATION), a

    ; 迷路の表示
    call    DungeonPrintMaze

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_dungeon + DUNGEON_ANIMATION)
    dec     (hl)
    jr      nz, 19$
    ld      a, (_dungeon + DUNGEON_ARROW)
    or      a
    jr      z, 18$
    xor     a
    ld      (_dungeon + DUNGEON_ARROW), a
    ld      a, #DUNGEON_ANIMATION_WALK
    ld      (_dungeon + DUNGEON_ANIMATION), a
    jr      19$

    ;　処理の更新
18$:
    ld      hl, #DungeonIdle
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; 矢印の表示
    call    DungeonPrintArrow

    ; レジスタの復帰

    ; 終了
    ret

; エネミーと遭遇する
;
DungeonEncount:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; アニメーションの設定
    ld      a, #DUNGEON_ANIMATION_ENCOUNT
    ld      (_dungeon + DUNGEON_ANIMATION), a

    ; エンカウントの表示
    call    DungeonPrintEncount

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_dungeon + DUNGEON_ANIMATION)
    dec     (hl)
    jr      nz, 19$

    ; 処理の更新
    ld      hl, #DungeonBattle
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; エネミーと戦う
;
DungeonBattle:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; 戦闘の読み込み
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    ld      e, a
    ld      d, #0x00
    ld      hl, #dungeonBattleEnemyGroup
    add     hl, de
    ld      a, (hl)
    call    _BattleLoad

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; 戦闘の更新
    call    _BattleUpdate
    call    _BattleRender

    ; 全滅
    call    _BattleIsDead
    jr      nc, 10$
    ld      hl, #DungeonDead
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
    jr      19$

    ; 戦闘終了
10$:
    call    _BattleIsEnd
    jr      nc, 19$
    ld      hl, #DungeonBattleEnd
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 全滅する
;
DungeonDead:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; パターンネームの転送
    ld      hl, #(APP_PATTERN_NAME_TABLE + 0x0000)
    ld      a, #____
    ld      bc, #0x0300
    call    FILVRM

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

    ; レベルダウン
    call    _GameClearString
    ld      c, #0x00
    call    _PlayerGetPartyNumber
    ld      b, a
00$:
    ld      a, c
    call    _PlayerGetPartyCharacter
    ld      d, a
    call    _PlayerDownCharacterLevel
    jr      nc, 01$
    ld      a, d
    call    _PlayerGetCharacterName
    call    _GameConcatString
    ld      hl, #dungeonDeadString_0
    call    _GameConcatString
01$:
    ld      a, d
    call    _PlayerReviveCharacter
    inc     c
    djnz    00$

    ; 所持金を失う
    call    _PlayerGetGold
    call    _PlayerUseGold
    ld      hl, #dungeonDeadString_1
    call    _GameConcatString

    ; 全滅の表示
    call    DungeonPrintDead

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 町へ
    ld      a, #GAME_GOTO_TOWN
    ld      (_game + GAME_GOTO), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 戦闘をを終了する
;
DungeonBattleEnd:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; パターンネームの転送
    ld      hl, #(APP_PATTERN_NAME_TABLE + 0x0000)
    ld      a, #____
    ld      bc, #0x0300
    call    FILVRM

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

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; アニメーションの設定
    ld      a, #DUNGEON_ANIMATION_NEXT
    ld      (_dungeon + DUNGEON_ANIMATION), a
    
    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_dungeon + DUNGEON_ANIMATION)
    dec     (hl)
    jr      nz, 19$

    ; 出口の確認
    ld      a, (_dungeon + DUNGEON_MAZE_HERE)
    cp      #MAZE_BLOCK_ROOM_1
    jr      nz, 12$
    ld      hl, #(_dungeon + DUNGEON_JUNCTION)
    ld      a, (hl)
    or      a
    jr      nz, 10$
    ld      hl, #DungeonExit
    jr      18$
10$:
    dec     (hl)
11$:
    ld      a, #MAZE_BLOCK_TURN_BACK
    ld      (_dungeon + DUNGEON_MAZE_NEXT), a
    ld      hl, #DungeonWalk
    jr      18$

    ; 城の出口
12$:
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    jr      z, 13$
    ld      hl, #(_dungeon + DUNGEON_CASTLE)
    inc     (hl)
    ld      a, (hl)
    cp      #DUNGEON_CASTLE_LENGTH
    jr      c, 13$
    ld      hl, #DungeonExit
    jr      18$

    ; 探索の継続
13$:
    ld      hl, #DungeonIdle
;   jr      18$

    ; 処理の更新
18$:
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ダンジョンから出る
;
DungeonExit:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; 出口の表示
    call    DungeonPrintExit

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; SPACE キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; 町へ
    ld      a, #GAME_GOTO_TOWN
    ld      (_game + GAME_GOTO), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; キャンプを張る
;
DungeonCamp:

    ; レジスタの保存

    ; 初期化
    ld      a, (_dungeon + DUNGEON_STATE)
    or      a
    jr      nz, 09$

    ; キャンプの読み込み
    ld      a, #0x01
    call    _CampLoad

    ; 初期化の完了
    ld      hl, #(_dungeon + DUNGEON_STATE)
    inc     (hl)
09$:

    ; キャンプの更新
    call    _CampUpdate
    call    _CampRender

    ; キャンプの完了
    call    _CampIsDone
    jr      nc, 19$

    ; 戻る
    ld      hl, #DungeonIdle
    ld      (_dungeon + DUNGEON_PROC_L), hl
    xor     a
    ld      (_dungeon + DUNGEON_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; コマンドを取得する
;
DungeonGetCommand:

    ; レジスタの保存

    ; a > コマンド

    ; 自動で移動
    jr      20$

    ; キー入力による取得
10$:
    ld      a, (_input + INPUT_KEY_UP)
    dec     a
    jr      nz, 11$
    ld      a, #DUNGEON_COMMAND_FORWARD
    jr      19$
11$:
    ld      a, (_input + INPUT_KEY_DOWN)
    dec     a
    jr      nz, 12$
    ld      a, #DUNGEON_COMMAND_BACK
    jr      19$
12$:
    ld      a, (_input + INPUT_KEY_LEFT)
    dec     a
    jr      nz, 13$
    ld      a, #DUNGEON_COMMAND_LEFT
    jr      19$
13$:
    ld      a, (_input + INPUT_KEY_RIGHT)
    dec     a
    jr      nz, 14$
    ld      a, #DUNGEON_COMMAND_RIGHT
    jr      19$
14$:
    xor     a
;   jr      19$
19$:
    jr      90$

    ; 自動による取得
20$:
    ld      a, (_dungeon + DUNGEON_DIRECTION)
    or      a
    jr      z, 22$
    cp      #MAZE_DIRECTION_WEST
    jr      nz, 21$
    ld      a, #DUNGEON_COMMAND_RIGHT
    jr      29$
21$:
    ld      a, #DUNGEON_COMMAND_LEFT
    jr      29$
22$:
    ld      a, (_dungeon + DUNGEON_POSITION_Y)
    cp      #MAZE_BLOCK_O_Y
    jr      z, 23$
    ld      a, #DUNGEON_COMMAND_FORWARD
    jr      29$
23$:
    ld      a, #DUNGEON_COMMAND_DONE
;   jr      29$
29$:
;   jr      90$

    ; コマンドの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 入り口を表示する
;
DungeonPrintEnter:

    ; レジスタの保存
    push    hl
    push    de

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; メッセージの表示
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    ld      hl, #dungeonEnterString_0
    jr      z, 10$
    ld      hl, #dungeonEnterString_1
10$:
    ld      d, #4
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 待機を表示する
;
DungeonPrintIdle:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 迷路の表示
    ld      de, (_dungeon + DUNGEON_POSITION_X)
    ld      a, (_dungeon + DUNGEON_DIRECTION)
    call    _MazePrint

    ; 分岐路の表示
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    call    z, DungeonPrintJunction

    ; パーティの表示
    call    _PlayerPrintParty

    ; 所持品の表示
    call    _PlayerPrintItem

    ; メニューの表示
    ld      de, #(_patternName + 4 * 0x0020 + 10)
    ld      bc, #((4 << 8) | 12)
    call    _GamePrintFrame
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    ld      hl, #dungeonIdleString_0
    jr      z, 10$
    ld      hl, #dungeonIdleString_1
10$:
    ld      de, #(_patternName + 5 * 0x0020 + 12)
    call    _GamePrintString

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 迷路を表示する
;
DungeonPrintMaze:

    ; レジスタの保存
    push    de
    
    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 迷路の表示
    ld      de, (_dungeon + DUNGEON_POSITION_X)
    ld      a, (_dungeon + DUNGEON_DIRECTION)
    call    _MazePrint

    ; レジスタの復帰
    pop     de

    ; 終了
    ret

; 矢印を表示する
;
DungeonPrintArrow:

    ; レジスタの保存
    push    hl
    push    bc
    push    de
    
    ; 矢印の表示
    ld      a, (_dungeon + DUNGEON_ARROW)
    or      a
    jr      z, 19$
    dec     a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #dungeonArrowSprite
    add     hl, de
    ld      de, #(_sprite + DUNGEON_SPRITE_ARROW)
    ld      bc, #0x0004
    ldir
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 罠を表示する
;
DungeonPrintTrap:

    ; レジスタの保存
    push    hl
    push    de

    ; メッセージの表示
    ld      hl, #dungeonTrapString
    ld      d, #4
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

DungeonPrintTrapFind:

    ; レジスタの保存
    push    hl
    push    de

    ; メッセージの表示
    ld      a, (_dungeon + DUNGEON_TARGET)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #dungeonTrapFindString
    call    _GameConcatString
    ld      d, #4
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

DungeonPrintTrapRelease:

    ; レジスタの保存
    push    hl
    push    de

    ; メッセージの表示
    ld      a, (_dungeon + DUNGEON_TARGET)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #dungeonTrapReleaseString
    call    _GameConcatString
    ld      d, #5
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

DungeonPrintTrapMiss:

    ; レジスタの保存
    push    hl
    push    de

    ; メッセージの表示
    ld      a, (_dungeon + DUNGEON_TARGET)
    call    _PlayerGetPartyCharacter
    call    _PlayerGetCharacterName
    call    _GameSetString
    ld      hl, #dungeonTrapMissString
    call    _GameConcatString
    ld      d, #5
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

DungeonPrintTrapDamage:

    ; レジスタの保存

    ; パーティの表示
    call    _PlayerPrintParty

    ; レジスタの復帰

    ; 終了
    ret

; 分岐路を表示する
;
DungeonPrintJunction:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 分岐路の表示
    ld      de, #(_patternName + 0 * 0x0020 + 22)
    ld      bc, #((3 << 8) | 10)
    call    _GamePrintFrame
    ld      hl, #dungeonJunctionString
    ld      de, #(_patternName + 1 * 0x0020 + 23)
    call    _GamePrintString
    ld      a, (_dungeon + DUNGEON_JUNCTION)
    ld      l, a
    ld      h, #0x00
    ld      de, #(_patternName + 1 * 0x0020 + 29)
    ld      b, #0x02
    call    _GamePrintValue

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; エンカウントを表示する
;
DungeonPrintEncount:

    ; レジスタの保存
    push    hl
    push    de

    ; メッセージの表示
    ld      hl, #dungeonEncountString
    ld      d, #4
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 全滅を表示する
;
DungeonPrintDead:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; メッセージの表示
    ld      de, #(_patternName + 4 * 0x0020 + 6)
    ld      bc, #((8 << 8) | 20)
    call    _GamePrintFrame
    call    _GameGetString
    ld      de, #(_patternName + 5 * 0x0020 + 7)
    call    _GamePrintString

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 出口を表示する
;
DungeonPrintExit:

    ; レジスタの保存
    push    hl
    push    de

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 迷路の表示
    ld      de, (_dungeon + DUNGEON_POSITION_X)
    ld      a, (_dungeon + DUNGEON_DIRECTION)
    call    _MazePrint

    ; メッセージの表示
    ld      a, (_dungeon + DUNGEON_FLAG)
    bit     #DUNGEON_FLAG_CASTLE_BIT, a
    ld      hl, #dungeonExitString_0
    jr      z, 10$
    ld      hl, #dungeonExitString_1
10$:
    ld      d, #4
    call    _GamePrintMessage

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 定数の定義
;

; ダンジョンの初期値
;
dungeonDefault:

    .dw     DUNGEON_PROC_NULL
    .db     DUNGEON_STATE_NULL
    .db     DUNGEON_FLAG_NULL
    .db     MAZE_BLOCK_PATH ; DUNGEON_MAZE_NULL
    .db     MAZE_BLOCK_NULL ; DUNGEON_MAZE_NULL
    .db     DUNGEON_JUNCTION_NULL
    .db     DUNGEON_CASTLE_NULL
    .db     DUNGEON_POSITION_NULL
    .db     DUNGEON_POSITION_NULL
    .db     DUNGEON_DIRECTION_NULL
    .db     DUNGEON_COMMAND_NULL
    .db     DUNGEON_ARROW_NULL
    .db     DUNGEON_TARGET_NULL
    .db     DUNGEON_ANIMATION_NULL
    .db     DUNGEON_CHEAT_NULL

; 入り口
;
dungeonEnterString_0:

    .db     _KTA, _KSN, _K_N, _KSI, _KSN, _Kyo, _K_N, _HNI, ____, _HHA, _H_I, _Htu, _HTA, 0x00

dungeonEnterString_1:

    .db     _HHA, _HKU, _HRI, _Hyu, _H_U, _HNO, _HSI, _HRO, _HNI, ____, _HHA, _H_I, _Htu, _HTA, 0x00

; 待機
;
dungeonIdleString_0:

    .db     _KTA, _KSN, _K_I, _KSU, _HWO, ____, _HHU, _HRU, __LF
    .db     _KKI, _Kya, _K_N, _KHU, _KPS, _HWO, ____, _HHA, _HRU, __LF
    .db     0x00

dungeonIdleString_1:

    .db     _HSA, _HKI, _HNI, ____, _HSU, _HSU, _HMU, __LF
    .db     _KKI, _Kya, _K_N, _KHU, _KPS, _HWO, ____, _HHA, _HRU, __LF
    .db     0x00

; 歩く
;
dungeonWalkCase:

    .dw     DungeonNull
    .dw     DungeonEncount
    .dw     DungeonEncount
    .dw     DungeonTrap
    .dw     DungeonIdle
    .dw     DungeonEncount
    .dw     DungeonJunction
    .dw     DungeonIdle
    .dw     DungeonEncount
    .dw     DungeonEncount
    .dw     DungeonEncount

; 罠
;
dungeonTrapString:

    .db     _HWA, _HNA, _HNI, ____, _HKA, _HKA, _Htu, _HTA, 0x00

dungeonTrapFindString:

    .db     _HHA, _HWA, _HNA, _HWO, ____, _HHA, _Htu, _HKE, _H_N, _HSI, _HTA, 0x00

dungeonTrapReleaseString:

    .db     _HHA, _HWA, _HNA, _HNO, _HKA, _H_I, _HSI, _KSN, _Hyo, _HNI, ____, _HSE, _H_I, _HKO, _H_U, _HSI, _HTA, 0x00

dungeonTrapMissString:

    .db     _HHA, _HWA, _HNA, _HNO, _HKA, _H_I, _HSI, _KSN, _Hyo, _HNI, ____, _HSI, _Htu, _HHA, _KPS, _H_I, _HSI, _HTA, 0x00

; 分岐路
;
dungeonJunctionString:

    .db     _HWA, _HKI, _HMI, _HTI, ____, ____, 0x00

; 矢印
;
dungeonArrowSprite:

    .db     0x58 - 0x01, 0x78, 0x08, VDP_COLOR_WHITE
    .db     0x58 - 0x01, 0x78, 0x0c, VDP_COLOR_WHITE
    .db     0x58 - 0x01, 0x78, 0x10, VDP_COLOR_WHITE
    .db     0x58 - 0x01, 0x78, 0x14, VDP_COLOR_WHITE

; エンカウント
;
dungeonEncountString:

    .db     _HKA, _H_I, _HHU, _KSN, _HTU, _HNI, ____, _HTE, _KSN, _H_A, _Htu, _HTA, 0x00

; 戦闘
;
dungeonBattleEnemyGroup:

    .db     ENEMY_GROUP_NULL
    .db     ENEMY_GROUP_ROOM_1
    .db     ENEMY_GROUP_ROOM_2
    .db     ENEMY_GROUP_NULL
    .db     ENEMY_GROUP_NULL
    .db     ENEMY_GROUP_ROOM_3
    .db     ENEMY_GROUP_NULL
    .db     ENEMY_GROUP_NULL
    .db     ENEMY_GROUP_CASTLE_1
    .db     ENEMY_GROUP_CASTLE_2
    .db     ENEMY_GROUP_CASTLE_3

; 全滅
;
dungeonDeadString_0:

    .db     _HHA, _KRE, _KHE, _KSN, _KRU, _HKA, _KSN, ____, _HSA, _HKA, _KSN, _Htu, _HTA, __LF, 0x00

dungeonDeadString_1:

    .db     _H_O, _HKA, _HNE, _HWO, _HSU, _HHE, _KSN, _HTE, ____, _H_U, _HSI, _HNA, _Htu, _HTA, 0x00

; 出口
;
dungeonExitString_0:

    .db     _KTA, _KSN, _K_N, _KSI, _KSN, _Kyo, _K_N, _HWO, ____, _HTA, _H_N, _HSA, _HKU, _HSI, _HTU, _HKU, _HSI, _HTA, 0x00

dungeonExitString_1:

    .db     _K_I, _KSI, _Kya, _KSU, _KYA, _KRU, _HHA, ____, _HNA, _HKA, _KSN, _HKI, _HNE, _HMU, _HRI, _HNI, _HTU, _H_I, _HTA, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ダンジョン
;
_dungeon::

    .ds     DUNGEON_LENGTH

