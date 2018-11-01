//
//  ConnectPinpadViewController.m
//  Demo Objc
//
//  Created by Eduardo Mello de Macedo | Stone on 02/03/17.
//  Copyright © 2017 Eduardo Mello de Macedo | Stone. All rights reserved.
//

#import "SelectPinpadViewController.h"
#import "NSString+Utils.h"
#import "DemoPreferences.h"

@implementation SelectPinpadViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // Setup UI components
    [self setupView];

    // Update connectedPinpads
    [self findConnectedPinpads];

    // Get the currently selected pinpad.
    STNPinpad *selectedPinpad = [[STNPinPadConnectionProvider new] selectedPinpad];

    // if the selected pinpad exists update the selected row at table view
    if (selectedPinpad != nil && [_connectedPinpads containsObject:selectedPinpad]) {
        int i = (int) [_connectedPinpads indexOfObject:selectedPinpad];
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                animated:false
                          scrollPosition:UITableViewScrollPositionTop];

        // Update label text with the name of selected pinpad
        _feedback.text = [NSString stringWithFormat:@"Selected pinpad %@", selectedPinpad.name];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Buttons actions

// Action to find connected pinpads
- (IBAction)refresh:(id)sender {
    [self findConnectedPinpads];
}

// Update connected pinpads list and refresh table view content
- (void)findConnectedPinpads {
    _connectedPinpads = [[STNPinPadConnectionProvider new] listConnectedPinpads];
    [self refreshTableViewContent];
}

#pragma mark - UITableViewDataSource

// Set number of rows based on the numbers of available connected pinpads
- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _connectedPinpads.count;
}

// Set a cell for pinpad from list
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pinpadCell" forIndexPath:indexPath];
    STNPinpad *pinpad = _connectedPinpads[indexPath.row];
    cell.textLabel.text = pinpad.name;
    return cell;
}

#pragma mark - UITableViewDelegate

// Connect to the selected pinpad
- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check if the row is a valid position at list of connected pinpads
    if ([_connectedPinpads count] > indexPath.row) {
        // The selected pinpad could be retrieved as below
        STNPinpad *pinpad = _connectedPinpads[indexPath.row];
        STNPinPadConnectionProvider *pinpadConnectionProvider = [STNPinPadConnectionProvider new];
        if ([pinpadConnectionProvider selectedPinpad] == pinpad) {
            NSLog(@"Device already selected.");
            [self setFeedbackMessage:[kLogDeviceAlreadyConnected localize]];
        } else {
            // selectPinpad will try to select the choosed pinpad
            // the return must be used to check connectivity
                [pinpadConnectionProvider selectPinpad:pinpad
                                                      withBlock:^(BOOL succeeded, NSError * _Nonnull error) {
                  NSString *labelContent = [NSString stringWithFormat:@"pinpad %@", pinpad.name];
                    if (succeeded) {
                        // The pinpad device is selected and available for transactions
                        // If you want implementing the automatic connection with last pinpad selected
                        // you should save the pinpad indentifier in someplace,
                        // we recommend the save at NSUserDefaults.
                        NSLog(@"Pinpad selection succeeded: %@", pinpad);
                        labelContent = [@"Valid " stringByAppendingString:labelContent];
                        [DemoPreferences updateLastSelectedDevice: pinpad.identifier];
                        // The selected pinpad could be retrieved as commented code below by the application.
                        // STNPinpad *pinpad = [[STNPinPadConnectionProvider new] selectedPinpad];
                        // NSLog(@"Selected pinpad %@", pinpad);
                    } else {
                        //The pinpad device is not available for transactions
                        NSLog(@"Error: %@", error.description);
                        labelContent = [@"Invalid " stringByAppendingString:labelContent];
                    }
                    // Refresh label data
                    [self setFeedbackMessage:labelContent];
                }];
        }
    }
}

#pragma mark - UI Update

// Setup view
- (void)setupView {
    [super viewDidLoad];

    self.navigationItem.title = [kTitleSelection localize];
    _instructionLabel.text = [kInstructionSelection localize];
    [_refreshButton setTitle:[kButtonRefresh localize]
                    forState:UIControlStateNormal];
    _overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overlayView.backgroundColor = [UIColor colorWithRed:0
                                                   green:0
                                                    blue:0
                                                   alpha:0.5];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = _overlayView.center;
    [_tableView setAllowsMultipleSelection:NO];
}

// Update UI Element
- (void)setFeedbackMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.feedback.text = message;
    });
}

// Refresh Table View
-(void) refreshTableViewContent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
@end
