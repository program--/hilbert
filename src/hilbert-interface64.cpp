#include <cpp11.hpp>
#include <cstring>
#include <bitset>
#include "hilbert.hpp"

using std::vector;
using cpp11::integers;
using cpp11::doubles;
using cpp11::strings;

[[cpp11::register]]
strings HILBERT_index64_(size_t n, integers x, integers y) 
{
    const int64_t nn = static_cast<int64_t>(n);
    const size_t len = x.size();
    vector<int64_t> xx(x.begin(), x.end()),
                    yy(y.begin(), y.end());
    vector<int64_t> h(len);

    for (size_t i = 0; i < len; ++i) {
        if (i % 8130 == 0) {
            cpp11::check_user_interrupt();
        }
        
        hilbert::curve::positionToIndex(int64_t(1) << nn, xx[i], yy[i], &h[i]);
    }

    const cpp11::writable::strings indices(len);
    for (size_t i = 0; i < len; i++) {
        indices[i] = std::bitset<64>(h[i]).to_string();
    }
    
    indices.attr("class") = "bitstring";
    return indices;
}