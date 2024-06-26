#pragma once

#include <nice/agent.h>
#include <p2plite/addr.h>

namespace p2plite {
    class NatTraverser {
    public:
        explicit NatTraverser(Addr stunServerAddr);
        ~NatTraverser();

    private:
        Addr stunServerAddr_;
    };
}
