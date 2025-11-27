#include "Engine.h"
#include <iostream>

int main() {
    try {
        Engine engine;
        
        if (!engine.initialize()) {
            std::cerr << "Échec d'initialisation du moteur" << std::endl;
            return 1;
        }
        
        engine.run();
        
        std::cout << "Programme terminé avec succès" << std::endl;
    }
    catch (const Ogre::Exception& e) {
        std::cerr << "Exception Ogre: " << e.getFullDescription() << std::endl;
        return 1;
    }
    
    return 0;
}