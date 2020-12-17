#pragma once

#include "src/core/graph.h"
#include "src/solver/solver.h"

void generateNode(rge::Graph &graph, size_t degree, size_t depth);

rge::Graph *generateGraph(size_t degree, size_t depth);