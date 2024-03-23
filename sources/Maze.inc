; Maze.inc : 迷路
;


; マクロの定義
;

; 迷路
MAZE_PATH                       =   0x00
MAZE_WALL                       =   0x01

; 大きさ
MAZE_SIZE_X                     =   0x10
MAZE_SIZE_Y                     =   0x10

; 向き
MAZE_DIRECTION_NORTH            =   0x00
MAZE_DIRECTION_EAST             =   0x01
MAZE_DIRECTION_SOUTH            =   0x02
MAZE_DIRECTION_WEST             =   0x03

; 区画
MAZE_BLOCK_NULL                 =   0x00
MAZE_BLOCK_ROOM_1               =   0x01
MAZE_BLOCK_ROOM_2               =   0x02
MAZE_BLOCK_DEAD_END             =   0x03
MAZE_BLOCK_PATH                 =   0x04
MAZE_BLOCK_ROOM_3               =   0x05
MAZE_BLOCK_JUNCTION             =   0x06
MAZE_BLOCK_TURN_BACK            =   0x07
MAZE_BLOCK_CASTLE_1             =   0x08
MAZE_BLOCK_CASTLE_2             =   0x09
MAZE_BLOCK_CASTLE_3             =   0x0a
MAZE_BLOCK_SIZE_X               =   0x07
MAZE_BLOCK_SIZE_Y               =   0x07
MAZE_BLOCK_O_X                  =   0x03
MAZE_BLOCK_O_Y                  =   0x03

; 外部関数宣言
;

    .globl  _MazeInitialize
    .globl  _MazeLoad
    .globl  _MazeLoadHere
    .globl  _MazeLoadNext
    .globl  _MazeIsWall
    .globl  _MazeGetHerePosition
    .globl  _MazeGetHereDirection
    .globl  _MazePrint

; 外部変数宣言
;

    .globl  _maze
