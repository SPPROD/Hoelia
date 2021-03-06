/*---------------------------------------------------------------------------------
	
	Hoelia
	Copyright (C) 2013-2014 Deloptia <deloptia.devteam@gmail.com>
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
---------------------------------------------------------------------------------*/
#ifndef CONFIG_H
#define CONFIG_H

#define APP_NAME "Hoelia"

#define NB_CHARACTERS 1

#define NB_TILESETS 3
#define NB_ZONES 3
#define NB_DOORS 12

#define DEFAULT_MAP_WIDTH 40
#define DEFAULT_MAP_HEIGHT 30

#define OVERWORLD_SIZE 2
#define INDOOR_SIZE 3
#define CAVE_1_SIZE 2

#ifdef __ANDROID__
	#define VIEWPORT
	#define PAD
	
	#define info(txt...) __android_log_print(ANDROID_LOG_INFO, APP_NAME, txt)
	#define debug(txt...) __android_log_print(ANDROID_LOG_DEBUG, APP_NAME, txt)
	#define warn(txt...) __android_log_print(ANDROID_LOG_WARNING, APP_NAME, txt)
	#define error(txt...) __android_log_print(ANDROID_LOG_ERROR, APP_NAME, txt)
#else
	#define info(txt...) printf("INFO:\t"); printf(txt)
	#define debug(txt...) printf("DEBUG:\t"); printf(txt)
	#define warn(txt...) printf("WARN:\t"); printf(txt)
	#define error(txt...) fprintf(stderr, "ERROR:\t"); fprintf(stderr, txt)
#endif

#endif // CONFIG_H
