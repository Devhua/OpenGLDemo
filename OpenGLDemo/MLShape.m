//
//  MLShape.m
//  OpenGLDemo
//
//  Created by Enki on 15/4/22.
//  Copyright (c) 2015年 seewo. All rights reserved.
//

#import "MLShape.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

typedef struct _Vertex{
    GLfloat x;
    GLfloat y;
    GLfloat z;
}Vertex3D;

static const GLfloat vertexInfoList[] = {
    -150.f, 150.f, 0.0f,       // top left
    -150.f, -150.f, 0.0f,      // bottom left
    150.f, 150.f, 0.0f,        // top right
    150.f, -150.f, 0.0f,       // bottom right
};

static const GLfloat colorInfoList[] = {
    0.99f, 0.01f, 0.01f, 1.0f,
    0.01f, 0.99f, 0.01, 1.0f,
    0.01f, 0.01f, 0.99f, 1.0f,
    0.01f, 0.02f, 0.01f, 1.0f
};

@implementation MLShape
{
    GLuint vao;
    GLuint vboVertices, vboColors;
    NSMutableArray *_points;
    Vertex3D *_pVertex3D;
    BOOL isVAO;
}

- (instancetype) init
{
    self = [super init];
    if ( self ) {
//        [self setup];
        _points = [NSMutableArray array];
        GLsizeiptr vertexsize = sizeof(Vertex3D) * 1000;
        _pVertex3D = malloc( vertexsize );
    }
    
    return self;
}

- (void) addPoint:(NSValue*) value
{
    if ( value ) {
        [_points addObject:value];
        CGPoint point = [value CGPointValue];
        _pVertex3D[_points.count-1].x = point.x * [UIScreen mainScreen].scale;
        _pVertex3D[_points.count-1].y = point.y * [UIScreen mainScreen].scale;
        _pVertex3D[_points.count-1].z = 0.f;
    }
}

- (void) updateGenBuffers
{
    return;
    isVAO = YES;
    GLsizeiptr vertexsize = sizeof(Vertex3D) * _points.count;
    Vertex3D *pv = malloc( vertexsize );
    GLvoid *pdata = pv;
    for ( NSValue *value in _points ) {
        CGPoint point = [value CGPointValue];
        pv->x = point.x * [UIScreen mainScreen].scale;
        pv->y = point.y * [UIScreen mainScreen].scale;
        pv->z = 0.f;
        pv++;
    }
    
    glGenVertexArraysOES(1, &vao);  // 生成VAO
    glBindVertexArrayOES(vao);      // 绑定VAO
    
    glGenBuffers(1, &vboVertices);  // 生成顶点VBO
    glBindBuffer(GL_ARRAY_BUFFER, vboVertices); // 绑定VBO
    // 指定顶点缓存数据
    glBufferData(GL_ARRAY_BUFFER, vertexsize, pdata, GL_STATIC_DRAW);
    // 注意这里对glEnableClientState(GL_VERTEX_ARRAY)的调用必须紧跟着glVertexPointer，否则调用无效！
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, (const GLvoid*)0);
    
    // 取消VAO的绑定
    glBindVertexArrayOES(0);
    glDisableClientState(GL_VERTEX_ARRAY);
    free(pdata);
}

- (void) draw
{
    glColor4f(1.0, 0.f, 0.f, 1.f);
    glLineWidth(4.f);

    if ( isVAO ) {
        
        glBindVertexArrayOES(vao);
        glDrawArrays(GL_LINE_STRIP, 0, (GLsizei)_points.count);
        
    } else {
    
        glEnableClientState(GL_VERTEX_ARRAY);
        glVertexPointer(3, GL_FLOAT, 0, (const GLvoid*)_pVertex3D);
        glDrawArrays(GL_LINE_STRIP, 0, (GLsizei)_points.count);
        glDisableClientState(GL_VERTEX_ARRAY);
    
    }
}


- (void) setup
{
    glGenVertexArraysOES(1, &vao);  // 生成VAO
    glBindVertexArrayOES(vao);      // 绑定VAO
    
    glGenBuffers(1, &vboVertices);  // 生成顶点VBO
    glBindBuffer(GL_ARRAY_BUFFER, vboVertices); // 绑定VBO
    // 指定顶点缓存数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexInfoList), vertexInfoList, GL_STATIC_DRAW);
    // 注意这里对glEnableClientState(GL_VERTEX_ARRAY)的调用必须紧跟着glVertexPointer，否则调用无效！
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, (const GLvoid*)0);
    
    glGenBuffers(1, &vboColors);    // 生成颜色VBO
    glBindBuffer(GL_ARRAY_BUFFER, vboColors);   // 绑定VBO
    // 指定颜色缓存数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(colorInfoList), colorInfoList, GL_STATIC_DRAW);
    // 注意这里对glEnableClientState(GL_COLOR_ARRAY)的调用必须紧跟着glColorPointer，否则调用无效！
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(4, GL_FLOAT, 0, (const GLvoid*)0);
    
    // 取消VAO的绑定
    glBindVertexArrayOES(0);
}

- (void) dealloc
{
    free(_pVertex3D);
    glDeleteVertexArraysOES(1, &vao);
    glDeleteBuffers(1, &vboVertices);
    glDeleteBuffers(1, &vboColors);
}

@end
