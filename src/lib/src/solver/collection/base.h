#pragma once

#include "src/solver/core/base.h"

namespace rge::solver
{
	struct DiscoElement
	{
		uID id;
		bool found;

		inline bool operator==(const uID &id) { return this->id == id; }
		inline bool operator!=(const uID &id) { return !(*this == id); }
		inline bool operator<(const uID &id) { return this->id < id; }
		inline bool operator>(const uID &id) { return this->id > id; }
		inline bool operator<=(const uID &id) { return !(*this > id); }
		inline bool operator>=(const uID &id) { return !(*this < id); }

		inline uID &get() { return id; }
	};
} // namespace rge::solver