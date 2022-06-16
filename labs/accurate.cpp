#include <vector>
#include <string>

class Number{
public:
    std::vector<int> whole;
    std::vector<int> fractional;
    std::vector<int> converter(const std::string &num);

    Number(float num);
    Number operator +(const Number &other);
    std::string to_string();
};

Number::Number(float num){
    std::string parsed_num = std::to_string(num);
    std::string whole_str, fractional_str;
    bool switcher = false;
    for (size_t i = 0; i < parsed_num.size(); i++){
        if (parsed_num[i] == '.') {
            switcher = true;
            continue;
        }
        if (switcher) fractional_str += parsed_num[i];
        if (!switcher) whole_str += parsed_num[i];
    }
    whole = converter(whole_str);
    fractional = converter(fractional_str);
}

std::vector<int> Number::converter(const std::string &num){
    std::vector<int> target;
    for (size_t i = 0; i < num.size(); i++)
        target.push_back(static_cast<int>(num[i]));
    return target;
}

Number operator+(const Number& other){
    std::vector<int> new_whole, new_fractional;
    if(other.whole.size() > whole.size()) 
}
std::string Number::to_string(){
    std::string target = "Number value";
    for (size_t i = 0; i < whole.size(); i++){   
        target += std::to_string(whole[i]);
    }   
    for (size_t i = 0; i < fractional.size(); i++){   
        target += std::to_string(fractional[i]);
    }   
    return target;
}

int main(int argc, char** argv){
 Number a = Number(0.1);
 Number b = Number(0.2);

}