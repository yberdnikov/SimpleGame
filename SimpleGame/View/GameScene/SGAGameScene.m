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
@property (nonatomic, strong) NSArray *spriteActions;
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
        
        self.spriteActions = @[NSStringFromSelector(@selector(moveSpriteRandomly:)),
                               NSStringFromSelector(@selector(rotateSpriteRandomly:)),
                               NSStringFromSelector(@selector(scaleSpriteRandomly:))];
        
        [self applyRandomActionToSprites:self.sprites];
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

- (void)loadSprites
{
    self.sprites = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < MAX_SPRITES; i++)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = CGPointMake(arc4random_uniform((NSInteger)self.size.width), arc4random_uniform((NSInteger)self.size.height));
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:MAX(sprite.size.width, sprite.size.height) / 2]; // circle looks better
        sprite.physicsBody.dynamic = YES;
        sprite.physicsBody.allowsRotation = YES;
        sprite.physicsBody.categoryBitMask = 1;
        sprite.physicsBody.contactTestBitMask = 1;
        sprite.physicsBody.collisionBitMask = 1;
        
        [self.sprites addObject:sprite];
        [self addChild:sprite];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

#pragma mark - Touch handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1)
    {
        UITouch *touch = [touches anyObject];
        
        if (touch.tapCount == 1)
            [self performSelector:@selector(applyRandomActionToSprites:) withObject:self.sprites afterDelay:0.3];
        else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.paused = !self.paused;
        }
    }
    else if (touches.count > 1)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.paused = !self.paused;
    }
}

#pragma mark - Actions

- (void)applyRandomActionToSprites:(NSArray *)sprites
{
    [sprites makeObjectsPerformSelector:@selector(removeAllActions)];
    
    NSInteger actionIndex = arc4random_uniform(self.spriteActions.count);
    SEL randomAction = NSSelectorFromString([self.spriteActions objectAtIndex:actionIndex]);
    
    //can be much easy - [self performSelector ..], but compiler shows warning, so a little more advanced
    IMP imp = [self methodForSelector:randomAction];
    void (*func)(id, SEL, ...) = (void *)imp;

    [self.sprites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        func(self, randomAction, obj);
    }];
}

- (void)moveSpriteRandomly:(SKSpriteNode *)sprite
{
    SKAction *moveXAction = [SKAction moveToX:arc4random_uniform((NSInteger)self.size.width) duration:5.0f];
    SKAction *moveYAction = [SKAction moveToY:arc4random_uniform((NSInteger)self.size.height) duration:5.0f];
    
    __weak SGAGameScene *weakSelf = self;
    [sprite runAction:[SKAction group:@[moveXAction, moveYAction]] completion:^{
        [weakSelf moveSpriteRandomly:sprite];
    }];
}

- (void)rotateSpriteRandomly:(SKSpriteNode *)sprite
{
    NSInteger randomGradus = arc4random_uniform(360);
    CGFloat radian = randomGradus * M_PI / 180.0f;
    
    __weak SGAGameScene *weakSelf = self;
    [sprite runAction:[SKAction rotateToAngle:radian duration:5.0f] completion:^{
        [weakSelf rotateSpriteRandomly:sprite];
    }];
}

- (void)scaleSpriteRandomly:(SKSpriteNode *)sprite
{
    NSInteger randomScaleFactor = arc4random_uniform(5);
    
    __weak SGAGameScene *weakSelf = self;
    [sprite runAction:[SKAction scaleTo:randomScaleFactor duration:5.0f] completion:^{
        [weakSelf scaleSpriteRandomly:sprite];
    }];
}

#pragma mark - SKPhysicsContactDelegate methods

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    self.scores++;
}

@end
