/*
 * name
 * Copyright (C) 2005 Tsukasa Hamano <code@cuspy.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
/* $Id: template.c,v 1.2 2007-06-05 13:25:21 hamano Exp $ */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *args[]){
    if(argc < 2){
        fprintf(stderr, "too few arguments\n");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}