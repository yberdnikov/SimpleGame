//
//  SGAPlayer.m
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "SGAPlayer.h"

@implementation SGAPlayer

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
        return nil;
    
    self.nickname = [decoder decodeObjectForKey:@"nickname"];
    self.score = [[decoder decodeObjectForKey:@"score"] integerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:@(self.score) forKey:@"score"];
}

- (BOOL)serialize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filename = [[NSString alloc] initWithFormat:@"%@.plist", self.nickname];
    
    return [NSKeyedArchiver archiveRootObject:self toFile:[documentsPath stringByAppendingPathComponent:filename]];
}

@end
