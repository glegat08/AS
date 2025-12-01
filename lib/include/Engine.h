#pragma once

// Headers OgreNext
#include "OgreRoot.h"
#include "OgreWindow.h"
#include "OgreSceneManager.h"
#include "OgreCamera.h"
#include "Compositor/OgreCompositorManager2.h"
#include "OgreConfigFile.h"

#include <memory>

class Engine
{
public:
    Engine();
    ~Engine();

    bool initialize();
    void run();
    void shutdown();

    Ogre::Root* getRoot() const { return m_root.get(); }
    Ogre::SceneManager* getSceneManager() const { return m_sceneManager; }
    Ogre::Camera* getCamera() const { return m_camera; }
    Ogre::Window* getWindow() const { return m_window; }

private:
    // OgreNext uses std::unique_ptr for Root
    std::unique_ptr<Ogre::Root> m_root;
    
    // Raw pointers for these (owned by Root)
    Ogre::Window* m_window;
    Ogre::SceneManager* m_sceneManager;
    Ogre::Camera* m_camera;
    Ogre::CompositorWorkspace* m_workspace;
};