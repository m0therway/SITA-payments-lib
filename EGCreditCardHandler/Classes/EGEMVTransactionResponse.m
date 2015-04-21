//
//  EGEMVTransactionResponse.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/20/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGEMVTransactionResponse.h"
#import <RBA_SDK/RBA_SDK.h>

/*
 * We want to use this long ugly method so these property names are
 * checked at compile time, but we'll clean it up with a macro.
 */

#define PROP_NAME(arg) NSStringFromSelector(@selector(arg))

@interface EGEMVTransactionResponse ()

@property(nonatomic,copy) NSString* eMVTrack2Encrypted;
@property(nonatomic,copy) NSString* eMVApplicationIdentifierField;
@property(nonatomic,copy) NSString* eMVIssuerScriptTemplate1Field;
@property(nonatomic,copy) NSString* eMVIssuerScriptTemplate2Field;
@property(nonatomic,copy) NSString* eMVApplicationInterchangeProfileField;
@property(nonatomic,copy) NSString* eMVDedicatedFileNameField;
@property(nonatomic,copy) NSString* eMVAuthorizationResponseCodeField;
@property(nonatomic,copy) NSString* eMVIssuerAuthenticationDataField;
@property(nonatomic,copy) NSString* eMVTerminalVerificationResultsField;
@property(nonatomic,copy) NSString* eMVTransactionDateField;
@property(nonatomic,copy) NSString* eMVTransactionStatusInformationField;
@property(nonatomic,copy) NSString* eMVCryptogramTransactionTypeField;
@property(nonatomic,copy) NSString* eMVIssuerCountryCodeField;
@property(nonatomic,copy) NSString* eMVTransactionCurrencyCodeField;
@property(nonatomic,copy) NSString* eMVTransactionAmountField;
@property(nonatomic,copy) NSString* eMVApplicationUsageControlField;
@property(nonatomic,copy) NSString* eMVApplicationVersionNumberField;
@property(nonatomic,copy) NSString* eMVIssuerActionCodeDenialField;
@property(nonatomic,copy) NSString* eMVIssuerActionCodeOnlineField;
@property(nonatomic,copy) NSString* eMVIssuerActionCodeDefaultField;
@property(nonatomic,copy) NSString* eMVIssuerApplicationDataField;
@property(nonatomic,copy) NSString* eMVTerminalCountryCodeField;
@property(nonatomic,copy) NSString* eMVInterfaceDeviceSerialNumberField;
@property(nonatomic,copy) NSString* eMVApplicationCryptogramField;
@property(nonatomic,copy) NSString* eMVCryptogramInformationDataField;
@property(nonatomic,copy) NSString* eMVTerminalCapabilitiesField;
@property(nonatomic,copy) NSString* eMVCardholderVerificationMethodResultsField;
@property(nonatomic,copy) NSString* eMVTerminalTypeField;
@property(nonatomic,copy) NSString* eMVApplicationTransactionCounterField;
@property(nonatomic,copy) NSString* eMVUnpredictableNumberField;
@property(nonatomic,copy) NSString* eMVTransactionSequenceCounterIDField;
@property(nonatomic,copy) NSString* eMVApplicationCurrencyCodeField;
@property(nonatomic,copy) NSString* eMVTransactionCategoryCodeField;
@property(nonatomic,copy) NSString* eMVIssuerScriptResultsField;
@property(nonatomic,copy) NSString* eMVPanSequenceNumber;
@property(nonatomic,copy) NSString* eMVServiceCode;
@property(nonatomic,copy) NSString* eMVShortFileIdentifier;
@property(nonatomic,copy) NSString* nonEMVPinEntryRequired;
@property(nonatomic,copy) NSString* nonEMVSignatureRequired;
@property(nonatomic,copy) NSString* nonEMVConfirmationResponseCode;
@property(nonatomic,copy) NSString* nonEMVTransactionType;
@property(nonatomic,copy) NSString* nonEMVErrorResponseCode;
@property(nonatomic,copy) NSString* nonEMVCardPaymentCode;
@property(nonatomic,copy) NSString* nonEMVCardEntryCode;

@end

@implementation EGEMVTransactionResponse

- (BOOL)isOfflineApproved
{
	//A = Approve (purchase or refund).
	//D = Decline (purchase or refund).
	//C = Completed (refund).
	//E = Error or incompletion (purchase or refund).
	
	return [self.nonEMVConfirmationResponseCode isEqualToString:@"A"];
}

- (void)updateWithRBAParameter:(NSInteger)parameterId
{
	while (true) {
		if ([RBA_SDK GetParamLen:parameterId] <= 0) {
			break;
		}
		
		NSString* parameter = [RBA_SDK GetParam:parameterId];
		[self setDataFromParameter:parameter];
	}
}

