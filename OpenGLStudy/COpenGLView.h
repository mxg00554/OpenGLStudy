//
//  COpenGLView.h
//  OpenGLStudy
//
//  Created by BulletsMac3 on 2013/03/15.
//  Copyright (c) 2013年 BulletsMac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COpenGLView : UIView
{
    EAGLContext*    m_pGLContext;           //!< OpenGl コンテキスト
    GLuint          m_hFrameBuffer;         //!< OpenGl フレームバッファーハンドル
    GLuint          m_hColorRenderBuffer;   //!< OpenGl カラーレンダバッファハンドル
    GLuint          m_hDepthRenderbuffer;   //!< OpenGl デプスレンダバッファハンドル

    CADisplayLink *   m_DisplayLink;
}
@end
