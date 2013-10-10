//
//  Evento.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 09-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Imagen, Institucion, Lugar, Persona, TipoEvento;

@interface Evento : NSManagedObject

@property (nonatomic, retain) NSString * descripcionEvento;
@property (nonatomic, retain) NSString * horaFin;
@property (nonatomic, retain) NSString * horaInicio;
@property (nonatomic, retain) NSString * tematica;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSSet *imagenEvento;
@property (nonatomic, retain) NSSet *institucionPatrocinante;
@property (nonatomic, retain) Lugar *lugarEnQueMeDesarrollo;
@property (nonatomic, retain) Persona *speaker;
@property (nonatomic, retain) TipoEvento *tipoEvento;
@end

@interface Evento (CoreDataGeneratedAccessors)

- (void)addImagenEventoObject:(Imagen *)value;
- (void)removeImagenEventoObject:(Imagen *)value;
- (void)addImagenEvento:(NSSet *)values;
- (void)removeImagenEvento:(NSSet *)values;

- (void)addInstitucionPatrocinanteObject:(Institucion *)value;
- (void)removeInstitucionPatrocinanteObject:(Institucion *)value;
- (void)addInstitucionPatrocinante:(NSSet *)values;
- (void)removeInstitucionPatrocinante:(NSSet *)values;

@end
