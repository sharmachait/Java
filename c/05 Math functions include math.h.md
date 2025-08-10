
- sqrt()
- pow()
- round()
- ceil()
- floor()
- abs()

```c
#include <math.h>
int main() {
	
	int x = 9;
	x = sqrt(x);
	printf("%d", x);
	
	x = pow(x, 2);
	printf("%d", x);
	
	float pi = 3.14;
	pi=round(pi);// 3.000000
	printf("%f", pi);
	
	pi=3.14;
	pi=ceil(pi);
	printf("%f", pi); // 4.000000
	
	return 0;
}
```