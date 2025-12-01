#include "Engine.h"
#include "OgreException.h"
#include "OgreWindowEventUtilities.h"
#include "Compositor/OgreCompositorManager2.h"

Engine::Engine()
    : m_root(nullptr)
    , m_window(nullptr)
    , m_sceneManager(nullptr)
    , m_camera(nullptr)
    , m_workspace(nullptr)
{
}

Engine::~Engine()
{
    shutdown();
}

bool Engine::initialize()
{
    // Create Root - OgreNext 3.0.0
    m_root = std::make_unique<Ogre::Root>(nullptr, "", "", "Ogre.log");

    // Load D3D11 plugin - Different names for Debug/Release
    #ifdef _DEBUG
        // Debug build - DLL has _d suffix
        m_root->loadPlugin("RenderSystem_Direct3D11_d", false, nullptr);
    #else
        // Release build - No suffix
        m_root->loadPlugin("RenderSystem_Direct3D11", false, nullptr);
    #endif
    
    // Get and set render system
    const Ogre::RenderSystemList& rsList = m_root->getAvailableRenderers();
    if (rsList.empty()) {
        return false;
    }
    m_root->setRenderSystem(rsList[0]);

    // Initialize
    m_root->initialise(false);

    // Create window
    Ogre::NameValuePairList params;
    m_window = m_root->createRenderWindow("MainWindow", 1280, 720, false, &params);

    // Create scene manager
    m_sceneManager = m_root->createSceneManager(Ogre::ST_GENERIC, 1, "MainSceneManager");

    // Create camera
    m_camera = m_sceneManager->createCamera("MainCamera");
    m_camera->setPosition(Ogre::Vector3(0, 100, 500));
    m_camera->lookAt(Ogre::Vector3(0, 0, 0));
    m_camera->setNearClipDistance(5.0f);
    m_camera->setAutoAspectRatio(true);

    // Setup compositor
    Ogre::CompositorManager2* compositorManager = m_root->getCompositorManager2();
    const Ogre::String workspaceName = "MainWorkspace";
    
    if (!compositorManager->hasWorkspaceDefinition(workspaceName)) {
        compositorManager->createBasicWorkspaceDef(workspaceName, Ogre::ColourValue(0.2f, 0.4f, 0.6f));
    }

    m_workspace = compositorManager->addWorkspace(m_sceneManager, m_window->getTexture(), m_camera, workspaceName, true);

    return true;
}

void Engine::run()
{
    if (!m_root || !m_window) return;

    while (!m_window->isClosed()) {
        Ogre::WindowEventUtilities::messagePump();
        if (!m_root->renderOneFrame()) break;
    }
}

void Engine::shutdown()
{
    if (m_workspace && m_root) {
        m_root->getCompositorManager2()->removeWorkspace(m_workspace);
        m_workspace = nullptr;
    }
    if (m_sceneManager && m_root) {
        m_root->destroySceneManager(m_sceneManager);
        m_sceneManager = nullptr;
    }
    m_camera = nullptr;
    m_window = nullptr;
    m_root.reset();
}