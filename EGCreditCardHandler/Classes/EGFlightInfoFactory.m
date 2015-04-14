//
//  EGFlightInfoFactory.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGFlightInfoFactory.h"
#import "EGFlightInfoImpl.h"

@implementation EGFlightInfoFactory

- (id<EGFlightInfo>)flightInfoWithCompanyId:(NSInteger)companyId
									 crewId:(NSInteger)crewId
								   deviceId:(NSString*)deviceId
							  departureTime:(NSDate*)departureTime
							   flightNumber:(NSString*)flightNumber
					 originatingAirportCode:(NSString*)originatingAirportCode
					 destinationAirportCode:(NSString*)destinationAirportCode
{
	return [[EGFlightInfoImpl alloc] initWithCompanyId:companyId
												crewId:crewId
											  deviceId:deviceId
										 departureTime:departureTime
										  flightNumber:flightNumber
								originatingAirportCode:originatingAirportCode
								destinationAirportCode:destinationAirportCode];
}

@end
