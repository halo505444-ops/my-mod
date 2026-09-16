#pragma once
#import <Foundation/Foundation.h>

// فەنکشنی گۆڕینی بەهای یادگە (Memory Patching) بۆ کارپێکردنی هاکەکان
inline void WriteMemory(uintptr_t address, const void *bytes, size_t length) {
    if (address == 0) return;
    vm_prot_t originalProt;
    // گۆڕینی مۆڵەتی یادگە بۆ ئەوەی ڕێگە بە دەستکاری کردن بدات
    vm_protect(mach_task_self(), (vm_address_t)address, length, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    memcpy((void *)address, bytes, length);
    vm_protect(mach_task_self(), (vm_address_t)address, length, FALSE, originalProt);
}
