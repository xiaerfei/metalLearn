//
//  Shader.hpp
//  OpenGL
//
//  Created by xiaerfei on 2022/8/8.
//  Copyright © 2022 Sharon. All rights reserved.
//

#ifndef Shader_hpp
#define Shader_hpp

#include <stdio.h>
#include <sstream>
#include <iostream>

class shader {
public:
    unsigned int ID;
    // 构造器读取并构建着色器
    shader(const char* vertexPath, const char* fragmentPath);
    // 使用/激活程序
    void use();
    // uniform工具函数
    void setBool(const std::string &name, bool value) const;
    void setInt(const std::string &name, int value) const;
    void setFloat(const std::string &name, float value) const;
private:
    void checkCompileErrors(unsigned int shader, std::string type);
};

#endif /* Shader_hpp */
