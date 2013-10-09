//
//  Institucion.h
//  DualmobileCongress
//
//  Created by felix sanhueza on 6/6/13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento, Lugar, Persona, TipoInstitucion;

@interface Institucion : NSManagedObject

@property (nonatomic, retain) NSString * descripcionInstitucion;
@property (nonatomic, retain) NSString * nombreInstitucion;
@property (nonatomic, retain) Evento *eventoQuePatrocino;
@property (nonatomic, retain) Lugar *lugarEnqueEstoy;
@property (nonatomic, retain) NSSet *personaQuePatrocino;
@property (nonatomic, retain) TipoInstitucion *tipoInstitucion;
@end

@interface Institucion (CoreDataGeneratedAccessors)

- (void)addPersonaQuePatrocinoObject:(Persona *)value;
- (void)removePersonaQuePatrocinoObject:(Persona *)value;
- (void)addPersonaQuePatrocino:(NSSet *)values;
- (void)removePersonaQuePatrocino:(NSSet *)values;

@end
