//
//  MKBuys.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuys.h"
#import "MKBuy.h"

@implementation MKBuys

- (id)init
{
    self = [super init];
    self.nodeChildClass = MKBuy.class;
//    [self read];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Buys";
}

 - (MKBuy *)addBuy
{
    MKBuy *buy = [super addChild];
    [self write];
    return buy;
}

- (void)delete
{
    return;
}

@end
