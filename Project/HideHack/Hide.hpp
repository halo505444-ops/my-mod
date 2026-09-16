#pragma once
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <sys/sysctl.h>

inline void InitializeHideHack() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // پشکنینە سەرەتاییەکانی پاراستن
    });
}
