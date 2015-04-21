//
//  EGCardReaderManager.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCardReaderManager.h"
#import "EGLoggingDelegate.h"
#import <RBA_SDK/RBA_SDK.h>
#import "EGConstants.h"
#import "EGCardTransactionFactory.h"
#import "EGEMVTransactionResponse.h"

// logging macros
#define EGLogError(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelError file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogWarn(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelWarn file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogInfo(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelInfo file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogDebug(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelDebug file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]
#define EGLogVerbose(frmt, ...) [self.loggingDelegate logMessageWithLevel:EGLogLevelVerbose file:__FILE__ function:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(frmt), ## __VA_ARGS__]


@interface EGCardReaderManager () <LogTrace_support, RBA_SDK_Event_support>

@property(nonatomic,weak) id<EGLoggingDelegate> loggingDelegate;
@property(nonatomic,copy) EGTransactionCallback currentTransactionCallback;
@property(nonatomic,strong) id<EGCardTransaction> currentTransaction;
@property(nonatomic,strong) EGEMVTransactionResponse* currentEMVResponse;

@end


@implementation EGCardReaderManager

#pragma mark - Public API

- (instancetype)initWithLoggingDelegate:(id<EGLoggingDelegate>)loggingDelegate
{
	self = [super init];
	
	if (self) {
		self.loggingDelegate = loggingDelegate;
		
		[LogTrace SetDelegate:self];
		[LogTrace SetDefaultLogLevel:LTL_TRACE];
		
		NSInteger result = [RBA_SDK Initialize];
		
		if (result != RESULT_SUCCESS) {
			EGLogError(@"Failed to initialize RBA SDK. Result code: %d", result);
			
			return nil;
		} else {
			EGLogInfo(@"RBA SDK initialized.");
			[RBA_SDK SetDelegate:self];
			
#warning TODO: payment service?
		}
	}
	
	return self;
}

- (void)dealloc {
	[self disconnectFromRBA];
}

- (void)performSwipeTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	EGLogVerbose(@"do swipe transaction");
	
	[self doNonEMVCardReadForTransaction:transaction withCallback:callback];
}

- (void)performNFCTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	EGLogVerbose(@"do nfc transaction");
	
	[self doNonEMVCardReadForTransaction:transaction withCallback:callback];
}

- (void)performEMVTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback
{
	EGLogVerbose(@"do emv transaction");
	
	[self doEMVCardReadForTransaction:transaction withCallback:callback];
}

#pragma mark - Logging Adapter

/*
 * For now we'll keep this simple. We may eventually want to parse the line (ick)
 * to re-extract logging data and route it out more elegantly to our logging framework.
 */
- (void)LogTraceOut:(NSString *)line
{
	EGLogInfo(@"%@", line);
}

#pragma mark - RBA_SDK_Event_support

- (void)ProcessPinPadParameters:(NSInteger)messageId
{
#warning TODO: how do we know if a message is blocking?
	
	EGLogVerbose(@"Received message callback: %d", messageId);
	
	switch (messageId) {
		case M23_CARD_READ: {
			EGLogDebug(@"Received card read message callback");
			[self handleNonEMVCardReadResponse];
			
			break;
		}
			
		case M33_02_EMV_TRANSACTION_PREPARATION_RESPONSE: {
			EGLogDebug(@"Received EMV transaction preparation response");
			[self handleEMVTransactionPreparationResponse];
			
			break;
		}
		
		case M33_03_EMV_AUTHORIZATION_REQUEST: {
			EGLogDebug(@"Received EMV authorization request");
			[self handleEMVAuthorizationRequest];
			
			break;
		}
			
		case M33_05_EMV_AUTHORIZATION_CONFIRMATION: {
			EGLogDebug(@"Received EMV authorization confirmation");
			[self handleEMVAuthorizationConfirmation];
			
			break;
		}
		
#warning TODO: handle cancellation (especially for chip card)?
		
		default: {
			EGLogWarn(@"Unhandled message callback: %d", messageId);
			break;
		}
	}
}

