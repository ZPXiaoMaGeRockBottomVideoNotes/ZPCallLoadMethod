//
//  ZPPerson+ZPTest1.m
//  分类中的load方法
//
//  Created by 赵鹏 on 2019/5/13.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPerson+ZPTest1.h"

@implementation ZPPerson (ZPTest1)

+ (void)load
{
    NSLog(@"ZPPerson (ZPTest1) +load");
}

+ (void)test
{
    NSLog(@"ZPPerson (ZPTest1) + test");
}

@end
