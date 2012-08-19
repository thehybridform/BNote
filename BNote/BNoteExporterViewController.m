//
//  BNoteExporterViewController.m
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import "BNoteExporterViewController.h"
#import "BNoteArchiverManager.h"
#import "BNoteArchiver.h"
#import "LayerFormater.h"
#import "BNoteFactory.h"
#import "BNoteSessionData.h"

@interface BNoteExporterViewController ()

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *exportButton;
@property (strong, nonatomic) IBOutlet UITextView *helpView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *destinationSegmentedControl;
@property (strong, nonatomic) NSArray *archiveOutlets;
@property (strong, nonatomic) id<BNoteArchiver> selectedArchiver;

@end

@implementation BNoteExporterViewController
@synthesize menuView = _menuView;
@synthesize footerView = _footerView;
@synthesize titleLabel = _titleLabel;
@synthesize cancelButton = _cancelButton;
@synthesize exportButton = _exportButton;
@synthesize destinationSegmentedControl = _destinationSegmentedControl;
@synthesize helpView = _helpView;
@synthesize tableView = _tableView;
@synthesize selectedArchiver = _selectedArchiver;

- (id)initWithDefault
{
    self = [super initWithNibName:@"BNoteExporterViewController" bundle:nil];
    if (self) {
        
        self.archiveOutlets = [BNoteArchiverManager instance].archivers;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.destinationSegmentedControl setTitle:NSLocalizedString(@"Selected Topic Group", nil) forSegmentAtIndex:0];
    [self.destinationSegmentedControl setTitle:NSLocalizedString(@"Selected Topic", nil) forSegmentAtIndex:1];
    [self.destinationSegmentedControl setTitle:NSLocalizedString(@"All Data", nil) forSegmentAtIndex:2];
    [self.destinationSegmentedControl setTintColor:[BNoteConstants appHighlightColor1]];

    self.destinationSegmentedControl.selectedSegmentIndex = 0;
    
    self.titleLabel.text = NSLocalizedString(@"Archive BeNote Data", @"The Archive BeNote Data title");
    self.titleLabel.textColor = [BNoteConstants appHighlightColor1];
    self.titleLabel.font = [BNoteConstants font:RobotoBold andSize:20];
    
    self.helpView.font = [BNoteConstants font:RobotoRegular andSize:16];
    self.helpView.textColor = [BNoteConstants appHighlightColor1];
    
    [LayerFormater roundCornersForView:self.tableView];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:self.tableView];
    
    [LayerFormater setBorderWidth:1 forView:self.footerView];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:self.footerView];
    
    [LayerFormater setBorderWidth:1 forView:self.menuView];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:self.menuView];
    
    [LayerFormater addShadowToView:self.footerView];
    [LayerFormater addShadowToView:self.menuView];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.menuView = nil;
    self.footerView = nil;
    self.titleLabel = nil;
    self.cancelButton = nil;
    self.exportButton = nil;
    self.destinationSegmentedControl = nil;
    self.tableView = nil;
}

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)export:(id)sender
{
    int index = self.destinationSegmentedControl.selectedSegmentIndex;
    NSString *title = [self.destinationSegmentedControl titleForSegmentAtIndex:index];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Archive BeNote Data", @"The Archive BeNote Data title")
                                                    message:title
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {

        BOOL result;
        id<BNoteArchiver> archiver = self.selectedArchiver;
        
        switch (self.destinationSegmentedControl.selectedSegmentIndex) {
            case 0:
                result = [archiver archiveTopicGroup:[BNoteSessionData instance].selectedTopicGroup];
                break;
                
            case 1:
                result = [archiver archiveTopic:[BNoteSessionData instance].selectedTopic];
                break;
                
            case 2:
                result = [archiver archiveAll];
                break;
                
            default:
                break;
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.archiveOutlets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<BNoteArchiver> archiver = [self.archiveOutlets objectAtIndex:[indexPath row]];

    self.selectedArchiver = archiver;
    self.helpView.text = [archiver helpText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [LayerFormater setBorderColor:[UIColor clearColor] forView:cell];
        
        UIFont *font = [BNoteConstants font:RobotoLight andSize:15.0];
        [[cell textLabel] setFont:font];
        [[cell textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
        [cell setSelectedBackgroundView:[BNoteFactory createHighlight:[BNoteConstants appHighlightColor1]]];

        [LayerFormater setBorderWidth:1 forView:cell];
    }
    
    id<BNoteArchiver> archiver = [self.archiveOutlets objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [archiver displayName];
    
    return cell;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end