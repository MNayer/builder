# Makefile for building apptainer images and the software projects inside
# the containers.

# Use the following variable set the list of projects which are build
PROJECTS_WORKING := \
	curl \
	FFmpeg \
	file \
	git \
	ghostscript \
	gpac \
	ImageMagick \
	ImageMagick6 \
	jasper \
	libxml2 \
	mariadb \
	mruby \
	openjpeg \
	openssl \
	php-src \
	pjproject \
	qemu \
	radare2 \
	samba \
	sqlite \
	squashfs-tools \
	tcpdump \
	vim

PROJECTS_WIP := 

PROJECTS := $(PROJECTS_WORKING) $(PROJECTS_WIP)

## Commands:
# - build_images: Builds all apptainer images
# - build_projects: Builds all projects
# - build_project_{project_name}: Builds the project {project_name}

.PHONY: build_images build_projects

all: build_images

build_images: $(patsubst %, apptainer/projects/%/container.sif, $(PROJECTS))
build_projects: $(patsubst %, build_project_%, $(PROJECTS))

#
## Build images:
#
apptainer/base.sif: apptainer/base/base_shims.def
	apptainer build -F $@ $<

apptainer/projects/%/container.sif: apptainer/projects/%/container.def apptainer/base.sif
	apptainer build -F $@ $<

#
## Build projects:
#

$(foreach project, $(PROJECTS), \
	$(if $(wildcard apptainer/projects/$(project)/Makefile.train),$(eval include apptainer/projects/$(project)/Makefile.train)) \
	$(if $(wildcard apptainer/projects/$(project)/Makefile.test),$(eval include apptainer/projects/$(project)/Makefile.test)) \
	$(if $(wildcard apptainer/projects/$(project)/Makefile.valid),$(eval include apptainer/projects/$(project)/Makefile.valid)) \
)