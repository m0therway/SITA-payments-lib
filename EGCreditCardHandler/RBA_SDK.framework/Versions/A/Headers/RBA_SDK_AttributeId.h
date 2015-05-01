/**************************************************************************
 *  THIS IS AUTO-GENERATED FILE. DO NOT EDIT
 *  INSTEAD OF THIS EDIT rba_sdk.xml and run XML2RBA_SDK.pl
 **************************************************************************/
//! \addtogroup	sdk_c_api
//!@{
//! \enum RBA_SDK_ATTRIBUTE_ID
//!
//! Interval for battery timer
//!\var	BATTERY_TIMER_INTERVAL_MINUTES
//!\brief		Interval for checking battery level, in minutes
//!
//! Process message timeout
//!\var	PROCESS_MESSAGE_TIMEOUT_SEC
//!\brief		Maximum timeout for the processing one message, in seconds
//!
//! Discover Service
//!\var	DISCOVER_SERVICE_UDP_PORT
//!\brief		UDP port to send broadcast messages. The same port uses for listening response

enum RBA_SDK_ATTRIBUTE_ID {

//! \cond PRIVATE
//SSL Attribute for TCP/IP session
	SSL_ROOT_CERTIFICATE_FILE = 0,
//! \endcond
//! \cond PRIVATE
	SSL_CERTIFICATE_FILE_1 = 1,
//! \endcond
//! \cond PRIVATE
	SSL_CERTIFICATE_FILE_2 = 2,
//! \endcond
//! \cond PRIVATE
	SSL_CERTIFICATE_FILE_3 = 3,
//! \endcond
//! \cond PRIVATE
	SSL_CERTIFICATE_FILE_4 = 4,
//! \endcond
//! \cond PRIVATE
	SSL_LOCAL_CERTIFICATE_FILE = 5,
//! \endcond
//! \cond PRIVATE
	SSL_PRIVATE_KEY_FILE = 6,
//! \endcond
//! \cond PRIVATE
	SSL_SECURE_PROTOCOL = 7,
//! \endcond

//Interval for battery timer
	BATTERY_TIMER_INTERVAL_MINUTES = 8,

//Process message timeout
	PROCESS_MESSAGE_TIMEOUT_SEC = 9,

//Discover Service
	DISCOVER_SERVICE_UDP_PORT = 10,

//! \cond PRIVATE
//Last Attribute for internal use
	ATTRIBUTE_LAST = 11,
//! \endcond

};
//!@}
