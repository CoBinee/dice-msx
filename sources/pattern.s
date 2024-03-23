; image2pattern
;

    .module patternTable
    .area   _CODE

_patternTable::

    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x10, 0x10, 0x10, 0x10, 0x10, 0x00, 0x10, 0x00
    .db     0x28, 0x28, 0x28, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x28, 0x7c, 0x28, 0x28, 0x28, 0x7c, 0x28, 0x00
    .db     0x28, 0x7e, 0xa8, 0x7c, 0x2a, 0xfc, 0x28, 0x00
    .db     0x00, 0xc4, 0xc8, 0x10, 0x20, 0x4c, 0x8c, 0x00
    .db     0x30, 0x48, 0x48, 0x32, 0x54, 0x88, 0x76, 0x00
    .db     0x10, 0x10, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x18, 0x20, 0x40, 0x40, 0x40, 0x20, 0x18, 0x00
    .db     0x60, 0x10, 0x08, 0x08, 0x08, 0x10, 0x60, 0x00
    .db     0x10, 0x54, 0x38, 0x10, 0x38, 0x54, 0x10, 0x00
    .db     0x00, 0x10, 0x10, 0x7c, 0x10, 0x10, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x40, 0x00
    .db     0x00, 0x00, 0x00, 0x7c, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x60, 0x60, 0x00
    .db     0x00, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x00
    .db     0x30, 0x48, 0x84, 0x84, 0x84, 0x48, 0x30, 0x00
    .db     0x10, 0x30, 0x10, 0x10, 0x10, 0x10, 0x38, 0x00
    .db     0x78, 0x84, 0x04, 0x38, 0x40, 0x84, 0xfc, 0x00
    .db     0x78, 0x84, 0x04, 0x18, 0x04, 0x84, 0x78, 0x00
    .db     0x18, 0x28, 0x48, 0x88, 0xfc, 0x08, 0x1c, 0x00
    .db     0xfc, 0x80, 0xf8, 0x04, 0x04, 0x84, 0x78, 0x00
    .db     0x78, 0x84, 0x80, 0xf8, 0x84, 0x84, 0x78, 0x00
    .db     0xfc, 0x84, 0x08, 0x08, 0x10, 0x10, 0x30, 0x00
    .db     0x78, 0x84, 0x84, 0x78, 0x84, 0x84, 0x78, 0x00
    .db     0x78, 0x84, 0x84, 0x7c, 0x04, 0x08, 0x70, 0x00
    .db     0x00, 0x30, 0x30, 0x00, 0x30, 0x30, 0x00, 0x00
    .db     0x00, 0x30, 0x30, 0x00, 0x30, 0x10, 0x20, 0x00
    .db     0x08, 0x10, 0x20, 0x40, 0x20, 0x10, 0x08, 0x00
    .db     0x00, 0x00, 0x7c, 0x00, 0x7c, 0x00, 0x00, 0x00
    .db     0x20, 0x10, 0x08, 0x04, 0x08, 0x10, 0x20, 0x00
    .db     0x78, 0x84, 0x84, 0x18, 0x20, 0x00, 0x20, 0x00
    .db     0x7c, 0xc6, 0x9a, 0xa2, 0x9a, 0xc6, 0x7c, 0x00
    .db     0x30, 0x10, 0x28, 0x28, 0x7c, 0x44, 0xee, 0x00
    .db     0xf8, 0x44, 0x44, 0x78, 0x44, 0x44, 0xf8, 0x00
    .db     0x3c, 0x44, 0x80, 0x80, 0x80, 0x44, 0x38, 0x00
    .db     0xf0, 0x48, 0x44, 0x44, 0x44, 0x48, 0xf0, 0x00
    .db     0xfc, 0x44, 0x50, 0x70, 0x50, 0x44, 0xfc, 0x00
    .db     0xfc, 0x44, 0x50, 0x70, 0x50, 0x40, 0xe0, 0x00
    .db     0x3c, 0x44, 0x80, 0x80, 0x8c, 0x44, 0x3c, 0x00
    .db     0xee, 0x44, 0x44, 0x7c, 0x44, 0x44, 0xee, 0x00
    .db     0x38, 0x10, 0x10, 0x10, 0x10, 0x10, 0x38, 0x00
    .db     0x1c, 0x08, 0x08, 0x08, 0x08, 0x88, 0x70, 0x00
    .db     0xee, 0x48, 0x50, 0x70, 0x48, 0x44, 0xe6, 0x00
    .db     0xe0, 0x40, 0x40, 0x40, 0x40, 0x44, 0xfc, 0x00
    .db     0xc6, 0x6c, 0x54, 0x54, 0x44, 0x44, 0xee, 0x00
    .db     0xce, 0x44, 0x64, 0x54, 0x4c, 0x44, 0xe4, 0x00
    .db     0x78, 0x84, 0x84, 0x84, 0x84, 0x84, 0x78, 0x00
    .db     0xf8, 0x44, 0x44, 0x78, 0x40, 0x40, 0xe0, 0x00
    .db     0x78, 0x84, 0x84, 0x84, 0x94, 0x88, 0x74, 0x00
    .db     0xf8, 0x44, 0x44, 0x78, 0x48, 0x44, 0xe6, 0x00
    .db     0x78, 0x88, 0x80, 0x78, 0x04, 0x84, 0xf8, 0x00
    .db     0x7c, 0x92, 0x10, 0x10, 0x10, 0x10, 0x38, 0x00
    .db     0xee, 0x44, 0x44, 0x44, 0x44, 0x44, 0x38, 0x00
    .db     0xee, 0x44, 0x44, 0x28, 0x28, 0x10, 0x10, 0x00
    .db     0xee, 0x44, 0x54, 0x54, 0x54, 0x6c, 0x44, 0x00
    .db     0xc6, 0x44, 0x28, 0x10, 0x28, 0x44, 0xc6, 0x00
    .db     0xc6, 0x44, 0x28, 0x10, 0x10, 0x10, 0x38, 0x00
    .db     0xfc, 0x88, 0x10, 0x20, 0x40, 0x84, 0xfc, 0x00
    .db     0x38, 0x20, 0x20, 0x20, 0x20, 0x20, 0x38, 0x00
    .db     0x00, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x00
    .db     0x38, 0x08, 0x08, 0x08, 0x08, 0x08, 0x38, 0x00
    .db     0x10, 0x28, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 0x00
    .db     0xfc, 0x04, 0x24, 0x28, 0x20, 0x40, 0x80, 0x00
    .db     0x04, 0x08, 0x10, 0x30, 0xd0, 0x10, 0x10, 0x00
    .db     0x10, 0xfe, 0x82, 0x82, 0x02, 0x04, 0x38, 0x00
    .db     0x00, 0x7c, 0x10, 0x10, 0x10, 0x10, 0xfe, 0x00
    .db     0x08, 0xfe, 0x08, 0x18, 0x28, 0x48, 0x88, 0x00
    .db     0x20, 0xfc, 0x24, 0x24, 0x44, 0x44, 0x98, 0x00
    .db     0x10, 0xfe, 0x10, 0x10, 0xfe, 0x10, 0x10, 0x00
    .db     0x40, 0x7c, 0x44, 0x84, 0x04, 0x08, 0x70, 0x00
    .db     0x40, 0x7e, 0x48, 0x88, 0x08, 0x10, 0x60, 0x00
    .db     0x00, 0xfc, 0x04, 0x04, 0x04, 0x04, 0xfc, 0x00
    .db     0x48, 0xfc, 0x48, 0x48, 0x08, 0x10, 0x60, 0x00
    .db     0xe0, 0x04, 0xe4, 0x04, 0x08, 0x10, 0xe0, 0x00
    .db     0xfc, 0x04, 0x08, 0x10, 0x30, 0x48, 0x84, 0x00
    .db     0x40, 0xfc, 0x44, 0x48, 0x40, 0x40, 0x3c, 0x00
    .db     0x84, 0x84, 0x44, 0x04, 0x08, 0x10, 0xe0, 0x00
    .db     0x7c, 0x44, 0x64, 0x9c, 0x04, 0x08, 0x70, 0x00
    .db     0x1c, 0x70, 0x10, 0xfe, 0x10, 0x20, 0xc0, 0x00
    .db     0x00, 0xa4, 0xa4, 0xa4, 0x04, 0x08, 0x70, 0x00
    .db     0x78, 0x00, 0xfc, 0x10, 0x10, 0x20, 0xc0, 0x00
    .db     0x40, 0x40, 0x40, 0x70, 0x4c, 0x40, 0x40, 0x00
    .db     0x10, 0xfc, 0x10, 0x10, 0x10, 0x20, 0xc0, 0x00
    .db     0x00, 0x78, 0x00, 0x00, 0x00, 0x00, 0xfc, 0x00
    .db     0xfc, 0x04, 0x04, 0x28, 0x10, 0x28, 0xc4, 0x00
    .db     0x10, 0xfc, 0x08, 0x38, 0x54, 0x92, 0x10, 0x00
    .db     0x00, 0x04, 0x04, 0x08, 0x10, 0x20, 0xc0, 0x00
    .db     0x00, 0x10, 0x48, 0x48, 0x44, 0x44, 0x84, 0x00
    .db     0x00, 0x80, 0x8c, 0xf0, 0x80, 0x80, 0x7c, 0x00
    .db     0x00, 0xfc, 0x04, 0x04, 0x04, 0x08, 0x70, 0x00
    .db     0x00, 0x20, 0x50, 0x88, 0x04, 0x02, 0x00, 0x00
    .db     0x10, 0xfe, 0x10, 0x54, 0x92, 0x92, 0x10, 0x00
    .db     0x00, 0xfc, 0x04, 0x04, 0x48, 0x30, 0x10, 0x00
    .db     0x70, 0x08, 0x60, 0x18, 0x00, 0xe0, 0x1c, 0x00
    .db     0x10, 0x20, 0x40, 0x48, 0x88, 0xfc, 0x84, 0x00
    .db     0x04, 0x44, 0x28, 0x10, 0x28, 0x44, 0x80, 0x00
    .db     0xfc, 0x20, 0x20, 0xfc, 0x20, 0x20, 0x1c, 0x00
    .db     0x20, 0x20, 0xfe, 0x22, 0x24, 0x28, 0x20, 0x00
    .db     0x00, 0x78, 0x08, 0x08, 0x08, 0x08, 0xfe, 0x00
    .db     0xfc, 0x04, 0x04, 0xfc, 0x04, 0x04, 0xfc, 0x00
    .db     0x78, 0x00, 0xfc, 0x04, 0x04, 0x08, 0x70, 0x00
    .db     0x44, 0x44, 0x44, 0x44, 0x04, 0x08, 0x10, 0x00
    .db     0x50, 0x50, 0x50, 0x54, 0x54, 0x54, 0x98, 0x00
    .db     0x80, 0x80, 0x80, 0x80, 0x84, 0x98, 0xe0, 0x00
    .db     0x00, 0xfc, 0x84, 0x84, 0x84, 0x84, 0xfc, 0x00
    .db     0x00, 0xfc, 0x84, 0x84, 0x04, 0x08, 0x30, 0x00
    .db     0x00, 0xfc, 0x04, 0xfc, 0x04, 0x08, 0xf0, 0x00
    .db     0x00, 0xe4, 0x04, 0x04, 0x08, 0x10, 0xe0, 0x00
    .db     0x00, 0x00, 0x54, 0x54, 0x04, 0x08, 0x30, 0x00
    .db     0x00, 0x20, 0x7c, 0x24, 0x28, 0x20, 0x20, 0x00
    .db     0x00, 0x00, 0x38, 0x08, 0x08, 0x08, 0x7c, 0x00
    .db     0x00, 0x00, 0x78, 0x08, 0x78, 0x08, 0x78, 0x00
    .db     0x00, 0x00, 0x7c, 0x04, 0x18, 0x10, 0x20, 0x00
    .db     0x00, 0x08, 0x10, 0x30, 0x50, 0x10, 0x10, 0x00
    .db     0x00, 0x10, 0x7c, 0x44, 0x04, 0x08, 0x30, 0x00
    .db     0x00, 0x00, 0x7c, 0x10, 0x10, 0x10, 0x7c, 0x00
    .db     0x00, 0x08, 0x7c, 0x08, 0x18, 0x28, 0x48, 0x00
    .db     0x20, 0x90, 0x50, 0x40, 0x00, 0x00, 0x00, 0x00
    .db     0x60, 0x90, 0x90, 0x60, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x30, 0x30, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x10, 0x38, 0x7c, 0xfe, 0x38, 0x38, 0x38, 0x00
    .db     0x38, 0x38, 0x38, 0xfe, 0x7c, 0x38, 0x10, 0x00
    .db     0x10, 0x30, 0x7e, 0xfe, 0x7e, 0x30, 0x10, 0x00
    .db     0x10, 0x18, 0xfc, 0xfe, 0xfc, 0x18, 0x10, 0x00
    .db     0x20, 0xfc, 0x20, 0x7c, 0xaa, 0x92, 0x64, 0x00
    .db     0x80, 0x84, 0x82, 0x82, 0x92, 0xa0, 0x40, 0x00
    .db     0x78, 0x00, 0xf8, 0x04, 0x04, 0x08, 0x70, 0x00
    .db     0x38, 0x00, 0x7c, 0x08, 0x10, 0x28, 0xc6, 0x00
    .db     0x24, 0x72, 0x20, 0x7c, 0xa2, 0xa2, 0x6c, 0x00
    .db     0x20, 0x24, 0xf2, 0x4a, 0x48, 0x88, 0xb0, 0x00
    .db     0x10, 0x7c, 0x08, 0x7e, 0x04, 0x80, 0x7c, 0x00
    .db     0x08, 0x10, 0x20, 0x40, 0x20, 0x10, 0x08, 0x00
    .db     0x84, 0x84, 0xbe, 0x84, 0x84, 0x84, 0x98, 0x00
    .db     0x00, 0x7c, 0x00, 0x00, 0x40, 0x80, 0x7e, 0x00
    .db     0x10, 0xfc, 0x08, 0x7c, 0x80, 0x80, 0x7c, 0x00
    .db     0x80, 0x80, 0x80, 0x84, 0x84, 0x88, 0x70, 0x00
    .db     0x08, 0xfe, 0x38, 0x48, 0x38, 0x08, 0x30, 0x00
    .db     0x44, 0x44, 0xfe, 0x44, 0x48, 0x40, 0x3c, 0x00
    .db     0x4c, 0x28, 0x10, 0xfc, 0x20, 0x40, 0x3c, 0x00
    .db     0x40, 0xec, 0x40, 0x40, 0x90, 0xa0, 0x9e, 0x00
    .db     0x20, 0xf8, 0x40, 0x78, 0x84, 0x04, 0x78, 0x00
    .db     0x00, 0xfc, 0x02, 0x02, 0x02, 0x04, 0x38, 0x00
    .db     0xfe, 0x08, 0x10, 0x20, 0x20, 0x20, 0x1c, 0x00
    .db     0x40, 0x2c, 0x30, 0x40, 0x80, 0x80, 0x7c, 0x00
    .db     0x40, 0xee, 0x44, 0x44, 0x9e, 0xa4, 0x38, 0x00
    .db     0xbe, 0x80, 0x80, 0x80, 0x90, 0xa0, 0x9e, 0x00
    .db     0x10, 0xbc, 0x52, 0xd2, 0xa6, 0xaa, 0x4c, 0x00
    .db     0x4c, 0xd2, 0x62, 0x42, 0x4e, 0xd2, 0x4c, 0x00
    .db     0x38, 0x54, 0x92, 0x92, 0xa2, 0xa2, 0x44, 0x00
    .db     0x84, 0xbe, 0x84, 0x84, 0x9c, 0xa6, 0x98, 0x00
    .db     0xe0, 0x44, 0x86, 0x84, 0x84, 0x88, 0x70, 0x00
    .db     0x20, 0x18, 0x30, 0x14, 0x8a, 0xca, 0x9a, 0x00
    .db     0x00, 0x20, 0x50, 0x88, 0x04, 0x02, 0x00, 0x00
    .db     0xbe, 0x84, 0xbe, 0x84, 0x9e, 0xa4, 0x98, 0x00
    .db     0x08, 0x7e, 0x08, 0x7e, 0x38, 0x4c, 0x3a, 0x00
    .db     0x70, 0x14, 0x14, 0x7e, 0xa4, 0xa4, 0x48, 0x00
    .db     0x24, 0xf2, 0x22, 0x60, 0xa2, 0xa2, 0x7c, 0x00
    .db     0x10, 0xbc, 0x52, 0xd2, 0xa2, 0xa2, 0x4c, 0x00
    .db     0x40, 0xf0, 0x40, 0xf4, 0x44, 0x44, 0x38, 0x00
    .db     0x48, 0xfc, 0x4a, 0x4a, 0x22, 0x2c, 0x20, 0x00
    .db     0x08, 0xbc, 0xca, 0x8a, 0xaa, 0x9c, 0x10, 0x00
    .db     0x10, 0x1c, 0x10, 0x10, 0x78, 0x94, 0x60, 0x00
    .db     0x30, 0x88, 0x80, 0xf8, 0x84, 0x04, 0x78, 0x00
    .db     0x98, 0xa4, 0xc4, 0x84, 0x04, 0x08, 0x30, 0x00
    .db     0x70, 0x20, 0x78, 0x84, 0x34, 0x4c, 0x38, 0x00
    .db     0x48, 0xd4, 0x64, 0x44, 0xc4, 0xc4, 0x42, 0x00
    .db     0x70, 0x20, 0x78, 0x84, 0x04, 0x04, 0x78, 0x00
    .db     0x40, 0xdc, 0x62, 0x42, 0xc2, 0xc2, 0x4c, 0x00
    .db     0x10, 0x7e, 0x20, 0x1c, 0x28, 0x40, 0x3e, 0x00
    .db     0x10, 0x10, 0x20, 0x20, 0x52, 0x52, 0x8c, 0x00
    .db     0x00, 0x00, 0x00, 0x78, 0x04, 0x04, 0x38, 0x00
    .db     0x00, 0x00, 0x28, 0x7c, 0x2a, 0x22, 0x24, 0x00
    .db     0x00, 0x00, 0x08, 0x5c, 0x6a, 0x4a, 0x1c, 0x00
    .db     0x00, 0x00, 0x08, 0x0e, 0x38, 0x4c, 0x32, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x1f, 0x3f, 0x70, 0x60, 0x60, 0x60, 0x60
    .db     0x00, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0xf8, 0xfc, 0x0e, 0x06, 0x06, 0x06, 0x06
    .db     0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60
    .db     0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06
    .db     0x60, 0x60, 0x60, 0x60, 0x70, 0x3f, 0x1f, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0x00
    .db     0x06, 0x06, 0x06, 0x06, 0x0e, 0xfc, 0xf8, 0x00
    .db     0xff, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xff, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    .db     0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0xff
    .db     0x80, 0xc0, 0xa0, 0x90, 0x88, 0x84, 0x82, 0x81
    .db     0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01
    .db     0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80
    .db     0x01, 0x03, 0x05, 0x09, 0x11, 0x21, 0x41, 0x81
    .db     0x81, 0x82, 0x84, 0x88, 0x90, 0xa0, 0xc0, 0x80
    .db     0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80
    .db     0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01
    .db     0x81, 0x41, 0x21, 0x11, 0x09, 0x05, 0x03, 0x01
    .db     0xe0, 0x9c, 0x83, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x07, 0x39, 0xc1, 0x01, 0x01, 0x01, 0x01, 0x01
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x83, 0x9c, 0xe0
    .db     0x01, 0x01, 0x01, 0x01, 0x01, 0xc1, 0x39, 0x07
    .db     0xe0, 0x1c, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x80, 0x70, 0x0e, 0x01, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x38, 0x07
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x1c, 0xe0
    .db     0x00, 0x00, 0x01, 0x0e, 0x70, 0x80, 0x00, 0x00
    .db     0x07, 0x38, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xf8, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0xc0, 0x3e, 0x01, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0xf0, 0x0f, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x80, 0x7c, 0x03, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe0, 0x1f
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0xf8
    .db     0x00, 0x00, 0x00, 0x00, 0x01, 0x3e, 0xc0, 0x00
    .db     0x00, 0x00, 0x00, 0x0f, 0xf0, 0x00, 0x00, 0x00
    .db     0x00, 0x03, 0x7c, 0x80, 0x00, 0x00, 0x00, 0x00
    .db     0x1f, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x3f, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x7f
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xfe
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0xfc, 0x00
    .db     0x00, 0x3f, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x7f, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xfe, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0xfc, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


