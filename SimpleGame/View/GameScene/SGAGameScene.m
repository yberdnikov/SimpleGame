//
//  SGAGameScene.m
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "SGAGameScene.h"

@interface SGAGameScene ()
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@end

@implementation SGAGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self addChild:self.scoreLabel];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];

        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SKSpriteNode *sprite = (SKSpriteNode *)obj;
            sprite.paused = !sprite.paused;
        }];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

#pragma mark - Properties

- (SKLabelNode *)scoreLabel
{
    if (_scoreLabel)
        return _scoreLabel;
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    _scoreLabel.fontSize = 17.0f;
    _scoreLabel.text = NSLocalizedString(@"Scores", nil);
    _scoreLabel.position = CGPointMake(CGRectGetWidth(self.scoreLabel.frame) / 2, CGRectGetHeight(self.scoreLabel.frame) / 2);
    
    return _scoreLabel;
}

- (void)setScores:(NSInteger)scores
{
    _scores = scores;
    
    self.scoreLabel.text = [[NSString alloc] initWithFormat:@"%@: %d", NSLocalizedString(@"Scores", nil), scores];
}

@end
