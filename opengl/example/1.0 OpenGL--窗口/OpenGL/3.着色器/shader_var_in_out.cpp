//
//  shader_var_in_out.cpp
//  OpenGL
//
//  Created by xiaerfei on 2022/8/8.
//  Copyright © 2022 Sharon. All rights reserved.
//

#include "shader_var_in_out.hpp"
#include <glad.h>
#include <glfw3.h>
#include <iostream>

static const char *vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "out vec4 vertexColor;// 把输出变量设置为暗红色\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "   vertexColor = vec4(0.5, 0.0, 0.0, 1.0);\n"
    "}\0";
static const char *fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "in vec4 vertexColor;// 从顶点着色器传来的输入变量（名称相同、类型相同）\n"
    "void main()\n"
    "{\n"
    "   FragColor = vertexColor;\n"
    "}\n\0";

static void processInput(GLFWwindow *window)
{
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}

// 每当窗口改变大小，GLFW会调用这个函数并填充相应的参数供你处理
static void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // make sure the viewport matches the new window dimensions; note that width and
    // height will be significantly larger than specified on retina displays.
    glViewport(0, 0, width, height);
}



int sharder_var_in_out() {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
    
    GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    // 告诉GLFW我们希望每当窗口调整大小的时候调用这个函数
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    
    // GLAD是用来管理OpenGL的函数指针的，所以在调用任何OpenGL的函数之前我们需要初始化GLAD。
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    
    // vertex shader
    unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    // check for shader compile errors
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    // fragment shader
    unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    // check for shader compile errors
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    // link shaders
    unsigned int shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    // check for linking errors
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
    }
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    float vertices[] = {
        -0.5f, -0.5f, 0.0f, // left
         0.5f, -0.5f, 0.0f, // right
         0.0f,  0.5f, 0.0f  // top
    };
    
    unsigned int VBO, VAO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    // 使用glBindBuffer函数把新创建的缓冲绑定到GL_ARRAY_BUFFER目标上
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBindVertexArray(VAO);
    // 调用glBufferData函数，它会把之前定义的顶点数据复制到缓冲的内存中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    // 通知OpenGL如何解释这些顶点数据
    /*
     第一个参数指定顶点属性位置，与顶点着色器中layout(location=0)对应。
     第二个参数指定顶点属性大小。
     第三个参数指定数据类型。
     第四个参数定义是否希望数据被标准化。
     第五个参数是步长（Stride），指定在连续的顶点属性之间的间隔。
     第六个参数表示我们的位置数据在缓冲区起始位置的偏移量。
     */
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    /*
     https://zhuanlan.zhihu.com/p/392128223
     
     glEnableVertexAttribArray(x)
     
     x 是一个数字，比如6，这个数字就表示某个顶点属性，或者表示其编号，因为VAO可以看成一个数组，
     这个数字也可以看成这个数组的索引，它对应的应该是glsl中的layout (location = 6) 这段代码。
     
     我们可以认为VAO这个数组中的每个元素都有两个状态，enabled和disabled，默认都是disabled，
     此时 VertexShader去读取对应的值时，读到的将是一个默认值（而不是数组中的值）。
     
     glEnableVertexAttribArray的作用就是将该状态置为enabled，此时着色器读取值才能生效。
     */
    glEnableVertexAttribArray(0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    

    /*
     我们可不希望只绘制一个图像之后我们的应用程序就立即退出并关闭窗口。我们希望程序在我们主动关闭它之前
     不断绘制图像并能够接受用户输入。因此，我们需要在程序中添加一个while循环，我们可以把它称之为渲染循
     环(Render Loop)，它能在我们让GLFW退出前一直保持运行。
     
     1. glfwWindowShouldClose 函数在我们每次循环的开始前检查一次GLFW是否被要求退出，如果是的话该函
        数返回true然后渲染循环便结束了，之后为我们就可以关闭应用程序了。
     2. glfwPollEvents 函数检查有没有触发什么事件（比如键盘输入、鼠标移动等）、更新窗口状态，并调用对应
        的回调函数（可以通过回调方法手动设置）。
     3. glfwSwapBuffers 函数会交换颜色缓冲（它是一个储存着GLFW窗口每一个像素颜色值的大缓冲），它在这一
        迭代中被用来绘制，并且将会作为输出显示在屏幕上。
     */
    while (!glfwWindowShouldClose(window))
    {
        // input
        // -----
        processInput(window);
        
        // glClearColor 函数是一个状态设置函数，而 glClear 函数则是一个状态使用的函数，它使用了当前的状态来获取应该清除为的颜色。
        
        // 设置清空屏幕所用的颜色
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        // 清空颜色缓冲
        glClear(GL_COLOR_BUFFER_BIT);
        
        // draw our first triangle
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    
    glfwTerminate();
    
    
    return 0;
}







