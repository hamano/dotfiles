/*
 * name
 * Copyright (C) 2005 HAMANO Tsukasa <code@cuspy.org>
 * This software is released under the MIT License.
 * See LICENSE file for more details.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
    if(argc < 2){
        fprintf(stderr, "too few arguments\n");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
