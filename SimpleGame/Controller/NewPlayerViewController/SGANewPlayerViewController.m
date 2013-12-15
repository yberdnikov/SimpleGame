//
//  SGANewPlayerViewController.m
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "SGANewPlayerViewController.h"
#import "SGAPlayer.h"
#import "SGAGameViewController.h"

@interface SGANewPlayerViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;

@end

@implementation SGANewPlayerViewController

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
    
    self.title = NSLocalizedString(@"New Player", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIButton selectors

- (IBAction)startGameButtonPressed:(UIButton *)sender
{
    if (!self.nicknameTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"Please enter nickname", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self createNewPlayer:self.nicknameTextField.text];
}

- (void)createNewPlayer:(NSString *)nickname
{
    SGAPlayer *newPlayer = [[SGAPlayer alloc] init];
    newPlayer.nickname = nickname;
    
    UIAlertView *alert;
    if ([newPlayer serialize])
    {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Player created", nil)
                                           message:NSLocalizedString(@"Player was created. Prepare for game!", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                           message:NSLocalizedString(@"Failed to create new player", nil)
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SGAGameViewController *gameController = (SGAGameViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];
    
    [self.navigationController pushViewController:gameController animated:YES];
}

@end
