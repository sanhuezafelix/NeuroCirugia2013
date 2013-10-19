#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface mCongressAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (mCongressAPIClient *)sharedClient;

@property BOOL estadoAutorizadorSincronizacion;
@property BOOL estadoAutorizadorUnaVezSync;


@end