- (void)handleNonEMVCardReadResponse
{
	EGLogVerbose(@"Read card type: %@", [self lastReadCardSource]);
	NSString* serviceCode = [self getVariable:@"000413" outError:nil];
	NSError* error = nil;
	
#warning TODO: Peter's code stops if the card is invalid OR if it's a chip card. Why?
	if ([self isCardValidAndMagnetic:serviceCode]) {
		NSString* exitType = [RBA_SDK GetParam:P23_RES_EXIT_TYPE];
		
		if ([exitType isEqualToString:@"0"]) {
			NSString* track1 = [RBA_SDK GetParam:P23_RES_TRACK1];
			NSString* track2 = [RBA_SDK GetParam:P23_RES_TRACK2];
			NSString* track3 = [RBA_SDK GetParam:P23_RES_TRACK3];
			
			EGLogVerbose(@"Got track 1 data: %@", track1);
			EGLogVerbose(@"Got track 2 data: %@", track2);
			EGLogVerbose(@"Got track 3 data: %@", track3);
#warning TODO: Add to Payment Report
		} else {
			EGLogWarn(@"Got exit type: %@. Aborting.", exitType);
			error = [NSError errorWithDomain:EGRBASDKErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Invalid exit type." }];
		}
	} else {
		EGLogWarn(@"Invalid or chip card service code: %@. Aborting.", serviceCode);
		error = [NSError errorWithDomain:EGRBASDKErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Invalid or chip card service code." }];
	}
	
	[self takeRBAOffline];
	
	if (self.currentTransactionCallback) {
		EGTransactionCallback callback = self.currentTransactionCallback;
		self.currentTransactionCallback = nil;
		self.currentTransaction = nil;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(error);
		});
	}
}

- (void)handleEMVTransactionPreparationResponse
{
	self.currentEMVResponse = [[EGEMVTransactionResponse alloc] init];
	[self.currentEMVResponse updateWithRBAParameter:P33_02_RES_EMV_TAG];
	[RBA_SDK SetParam:P04_REQ_FORCE_PAYMENT_TYPE data:@"0"];
	[RBA_SDK SetParam:P04_REQ_PAYMENT_TYPE data:@"B"];
	[RBA_SDK SetParam:P04_REQ_AMOUNT data:@"000"];
	[RBA_SDK ProcessMessage:M04_SET_PAYMENT_TYPE];
	
	// apparently we need the amount in cents
	NSInteger centAmount = [[[self.currentTransaction amount] decimalNumberByMultiplyingByPowerOf10:2] integerValue];
	[RBA_SDK SetParam:P13_REQ_AMOUNT data:[NSString stringWithFormat:@"%ld", centAmount]];
	[RBA_SDK ProcessMessage:M13_AMOUNT];
	[RBA_SDK ResetParam:P_ALL_PARAMS];
	
	// presumably this triggers another callback to ProcessPinPadParameters?
}

- (void)handleEMVAuthorizationRequest
{
	[RBA_SDK SetParam:P33_04_RES_STATUS data:@"00"];
	[RBA_SDK SetParam:P33_04_RES_EMVH_CURRENT_PACKET_NBR data:@"0"];
	[RBA_SDK SetParam:P33_04_RES_EMVH_PACKET_TYPE data:@"0"];
	[RBA_SDK AddTagParam:M33_04_EMV_AUTHORIZATION_RESPONSE tagid:0x1004 string:@"0"];
	[RBA_SDK AddTagParam:M33_04_EMV_AUTHORIZATION_RESPONSE tagid:0x8A string:@"00"];
	[RBA_SDK ProcessMessage:M33_04_EMV_AUTHORIZATION_RESPONSE];
	
	[RBA_SDK ResetParam:P_ALL_PARAMS];
	
	// presumably this triggers another callback to ProcessPinPadParameters?
}

