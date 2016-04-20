//
//  CDMacros.h
//  LeanChatLib
//
//  Created by lzw on 15/7/13.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#ifndef LeanChatLib_CDMacros_h
#define LeanChatLib_CDMacros_h

#ifndef DLog
    #ifdef DEBUG
    #   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
    #else
    #   define DLog(...)
#endif
#endif


#ifndef WEAKSEL
#define WEAKSELF  typeof(self) __weak weakSelf = self;
#endif

#define LeanChatLibDeprecated(explain) __attribute__((deprecated(explain)))

#endif
