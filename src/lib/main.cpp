#include "include/ffi.h"

#include <iostream>
#include <cmath>
#include <chrono>

using namespace rge;

int main()
{
    /*
    Graph *graph;
    {
        auto start = std::chrono::system_clock::now();

        graph = generateGraph(7, 6);

        auto end = std::chrono::system_clock::now();
        auto time = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
        std::cout << "Generate Graph:\t\t" << time << "ms" << std::endl;
    }

    //std::cout <<  printGraph(graph) << std::endl;

    solver::SolveResult result;
    {
        size_t count = 1;
        long long totalTime = 0;
        for (size_t i = 0; i < count; i++)
        {
            auto start = std::chrono::system_clock::now();

            result = solver::solve<solver::DIJKSTRA, BINARY>(graph, 0, graph->ids.size() - 1);

            auto end = std::chrono::system_clock::now();
            auto time = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
            totalTime += time;
            std::cout << "Solve Graph:\t\t" << time << "ms" << std::endl;
        }
        std::cout << "Solve Graph AVG:\t" << totalTime / count << "ms" << std::endl;
    }
    */
   Graph graph;
   graph.ids = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ,12};
   graph.positions =
   {
       {0.0, 0.0}, {0.0, 0.0}, {0.0, 0.0},
       {0.0, 0.0}, {0.0, 0.0}, {0.0, 0.0},
       {0.0, 0.0}, {0.0, 0.0}, {0.0, 0.0},
       {0.0, 0.0}, {0.0, 0.0}, {0.0, 0.0},
       {0.0, 0.0}
   };
   graph.connections =
   {
       { {1, 3.0}, {3, 4.0}, {12, 7.0} },
       { {0, 3.0}, {3, 4.0}, {7, 1.0}, {12, 2.0} },
       { {11, 2.0}, {12, 3.0}, },
       { {0, 4.0}, {1, 4.0}, {5, 5.0} },
       { {6, 2.0}, {10, 5.0}, },
       { {3, 5.0}, {7, 3.0}, },
       { {4, 2.0}, {7, 2.0}, },
       { {1, 1.0}, {5, 3.0}, {6, 2.0} },
       { {9, 6.0}, {10, 4.0}, {11, 4.0} },
       { {8, 6.0}, {10, 4.0}, {11, 4.0} },
       { {4, 5.0}, {8, 4.0}, {9, 4.0} },
       { {2, 2.0}, {8, 4.0}, {9, 4.0} },
       { {0, 7.0}, {1, 2.0}, {2, 3.0} },
   };

   solver::SolveResult result = solver::solve<solver::DIJKSTRA, BINARY>(&graph, 0, 4);
   

   std::cout << "Found:\t" << (result.found ? "true" : "false") << std::endl;
   if (result.found)
       for (auto &i : result.path)
           std::cout << "Path:\t" << i << std::endl;

   return !(result.found == true);
}