- (void)handleEMVAuthorizationConfirmation {
	[self.currentEMVResponse updateWithRBAParameter:P33_05_RES_EMV_TAG];
	
#warning TODO: what is this for?
//	_emv.EMVApplicationCurrencyCode = _emv.EMVTransactionCurrencyCode   //IJ not supprot yet
	
	[RBA_SDK ResetParam:P_ALL_PARAMS];
	NSError* error = nil;
	
	if ([self.currentEMVResponse isOfflineApproved]) {
#warning TODO: Add to Payment Report
	} else {
		EGLogWarn(@"Unexpected confirmation response code: %@. Aborting.", self.currentEMVResponse.nonEMVConfirmationResponseCode);
		error = [NSError errorWithDomain:EGRBASDKErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Unexpected confirmation response code." }];
	}
	
	[self takeRBAOffline];
	
	if (self.currentTransactionCallback) {
		EGTransactionCallback callback = self.currentTransactionCallback;
		self.currentTransactionCallback = nil;
		self.currentTransaction = nil;
		self.currentEMVResponse = nil;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(error);
		});
	}
}

#pragma mark - RBA handling

- (NSError*)errorForRBAResult:(NSInteger)result withDescription:(NSString*)description
{
	return [NSError errorWithDomain:EGRBASDKErrorDomain
							   code:result
						   userInfo:@{NSLocalizedDescriptionKey : description}];
}

- (NSError*)connectToRBA
{
	EGLogVerbose(@"Connecting to RBA SDK");
	
	static bool firstTime = true;
	NSInteger ret = RESULT_ERROR;
	// Set Timeouts
	SETTINGS_COMM_TIMEOUTS comm_timeouts;
	comm_timeouts.ConnectTimeout = 0;
	comm_timeouts.ReceiveTimeout = 0;
	comm_timeouts.SendTimeout    = 0;
	[RBA_SDK SetCommTimeouts:comm_timeouts];
	
	[RBA_SDK SetDelegate:self];
	if( firstTime )
	{
		SETTINGS_COMMUNICATION commSetting;
#warning TODO: apparently it is possible to connect in the Simulator using TCP/IP?
//		if( TCP_CONNECTION ) {
//			commSetting.interface_id = TCPIP_INTERFACE;
//			strcpy(commSetting.ip_config.IPAddress,IP_ADDRESS);
//			strcpy(commSetting.ip_config.Port,IP_PORT);
//		}
//		else {
			memset(&commSetting,0,sizeof(SETTINGS_COMMUNICATION));
			commSetting.interface_id = ACCESSORY_INTERFACE;
//		}
		// Connecting ...
		ret = [RBA_SDK Connect:commSetting];
		
		firstTime = false;
	}
	else {
		// Reconnecting ...
		ret = [RBA_SDK Reconnect];
	}
	
	if (ret == RESULT_SUCCESS) {
		EGLogVerbose(@"Successfully connected to RBA SDK");
		return nil;
	} else {
		return [self errorForRBAResult:ret withDescription:@"RBA connection failed"];
	}
}

- (void)disconnectFromRBA
{
	EGLogVerbose(@"Disconnecting from RBA SDK");
	
	if( [RBA_SDK GetConnectionStatus] == CONNECTED )
	{
		[self takeRBAOffline];
	}
	
	[RBA_SDK SetDelegate:nil];
	[RBA_SDK Disconnect];
}

- (NSError*)takeRBAOnline
{
	[RBA_SDK SetParam:P01_REQ_APPID data:@"0000"];
	[RBA_SDK SetParam:P01_REQ_PARAMID data:@"0000"];
	NSInteger ret = [RBA_SDK ProcessMessage:M01_ONLINE];
	
	if(ret == RESULT_SUCCESS) {
		return nil;
	} else {
		return [self errorForRBAResult:ret withDescription:@"Failed to take RBA online"];
	}
}

- (NSError*)takeRBAOffline
{
	NSInteger ret = [RBA_SDK ProcessMessage:M00_OFFLINE];
	
	if(ret == RESULT_SUCCESS) {
		return nil;
	} else {
		return [self errorForRBAResult:ret withDescription:@"Failed to take RBA offline"];
	}
}

