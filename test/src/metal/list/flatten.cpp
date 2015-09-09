// Copyright Bruno Dutra 2015
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt)

#include <metal/list/flatten.hpp>
#include <metal/list/join.hpp>
#include <metal/optional/just.hpp>

#include "test.hpp"

#define MATRIX(M, N) \
    using CAT(CAT(trunk, N), 0) = SEQ()<VALS(N)>; \
    using CAT(CAT(trunk, N), INC(M)) = metal::join_t<CAT(CAT(trunk, N), M), CAT(CAT(trunk, N), M)>; \
    using CAT(CAT(tree, N), M) = SEQ()<VALS(N) COMMA(AND(M, N)) ENUM(M, CAT(tree, N))>; \
    ASSERT((metal::is_just_t<metal::flatten<VAL(M)>>), (FALSE)); \
    ASSERT((metal::is_just_t<metal::flatten<NUM(M)>>), (FALSE)); \
    ASSERT((metal::is_just_t<metal::flatten<PAIR(M)>>), (TRUE)); \
    ASSERT((metal::is_just_t<metal::flatten<LIST(M)>>), (TRUE)); \
    ASSERT((metal::is_just_t<metal::flatten<MAP(M)>>), (BOOL(!M))); \
    ASSERT((metal::is_just_t<metal::flatten<ARG(M)>>), (FALSE)); \
    ASSERT((metal::is_just_t<metal::flatten<LBD(M)>>), (TRUE)); \
    ASSERT((metal::is_just_t<metal::flatten<FUN(M)>>), (FALSE)); \
    ASSERT((metal::is_just_t<metal::flatten<SEQ(M)<ENUM(M, MAP(N) BAR)>>>), (BOOL(!M))); \
    ASSERT((metal::flatten_t<SEQ()<VAL(M)>>), (SEQ()<VAL(M)>)); \
    ASSERT((metal::flatten_t<SEQ()<NUM(M)>>), (SEQ()<NUM(M)>)); \
    ASSERT((metal::flatten_t<PAIR(M)>), (PAIR(M))); \
    ASSERT((metal::flatten_t<LIST(M)>), (LIST(M))); \
    ASSERT((metal::flatten_t<SEQ()<MAP(M)>>), (SEQ()<ENUM(M, FORWARD(NUM), FORWARD(VAL))>)); \
    ASSERT((metal::flatten_t<SEQ()<ARG(M)>>), (SEQ()<ARG(M)>)); \
    ASSERT((metal::flatten_t<LBD(M)>), (LBD(M))); \
    ASSERT((metal::flatten_t<SEQ()<FUN(M)>>), (SEQ()<FUN(M)>)); \
    ASSERT((metal::flatten_t<CAT(CAT(tree, N), M)>), (CAT(CAT(trunk, N), M))); \
/**/

GEN(MATRIX)