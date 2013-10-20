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
    
    if (!(self.estadoAutorizadorSincronizacion == NO)) {
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
    
    if (!(self.estadoAutorizadorUnaVezSync == NO)) {
        
        if([entity.name isEqualToString:@"Evento"]){
            
            
            NSString *RepresentacionPalSpeaker = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"speaker_id"]];
            if ((![RepresentacionPalSpeaker isEqualToString:@"<null>)"]) && (![RepresentacionPalSpeaker isEqualToString:@"(null)"])){
                
                diccionarioPaLasRelaciones = @{ @"speaker" : @{@"id" : RepresentacionPalSpeaker }
                                                
                                                };
            }
            
            
            NSString *RepresentacionPalTipoDeEvento = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoPadre_id"]];
            if ((![RepresentacionPalTipoDeEvento isEqualToString:@"<null>)"]) && (![RepresentacionPalTipoDeEvento isEqualToString:@"(null)"])){
                
                diccionarioPaLasRelaciones = @{ @"eventoPadre" : @{@"id" : RepresentacionPalTipoDeEvento }
                                                
                                                };
            }
            
            
            NSString *RepresentacionPallugarEnQueMeDesarrollo = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarEnQueMeDesarrollo_id"]];
            
            if ((![RepresentacionPallugarEnQueMeDesarrollo isEqualToString:@"<null>)"]) && (![RepresentacionPalTipoDeEvento isEqualToString:@"(null)"])){
                
                diccionarioPaLasRelaciones = @{ @"lugarEnQueMeDesarrollo" : @{@"id" : RepresentacionPallugarEnQueMeDesarrollo }
                                                
                                                };
            }
            
            
        }
        
        else if([entity.name isEqualToString:@"Persona"])
        {
            
            NSString *representacionPaLugarOrigen = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarDondeProvengo_id"]];
            
            
            if ((![representacionPaLugarOrigen isEqualToString:@"(null)"])  && (![representacionPaLugarOrigen isEqualToString:@"<null>"])) {
                diccionarioPaLasRelaciones = @{ @"lugarDondeProvengo" : @{@"id" : representacionPaLugarOrigen }
                                                
                                                };
                
            }
            
            NSString *representacionNotifiDelHuea = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"notificacionSobreMi_id"]];
            
            if ((![representacionNotifiDelHuea isEqualToString:@"(null)"])  && (![representacionNotifiDelHuea isEqualToString:@"<null>"])) {
                diccionarioPaLasRelaciones = @{ @"notificacionSobreMi" : @{@"id" : representacionNotifiDelHuea }
                                                
                                                };
            }
            
            NSString *representacionPaInstitucionPatrocinante = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionQueMePatrocina_id"]];
            
            if ((![representacionPaInstitucionPatrocinante isEqualToString:@"(null)"])  && (![representacionPaInstitucionPatrocinante isEqualToString:@"<null>"])) {            diccionarioPaLasRelaciones = @{
                                                                                                                                                                                                               @"institucionQueMePatrocina" : @{@"id" : representacionPaInstitucionPatrocinante}
                                                                                                                                                                                                               };
            }
            
            //        NSString *representacionParticipacion = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoParticipo_id"]];
            //   if ((![representacionParticipacion isEqualToString:@"(null)"])  && (![representacionParticipacion isEqualToString:@"<null>"])) {                     diccionarioPaLasRelaciones = @{
            //                                           @"eventoParticipo" : @{@"id" : representacionParticipacion}
            //                                           };
            //        }
            
            
        }
        
        
        
        else if([entity.name isEqualToString:@"Eventopadre"])
        {
            NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"institucionPatrocinante_id"]];
            if ((![eventID isEqualToString:@"(null)"])  && (![eventID isEqualToString:@"<null>"])) {               diccionarioPaLasRelaciones = @{
                                                                                                                                                  @"institucionPatrocinante" : @{@"id" : eventID}
                                                                                                                                                  };
            }
            
            NSString *eventID2 = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"lugarDesarrolloEP_id"]];
            if ((![eventID2 isEqualToString:@"(null)"])  && (![eventID2 isEqualToString:@"<null>"])) {             diccionarioPaLasRelaciones = @{
                                                                                                                                                  @"lugarEnQueMeDesarrollo" : @{@"id" : eventID2}
                                                                                                                                                  };
            }
            
            
        }
        else if([entity.name isEqualToString:@"Notificacion"])
        {
            NSString *representacionRelsTipoEvento= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoAsociado_id"]];
            if ((![representacionRelsTipoEvento isEqualToString:@"(null)"])  && (![representacionRelsTipoEvento isEqualToString:@"<null>"])) {            diccionarioPaLasRelaciones = @{
                                                                                                                                                                                         @"eventoAsociado" : @{@"id" : representacionRelsTipoEvento}
                                                                                                                                                                                         };
            }
            
            NSString *representacionRelsTipoEvento2= [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaAsociada_id"]];
            if ((![representacionRelsTipoEvento2 isEqualToString:@"(null)"])  && (![representacionRelsTipoEvento2 isEqualToString:@"<null>"])) {            diccionarioPaLasRelaciones = @{
                                                                                                                                                                                           @"personaAsociada" : @{@"id" : representacionRelsTipoEvento2}
                                                                                                                                                                                           };
            }
        }
        else if([entity.name isEqualToString:@"Lugar"])
        {
            //        NSString *representacionPaInstitucionAqui = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"ciudad"]];
            //
            //        if (![representacionPaInstitucionAqui isEqualToString:@"(null)"]) {
            //            diccionarioPaLasRelaciones = @{
            //                                           @"ciudad" : @{@"id" : representacionPaInstitucionAqui}
            //                                           };
            //
            //        }
            //        NSString *representacionPaPaisEnQueEstoy = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"nombreLugar"]];
            //
            //        if (![representacionPaPaisEnQueEstoy isEqualToString:@"(null)"]  && ![representacionPaPaisEnQueEstoy isEqualToString:@"<null>"]) {
            //            diccionarioPaLasRelaciones = @{
            //                                           @"nombreLugar" : @{@"id" : representacionPaPaisEnQueEstoy}
            //                                           };
            //        }
        }
        
        //    else if([entity.name isEqualToString:@"Institucion"])
        //    {
        //        NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"eventoQuePatrocino_id"]];
        //        if (![eventID isEqualToString:@"(null)"]) {
        //            diccionarioPaLasRelaciones = @{
        //                                           @"eventoQuePatrocino" : @{@"id" : eventID}
        //                                           };
        //            
        //        }
        //    }
        else if([entity.name isEqualToString:@"Imagen"])
            
        {
            NSString *representacionPaPersonaQueGrafico = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"personaQueGrafico_id"]];
            
            if (![representacionPaPersonaQueGrafico isEqualToString:@"(null)"]) {
                diccionarioPaLasRelaciones = @{
                                               @"personaQueGrafico" : @{@"id" : representacionPaPersonaQueGrafico}
                                               };
            }
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