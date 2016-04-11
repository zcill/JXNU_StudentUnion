//
//  DefineHeaders.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/8.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#ifndef DefineHeaders_h
#define DefineHeaders_h

// DLog will output like NSLog only when the DEBUG variable is set

#ifdef DEBUG

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#define DLog(...)

#endif

// ALog will always output like NSLog

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ULog will show the UIAlertView only when the DEBUG variable is set

#ifdef DEBUG

#define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }

#else

#define ULog(...)

#endif

#endif /* DefineHeaders_h */
