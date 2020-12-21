#pragma once

#if defined _WIN32 || defined __CYGWIN__ || defined __MINGW32__
#ifdef BUILDING_DLL
#ifdef __GNUC__
#define DLL_PUBLIC __attribute__((dllexport))
#else
#define DLL_PUBLIC __declspec(dllexport)
#endif
#else
#ifdef __GNUC__
#define DLL_PUBLIC __attribute__((dllimport))
#else
#define DLL_PUBLIC __declspec(dllimport)
#endif
#endif
#define DLL_PRIVATE
#else
#if __GNUC__ >= 4
#define DLL_PUBLIC __attribute__((visibility("default")))
#define DLL_PRIVATE __attribute__((visibility("hidden")))
#else
#define DLL_PUBLIC
#define DLL_PRIVATE
#endif
#endif

#include "ffi.h"

#ifdef __cplusplus
extern "C"
{
#endif

	DLL_PUBLIC rge::Graph *graphMake(size_t nodeCount, rge::uID *ids, rge::Vector2 *positions, size_t *connectionCounts, rge::Connection **connections);

	DLL_PUBLIC rge::solver::SolveResult *graphSolve(rge::Graph *graph, rge::uID rootNodeID, rge::uID goalNodeID, rge::solver::SolveMode solveMode, rge::SearcherMode searcherMode);

	DLL_PUBLIC int graphSolveResultResponse(rge::solver::SolveResult *result);

	DLL_PUBLIC size_t graphSolveResultPathSize(rge::solver::SolveResult *result);
	DLL_PUBLIC void graphSolveResultPath(rge::solver::SolveResult *result, rge::uID *path);

	DLL_PUBLIC const char *printGraph(rge::Graph *graph);

#ifdef __cplusplus
}
#endif
