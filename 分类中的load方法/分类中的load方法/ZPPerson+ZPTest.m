//
//  ZPPerson+ZPTest.m
//  分类中的load方法
//
//  Created by 赵鹏 on 2019/5/13.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPerson+ZPTest.h"

@implementation ZPPerson (ZPTest)

+ (void)load
{
    NSLog(@"ZPPerson (ZPTest) +load");
}

+ (void)test
{
    NSLog(@"ZPPerson (ZPTest) + test");
}

@end
