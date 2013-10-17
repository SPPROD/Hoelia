#---------------------------------------------------------------------------------
# Compiler executables
#---------------------------------------------------------------------------------
CC		:=	gcc
CXX		:=	g++

#---------------------------------------------------------------------------------
# Options for code generation
#---------------------------------------------------------------------------------
CFLAGS	:=	-g -Wall
CXXFLAGS:=	$(CFLAGS) -std=c++0x
LDFLAGS	:=	-g

#---------------------------------------------------------------------------------
# Any extra libraries you wish to link with your project
#---------------------------------------------------------------------------------
#LIBS	:=	-lSDL2_ttf -lSDL2_image -lSDL2 -Wl,-Bdynamic -lfreetype -lpthread -ldl
LIBS	:=	-lSDL2_ttf -lSDL2_net -lSDL2_mixer -lSDL2_image -lSDL2

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:=	

#---------------------------------------------------------------------------------
# Source folders and executable name
#---------------------------------------------------------------------------------
TARGET	:=  $(shell basename $(CURDIR))
BUILD	:=	build
SOURCES	:=	droid/jni/src/source
INCLUDES:=	droid/jni/src/source droid/jni/src/include

#---------------------------------------------------------------------------------
# Source files
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------
export OUTPUT	:=	$(CURDIR)/$(TARGET)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))

#---------------------------------------------------------------------------------
# Use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
	export LD	:=	$(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
	export LD	:=	$(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export OFILES	:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o)

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir))

export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

export NDK_PROJECT_PATH := $(CURDIR)/droid

#---------------------------------------------------------------------------------
.PHONY: $(BUILD) clean run edit maps install uninstall droid
#------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@make --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
	@ln -sf droid/assets/graphics graphics
	@ln -sf droid/assets/fonts fonts
	@ln -sf droid/assets/maps maps

#---------------------------------------------------------------------------------
run:
	@echo running ...
	@./$(TARGET)

#---------------------------------------------------------------------------------
edit:
	@echo editing ...
	@gvim -c "Project $(TARGET).vimproj"

#---------------------------------------------------------------------------------
maps:
	@echo compiling maps ...
	@make --no-print-directory -C tools/reader
	@./tools/maps

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET)

#---------------------------------------------------------------------------------
install:
	@cp -u $(TARGET) /usr/bin/$(TARGET)
	@echo installed.

#---------------------------------------------------------------------------------
uninstall:
	@rm -f /usr/bin/$(TARGET)
	@echo uninstalled.

#---------------------------------------------------------------------------------
droid:
	@echo making for android ...
	@cd droid && \
	pwd && \
	$(ANDROID_NDK)/ndk-build NDK_DEBUG=1 && \
	ant debug && \
	dropbox start > /dev/null && \
	cp -f bin/$(TARGET)-debug.apk ~/Dropbox/Public/$(TARGET)-debug.apk && \
	cd ..
	@echo done.

#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
# Makefile targets
#---------------------------------------------------------------------------------
all: $(OUTPUT)

#---------------------------------------------------------------------------------
$(OUTPUT): $(OFILES)
	@echo built ... $(notdir $@)
	@$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@

#---------------------------------------------------------------------------------
%.o: %.c
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

#---------------------------------------------------------------------------------
%.o: %.cpp
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

