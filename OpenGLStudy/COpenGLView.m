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
    // コンテキストの設定
        CAEAGLLayer* pEAGLLayer = (CAEAGLLayer*)self.layer;
        pEAGLLayer.opaque = YES;
        pEAGLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];

        m_pGLContext = [ [EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 ];
        [EAGLContext setCurrentContext:m_pGLContext];

        glGenFramebuffers(1, &m_hFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, m_hFrameBuffer);
        
        glGenRenderbuffers(1, &m_hColorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, m_hColorRenderBuffer);
        [m_pGLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:pEAGLLayer];

        GLint iWidth,iHeight;
        glGetRenderbufferParameteriv( GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &iWidth );
        glGetRenderbufferParameteriv( GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &iHeight );

        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, m_hColorRenderBuffer);

        glGenRenderbuffers(1, &m_hDepthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, m_hDepthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT32_OES, iWidth, iHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_OES, GL_RENDERBUFFER, m_hDepthRenderbuffer);

        glBindRenderbuffer(GL_RENDERBUFFER, m_hColorRenderBuffer);

        checkFramebufferStatus();

        [ self beginAnimationing];
        printf("(%d,%d)\n",iWidth,iHeight);
    }
    return self;
}
- (void)drawFrame {
    //draw stuff
    m_fAnimationFrame += 1;
    [EAGLContext setCurrentContext:m_pGLContext];
    glClearColor( sinf(m_fAnimationFrame*0.1f)*0.5f+0.5f, 0.0f, 0.0f, 1.0f );
    glClear( GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT );
    [ m_pGLContext presentRenderbuffer:GL_RENDERBUFFER ];
}

- (void)destroy {
   // if(resourcesLoaded)
    {
        [m_DisplayLink invalidate];
        //free resources
     //   resourcesLoaded = NO;
    }
}
- (void)beginAnimationing {
    m_DisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
    [m_DisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)endAnimationing {
    [m_DisplayLink invalidate];
    m_DisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(destroy)];
    [m_DisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
@end


void checkFramebufferStatus()
{
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status == GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"framebuffer complete");
        //NSLog(@"failed to make complete framebuffer object %x", status);
    }
    else if(status == GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT)
    {
        NSLog(@"incomplete framebuffer attachments");
    }
    else if(status == GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT)
    {
        NSLog(@"incomplete missing framebuffer attachments");
    }
    else if(status == GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS)
    {
        NSLog(@"incomplete framebuffer attachments dimensions");
    }
    else if(status == GL_FRAMEBUFFER_UNSUPPORTED)
    {
        NSLog(@"combination of internal formats used by attachments in thef ramebuffer results in a nonrednerable target");
    }
}
