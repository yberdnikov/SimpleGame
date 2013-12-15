//
//  SGAPlayer.h
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAPlayer : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger score;

- (BOOL)serialize;

@end
