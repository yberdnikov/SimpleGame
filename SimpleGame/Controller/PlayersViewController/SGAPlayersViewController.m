//
//  SGAPlayersViewController.m
//  SimpleGame
//
//  Created by Yuriy Berdnikov on 12/15/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "SGAPlayersViewController.h"
#import "SGAPlayer.h"
#import "SGAGameViewController.h"

@interface SGAPlayersViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contentDataSource;
@property (nonatomic, strong) SGAPlayer *selectedPlayer;
@end

@implementation SGAPlayersViewController

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
    
    self.title = NSLocalizedString(@"Players", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadPlayers];
    [self.contentTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPlayers
{
    [self.contentDataSource removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[[NSURL alloc] initFileURLWithPath:documentsPath]
                                                      includingPropertiesForKeys:@[]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:&error];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.contentDataSource = [[NSMutableArray alloc] initWithArray:contents];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSString *filename = [[self.contentDataSource objectAtIndex:indexPath.row] lastPathComponent];
    cell.textLabel.text = [[filename componentsSeparatedByString:@"."] objectAtIndex:0];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete)
        return;
    
    //would be better to do it in another queue .. 
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:[self.contentDataSource objectAtIndex:indexPath.row] error:&error])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self.contentDataSource removeObjectAtIndex:indexPath.row];
    
    [self.contentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewSelegate methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedPlayer = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.contentDataSource objectAtIndex:indexPath.row]];
    
    NSString *alertMessage = [[NSString alloc] initWithFormat:@"%@: %@\n%@: %d",
                              NSLocalizedString(@"Nickname", nil), self.selectedPlayer.nickname,
                              NSLocalizedString(@"Scores", nil), self.selectedPlayer.score];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Player Info", nil)
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:NSLocalizedString(@"Play game", nil), nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex)
        return;
    
    SGAGameViewController *gameController = (SGAGameViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];
    gameController.playerInfo = self.selectedPlayer;
    
    [self.navigationController pushViewController:gameController animated:YES];
}

@end
