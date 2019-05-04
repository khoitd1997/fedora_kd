#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

static const int someRandom = 5;
const std::string testStr = "rand string or something";

struct TestStruct {
  int member;

  TestStruct(const int num) : member{num} {
    std::cout << "The member is " << member << std::endl;
  }
  ~TestStruct() {
    std::cout << "Destructor being called " << member << std::endl;
  }
};

template <size_t N> double powerTemplate(const double base) {
  return base * powerTemplate<N - 1>(base);
}

template <> double powerTemplate<1>(const double base) { return base; }

template <> double powerTemplate<0>(const double base) { return 1; }

template <typename T>
void testFunc(
    typename std::enable_if<std::is_arithmetic<T>::value, T>::type stuff) {
  std::cout << "function is: " << __PRETTY_FUNCTION__ << std::endl;
}

// template <typename... Args> bool testFold(Args... args) { return ... + args;
// }

template <typename T> T testSum(T num) { return num; }
// template <typename T, typename... Args,
//           std::enable_if_t<std::is_arithmetic<T>::value> * = nullptr>
// T testSum(T num, Args... args) {
//   return num + testSum(args...);
// }

template <
    typename... Args,
    std::enable_if_t<std::conjunction_v<std::is_integral<Args>...>> * = nullptr>
auto sum(Args... args) {
  return (... + args);
}

int main(void) {
  //   testFunc(4);
  //   testFunc<double>(4.0);
  //   testFunc<double>(4.0);

  //   std::cout << "the result is " << testFold(1, 2, 3, 4) << std::endl;

  //   std::cout << "test sum is: " << testSum(5, 3, 4, 5) << std::endl;

  auto lambdaSum = [](std::vector<int> list) {
    return std::accumulate(list.cbegin(), list.cend(), 0,
                           [](int sum, int num) { return sum + num; });
  };
  std::cout << "test sum is: " << lambdaSum(std::vector{5, 3, 4, 5})
            << std::endl;

  //   std::cout << "test sum is: " << sum(5, 3, 4, 5) << std::endl;

  //   std::cout << "The result is " << powerTemplate<5>(2) << std::endl;
  return 0;
}
