//
//  MVYViewController.h
//  OAuth2Example
//
//  Created by Álvaro Murillo del Puerto on 20/09/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVYViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *clientIDTextField;
@property (nonatomic, weak) IBOutlet UITextField *secretIDTextField;
@property (nonatomic, weak) IBOutlet UITextField *userTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *matchIdTextField;
@property (nonatomic, weak) IBOutlet UITextView *responseTextView;

@end
