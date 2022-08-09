//
//  std_path.hpp
//  OpenGL
//
//  Created by xiaerfei on 2022/8/9.
//  Copyright © 2022 Sharon. All rights reserved.
//

#ifndef std_path_hpp
#define std_path_hpp

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#ifdef __APPLE__
#include "CoreFoundation/CoreFoundation.h"
#endif


namespace std_path {
extern std::string get_path(std::string path_str);
}

#endif /* std_path_hpp */
