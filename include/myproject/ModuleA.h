#ifndef MYPROJECT_MODULEA_H_fi84aj
#define MYPROJECT_MODULEA_H_fi84aj

#include <string>

namespace myproject
{

class StringProcessor
{
public:
    std::string reverse(const std::string& input);

    std::string toUpper(const std::string& input);

    std::string removeSpaces(const std::string& input);
};

} // namespace myproject

#endif // MYPROJECT_MODULEA_H_fi84aj