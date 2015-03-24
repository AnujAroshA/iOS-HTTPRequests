//
//  ViewController.m
//  HttpRequests
//
//  Created by Anuja Piyadigama on 3/15/15.
//  Copyright (c) 2015 AnujAroshA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - ViewController lifecycle methods

/**
 *  All the HTTP request calling methods call inside this
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    /*
     *  Keep your server request outside of the main queue in all posible oppotunities
     */
    
//    [self performSelectorInBackground:@selector(sendHttpGet) withObject:nil];
    
//    [self performSelectorInBackground:@selector(sendHttpGetAsync) withObject:nil];
    
//    [self performSelectorInBackground:@selector(sendHttpGetMutable) withObject:nil];
    
//    [self performSelectorInBackground:@selector(sendHttpPost) withObject:nil];
    
    /*
     *  Enen though following method call leads to a server request, it needs to be call inside the main thread
     *  because of the delegate pattern it used.
     */
    
    [self sendHttpPostDataDelegate];
}

#pragma mark - supportive methods

/**
 *  Sends synchronous (happening at the same time) HTTP GET request to your localhost.
 *  Gather response data inside the same method.
 */
- (void)sendHttpGet {
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    /*
     *  String literal that hardcode the localhost server URL which handles the HTTP GET request
     */
    NSString *urlStr = @"http://127.0.0.1/restapi/index.php?name=Anuja";
    
    /*
     *  URLWithString - Returns an NSURL object initialized with URLString.
     *                  If the URL string was malformed or nil, returns nil.
     */
    NSURL *url = [NSURL URLWithString:urlStr];
    
    /*
     *  requestWithURL - Creates and returns a URL request for a specified URL with default cache policy (NSURLRequestUseProtocolCachePolicy) and timeout value (60 seconds).
     *
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    
    /*
     *  sendSynchronousRequest:returningResponse:error: - Performs a synchronous load of the specified URL request.
     *                                                    Returns the downloaded data for the URL request. 
     *                                                    Returns nil if a connection could not be created or if the download fails.
     */
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%s - %d # responseStr = %@", __PRETTY_FUNCTION__, __LINE__, responseStr);
}

/**
 *  Sends Asynchronous (NOT happening at the same time) HTTP GET request to your localhost.
 *  Gather response data inside the block of request class method.
 */
- (void)sendHttpGetAsync {
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSString *urlStr = @"http://127.0.0.1/restapi/index.php?name=AnujA";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    /*
     *  sendAsynchronousRequest:queue:completionHandler: - Loads the data for a URL request and executes a handler block on an operation queue when the request completes or fails.
     */
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%s - %d # responseStr = %@", __PRETTY_FUNCTION__, __LINE__, responseStr);
    }];
}


/**
 *  Sends synchronous (happening at the same time) HTTP mutable GET request to your localhost.
 *  Importance of mutability is we can modify request header.
 *  Gather response data inside the same method.
 */
- (void)sendHttpGetMutable {
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSString *urlStr = @"http://127.0.0.1/restapi/index.php?name=anuja";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"GET"];
    
    /*
     *  addValue:forHTTPHeaderField: - Adds an HTTP header to the receiver’s HTTP header dictionary.
     *                                 This is the way we add custom headers to a HTTP request.
     *                                 Otherwise we use setValue:forHTTPHeaderField: method to set values to existing headers.
     */
    [request addValue:@"apiuser" forHTTPHeaderField:@"X-USERNAME"];
    
    /*
     *  allHTTPHeaderFields - Listing all of the receiver’s HTTP header fields. (read-only)
     */
    NSLog(@"%s - %d # allHTTPHeaderFields = %@", __PRETTY_FUNCTION__, __LINE__, [request allHTTPHeaderFields]);
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%s - %d # responseStr = %@", __PRETTY_FUNCTION__, __LINE__, responseStr);
}

/**
 *  Sends synchronous HTTP POST request.
 *  Gather response data inside the same method.
 */
- (void)sendHttpPost {
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSString *postMsg = @"name=AnujAroshA";
    NSString *urlStr = @"http://127.0.0.1/restapi/index.php";
    
    /*
     *  dataUsingEncoding:allowLossyConversion: - Returns nil if flag is NO and the receiver can’t be converted without losing some information.
     */
    NSData *postData = [postMsg dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    /*
     *  Sets value for default header field
     */
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    /*
     *  Add customer header field and value
     */
    [request addValue:@"apiuser" forHTTPHeaderField:@"X-USERNAME"];
    
    [request setHTTPBody:postData];

    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%s - %d # responseStr = %@", __PRETTY_FUNCTION__, __LINE__, responseStr);
}

/**
 *  Sends HTTP POST request.
 *  Gather response data using NSURLConnectionDataDelegate methods
 */
- (void)sendHttpPostDataDelegate {
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSString *postMsg = @"name=anujarosha";
    NSString *urlStr = @"http://127.0.0.1/restapi/index.php";
    
    NSData *postData = [postMsg dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"apiuser" forHTTPHeaderField:@"X-USERNAME"];
    
    [request setHTTPBody:postData];
    
    /*
     * Calling for the NSURLConnectionDataDelegate
     */
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"%s - %d # Connection Successful", __PRETTY_FUNCTION__, __LINE__);
    } else {
        NSLog(@"%s - %d # Connection could not be made", __PRETTY_FUNCTION__, __LINE__);
    }
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%s - %d # response = %@", __PRETTY_FUNCTION__, __LINE__, response);
}

@end
