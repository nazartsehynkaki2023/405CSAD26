from math_operations import add


def test_basic_addition() -> None:
    assert add(2, 3) == 5


def test_addition_with_zero() -> None:
    assert add(7, 0) == 7


def test_addition_with_negative_numbers() -> None:
    assert add(-4, -6) == -10
