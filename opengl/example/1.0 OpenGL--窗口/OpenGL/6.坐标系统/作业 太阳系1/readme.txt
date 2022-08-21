
完成一个初步的太阳系程序
三个球体，一个表示太阳，一个表示地球，一个表示月亮;
地球不停地绕太阳旋转，月亮绕地球旋转


要点:
画球体的函数: glutWireSphere(1.0, 20, 16);

如何让物体不停运动呢?

void glutTimerFunc( ) glutPostRedisplay()或glutIdleFunc()
