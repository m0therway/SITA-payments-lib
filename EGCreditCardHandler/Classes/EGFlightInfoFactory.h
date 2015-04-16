//
//  EGFlightInfoFactory.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An immutable object representing the current flight. This information is used
 * in the Payment Report. This object may be created using EGFlightInfoFactory.
 */
@protocol EGFlightInfo <NSObject>

/**
 * Identifier for the airline.
 */
- (NSInteger)companyId;

/**
 * identifier for the crew.
 */
- (NSInteger)crewId;

/**
 * Identifier for the device being used for transactions.
 */
- (NSString*)deviceId;

/**
 * Departure time.
 */
- (NSDate*)departureTime;

/**
 * Flight number.
 */
- (NSString*)flightNumber;

/**
 * Airport code of the originating airport. For instance, "ORD" for Chicago O'Hare.
 */
- (NSString*)originatingAirportCode;

/**
 * Airport code of the destination airport. For instance, "ORD" for Chicago O'Hare.
 */
- (NSString*)destinationAirportCode;

@end

/**
 * A factory for creating EGFlightInfo objects.
 */
@interface EGFlightInfoFactory : NSObject

+ (id<EGFlightInfo>)flightInfoWithCompanyId:(NSInteger)companyId
									 crewId:(NSInteger)crewId
								   deviceId:(NSString*)deviceId
							  departureTime:(NSDate*)departureTime
							   flightNumber:(NSString*)flightNumber
					 originatingAirportCode:(NSString*)originatingAirportCode
					 destinationAirportCode:(NSString*)destinationAirportCode;

@end
