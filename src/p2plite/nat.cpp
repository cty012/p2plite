#include <utility>
#include <p2plite/nat.h>

namespace p2plite {
    NatTraverser::NatTraverser(Addr stunServerAddr) : stunServerAddr_(std::move(stunServerAddr)) {}

    NatTraverser::~NatTraverser() = default;
}
