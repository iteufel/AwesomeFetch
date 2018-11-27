#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerDataRequest.h"


void handleRequest(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
  NSMutableURLRequest *httprequest =
  [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:request.headers[@"X-Url"]]];
  NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
  [headers removeObjectForKey:@"X-Url"];
  [headers removeObjectForKey:@"Host"];
  [headers removeObjectForKey:@"Access-Control-Request-Headers"];
  [headers removeObjectForKey:@"Origin"];
  [headers removeObjectForKey:@"Access-Control-Request-Method"];
  [httprequest setHTTPMethod:request.method];
  [httprequest setAllHTTPHeaderFields: headers];

  if(request.hasBody) {
    httprequest.HTTPBody = request.data;
  }
  NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:httprequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    GCDWebServerDataResponse* cresponse = [GCDWebServerDataResponse responseWithData:data contentType:httpResponse.allHeaderFields[@"Content-Type"]];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      NSMutableDictionary *allHeadders = [NSMutableDictionary dictionaryWithDictionary:[httpResponse allHeaderFields]];
      [allHeadders removeObjectForKey:@"Content-Length"];
      [allHeadders removeObjectForKey:@"Content-Type"];
      [allHeadders removeObjectForKey:@"Strict-Transport-Security"];
      [allHeadders removeObjectForKey:@"content-security-policy"];
      [allHeadders removeObjectForKey:@"Content-Encoding"];
      allHeadders[@"Access-Control-Allow-Headers"] = @"X-Url";
      allHeadders[@"Access-Control-Allow-Origin"] = @"*";
      allHeadders[@"Cache-Control"] = @"no-cache";
      
      allHeadders[@"Access-Control-Allow-Methods"] = @"OPTIONS, GET, POST, PUT, DELETE, HEAD";
      
      
      for (NSString* key in allHeadders) {
        [cresponse setValue:allHeadders[key] forAdditionalHeader:key];
      }
    }
    completionBlock(cresponse);
  }];
  [task resume];
}

GCDWebServer* startProxy()
{
  GCDWebServer* webServer = [[GCDWebServer alloc] init];
  
  [webServer addDefaultHandlerForMethod:@"OPTIONS"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        
                        GCDWebServerDataResponse* cresponse = [GCDWebServerDataResponse responseWithStatusCode:204];
                        [cresponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
                        [cresponse setValue:@"OPTIONS, GET, POST, PUT, DELETE, HEAD" forAdditionalHeader:@"Access-Control-Allow-Methods"];
                        [cresponse setValue:@"X-Url" forAdditionalHeader:@"Access-Control-Allow-Headers"];
                        [cresponse setValue:@"1728000" forAdditionalHeader:@"Access-Control-Max-Age"];
                        
                        completionBlock(cresponse);
                      }];
  
  [webServer addDefaultHandlerForMethod:@"GET"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        handleRequest(request, completionBlock);
                      }];
  
  [webServer addDefaultHandlerForMethod:@"POST"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        handleRequest(request, completionBlock);
                      }];
  
  [webServer addDefaultHandlerForMethod:@"HEAD"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        handleRequest(request, completionBlock);
                      }];
  
  [webServer addDefaultHandlerForMethod:@"DELETE"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        handleRequest(request, completionBlock);
                      }];
  
  [webServer addDefaultHandlerForMethod:@"UPDATE"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        handleRequest(request, completionBlock);
                      }];
  
  [webServer addDefaultHandlerForMethod:@"PUT"
                           requestClass:[GCDWebServerDataRequest class]
                      asyncProcessBlock:^(GCDWebServerDataRequest* request, GCDWebServerCompletionBlock completionBlock) {
                        
                        handleRequest(request, completionBlock);
                      }];
  
  
  
  [webServer startWithPort:8078 bonjourName:nil];
  
  return webServer;
}


static GCDWebServer* proxy = nil;

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CapacitorAwesomeFetch, "CapacitorAwesomeFetch",
           if(proxy == nil) {
             proxy = startProxy();
           }
)

