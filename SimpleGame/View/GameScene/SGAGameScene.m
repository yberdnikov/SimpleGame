//
//  SGAGameScene.m
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "SGAGameScene.h"

#define MAX_SPRITES 3

@interface SGAGameScene () <SKPhysicsContactDelegate>
@property (nonatomic, strong) SKLabelNode *scoreLabel;

@property (nonatomic, strong) NSMutableArray *sprites;
@end

@implementation SGAGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        [self loadSprites];
        
        [self addChild:self.scoreLabel];
        
        [self.sprites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self moveSpriteRandomly:obj];
        }];
    }
    
    return self;
}

#pragma mark - Properties

- (SKLabelNode *)scoreLabel
{
    if (_scoreLabel)
    {
        _scoreLabel.position = CGPointMake(CGRectGetWidth(_scoreLabel.frame) / 2, CGRectGetHeight(_scoreLabel.frame) / 2);
        return _scoreLabel;
    }
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    _scoreLabel.fontSize = 17.0f;
    _scoreLabel.text = NSLocalizedString(@"Scores", nil);
    _scoreLabel.position = CGPointMake(CGRectGetWidth(_scoreLabel.frame) / 2, CGRectGetHeight(_scoreLabel.frame) / 2);
    
    return _scoreLabel;
}

- (void)setScores:(NSInteger)scores
{
    _scores = scores;
    
    self.scoreLabel.text = [[NSString alloc] initWithFormat:@"%@: %d", NSLocalizedString(@"Scores", nil), scores];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
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

- (void)loadSprites
{
    self.sprites = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < MAX_SPRITES; i++)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = CGPointMake(arc4random() % (NSInteger)self.size.width, arc4random() % (NSInteger)self.size.height);
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
        sprite.physicsBody.dynamic = YES;
        sprite.physicsBody.allowsRotation = NO;
        sprite.physicsBody.categoryBitMask = 1;
        sprite.physicsBody.contactTestBitMask = 1;
        sprite.physicsBody.collisionBitMask = 1;
        
        [self.sprites addObject:sprite];
        [self addChild:sprite];
    }
}

- (void)moveSpriteRandomly:(SKSpriteNode *)sprite
{
    SKAction *moveXAction = [SKAction moveToX:arc4random() % (NSInteger)self.size.width duration:5.0f];
    SKAction *moveYAction = [SKAction moveToY:arc4random() % (NSInteger)self.size.height duration:5.0f];
    
    __weak SGAGameScene *weakSelf = self;
    [sprite runAction:[SKAction group:@[moveXAction, moveYAction]] completion:^{
        [weakSelf moveSpriteRandomly:sprite];
    }];
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

#pragma mark - SKPhysicsContactDelegate methods

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    self.scores++;
}

@end
