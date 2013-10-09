//
//  TipoInstitucion.h
//  DualmobileCongress
//
//  Created by felix sanhueza on 6/6/13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Institucion;

@interface TipoInstitucion : NSManagedObject

@property (nonatomic, retain) NSString * idTipoInstitucion;
@property (nonatomic, retain) NSSet *institucionQueDetermino;
@end

@interface TipoInstitucion (CoreDataGeneratedAccessors)

- (void)addInstitucionQueDeterminoObject:(Institucion *)value;
- (void)removeInstitucionQueDeterminoObject:(Institucion *)value;
- (void)addInstitucionQueDetermino:(NSSet *)values;
- (void)removeInstitucionQueDetermino:(NSSet *)values;

@end
