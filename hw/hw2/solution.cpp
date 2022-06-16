#include <iostream>
#include <string>
#include <set>
#include <vector>
#include <stack>

using namespace std;

int table[33][19];
set<string> separators;
set<string> service;

set<string> indextype;
set<string> elementtype;
vector<string> tokens;
vector<string> tokenstranslate;
stack<int> mag;
string res;
bool err = false;

void printErr(string word)
{
    cout << "Получена лексическая ошибка при обработке: " << word << endl;
}

string tolowercase(string s)
{
    for (int i = 0; i < s.length(); i++)
    {
        s[i] = tolower(s[i]);
    }
    return s;
}

string Rtrim(string s)
{
    s.erase(0, s.find_first_not_of(" "));
    return s;
}

string Ltrim(string s)
{
    s.erase(s.find_last_not_of(" ") + 1, s.length() - s.find_last_not_of(" ") + 1);
    return s;
}

string trim(string s)
{
    s.erase(0, s.find_first_not_of(" "));
    s.erase(s.find_last_not_of(" ") + 1, s.length() - s.find_last_not_of(" ") - 1);
    return s;
}

void InitTable()
{
    // 99 - Ошибка,0 - конец, q+100 - Вход в рекурсию, 100 - Выход из рекурсии
    for (int i = 1; i <= 32; i++)
    {
        for (int j = 1; j <= 18; j++)
        {
            table[i][j] = 99;
        }
    }
    table[1][5] = 2;
    table[2][1] = 3;
    table[3][14] = 2;
    table[3][15] = 4;
    table[4][6] = 7;
    table[4][7] = 20;
    table[4][8] = 105;
    table[4][9] = 12;
    table[5][16] = 6;
    table[6][1] = 3;
    table[6][17] = 0;
    table[7][12] = 8;
    table[8][3] = 9;
    table[9][13] = 10;
    table[9][14] = 8;
    table[10][10] = 11;
    table[11][4] = 5;
    table[12][12] = 13;
    table[12][16] = 6;
    table[13][2] = 14;
    table[14][13] = 5;
    table[20][10] = 21;
    table[21][4] = 5;
    table[1][5] = 2;
    table[15][1] = 16;
    table[16][14] = 15;
    table[16][15] = 17;
    table[17][4] = 18;

    table[17][6] = 22;
    table[17][7] = 30;
    table[17][8] = 118;
    table[17][9] = 27;
    table[18][16] = 19;
    table[19][1] = 16;
    table[19][11] = 100;
    table[22][12] = 23;
    table[23][3] = 24;
    table[24][13] = 25;
    table[24][14] = 23;
    table[25][10] = 26;
    table[26][4] = 18;
    table[27][12] = 28;
    table[27][16] = 19;
    table[28][2] = 29;
    table[29][13] = 18;
    table[30][10] = 31;
    table[31][4] = 18;
}

void InitSeparators()
{
    separators.insert(";");
    separators.insert(":");
    separators.insert(",");
    separators.insert(" ");
    separators.insert("[");
    separators.insert("]");
}

void InitService()
{
    service.insert("var");
    service.insert("array");
    service.insert("set");
    service.insert("string");
    service.insert("record");
    service.insert("end");
    service.insert("of");
}

void InitIndType()
{
    indextype.insert("byte");
    indextype.insert("char");
    indextype.insert("set");
    indextype.insert("string");
}

void InitElType()
{
    elementtype.insert("byte");
    elementtype.insert("char");
    elementtype.insert("real");
    elementtype.insert("integer");
}

void InitAll()
{
    InitTable();
    InitSeparators();
    InitService();
    InitElType();
    InitIndType();
}

bool Constant(string word)
{
    if (word[0] < '0' || word[0] > '9')
    {
        return false;
    }
    for (int i = 0; i < word.length(); i++)
    {
        if (word[i] < '0' || word[i] > '9')
        {
            err = true;
            printErr(word);
            return false;
        }
    }
    return true;
}

