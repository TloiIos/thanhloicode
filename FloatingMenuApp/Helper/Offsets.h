#ifndef OFFSETS_H
#define OFFSETS_H

// ==================== FREE FIRE OFFSETS ====================
// Phiên bản: 1.105.1 (Cập nhật 2024)

// ==================== PLAYER OFFSETS ====================
#define OFFSET_GET_HP               0x543592C
#define OFFSET_GET_MAX_HP           0x5435A3C
#define OFFSET_IS_DEAD              0x53AA18C
#define OFFSET_IS_VISIBLE           0x53C8894
#define OFFSET_IS_LOCAL_TEAM        0x53E20C4
#define OFFSET_GET_NAME             0x53BE8E0
#define OFFSET_GET_POSITION         0x91CA56C
#define OFFSET_SET_POSITION         0x91CA634
#define OFFSET_GET_FORWARD          0x91CAF64
#define OFFSET_SET_AIM              0x53C4534
#define OFFSET_IS_SIGHTING          0x53B769C
#define OFFSET_IS_FIRING            0x53ACC9C
#define OFFSET_PLAYER_ATTRIBUTES    0x708
#define OFFSET_PLAYER_SPEED         0x260
#define OFFSET_IS_BOT               0x438

// ==================== TRANSFORM OFFSETS ====================
#define OFFSET_GET_TRANSFORM        0x91B82E4
#define OFFSET_GET_POSITION_V3      0x91CA5D0
#define OFFSET_SET_POSITION_V3      0x91CA6A8
#define OFFSET_GET_ROTATION         0x91CB0E8
#define OFFSET_SET_ROTATION         0x91CB0E8

// ==================== CAMERA OFFSETS ====================
#define OFFSET_GET_CAMERA           0x915E9E4
#define OFFSET_WORLD_TO_VIEWPORT    0x915E364
#define OFFSET_CAMERA_TRANSFORM     0x380

// ==================== GAME OFFSETS ====================
#define OFFSET_CURRENT_MATCH        0x55C4DA4
#define OFFSET_GET_LOCAL_PLAYER     0x2FFE494
#define OFFSET_PLAYERS_DICTIONARY   0x148

// ==================== BONE OFFSETS ====================
#define OFFSET_HEAD_POSITION        0x54547E0
#define OFFSET_HIP_POSITION         0x5454990
#define OFFSET_LEFT_ANKLE           0x5454DE0
#define OFFSET_RIGHT_ANKLE          0x5454EEC
#define OFFSET_LEFT_TOE             0x5454FF8
#define OFFSET_RIGHT_TOE            0x5455104
#define OFFSET_LEFT_HAND            0x53C3608
#define OFFSET_RIGHT_HAND           0x53C370C
#define OFFSET_LEFT_FOREARM         0x53C3810
#define OFFSET_RIGHT_FOREARM        0x53C3914

// ==================== WEAPON OFFSETS ====================
#define OFFSET_GET_WEAPON           0x4DAEFBC
#define OFFSET_GET_WEAPON_ON_HAND   0x53BE110
#define OFFSET_SWAP_WEAPON          0x56E75DC
#define OFFSET_TAKE_DAMAGE          0x4A82BFC
#define OFFSET_RELOAD_WEAPON        0x4A8F238

#endif // OFFSETS_H
