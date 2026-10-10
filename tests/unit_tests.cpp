#include "math_operations.h"

#include <gtest/gtest.h>

TEST(MathOperations, BasicAddition) {
    EXPECT_EQ(add(2, 3), 5);
}

TEST(MathOperations, AdditionWithZero) {
    EXPECT_EQ(add(7, 0), 7);
}

TEST(MathOperations, AdditionWithNegativeNumbers) {
    EXPECT_EQ(add(-4, -6), -10);
}
