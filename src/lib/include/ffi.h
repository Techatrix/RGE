#pragma once

#include <memory>

#include "src/core/graph.h"
#include "src/solver/solver.h"

void generateNode(rge::Graph &graph, size_t degree, size_t depth);

std::unique_ptr<rge::Graph> generateStarGraph(size_t degree, size_t depth);

std::unique_ptr<rge::Graph> generateGridGraph(size_t width, size_t height, float distance);

std::unique_ptr<rge::Graph> generateGridGraphFromGrid(std::vector<std::vector<bool>>& grid, float distance);

std::unique_ptr<rge::Graph> generateHierarchicalGraph(size_t depth);

std::unique_ptr<rge::Graph> generateRandomGraph(size_t nodeCount);