bool Symbol(string word)
{
    for (int i = 0; i < word.length(); i++)
    {
        if ((word[i] < 'a' || word[i] > 'z') && (word[i] < '0' || word[i] > '9') && (word[i] != '_'))
        {
            err = true;
            printErr(word);
            return false;
        }
    }
    return true;
}

bool Ident(string word)
{
    if (((word[0] >= 'a') && (word[0] <= 'z')) || ((word[0] == '_') && (word.length() > 1)))
    {
        return true;
    }
    if ((word[0] == '_') && (word.length() == 1))
    {
        err = true;
        printErr(word);
    }
    return false;
}

string gettok(int i)
{
    setlocale(LC_ALL, "Russian");
    switch (i)
    {
    case (1):
        return "I";
    case (2):
        return "C";
    case (3):
        return "Ti";

    case (4):
        return "Te";
    case (5):
        return "var";
    case (6):
        return "array";
    case (7):
        return "set";
    case (8):
        return "record";
    case (9):
        return "string";
    case (10):
        return "of";
    case (11):
        return "end";
    case (12):
        return "[";
    case (13):
        return "]";
    case (14):
        return ",";
    case (15):
        return ":";
    case (16):
        return ";";
    }
}

void scanner(string s)
{
    int i = 0;
    string word;
    while (s.length() != 0)
    {
        s = trim(s);
        if (s.length() == 0)
        {
            return;
        }
        word = s.substr(0, 1);
        if (separators.find(word) != separators.end())
        {
            word = s.substr(0, 1);
            tokens.push_back(word);
            tokenstranslate.push_back(word);
            s = s.substr(1, s.length());
            continue;
        }
        i = 0;
        while ((separators.find(word) == separators.end()) && (i < s.length()) && (s[i] != ' '))
        {
            i++;

            word = s.substr(i, 1);
        }
        word = s.substr(0, i);
        if (service.find(word) != service.end())
        {
            tokens.push_back(word);
            tokenstranslate.push_back(word);
            s = s.substr(i, s.length());
            continue;
        }
        if ((indextype.find(word) != indextype.end() && (tokens[tokens.size() - 1] != "of")) && (tokens[tokens.size() - 1] != ":"))
        {
            tokens.push_back("Ti");
            tokenstranslate.push_back(word);
            s = s.substr(i, s.length());
            continue;
        }
        if (elementtype.find(word) != elementtype.end())
        {
            tokens.push_back("Te");
            tokenstranslate.push_back(word);
            s = s.substr(i, s.length());
            continue;
        }
        if (Constant(word))
        {
            tokens.push_back("C");
            tokenstranslate.push_back(word);
            s = s.substr(i, s.length());
            continue;
        }
        if (Ident(word))
        {
            tokens.push_back("I");
            tokenstranslate.push_back(word);
            s = s.substr(i, s.length());
            continue;
        }
        if (!Symbol(word))
        {

            return;
        }
        if (err)
        {
            return;
        }
        err = true;
        return;
    }
}

void clearall()
{
    tokens.clear();
    tokenstranslate.clear();
    err = false;
    res = "";
}

string getwr(int q)
{
    setlocale(LC_ALL, "Russian");
    string s = "";
    bool one = true;
    for (int i = 1; i < 17; i++)
    {
        if (table[q][i] != 99)
        {
            s += "'" + gettok(i) + "'";
            if (!one)
            {
                s += ", ";
            }
            one = false;
        }
    }
    return s;
}

int getcol(string s)
{
    setlocale(LC_ALL, "Russian");

    if (s == "I")
    {
        return 1;
    }
    else if (s == "C")
    {
        return 2;
    }
    else if (s == "Ti")
    {
        return 3;
    }
    else if (s == "Te")
    {
        return 4;
    }
    else if (s == "var")
    {
        return 5;
    }
    else if (s == "array")
    {
        return 6;
    }
    else if (s == "set")
    {
        return 7;
    }
    else if (s == "record")
    {
        return 8;
    }
    else if (s == "string")
    {
        return 9;
    }
    else if (s == "of")
    {
        return 10;
    }
    else if (s == "end")
    {
        return 11;
    }
    else if (s == "[")
    {
        return 12;
    }
    else if (s == "]")
    {
        return 13;
    }
    else if (s == ",")
    {
        return 14;
    }
    else if (s == ":")
    {
        return 15;
    }
    else if (s == ";")
    {
        return 16;
    }
    else
    {
        return 17;
    }
}

