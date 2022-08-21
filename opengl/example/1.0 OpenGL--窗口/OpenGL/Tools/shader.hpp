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
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

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
    void setVec2(const std::string &name, const glm::vec2 &value) const;
    void setVec2(const std::string &name, float x, float y) const;        // ------------------------------------------------------------------------
    void setVec3(const std::string &name, const glm::vec3 &value) const;
    void setVec3(const std::string &name, float x, float y, float z) const;
        // ------------------------------------------------------------------------
    void setVec4(const std::string &name, const glm::vec4 &value) const;
    void setVec4(const std::string &name, float x, float y, float z, float w) const;
        // ------------------------------------------------------------------------
    void setMat2(const std::string &name, const glm::mat2 &mat) const;
        // ------------------------------------------------------------------------
    void setMat3(const std::string &name, const glm::mat3 &mat) const;
        // ------------------------------------------------------------------------
    void setMat4(const std::string &name, const glm::mat4 &mat) const;
private:
    void checkCompileErrors(unsigned int shader, std::string type);
};

#endif /* Shader_hpp */
