//
//  EGCardReaderManager.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCardReaderManager.h"

@interface EGCardReaderManager ()

@property(nonatomic,strong) id<EGLoggingDelegate> loggingDelegate;

@end


@implementation EGCardReaderManager

- (instancetype)initWithLoggingDelegate:(id<EGLoggingDelegate>)loggingDelegate
{
	self = [super init];
	
	if (self) {
		self.loggingDelegate = loggingDelegate;
	}
	
	return self;
}

- (void)performSwipeTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	NSLog(@"do swipe");
	
	if (callback) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(nil);
		});
	}
}

- (void)performNFCTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	NSLog(@"do nfc");
	
	if (callback) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(nil);
		});
	}
}

- (void)performEMVTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	NSLog(@"do emv");
	
	if (callback) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(nil);
		});
	}
}

@end
