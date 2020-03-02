//
//  AppDelegate.m
//  Demo Objc
//
//  Created by Eduardo Mello de Macedo | Stone on 23/02/17.
//  Copyright © 2017 Eduardo Mello de Macedo | Stone. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+Utils.h"
#import "DemoPreferences.h"

@implementation AppDelegate

NSTimer* timer;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Set Stone as Acquirer
    [STNConfig setAcquirer:STNAcquirerStone];
   
    // Set the environment, it will impact the kind of requests for activation and authorization of transactions
    [STNConfig setEnvironment:[DemoPreferences lastSelectedEnvironment]];
    
    bool hasActivatedSconeCode = [STNValidationProvider validateActivation];
    if(hasActivatedSconeCode){
        NSLog(@"One or more Stone codes are already activated.");
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"NavigationBar"];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// Example code for connection maintenance
- (void)applicationDidEnterBackground:(UIApplication *)application {
}

// Keep the connection alive
- (void)keepConnectionAlive {
    // Try to connect and maintain the connection alive
    [STNPinPadConnectionProvider connectToPinpad:^(BOOL succeeded, NSError *error) {
        // You can use the succeeded param to check the connection status
        if (succeeded) {
            NSLog(@"Device connected %@", [kGeneralConnected localize]);
        } else {
            // You can use the error param to identify the reason of the failure
            NSLog(@"Error: Device not connected. %@", [error localizedDescription]);
            [self showErrorMessage:[error localizedDescription]];
        }
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showErrorMessage:(NSString *)error {
    
    UIAlertController *errorAlert = [UIAlertController
                                     alertControllerWithTitle:[kGeneralErrorTitle localize]
                                     message:error
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:[kGeneralOk localize]
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [errorAlert dismissViewControllerAnimated:YES
                                                                  completion:nil];
                               }];
    
    [errorAlert addAction:okButton];
    [self.window.rootViewController presentViewController:errorAlert
                                                 animated:YES
                                               completion:nil];
}

@end
