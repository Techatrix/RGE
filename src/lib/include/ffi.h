#pragma once

#include <memory>

#include "src/core/graph.h"
#include "src/solver/solver.h"

void generateNode(rge::Graph &graph, size_t degree, size_t depth);

std::unique_ptr<rge::Graph> generateGraph(size_t degree, size_t depth);

std::unique_ptr<rge::Graph> generateRandomGraph(size_t nodeCount, float radius, size_t connectionsPerNode = 100);
