//
//  PosteriorCaptureViewController.h
//  Demo Objc
//
//  Created by Bruno Colombini | Stone on 04/09/18.
//  Copyright © 2018 Eduardo Mello de Macedo | Stone. All rights reserved.
//

#import "ViewController.h"
#import "ActivityIndicatorView.h"

@interface PosteriorCaptureViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *transactions;

@property (strong, nonatomic) ActivityIndicatorView *activityIndicator;

@end
