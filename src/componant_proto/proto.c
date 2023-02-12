#include <stdlib.h>

void post(){
	printf("hello post\n");
	exit(0);
}

void foo(){
	int Vreturn = 3;
	void *adresse_post = &post;
	printf("hello foo\n goto post\n");
	/// printf("%d\n",adresse_post);
	goto *adresse_post;
}
void pre(){
	void *adresse_foo = &foo;
	printf("hello pre\n goto foo\n");
	/// printf("%d\n",adresse_foo);
	goto *adresse_foo;
}

int main(int argc, const char * argv[]){
	printf("hello main\n");
	pre();
	/// printf("%d",Vreturn);
	return 0;
}