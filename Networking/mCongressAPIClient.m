#import "mCongressAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kmCongressAPIBaseURLString = @"http://sopnia2013-chile.herokuapp.com/";


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
    self.estadoAutorizadorSincronizacionImagen = [defaults boolForKey:@"kAutorizadorSincronizacionImagen"];
    
    if (self.estadoAutorizadorSincronizacion == YES) {
        if ([fetchRequest.entityName isEqualToString:@"Evento"]) {
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"eventos" parameters:nil];
            
            
            NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);

        }
            else if ([fetchRequest.entityName isEqualToString:@"Persona"]) {
                
                mutableURLRequest = [self requestWithMethod:@"GET" path:@"personas" parameters:nil];
            
                
                NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
                                
}
            else if ([fetchRequest.entityName isEqualToString:@"Institucion"]) {
                
                mutableURLRequest = [self requestWithMethod:@"GET" path:@"institucions" parameters:nil];
                
                NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
                
                
}
            else if ([fetchRequest.entityName isEqualToString:@"Eventopadre"]) {
                
                mutableURLRequest = [self requestWithMethod:@"GET" path:@"eventopadres" parameters:nil];
                
                NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
}
        
            else if ([fetchRequest.entityName isEqualToString:@"Notificacion"]) {
                
                mutableURLRequest = [self requestWithMethod:@"GET" path:@"notificaciones" parameters:nil];
                
                NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
}
        

            else if ([fetchRequest.entityName isEqualToString:@"Lugar"]) {
                
                mutableURLRequest = [self requestWithMethod:@"GET" path:@"lugars" parameters:nil];
                
                NSLog(@"Debería Sincronizar ==> %@", [mutableURLRequest description]);
            }
else
            {
                NSLog(@"***NO*** Debería Sincronizar ==> %@", [mutableURLRequest description]);
            }
    }
    
    if (self.estadoAutorizadorSincronizacionImagen == YES) {
        
    if ([fetchRequest.entityName isEqualToString:@"Imagen"]) {
        
            mutableURLRequest = [self requestWithMethod:@"GET" path:@"imagens" parameters:nil];
            
            NSLog(@"Debería Sincronizar IMAGEN ==> %@", [mutableURLRequest description]);
            
        }
        else {
                        
            NSLog(@"***NO*** Debería Sincronizar IMAGEN==> %@", [mutableURLRequest description]);
        }
    }
    
        return mutableURLRequest;
}


- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
 
    return responseObject;
}


- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity 
                                 fromResponse:(NSHTTPURLResponse *)response

{
    
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    if ([entity.name isEqualToString:@"Imagen"]) {
            
            NSString *RepresentacionBinarioImagen = [NSString stringWithFormat:@"%@", [representation valueForKey:@"binarioImagen"]];
            [mutablePropertyValues setValue:RepresentacionBinarioImagen forKey:@"binarioImagen"];
            
        }


    return mutablePropertyValues;
}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response
{
    NSDictionary *diccionarioPaLasRelaciones = nil;
    if ([entity.name isEqualToString:@"Evento"]) {
        
        
        NSString *RepresentacionPalSpeaker = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"speaker_id"]];
        
        NSString *RepresentacionPalTipoDeEvento = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"tipoEvento_id"]];
        
        NSString *RepresentacionPallugarEnQueMeDesarrollo = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarEnQueMeDesarrollo_id"]];
        
        diccionarioPaLasRelaciones = @{ @"speaker" : @{@"id" : RepresentacionPalSpeaker },
                                        @"tipoEvento" : @{@"id" : RepresentacionPalTipoDeEvento }
                                        ,@"lugarEnQueMeDesarrollo" : @{@"id" : RepresentacionPallugarEnQueMeDesarrollo}  };
    }
    
    else if([entity.name isEqualToString:@"Persona"])
    {
        
        NSString *representacionPaLugarOrigen = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarDondeProvengo_id"]];
        
        if (![representacionPaLugarOrigen isEqualToString:@"(null)"]  && ![representacionPaLugarOrigen isEqualToString:@"<null>"]) {
            diccionarioPaLasRelaciones = @{ @"lugarDondeProvengo" : @{@"id" : representacionPaLugarOrigen }
                                            
                                            };
            
        }
        
        NSString *representacionNotifiDelHuea = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"notificacionSobreMi_id"]];
        
        if (![representacionPaLugarOrigen isEqualToString:@"(null)"]  && ![representacionPaLugarOrigen isEqualToString:@"<null>"]) {
            diccionarioPaLasRelaciones = @{ @"notificacionSobreMi" : @{@"id" : representacionNotifiDelHuea }
                                            
                                            };
            
        }

        
        
        
        NSString *representacionPaInstitucionPatrocinante = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionQueMePatrocina_id"]];
        if (![representacionPaInstitucionPatrocinante isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"institucionQueMePatrocina" : @{@"id" : representacionPaInstitucionPatrocinante}
                                           };
            
        }
    }
    
    else if([entity.name isEqualToString:@"Lugar"])
    {
        NSString *representacionPaInstitucionAqui = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionAqui_id"]];
        
        if (![representacionPaInstitucionAqui isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"institucionAqui" : @{@"id" : representacionPaInstitucionAqui}
                                           };
            
        }
        NSString *representacionPaPaisEnQueEstoy = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"paisEnQueEstoy_id"]];
        
        if (![representacionPaPaisEnQueEstoy isEqualToString:@"(null)"]  && ![representacionPaPaisEnQueEstoy isEqualToString:@"<null>"]) {
            diccionarioPaLasRelaciones = @{
                                           @"paisEnQueEstoy" : @{@"id" : representacionPaPaisEnQueEstoy}
                                           };
        }
    }
    
    else if([entity.name isEqualToString:@"Institucion"])
    {
        NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoQuePatrocino_id"]];
        if (![eventID isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"eventoQuePatrocino" : @{@"id" : eventID}
                                           };
            
        }
        
    }
    
    else if([entity.name isEqualToString:@"Eventopadres"])
    {
        NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionPatrocinante_id"]];
        if (![eventID isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"institucionPatrocinante" : @{@"id" : eventID}
                                           };
        }
    }
    
    else if([entity.name isEqualToString:@"Notificacion"])
    {
        NSString *representacionRelsTipoEvento= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoAsociado_id"]];
        if (![representacionRelsTipoEvento isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"eventoAsociado" : @{@"id" : representacionRelsTipoEvento}
                                           };
        }
    }
    else if([entity.name isEqualToString:@"Imagen"])
    {
        
        
        NSString *representacionPaPersonaQueGrafico = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaQueGrafico_id"]];
        
        if (![representacionPaPersonaQueGrafico isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"personaQueGrafico" : @{@"id" : representacionPaPersonaQueGrafico}
                                           };
        }
    }
    return diccionarioPaLasRelaciones;
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