- (void)setDataFromParameter:(NSString*)parameter
{
	NSLog(@"Parameter: %@", parameter);
	NSArray* paramArray = [parameter componentsSeparatedByString:@":"];
	
	if ([paramArray count] == 3) {
		NSString* tag = [paramArray[0] substringFromIndex:1];
		NSString* data = [paramArray[2] substringFromIndex:1];
		NSString* propName = [EGEMVTransactionResponse propertyNameForTag:tag];
		
		if (propName) {
			[self setValue:data forKey:propName];
		} else {
			NSLog(@"Unknown tag: %@", tag);
		}
	}
}

- (void)setIntermediateAuthorizationResponseCode:(NSString*)intermediateARC
{
	self.eMVAuthorizationResponseCodeField = [EGEMVTransactionResponse arcForIntermediateARC:intermediateARC];
}

+ (NSString*)arcForIntermediateARC:(NSString*)intermediateARC
{
	static NSDictionary* lookupTable = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		lookupTable = @{
						@"Y1" : @"5931",
						@"Y3" : @"5933",
						@"Z1" : @"5A31",
						@"Z3" : @"5A33",
					  };
	});
	
	NSString* result = lookupTable[intermediateARC];
	
	if (result) {
		return result;
	} else {
		return intermediateARC;
	}
}

+ (NSString*)propertyNameForTag:(NSString*)tag
{
	static NSDictionary* lookupTable = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		lookupTable = @{
						@"1001"	:	PROP_NAME(nonEMVPinEntryRequired),	//Pin entry Required Flag. 0: Not required, 1: required
						@"1002"	:	PROP_NAME(nonEMVSignatureRequired),	//Signature Required Flag. 0: Not required, 1: required
						@"1003"	:	PROP_NAME(nonEMVConfirmationResponseCode),
						@"1005"	:	PROP_NAME(nonEMVTransactionType),	//Transaction type. 00 = Purchase. 01 = refund.
						@"1010"	:	PROP_NAME(nonEMVErrorResponseCode),
						@"9000"	:	PROP_NAME(nonEMVCardPaymentCode),	//Card Payment Type. A = Debit. B = Credit.
						@"9001"	:	PROP_NAME(nonEMVCardEntryCode),		//Card Entry Mode. C = Chip entry. D = Contactless EMV entry.
						@"8A"	:	@"intermediateAuthorizationResponseCode",	// this one isn't really a property, so that macro won't work
						@"95"	:	PROP_NAME(eMVTerminalVerificationResultsField),
						@"4F"	:	PROP_NAME(eMVApplicationIdentifierField),
						@"82"	:	PROP_NAME(eMVApplicationInterchangeProfileField),
						@"84"	:	PROP_NAME(eMVDedicatedFileNameField),
						@"9A"	:	PROP_NAME(eMVTransactionDateField),
						@"9B"	:	PROP_NAME(eMVTransactionStatusInformationField),
						@"9C"	:	PROP_NAME(eMVCryptogramTransactionTypeField),
						@"5F28"	:	PROP_NAME(eMVIssuerCountryCodeField),
						@"5F2A"	:	PROP_NAME(eMVTransactionCurrencyCodeField),
						@"5F34"	:	PROP_NAME(eMVPanSequenceNumber),
						@"9F02"	:	PROP_NAME(eMVTransactionAmountField),
						@"9F07"	:	PROP_NAME(eMVApplicationUsageControlField),
						@"9F08"	:	PROP_NAME(eMVApplicationVersionNumberField),
						@"9F0D"	:	PROP_NAME(eMVIssuerActionCodeDefaultField),
						@"9F0E"	:	PROP_NAME(eMVIssuerActionCodeDenialField),
						@"9F0F"	:	PROP_NAME(eMVIssuerActionCodeOnlineField),
						@"9F10"	:	PROP_NAME(eMVIssuerApplicationDataField),
						@"9F1A"	:	PROP_NAME(eMVTerminalCountryCodeField),
						@"9F1E" :	PROP_NAME(eMVInterfaceDeviceSerialNumberField),
						@"9F26"	:	PROP_NAME(eMVApplicationCryptogramField),
						@"9F27"	:	PROP_NAME(eMVCryptogramInformationDataField),
						@"9F33"	:	PROP_NAME(eMVTerminalCapabilitiesField),
						@"9F34"	:	PROP_NAME(eMVCardholderVerificationMethodResultsField),
						@"9F35"	:	PROP_NAME(eMVTerminalTypeField),
						@"9F36"	:	PROP_NAME(eMVApplicationTransactionCounterField),
						@"9F37"	:	PROP_NAME(eMVUnpredictableNumberField),
						@"9F41"	:	PROP_NAME(eMVTransactionSequenceCounterIDField),
						@"9F42"	:	PROP_NAME(eMVApplicationCurrencyCodeField),	//not support yet
						@"9F53"	:	PROP_NAME(eMVTransactionCategoryCodeField),
						@"FF1F"	:	PROP_NAME(eMVTrack2Encrypted)
					  };
	});
	
	return lookupTable[tag];
}

@end
