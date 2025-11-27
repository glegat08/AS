#pragma once
#include <Ogre.h>
#include <string>

class Engine {
public:
    Engine();
    ~Engine();
    
    bool initialize();
    void run();
    
private:
    Ogre::Root* m_root;
    Ogre::RenderWindow* m_window;
};