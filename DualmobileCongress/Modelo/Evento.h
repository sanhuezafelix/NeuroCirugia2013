//
//  Evento.h
//  DualmobileCongress
//
//  Created by felix sanhueza on 6/6/13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Imagen, Institucion, Lugar, Persona, TipoEvento;

@interface Evento : NSManagedObject

@property (nonatomic, retain) NSString * descripcionEvento;
@property (nonatomic, retain) NSString * horaFin;
@property (nonatomic, retain) NSString * horaInicio;
@property (nonatomic, retain) NSString * tematica;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSSet *eventoDelQueSoyHijo;
@property (nonatomic, retain) Evento *eventoDelQueSoyPadre;
@property (nonatomic, retain) NSSet *eventoHijo;
@property (nonatomic, retain) Evento *eventoMadre;
@property (nonatomic, retain) NSSet *imagenEvento;
@property (nonatomic, retain) NSSet *institucionPatrocinante;
@property (nonatomic, retain) Lugar *lugarEnQueMeDesarrollo;
@property (nonatomic, retain) Persona *speaker;
@property (nonatomic, retain) TipoEvento *tipoEvento;
@end

@interface Evento (CoreDataGeneratedAccessors)

- (void)addEventoDelQueSoyHijoObject:(Evento *)value;
- (void)removeEventoDelQueSoyHijoObject:(Evento *)value;
- (void)addEventoDelQueSoyHijo:(NSSet *)values;
- (void)removeEventoDelQueSoyHijo:(NSSet *)values;

- (void)addEventoHijoObject:(Evento *)value;
- (void)removeEventoHijoObject:(Evento *)value;
- (void)addEventoHijo:(NSSet *)values;
- (void)removeEventoHijo:(NSSet *)values;

- (void)addImagenEventoObject:(Imagen *)value;
- (void)removeImagenEventoObject:(Imagen *)value;
- (void)addImagenEvento:(NSSet *)values;
- (void)removeImagenEvento:(NSSet *)values;

- (void)addInstitucionPatrocinanteObject:(Institucion *)value;
- (void)removeInstitucionPatrocinanteObject:(Institucion *)value;
- (void)addInstitucionPatrocinante:(NSSet *)values;
- (void)removeInstitucionPatrocinante:(NSSet *)values;

@end
