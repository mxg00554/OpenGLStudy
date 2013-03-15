//
//  Shader.fsh
//  OpenGLStudy
//
//  Created by BulletsMac3 on 2013/03/14.
//  Copyright (c) 2013年 BulletsMac3. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
