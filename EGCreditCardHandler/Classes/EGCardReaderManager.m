//
//  EGCardReaderManager.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCardReaderManager.h"
#import "EGLoggingDelegate.h"

// logging macros
#define EGLogError(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelError file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogWarn(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelWarn file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogInfo(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelInfo file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogDebug(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelDebug file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogVerbose(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelVerbose file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]


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
	EGLogVerbose(@"do swipe transaction");
	
	if (callback) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(nil);
		});
	}
}

- (void)performNFCTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	EGLogVerbose(@"do nfc transaction");
	
	if (callback) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(nil);
		});
	}
}

- (void)performEMVTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	EGLogVerbose(@"do emv transaction");
	
	if (callback) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(nil);
		});
	}
}

@end
