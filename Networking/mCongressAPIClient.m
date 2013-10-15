#import "mCongressAPIClient.h"
#import "AFJSONRequestOperation.h"

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
    
//    self.estadoAutorizadorSincronizacionImagen = [defaults boolForKey:@"kAutorizadorSincronizacionImagen"];
    
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
        else
        {
            NSLog(@"***NO*** Debería Sincronizar ==> %@", [mutableURLRequest description]);
        }
    }
    
//    if (self.estadoAutorizadorSincronizacionImagen == YES) {
//        
//        if ([fetchRequest.entityName isEqualToString:@"Imagen"]) {
//            
//            mutableURLRequest = [self requestWithMethod:@"GET" path:@"imagens" parameters:nil];
//            
//            NSLog(@"Debería Sincronizar IMAGEN ==> %@", [mutableURLRequest description]);
//        }
//        else {
//            
//            NSLog(@"***NO*** Debería Sincronizar IMAGEN==> %@", [mutableURLRequest description]);
//        }
//    }
    
    return mutableURLRequest;
}


- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    
    return responseObject;
}

//- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
//                                     ofEntity:(NSEntityDescription *)entity
//                                 fromResponse:(NSHTTPURLResponse *)response
//
//{
//    
//    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
//    if ([entity.name isEqualToString:@"Lugar"]) {
//        
//        NSString *RepresentacionBinarioImagen = [NSString stringWithFormat:@"%@", [representation valueForKey:@"pais"]];
//        [mutablePropertyValues setValue:RepresentacionBinarioImagen forKey:@"pais"];
//        
//    }
//    ///pa cambiar una heua no más
//    
//    return mutablePropertyValues;
//}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response
{
    NSDictionary *diccionarioPaLasRelaciones = nil;
    
    if ([entity.name isEqualToString:@"Evento"]) {
        
        NSString *RepresentacionEventoPadre = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoPadre_id"]];
        
        
        NSString *RepresentacionLugarEnQueMeDesarrollo = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarEnQueMeDesarrollo_id"]];

        NSString *RepresentacionSpeaker = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"speaker_id"]];
        
        
        
        diccionarioPaLasRelaciones = @{@"eventoPadre" : @{@"id" : RepresentacionEventoPadre },
                                       @"lugarEnQueMeDesarrollo" : @{@"id" : RepresentacionLugarEnQueMeDesarrollo},
                                       @"speaker" : @{@"id" : RepresentacionSpeaker }
                                       
                                       };
    }
    
    else if([entity.name isEqualToString:@"Eventopadre"])
    
    {
        
        NSString *RepresentacionlugarDesarrolloEP = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarDesarrolloEP_id"]];
        
        
        if (![RepresentacionlugarDesarrolloEP isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"lugarDesarrolloEP" : @{@"id" : RepresentacionlugarDesarrolloEP}
                                           };
        }
        
        
        NSString *participantes_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"participantes_id"]];
        
        
        if (![participantes_id isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"participantes" : @{@"id" : participantes_id}
                                           };
        }
        
        NSString *eventoHijo_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoHijo_id"]];
        
        
        if (![eventoHijo_id isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"eventoHijo" : @{@"id" : eventoHijo_id}
                                           };
        }
    }
    
    else if([entity.name isEqualToString:@"Institucion"])
    {
        NSString *eventoQuePatrocino_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoQuePatrocino_id"]];
        if (![eventoQuePatrocino_id isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"eventoQuePatrocino" : @{@"id" : eventoQuePatrocino_id}
                                           };
            
        }
    
    NSString *eventoPadreQuePatrocino_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoPadreQuePatrocino_id"]];
    if (![eventoPadreQuePatrocino_id isEqualToString:@"(null)"]) {
        diccionarioPaLasRelaciones = @{
                                       @"eventoPadreQuePatrocino" : @{@"id" : eventoPadreQuePatrocino_id}
                                       };
        
    }
        
        NSString *personaQuePatrocino_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaQuePatrocino_id"]];
        if (![personaQuePatrocino_id isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"personaQuePatrocino" : @{@"id" : personaQuePatrocino_id}
                                           };
            
        }




    NSString *lugarEnqueEstoy_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarEnqueEstoy_id"]];
    if (![lugarEnqueEstoy_id isEqualToString:@"(null)"]) {
        diccionarioPaLasRelaciones = @{
                                       @"lugarEnqueEstoy" : @{@"id" : lugarEnqueEstoy_id}
                                       };
    }
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
    
    
    
    NSString *eventoQueDicto_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoQueDicto_id"]];
    if (![eventoQueDicto_id isEqualToString:@"(null)"]) {
        diccionarioPaLasRelaciones = @{
                                       @"eventoQueDicto" : @{@"id" : eventoQueDicto_id}
                                       };
    }
    }
    
    else if([entity.name isEqualToString:@"Lugar"])
    
    {
        
        NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaDelQueSoyProcedencia_id"]];
        if (![eventID isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"personaDelQueSoyProcedencia" : @{@"id" : eventID}
                                           };
        }
        
        NSString *eventoLugar_id = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoLugar_id"]];
        if (![eventoLugar_id isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"eventoLugar" : @{@"id" : eventoLugar_id}
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
        
        NSString *representacionRelsTipoEvento2= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaAsociada_id"]];
        if (![representacionRelsTipoEvento2 isEqualToString:@"(null)"]) {
            diccionarioPaLasRelaciones = @{
                                           @"personaAsociada" : @{@"id" : representacionRelsTipoEvento2}
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
