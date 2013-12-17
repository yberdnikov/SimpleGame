//
//  SGAGameViewController.m
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "SGAGameViewController.h"
#import "SGAGameScene.h"

@interface SGAGameViewController () <UIAlertViewDelegate>

@end

@implementation SGAGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Game", nil);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonPressed)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    
    // Create and configure the scene.
    SGAGameScene *scene = [SGAGameScene sceneWithSize:skView.bounds.size];
    scene.scores = self.playerInfo.score;
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBarButtonItem selector

- (void)doneButtonPressed
{
    SKView *skView = (SKView *)self.view;
    skView.paused = YES;
    
    self.playerInfo.score = ((SGAGameScene *)skView.scene).scores;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Finish game ?", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to end this game ?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No", nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        [self.playerInfo serialize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        SKView *skView = (SKView *)self.view;
        skView.paused = NO;
    }
}

@end
