#include "Engine.h"
#include <iostream>

Engine::Engine() : m_root(nullptr), m_window(nullptr) {
}

Engine::~Engine() {
    if (m_root) {
        delete m_root;
    }
}

bool Engine::initialize() {
    m_root = new Ogre::Root();
    
    const auto& renderSystems = m_root->getAvailableRenderers();
    if (renderSystems.empty()) {
        std::cerr << "Aucun render system disponible" << std::endl;
        return false;
    }
    
    m_root->setRenderSystem(renderSystems[0]);
    m_root->initialise(false);
    
    m_window = m_root->createRenderWindow("Ma Fenêtre Ogre", 800, 600, false);
    
    std::cout << "Moteur initialisé !" << std::endl;
    return true;
}

void Engine::run() {
    std::cout << "Moteur en cours d'exécution..." << std::endl;
}