void synanaliz()
{
    setlocale(LC_ALL, "Russian");
    int q = 1;
    int i = 0;
    res = "Описание переменных:\n";
    int s = q;

    while ((q != 0) && (q != 99) && (i < tokens.size()))
    {
        s = q;
        q = table[q][getcol(tokens[i])];
        if (q == 105)
        {
            mag.push(5);
            q = 15;
        }
        if (q == 118)
        {
            mag.push(18);
            q = 15;
        }
        if (q == 100)
        {
            q = mag.top();
            mag.pop();
        }
        switch (q)
        {
        case (2):
            if (tokens[i] != "var")
            {
                cout << ", ";
            }
            break;
        case (3):
            cout << tokenstranslate[i];
            break;
        case (4):
            cout << ":тип - ";
            break;
        case (7):
            cout << "массив, индексы - ";
            break;
        case (8):
            if (tokens[i - 1] == "I")
            {
                cout << ", ";
            }
            break;
        case (9):
            cout << tokenstranslate[i];
            break;
        case (10):
            cout << ", тип элементов - ";
            break;
        case (5):
            if (tokens[i] == "Te")
            {
                cout << tokenstranslate[i];
            }
            if (tokens[i] == "end")
            {
                cout << "Конец записи";
            }
            break;
        case (12):
            cout << "строка ";
            break;
        case (14):
            cout << "с заданной длинной " + tokenstranslate[i];
            break;
        case (20):
            cout << "множество ";
            break;
        case (21):
            cout << "элементов типа ";
            break;
        case (15):
            if (tokens[i] == "record")
            {
                cout << "Запись" << endl
                     << "Параметры" << endl;
            }
            if (tokens[i] == ",")
            {
                cout << ", ";
            }
            break;
        case (16):
            cout << tokenstranslate[i];
            break;
        case (17):
            cout << ":тип - ";
            break;
        case (22):
            cout << "массив, ";
            break;
        case (23):

            if (tokens[i] == "[")
            {
                cout << "индексы - ";
            }
            if (tokens[i] == ",")
            {
                cout << ", ";
            }
            break;
        case (24):
            cout << tokenstranslate[i];
            break;
        case (26):
            cout << ", тип элемента - ";
            break;
        case (18):
            if (tokens[i] == "Te")
            {
                cout << tokenstranslate[i];
            }
            if (tokens[i] == "end")
            {
                cout << "конец записи";
            }
            break;
        case (27):
            cout << "строка";
            break;
        case (29):
            cout << "с заданной длинной" << tokenstranslate[i];
            break;
        case (30):
            cout << "множество элементов типа ";
            break;
        case (19):
            cout << endl;
            break;
        case (6):
            cout << endl;

            break;
        }
        i++;
    }

    if (q == 6)
    {
        cout << "Выражение корректно\n";
    }
    else if ((q == 99) || (i == tokens.size()))
    {
        cout << "Ошибка: '" << tokenstranslate[i - 1] << "', когда ожидалось: " << getwr(s);
    }
}

int main()
{
    setlocale(LC_ALL, "Russian");
    InitAll();
    string str;
    cout << "Введите строку для распознавания:" << endl;
    getline(cin, str);
    str = tolowercase(str);
    if (str.length() != 0)
    {
        scanner(str);
        if (!err)
        {
            cout << "Строка токенов:" << endl;
            for (int i = 0; i < tokens.size(); i++)
            {
                cout << tokens[i] << " ";
            }
            cout << endl;
            synanaliz();
            // cout << res;
        }
    }

    clearall();
    // cout << getcol(";") << gettok(7);
}
