; Code.inc : 文字コード
;


; マクロの定義
;

; 文字コード
_NUL                            =   0x00    ; 
_EXC                            =   0x01    ; !
_QUO                            =   0x02    ; "
_NUM                            =   0x03    ; #
_DOL                            =   0x04    ; $
_PER                            =   0x05    ; %
_AND                            =   0x06    ; &
_APO                            =   0x07    ; '
_LRB                            =   0x08    ; (
_RRB                            =   0x09    ; )
_AST                            =   0x0a    ; *
_PLS                            =   0x0b    ; +
_COM                            =   0x0c    ; ,
_MNS                            =   0x0d    ; -
_DOT                            =   0x0e    ; .
_SLA                            =   0x0f    ; /
___0                            =   0x10    ; 0
___1                            =   0x11    ; 1
___2                            =   0x12    ; 2
___3                            =   0x13    ; 3
___4                            =   0x14    ; 4
___5                            =   0x15    ; 5
___6                            =   0x16    ; 6
___7                            =   0x17    ; 7
___8                            =   0x18    ; 8
___9                            =   0x19    ; 9
_COL                            =   0x1a    ; :
_SCL                            =   0x1b    ; ;
_LES                            =   0x1c    ; <
_EQU                            =   0x1d    ; =
_GRT                            =   0x1e    ; >
_QUE                            =   0x1f    ; ?
__AT                            =   0x20    ; @
___A                            =   0x21    ; A
___B                            =   0x22    ; B
___C                            =   0x23    ; C
___D                            =   0x24    ; D
___E                            =   0x25    ; E
___F                            =   0x26    ; F
___G                            =   0x27    ; G
___H                            =   0x28    ; H
___I                            =   0x29    ; I
___J                            =   0x2a    ; J
___K                            =   0x2b    ; K
___L                            =   0x2c    ; L
___M                            =   0x2d    ; M
___N                            =   0x2e    ; N
___O                            =   0x2f    ; O
___P                            =   0x30    ; P
___Q                            =   0x31    ; Q
___R                            =   0x32    ; R
___S                            =   0x33    ; S
___T                            =   0x34    ; T
___U                            =   0x35    ; U
___V                            =   0x36    ; V
___W                            =   0x37    ; W
___X                            =   0x38    ; X
___Y                            =   0x39    ; Y
___Z                            =   0x3a    ; Z
_LSB                            =   0x3b    ; [
_BSL                            =   0x3c    ; \ 
_RSB                            =   0x3d    ; ]
_CAR                            =   0x3e    ; ^
_USC                            =   0x3f    ; _
_K_A                            =   0x40    ; ア
_K_I                            =   0x41    ; イ
_K_U                            =   0x42    ; ウ
_K_E                            =   0x43    ; エ
_K_O                            =   0x44    ; オ
_KKA                            =   0x45    ; カ
_KKI                            =   0x46    ; キ
_KKU                            =   0x47    ; ク
_KKE                            =   0x48    ; ケ
_KKO                            =   0x49    ; コ
_KSA                            =   0x4a    ; サ
_KSI                            =   0x4b    ; シ
_KSU                            =   0x4c    ; ス
_KSE                            =   0x4d    ; セ
_KSO                            =   0x4e    ; ソ
_KTA                            =   0x4f    ; タ
_KTI                            =   0x50    ; チ
_KTU                            =   0x51    ; ツ
_KTE                            =   0x52    ; テ
_KTO                            =   0x53    ; ト
_KNA                            =   0x54    ; ナ
_KNI                            =   0x55    ; ニ
_KNU                            =   0x56    ; ヌ
_KNE                            =   0x57    ; ネ
_KNO                            =   0x58    ; ノ
_KHA                            =   0x59    ; ハ
_KHI                            =   0x5a    ; ヒ
_KHU                            =   0x5b    ; フ
_KHE                            =   0x5c    ; ヘ
_KHO                            =   0x5d    ; ホ
_KMA                            =   0x5e    ; マ
_KMI                            =   0x5f    ; ミ
_KMU                            =   0x60    ; ム
_KME                            =   0x61    ; メ
_KMO                            =   0x62    ; モ
_KYA                            =   0x63    ; ヤ
_KYU                            =   0x64    ; ユ
_KYO                            =   0x65    ; ヨ
_KRA                            =   0x66    ; ラ
_KRI                            =   0x67    ; リ
_KRU                            =   0x68    ; ル
_KRE                            =   0x69    ; レ
_KRO                            =   0x6a    ; ロ
_KWA                            =   0x6b    ; ワ
_KWO                            =   0x6c    ; ヲ
_K_N                            =   0x6d    ; ン
_Ktu                            =   0x6e    ; ッ
_Kya                            =   0x6f    ; ャ
_Kyu                            =   0x70    ; ュ
_Kyo                            =   0x71    ; ョ
_K_a                            =   0x72    ; ァ
_K_i                            =   0x73    ; ィ
_K_u                            =   0x74    ; ゥ
_K_e                            =   0x75    ; ェ
_K_o                            =   0x76    ; ォ
_KSN                            =   0x77    ; 濁音
_KPS                            =   0x78    ; 半濁音
_KMP                            =   0x79    ; ・
____                            =   0x7a    ; 空白
_H_A                            =   0x80    ; あ
_H_I                            =   0x81    ; い
_H_U                            =   0x82    ; う
_H_E                            =   0x83    ; え
_H_O                            =   0x84    ; お
_HKA                            =   0x85    ; か
_HKI                            =   0x86    ; き
_HKU                            =   0x87    ; く
_HKE                            =   0x88    ; け
_HKO                            =   0x89    ; こ
_HSA                            =   0x8a    ; さ
_HSI                            =   0x8b    ; し
_HSU                            =   0x8c    ; す
_HSE                            =   0x8d    ; せ
_HSO                            =   0x8e    ; そ
_HTA                            =   0x8f    ; た
_HTI                            =   0x90    ; ち
_HTU                            =   0x91    ; つ
_HTE                            =   0x92    ; て
_HTO                            =   0x93    ; と
_HNA                            =   0x94    ; な
_HNI                            =   0x95    ; に
_HNU                            =   0x96    ; ぬ
_HNE                            =   0x97    ; ね
_HNO                            =   0x98    ; の
_HHA                            =   0x99    ; は
_HHI                            =   0x9a    ; ひ
_HHU                            =   0x9b    ; ふ
_HHE                            =   0x9c    ; へ
_HHO                            =   0x9d    ; ほ
_HMA                            =   0x9e    ; ま
_HMI                            =   0x9f    ; み
_HMU                            =   0xa0    ; む
_HME                            =   0xa1    ; め
_HMO                            =   0xa2    ; も
_HYA                            =   0xa3    ; や
_HYU                            =   0xa4    ; ゆ
_HYO                            =   0xa5    ; よ
_HRA                            =   0xa6    ; ら
_HRI                            =   0xa7    ; り
_HRU                            =   0xa8    ; る
_HRE                            =   0xa9    ; れ
_HRO                            =   0xaa    ; ろ
_HWA                            =   0xab    ; わ
_HWO                            =   0xac    ; を
_H_N                            =   0xad    ; ん
_Htu                            =   0xae    ; っ
_Hya                            =   0xaf    ; ゃ
_Hyu                            =   0xb0    ; ゅ
_Hyo                            =   0xb1    ; ょ

; カーソル
__UP                            =   0x7c    ; ↑
_DWN                            =   0x7d    ; ↓
_LFT                            =   0x7e    ; ←
_RGT                            =   0x7f    ; →

; 枠
_FLT                            =   0xb8    ; 
_F_T                            =   0xb9    ; 
_FRT                            =   0xba    ; 
_F_L                            =   0xbb    ; 
_F_R                            =   0xbc    ; 
_FLB                            =   0xbd    ; 
_F_B                            =   0xbe    ; 
_FRB                            =   0xbf    ; 

; 制御
__LF                            =   0xda


; 外部関数宣言
;

; 外部変数宣言
;


