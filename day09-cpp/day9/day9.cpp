#include <iostream>
#include <fstream>
#include <vector>
#include <filesystem>
#include <string>
#include <algorithm>

std::vector<std::string> readFile(const std::filesystem::path& filePath)
{
    std::vector<std::string> lines;

    std::ifstream file(filePath);
    if (file.is_open())
    {
        std::string line;
        while (std::getline(file, line))
        {
            lines.push_back(line);
        }
    }

    return lines;
}

long long getError(const std::vector<long long>& values, int preamblesSize)
{
    for (int valueIndex = preamblesSize; valueIndex < values.size(); ++valueIndex)
    {
        bool valide = false;

        auto preamblesBegin = values.begin() + valueIndex - preamblesSize;
        std::vector<long long> preambles(preamblesBegin, values.begin() + valueIndex);

        for (int i = 0; i < preambles.size(); ++i)
        {
            for (int j = i + 1; j < preambles.size(); ++j)
            {
                if (preambles[i] + preambles[j] == values[valueIndex])
                    valide = true;
            }
        }

        if (!valide)
        {
            return values[valueIndex];
        }
    }

    return 0;
}

long long getEncryptionWeakness(const std::vector<long long>& values, long long error)
{
    auto beginCurrent = values.begin();
    auto endCurrent = values.begin();

    long long sum = 0;

    while (beginCurrent < values.end() - 1 && sum != error)
    {
        sum = *beginCurrent;
        endCurrent = beginCurrent + 1;

        while (endCurrent < values.end() && sum < error)
        {
            sum += *endCurrent;
            if(sum != error)
                ++endCurrent;
        }
    
        if (sum != error)
            ++beginCurrent;
    }

    if (beginCurrent == values.end() - 1 && sum != error)
        return 0;
    
    auto min = *std::min_element(beginCurrent, endCurrent);
    auto max = *std::max_element(beginCurrent, endCurrent);

    return min + max;
}

int main()
{
    auto lines = readFile("data.txt");

    std::vector<long long> values;
    std::transform(lines.begin(), lines.end(), std::back_inserter(values), [](const std::string& value) { return std::stoll(value); });

    auto errorValue = getError(values, 25);
    auto encryptionWeakness = getEncryptionWeakness(values, errorValue);


    std::cout << "error value : " << errorValue << std::endl;
    std::cout << "Encryption Weakness value : " << encryptionWeakness << std::endl;

}


