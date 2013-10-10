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

NSString *URL = @"http://peoplesports-staging.herokuapp.com/";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//self.clientIDTextField.text = @"144230a47bfe750c1b79b7793efd95cdfa9d42f6e0b66d7fc1e315c84b49aec7";
	//self.secretIDTextField.text = @"3883cb393d665f2f4adc880764b25be87240a4e94c3143114ebb4388d69b079f";
    self.clientIDTextField.text = @"63166c5af5a404bc9a8aac0baedee1bac5e01eaf77125afee37ee4d305d88dd6";
	self.secretIDTextField.text = @"303abbdfbc6632ad41369d7f05d30195959af450d53c4356ce4da96087d3b599";
	
	self.userTextField.text		= @"demo2@never.es";
	self.passwordTextField.text = @"sasasasa";
	
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

	NSURL *url = [NSURL URLWithString:URL];
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

- (IBAction)createUserService:(id)sender {
    
	[self createUser];
		
}

- (IBAction)modifyUserService:(id)sender {
    
	[self modifyUser];
    
}

- (IBAction)createCardToUserService:(id)sender {
    
	[self createCard];
    
}

- (IBAction)getMeService:(id)sender {
    
	[self meUser];
    
}

- (IBAction)getMeCardService:(id)sender {
    
	[self meCards];
    
}

- (IBAction)payService:(id)sender {
    
	[self createPayment];
    
}

-(void) modifyUser {
    NSString *clientID	= self.clientIDTextField.text;
	NSString *secretID	= self.secretIDTextField.text;
	
	NSString *path = @"api/v1/users/me";
 

	
	NSURL *url = [NSURL URLWithString:URL];
	AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
	[oauthClient getPath:path parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id me = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *path = [NSString stringWithFormat:@"api/v1/users/%@", me[@"user"][@"id"] ];
        NSDictionary *parameters = //@{@"id":@24};
        @{@"id":@25,@"user":@{@"name":@"Pedro",@"surname":@"Gomez", @"teams_followeds":@[@"Real Madrid"], @"gender":@"female",@"postal_address":@"31113"}};
        
        
        [oauthClient setParameterEncoding:AFJSONParameterEncoding];
        [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
        [oauthClient putPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
	}];
	
}

-(void) meUser {
    NSString *clientID	= self.clientIDTextField.text;
	NSString *secretID	= self.secretIDTextField.text;
	
	NSString *path = @"api/v1/users/me";
	NSDictionary *parameters = //@{@"id":@24};
    @{@"id":@25,@"user":@{@"name":@"Pedro", @"team_followed_id":@2, @"gender":@"female",@"postal_address":@"31113"}};
	
	
	NSURL *url = [NSURL URLWithString:URL];
	AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
	[oauthClient getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
		self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
	}];
    
    [self signout];
}


-(void) createUser {
    NSString *clientID	= self.clientIDTextField.text;
	NSString *secretID	= self.secretIDTextField.text;
	
	NSString *path = @"api/v1/registrations";
	NSDictionary *parameters = //@{@"id":@24};
    @{@"user":@{@"name":@"Pedro", @"surname":@"", @"password":self.passwordTextField.text,@"password_confirmation":self.passwordTextField.text,@"email":self.userTextField.text, @"gender":@"female",@"postal_address":@"31113", @"role":@1}};
	
	
	NSURL *url = [NSURL URLWithString:URL];
	AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
	[oauthClient postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
		self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
	}];
    
}


-(void) createCard {

        NSString *clientID	= self.clientIDTextField.text;
        NSString *secretID	= self.secretIDTextField.text;
        
        NSString *path = @"api/v1/payments";
        NSDictionary *parameters = @{@"name":self.userTextField.text, @"credit_card_name":@"Pedro", @"credit_card_number":@"5555555555554444",@"credit_card_cvv":@"311",@"credit_card_date":@"05/2014"};
        
        
        NSURL *url = [NSURL URLWithString:URL];
        AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
        [oauthClient setParameterEncoding:AFJSONParameterEncoding];
        [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
        [oauthClient postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
        }];

    
    

}

-(void) modifyCard {
    
    NSString *clientID	= self.clientIDTextField.text;
    NSString *secretID	= self.secretIDTextField.text;
    
    NSString *path = @"api/v1/payments/2";
    NSDictionary *parameters = @{@"credit_card_name":@"Pedro", @"credit_card_number":@"4005519200000004",@"credit_card_cvv":@"311",@"credit_card_date":@"05/2015"};
    
    
    NSURL *url = [NSURL URLWithString:URL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
    [oauthClient putPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    }];
    
}

-(void) signout {
    
    NSString *clientID	= self.clientIDTextField.text;
    NSString *secretID	= self.secretIDTextField.text;
    
    NSString *path = @"users/sign_out";
    NSDictionary *parameters = @{};
    
    
    NSURL *url = [NSURL URLWithString:URL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
    [oauthClient deletePath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    
}

-(void) meCards {
    
    NSString *clientID	= self.clientIDTextField.text;
    NSString *secretID	= self.secretIDTextField.text;
    
    NSString *path = @"api/v1/payments";
    NSDictionary *parameters = @{@"credit_card_name":@"Pedro", @"credit_card_number":@"4005519200000004",@"credit_card_cvv":@"311",@"credit_card_date":@"05/2015"};
    
    
    NSURL *url = [NSURL URLWithString:URL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
    [oauthClient getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    }];
    
}


-(void) createPayment {
    
    NSString *clientID	= self.clientIDTextField.text;
    NSString *secretID	= self.secretIDTextField.text;
    
    NSString *path = @"api/v1/bids";
    NSDictionary *parameters = @{@"amount":@"213", @"number":@"2",@"match_id":self.matchIdTextField.text,@"method":@"paypal"};
    
    
    NSURL *url = [NSURL URLWithString:URL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:clientID secret:secretID];
    [oauthClient setParameterEncoding:AFJSONParameterEncoding];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [oauthClient setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:oauthClient.serviceProviderIdentifier]];
    [oauthClient postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
      
        [webView setDelegate:self];
        
        NSString *urlAddress =JSON[@"url"];//
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        if ([JSON[@"status"] isEqualToString:@"ok"]) {
            [self.view addSubview:webView];
            [webView loadRequest:requestObj];
        } else {
            self.responseTextView.text = [NSString stringWithFormat:@"Response: %@", JSON];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.responseTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = [[request URL] absoluteString];
    if ([URLString isEqualToString:@"success:fake:url:es/"]) {
        [webView removeFromSuperview];
    }
    if ([URLString isEqualToString:@"fail:fake:url:es/"]) {
        [webView removeFromSuperview];
    }
    return YES;
}

@end
