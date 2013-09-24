//
//  MVYViewController.m
//  OAuth2Example
//
//  Created by Álvaro Murillo del Puerto on 20/09/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import "MVYViewController.h"
#import "AFOAuth2Client.h"
#import "AFJSONRequestOperation.h"

@interface MVYViewController ()

@end

@implementation MVYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.clientIDTextField.text = @"";
	self.secretIDTextField.text = @"";
	self.userTextField.text		= @"";
	self.passwordTextField.text = @"";
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideKeyboard {
	
	for (UIView *view in self.view.subviews) {
		if ([view respondsToSelector:@selector(resignFirstResponder)]){
			[view resignFirstResponder];
		}
	}
}

- (IBAction)authenticate:(id)sender {
	
	NSString *clientID	= self.clientIDTextField.text;
	NSString *secretID	= self.secretIDTextField.text;
	NSString *user		= self.userTextField.text;
	NSString *password	= self.passwordTextField.text;

	NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
	AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
					
	[oauthClient authenticateUsingOAuthWithPath:@"oauth/token"
									   username:user
									   password:password
										  scope:nil
										success:^(AFOAuthCredential *credential) {
											self.responseTextView.text = [NSString stringWithFormat:@"Your access token: %@", credential.accessToken];
											[AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
										}
										failure:^(NSError *error) {
											self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
										}];
	
}

- (IBAction)tryService:(id)sender {
	
	NSString *clientID	= self.clientIDTextField.text;
	NSString *secretID	= self.secretIDTextField.text;
	
	NSString *path = @"api/v1/matches";
	NSDictionary *parameters = @{@"latitude": @36.793729017697189, @"longitude": @-7.301390142330979, @"distance": @2000};
	
	
	NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
	AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
	[oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
	[oauthClient getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
		self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
	}];
	
}

@end