- (NSError*)enableCardSource
{
	[self takeRBAOffline];
	
	NSError* error = nil;
	NSString* currentValue = [self readConfigurationGroup:@"13" index:@"14" outError:&error];
	
	if (error) {
		// we'll treat this as non-fatal
		EGLogError(@"Failed to read current card source config: %@", error);
		error = nil;
	}
	
	if ([currentValue integerValue] == 1) {
		// already set to the right value
		return nil;
	}
	
	// write out the new setting
	error = [self writeConfigurationGroup:@"13" index:@"14" data:@"1"];
	
	return error;
}

- (NSError*)enableSmartCard
{
	NSError* error = nil;
	
	if ([RBA_SDK GetConnectionStatus] != CONNECTED) {
		error = [self connectToRBA];
		
		if (error) {
			return error;
		}
	}
	
	NSString* currentValue = [self readConfigurationGroup:@"19" index:@"1" outError:&error];
	
	if (error) {
		// we'll treat this as non-fatal
		EGLogError(@"Failed to read current smart card config: %@", error);
		error = nil;
	}
	
	if ([currentValue integerValue] == 1) {
		// already set to the right value
		return nil;
	}
	
	// write out the new setting
	error = [self writeConfigurationGroup:@"19" index:@"11" data:@"1"];
	
	return error;
}

- (NSError*)writeConfigurationGroup:(NSString*)group index:(NSString*)index data:(NSString*)data
{
	EGLogDebug(@"CONFIGURATION WRITE %@_%@ =%@",group,index,data);
	
	[RBA_SDK SetParam:P60_REQ_GROUP_NUM data:group];
	[RBA_SDK SetParam:P60_REQ_INDEX_NUM data:index];
	[RBA_SDK SetParam:P60_REQ_DATA_CONFIG_PARAM data:data];
	
	NSInteger result = [RBA_SDK ProcessMessage:M60_CONFIGURATION_WRITE];
	
	if( result != RESULT_SUCCESS ) {
		return [self errorForRBAResult:result withDescription:@"Failed to write configuration"];
	} else {
		NSString* status = [RBA_SDK GetParam:P60_RES_STATUS];
		
		if( [status isEqualToString:@"2"] ) {
			return nil;
		} else {
			NSString* desc = [NSString stringWithFormat:@"Failed to write configuration. Status code: %@", status];
			return [self errorForRBAResult:result withDescription:desc];
		}
	}
}

- (NSString*)readConfigurationGroup:(NSString*)group index:(NSString*)index outError:(NSError**)outError
{
	NSString* data = nil;
	// set parameters
	[RBA_SDK SetParam:P61_REQ_GROUP_NUM data:group];
	[RBA_SDK SetParam:P61_REQ_INDEX_NUM data:index];
	
	NSInteger result = [RBA_SDK ProcessMessage:M61_CONFIGURATION_READ];
	
	// process message - send/receive
	if( result != RESULT_SUCCESS )
	{
		if (outError) {
			*outError = [self errorForRBAResult:result withDescription:@"Failed to read configuration"];
		}
	}
	else
	{
		NSString* status = [RBA_SDK GetParam:P61_RES_STATUS];
		data = [RBA_SDK GetParam:P61_RES_DATA_CONFIG_PARAMETER];
		
		EGLogDebug(@"CONFIGURATION READ %@_%@ = %@",[RBA_SDK GetParam:P61_RES_GROUP_NUM],[RBA_SDK GetParam:P61_RES_INDEX_NUM],data);
		
		if(![status isEqualToString:@"2"] && outError) {
			NSString* desc = [NSString stringWithFormat:@"Failed to read configuration. Status code: %@", status];
			*outError = [self errorForRBAResult:result withDescription:desc];
		}
	}
	
	return data;
}

