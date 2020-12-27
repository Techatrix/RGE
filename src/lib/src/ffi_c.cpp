#include "include/ffi_c.h"
#include "src/util/TemplateGeneratorSwitch.h"

#include <string>

using namespace rge;

Graph *graphMake(size_t nodeCount, uID *ids, Vector2 *positions, size_t *connectionCounts, Connection **connections)
{
	Graph *graph = new Graph{
		std::vector<uID>(nodeCount),
		std::vector<Vector2>(nodeCount),
		std::vector<std::vector<Connection>>(nodeCount),
	};
	
	for (size_t i = 0; i < nodeCount; i++)
	{
		graph->ids[i] = ids[i];
		graph->positions[i] = positions[i];

		for (size_t j = 0; j < connectionCounts[i]; j++)
			graph->connections[i].push_back(connections[i][j]);
	}

	if(!std::is_sorted(graph->ids.begin(), graph->ids.end()))
		graph->sort();

	return graph;
}

solver::SolveResult *graphSolve(Graph *graph, uID rootNodeID, uID goalNodeID, solver::SolveMode solveMode, searcher::SearcherMode searcherMode)
{
	constexpr int SIZE = solver::SolveModeLength * searcher::SearcherModeLength;
	int index = solveMode * solver::SolveModeLength + searcherMode;
	auto result = TemplateGeneratorSwitch<SIZE, solver::GSW, solver::SolveResult, Graph *, uID, uID>::impl(index, graph, rootNodeID, goalNodeID);

	return new solver::SolveResult(result);
}

int graphSolveResultResponse(solver::SolveResult *result)
{
	return result->response;
}

size_t graphSolveResultPathSize(solver::SolveResult *result)
{
	return result->path.size();
}

void graphSolveResultPath(solver::SolveResult *result, uID *path)
{
	std::copy(result->path.begin(), result->path.end(), path);
}

const char *printGraph(Graph *graph)
{
	std::string result;
	result += "IDs:\n";
	for (auto &i : graph->ids)
		result += std::to_string(i) + ", ";

	result += "\n\nPositions:\n";

	for (auto &p : graph->positions)
		result += "( " + std::to_string(p.x) + ' ' + std::to_string(p.y) + " ),\n";

	result += "\nConnections:\n";

	for (auto &cc : graph->connections)
	{
		for (auto &c : cc)
			result += '(' + std::to_string(c.id) + ' ' + std::to_string(c.weight) + "), ";
		result += '\n';
	}

	return (new std::string(result))->c_str();
}