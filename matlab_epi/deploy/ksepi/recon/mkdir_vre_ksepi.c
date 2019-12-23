#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DIR_TO_MAKE "/data/acq/ksepi"

int main(void) {
	if(mkdir(DIR_TO_MAKE, 0755) == -1) {
		printf("Failed to create %s\n", DIR_TO_MAKE);
		perror("mkdir");
		exit(EXIT_FAILURE);
	} else {
		chown(DIR_TO_MAKE, 564, 201);
	}
}
