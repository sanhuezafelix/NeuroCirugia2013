#import "mCongressAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "Eventopadre.h"
#import "Persona.h"
#import "Lugar.h"
#import "Evento.h"
#import "Institucion.h"
#import "Notificacion.h"

static NSString * const kmCongressAPIBaseURLString = @"http://sopnia-2013-cl.herokuapp.com/";


@implementation mCongressAPIClient

+ (mCongressAPIClient *)sharedClient {
    static mCongressAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kmCongressAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                             withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableURLRequest = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.estadoAutorizadorSincronizacion = [defaults boolForKey:@"kAutorizadorSincronizacion"];
    
    if (self.estadoAutorizadorSincronizacion == YES) {
        if ([fetchRequest.entityName isEqualToString:@"Evento"]) {
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"eventos" parameters:nil];
            
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
            
        }
        else if ([fetchRequest.entityName isEqualToString:@"Persona"]) {
            
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"personas" parameters:nil];
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
            
        }
        else if ([fetchRequest.entityName isEqualToString:@"Lugar"]) {
            
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"lugars" parameters:nil];
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
            
            
        }
        else if ([fetchRequest.entityName isEqualToString:@"Eventopadre"]) {
            
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"eventopadres" parameters:nil];
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
        }
        
        else if ([fetchRequest.entityName isEqualToString:@"Notificacion"]) {
            
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"notificacions" parameters:nil];
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
        }
        
        else if ([fetchRequest.entityName isEqualToString:@"Institucion"]) {
            
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"institucions" parameters:nil];
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
            
        }
    }
    
    if (self.estadoAutorizadorSincronizacion == NO)
    {
        NSLog(@"***NO*** Debería Sincronizar ==> ");
    }
    NSLog(@"este es el mutablerequiest %@", [mutableURLRequest  description]);

    return mutableURLRequest;
}


- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    
    return responseObject;
}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response
{
    
    
    NSDictionary *diccionarioPaLasRelaciones = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.estadoAutorizadorUnaVezSync = [defaults boolForKey:@"kPrimeraSincro"];
    
    if (self.estadoAutorizadorUnaVezSync == YES) {
        
        if ([entity.name isEqualToString:@"Evento"]) {
            
            
            NSString *RepresentacionPalSpeaker = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"speaker_id"]];


            NSString *RepresentacionPalTipoDeEvento = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoPadre_id"]];


            NSString *RepresentacionPallugarEnQueMeDesarrollo = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarEnQueMeDesarrollo_id"]];
            diccionarioPaLasRelaciones = @{ @"speaker" : @{@"id" : RepresentacionPalSpeaker },
                                            @"eventoPadre" : @{@"id" : RepresentacionPalTipoDeEvento }
                                            ,@"lugarEnQueMeDesarrollo" : @{@"id" : RepresentacionPallugarEnQueMeDesarrollo}  };
        

        
        }

        else if([entity.name isEqualToString:@"Persona"])
        {
            NSString *Representacion1 = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarDondeProvengo_id"]];
            
            NSString *Representacion2= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"notificacionSobreMi_id"]];
            
            NSString *Representacion3 = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionQueMePatrocina_id"]];
            
            NSString *Representacion4 = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoParticipo_id"]];
         
            diccionarioPaLasRelaciones = @{ @"lugarDondeProvengo" : @{@"id" : Representacion1 },
                                            @"notificacionSobreMi" : @{@"id" : Representacion2 }
                                            ,@"institucionQueMePatrocina" : @{@"id" : Representacion3}  ,
                                            @"eventoParticipo" : @{@"id" : Representacion4 }};
        }
        
        
        
        
        else if([entity.name isEqualToString:@"Lugar"])
        {
            
            NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaDelQueSoyProcedencia_id"]];

                diccionarioPaLasRelaciones = @{
                                               @"personaDelQueSoyProcedencia" : @{@"id" : eventID}
                                               };
                
            
            
        }
        
        else if([entity.name isEqualToString:@"Institucion"])
        {
            NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoQuePatrocino_id"]];
           

            diccionarioPaLasRelaciones = @{
                                               @"eventoQuePatrocino" : @{@"id" : eventID}
                                               };
                
            
        }
        
        else if([entity.name isEqualToString:@"Eventopadre"])
        {
            NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionPatrocinante_id"]];

            diccionarioPaLasRelaciones = @{
                                               @"institucionPatrocinante" : @{@"id" : eventID}
                                               };
            
        }
        NSString *eventID2 = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarDesarrolloEP_id"]];

        diccionarioPaLasRelaciones = @{@"lugarDesarrolloEP" : @{@"id" : eventID2}
                                        };
        
        
    }
    
        else if([entity.name isEqualToString:@"Notificacion"])
        {
            NSString *representacionRelsTipoEvento= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoAsociado_id"]];

            diccionarioPaLasRelaciones = @{
                                               @"eventoAsociado" : @{@"id" : representacionRelsTipoEvento}
                                               };
            
            
            NSString *representacionRelsTipoEvento2= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaAsociada_id"]];

            diccionarioPaLasRelaciones = @{
                                               @"personaAsociada" : @{@"id" : representacionRelsTipoEvento2}
                                               };
            
        }
    
    

    return diccionarioPaLasRelaciones;
 
                NSLog(@" ************ PASO HACIENDO REPRE DE LAS RELACIONES ==> ");
        

}


- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

@end
