//
//  std_path.cpp
//  OpenGL
//
//  Created by xiaerfei on 2022/8/9.
//  Copyright © 2022 Sharon. All rights reserved.
//

#include "std_path.hpp"
#include <filesystem>
#ifdef __APPLE__
#include "CoreFoundation/CoreFoundation.h"
#endif

std::string std_path::get_path(std::string path_str) {
#ifdef __APPLE__
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(mainBundle);
    char path[PATH_MAX];
    if (!CFURLGetFileSystemRepresentation(resourcesURL, TRUE, (UInt8 *)path, PATH_MAX))
    {
        // error!
    }
    CFRelease(resourcesURL);

    chdir(path);
#endif
    return path + path_str;
}
