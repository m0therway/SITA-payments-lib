//
//  EGFlightInfoImpl.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGFlightInfoImpl.h"

@interface EGFlightInfoImpl ()

@property(nonatomic) NSInteger companyId;
@property(nonatomic) NSInteger crewId;
@property(nonatomic,copy) NSString* deviceId;
@property(nonatomic,copy) NSDate* departureTime;
@property(nonatomic,copy) NSString* flightNumber;
@property(nonatomic,copy) NSString* originatingAirportCode;
@property(nonatomic,copy) NSString* destinationAirportCode;

@end

@implementation EGFlightInfoImpl

- (instancetype)initWithCompanyId:(NSInteger)companyId
						   crewId:(NSInteger)crewId
						 deviceId:(NSString*)deviceId
					departureTime:(NSDate*)departureTime
					 flightNumber:(NSString*)flightNumber
		   originatingAirportCode:(NSString*)originatingAirportCode
		   destinationAirportCode:(NSString*)destinationAirportCode;
{
	self = [super init];
	
	if (self) {
		self.companyId = companyId;
		self.crewId = crewId;
		self.deviceId = deviceId;
		self.departureTime = departureTime;
		self.flightNumber = flightNumber;
		self.originatingAirportCode = originatingAirportCode;
		self.destinationAirportCode = destinationAirportCode;
	}
	
	return self;
}

@end
