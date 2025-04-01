# Makefile for building apptainer images and the software projects inside
# the containers.

# Use the following variable set the list of projects which are build
PROJECTS_WORKING := \
	file \
	radare2 \
	vim

PROJECTS_WIP := 

PROJECTS := $(PROJECTS_WORKING) $(PROJECTS_WIP)

## Commands:
# - build_images: Builds all apptainer images
# - build_projects: Builds all projects
# - build_project_{project_name}: Builds the project {project_name}

.PHONY: build_images build_projects

all: build_projects

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

# - out/{project_name}/done
$(foreach project, $(PROJECTS), \
	$(eval out/$(project)/done: apptainer/projects/$(project)/container.sif; ./scripts/build_project.sh $(project)) )

# - build_project_{project_name}
$(foreach project, $(PROJECTS), \
	$(eval build_project_$(project): out/$(project)/done) )