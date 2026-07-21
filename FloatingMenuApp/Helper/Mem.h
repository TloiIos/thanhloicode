#ifndef MEM_H
#define MEM_H

#include <mach-o/dyld.h>
#include <string>
#include <cstring>
#include <cstdio>

// Stub for substrate - không dùng nữa
#define timer(sec) 
#define HOOK(offset, ptr, orig) 
#define HOOK_NO_ORIG(offset, ptr) 
#define HOOKSYM(sym, ptr, org) 
#define HOOKSYM_NO_ORIG(sym, ptr) 
#define getSym(symName) NULL
#define UIColorFromHex(hexColor) nil

bool getType(unsigned int data) {
    int a = data & 0xffff8000;
    int b = a + 0x00008000;
    int c = b & 0xffff7fff;
    return c;
}

struct MemoryFileInfo {
    uint32_t index;
    const struct mach_header *header;
    const char *name;
    long long address;
};

inline MemoryFileInfo getBaseInfo() {
    MemoryFileInfo _info;
    memset(&_info, 0, sizeof(_info));
    std::string applicationsPath = "/private/var/containers/Bundle/Application";
    for (uint32_t i = 0; i < _dyld_image_count(); i++)
    {
        const char *name = _dyld_get_image_name(i);
        if (!name) continue;
        std::string fullpath(name);
        if (strncmp(fullpath.c_str(), applicationsPath.c_str(), applicationsPath.size()) == 0)
        {
            _info.index = i;
            _info.header = _dyld_get_image_header(i);
            _info.name = _dyld_get_image_name(i);
            _info.address = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return _info;
}

inline MemoryFileInfo getMemoryFileInfo(const std::string& fileName) {
    MemoryFileInfo _info;
    memset(&_info, 0, sizeof(_info));
    const uint32_t imageCount = _dyld_image_count();
    for (uint32_t i = 0; i < imageCount; i++) {
        const char *name = _dyld_get_image_name(i);
        if (!name)
            continue;
        std::string fullpath(name);
        if (fullpath.length() < fileName.length() || fullpath.compare(fullpath.length() - fileName.length(), fileName.length(), fileName) != 0)
            continue;
        _info.index = i;
        _info.header = _dyld_get_image_header(i);
        _info.name = _dyld_get_image_name(i);
        _info.address = _dyld_get_image_vmaddr_slide(i);
        break;
    }
    return _info;
}

inline uintptr_t getAbsoluteAddress(const char *fileName, uintptr_t address) {
    MemoryFileInfo info;
    if (fileName)
        info = getMemoryFileInfo(fileName);
    else
        info = getBaseInfo();
    if (info.address == 0)
        return 0;
    return info.address + address;
}

inline uint64_t getRealOffset(uint64_t offset){
    return getAbsoluteAddress("UnityFramework", offset);
}

inline uint64_t getRealOffsetNULL(uint64_t offset){
    return getAbsoluteAddress(NULL, offset);
}

// Stub functions - không dùng nữa
inline bool vm_unity(long long offset, unsigned int data) { return true; }
inline bool vm(long long offset, unsigned int data) { return true; }
inline bool vm_anogs(long long offset, unsigned int data) { return true; }

#endif // MEM_H
