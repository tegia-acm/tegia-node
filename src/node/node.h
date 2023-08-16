#ifndef H_TEGIA_NODE
#define H_TEGIA_NODE
// ---------------------------------------------------------------------------------------------------

#include <iostream>
#include <tegia2/core/json.h>

#include "config.h"


namespace tegia {
namespace threads {
	class pool;
}
}

namespace tegia {
namespace node {

class node
{
	public:

		static node * _self;
		static node * instance();
		const nlohmann::json * const config(const std::string &name);

		node();
		~node();
		bool run();
		bool action();

		const nlohmann::json * const config();

	private:
		tegia::threads::pool * _threads;
		tegia::node::config  * _config;

};	// END class node

}	// END namespace node
}	// EMD namespace TEGIA


// ---------------------------------------------------------------------------------------------------
#endif