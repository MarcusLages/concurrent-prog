#define DOUBLE(x) x = x + x

int main() {
    int n = 5;
    DOUBLE(n + 1);
}