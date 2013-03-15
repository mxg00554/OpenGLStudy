//
//  COpenGLView.m
//  OpenGLStudy
//
//  Created by BulletsMac3 on 2013/03/15.
//  Copyright (c) 2013年 BulletsMac3. All rights reserved.
//

#import "COpenGLView.h"
#import <QuartzCore/QuartzCore.h>

@implementation COpenGLView

+ ( Class )layerClass
{
	return [ CAEAGLLayer class ];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- ( id ) initWithCoder:(NSCoder *)aDecoder
{
    self = [ super initWithCoder:aDecoder ];
    if (self) {
    // OpenGLの初期化処理
    // フレームバッファの設定
        glGenFramebuffers(1, &m_hFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, m_hFrameBuffer);
    // カラーバッファーの設定
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        float width = frame.size.width, height = frame.size.height;
        glGenRenderbuffers(1, &m_hColorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, m_hColorRenderBuffer    );
        glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA, width, height);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, m_hColorRenderBuffer);
    // 深度バッファーの設定
        glGenRenderbuffers(1, &m_hDepthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, m_hDepthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, m_hDepthRenderbuffer);
    // コンテキストの設定
        m_pGLContext = [ [EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 ];
        [ m_pGLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:( CAEAGLLayer* )self.layer ];

        printf("(%f,%f\n",width,height);
    }
    return self;
}

@end
