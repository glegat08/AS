#include "Engine.h"
#include <iostream>

int main()
{
    try
    {
        std::cout << "==================================" << std::endl;
        std::cout << "  Starting OgreNext Game" << std::endl;
        std::cout << "==================================" << std::endl;

        Engine engine;

        std::cout << "Initializing engine..." << std::endl;
        if (!engine.initialize())
        {
            std::cerr << "Failed to initialize engine!" << std::endl;
            return 1;
        }

        std::cout << "Engine initialized successfully!" << std::endl;
        std::cout << "Starting game loop..." << std::endl;
        std::cout << "Close the window to exit." << std::endl;

        engine.run();

        std::cout << "Shutting down..." << std::endl;
        engine.shutdown();

        std::cout << "Goodbye!" << std::endl;
        return 0;
    }
    catch (const std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << std::endl;
        return 1;
    }
}