- (NSString*)getVariable:(NSString*)varId outError:(NSError**)outError
{
	EGLogVerbose(@"Get Variable:%@",varId);
	
	NSString* value = nil;
	[RBA_SDK SetParam:P29_REQ_VARIABLE_ID data:varId];
	NSInteger result = [RBA_SDK ProcessMessage:M29_GET_VARIABLE];
	
	if(result != RESULT_SUCCESS) {
		if (outError) {
			*outError = [self errorForRBAResult:result withDescription:@"Failed to send GET_VARIABLE message"];
		}
	} else {
		NSString* status = [RBA_SDK GetParam:P29_RES_STATUS];
		
		if( [status isEqualToString:@"2"] ) {                       // OK
			EGLogVerbose(@"Got P29_RES_STATUS = 2 (OK)");
			value = [RBA_SDK GetParam:P29_RES_VARIABLE_DATA];
		}
		else if( [status isEqualToString:@"6"] ) {                  // Empty
			EGLogVerbose(@"Got P29_RES_STATUS = 2 (EMPTY)");
			value = nil;
		}
		else {                                                      // Error
			if (outError) {
				NSString* desc =[NSString stringWithFormat:@"Error in P29_RES_STATUS response: %@", status];
				*outError = [self errorForRBAResult:result withDescription:desc];
			}
			
			EGLogWarn(@"Got P29_RES_STATUS = %@ (ERROR)", status);
			EGLogWarn(@"Got P29_RES_VARIABLE_ID = %@", [RBA_SDK GetParam:P29_RES_VARIABLE_ID]);
			EGLogWarn(@"Got P29_RES_VARIABLE_DATA = %@", [RBA_SDK GetParam:P29_RES_VARIABLE_DATA]);
		}
	}
	
	return value;
}

- (BOOL)isCardValidAndMagnetic:(NSString*)serviceCode
{
	if ([serviceCode length] == 0 ||
		[serviceCode isEqualToString:@"000"] ||
		[serviceCode hasPrefix:@"2"] ||
		[serviceCode hasPrefix:@"6"]) {
		
		return NO;
	} else {
		return YES;
	}
}

- (void)setDevicePrompt:(NSString*)prompt
{
	[RBA_SDK SetParam:P23_REQ_PROMPT_INDEX data:prompt];
}

- (NSString*)lastReadCardSource
{
	return [RBA_SDK GetParam:P23_RES_CARD_SOURCE];
}

- (void)doNonEMVCardReadForTransaction:(id<EGCardTransaction>)transaction withCallback:(EGTransactionCallback)callback
{
#warning TODO: do we even want flight info in here? Maybe we should decouple the Payment Service.
	NSError* error = nil;
	
	if ([RBA_SDK GetConnectionStatus] != CONNECTED) {
		error = [self connectToRBA];
		
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(error);
			});
			
			return;
		}
	}
	
	error = [self enableCardSource];
	
	if (error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(error);
		});
		
		return;
	}
	
#warning TODO: Peter has 'DisableKeyedIn' here. Is that necessary? What does it do?
	[self setDevicePrompt:@"This is a prompt"];
	
	self.currentTransaction = transaction;
	self.currentTransactionCallback = callback;
	[RBA_SDK ProcessMessage:M23_CARD_READ];
	// we should now get a callback to ProcessPinPadParameters
}

- (void)doEMVCardReadForTransaction:(id<EGCardTransaction>)transaction withCallback:(EGTransactionCallback)callback
{
#warning TODO: do we even want flight info in here? Maybe we should decouple the Payment Service.
	NSError* error = nil;
	
	if ([RBA_SDK GetConnectionStatus] != CONNECTED) {
		error = [self connectToRBA];
		
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(error);
			});
			
			return;
		}
	}
	
	error = [self enableSmartCard];
	
	if (error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(error);
		});
		
		return;
	}
	
#warning TODO: Peter has 'DisableKeyedIn' here. Is that necessary? What does it do?
	error = [self takeRBAOnline];
	
	if (error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			callback(error);
		});
		
		return;
	}
	
	[RBA_SDK SetParam:P14_REQ_TXN_TYPE data:@"01"];
	[RBA_SDK ProcessMessage:M14_SET_TXN_TYPE];
	
	// apparently we need the amount in cents
	NSInteger centAmount = [[[transaction amount] decimalNumberByMultiplyingByPowerOf10:2] integerValue];
	[RBA_SDK SetParam:P13_REQ_AMOUNT data:[NSString stringWithFormat:@"%ld", centAmount]];
	
	self.currentTransaction = transaction;
	self.currentTransactionCallback = callback;
	[RBA_SDK ProcessMessage:M13_AMOUNT];
	// we should now get a callback to ProcessPinPadParameters
}

@end
