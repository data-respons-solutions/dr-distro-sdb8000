DESCRIPTION = "Reference image"

require recipes-bsp/images/datarespons-image.bb

FEATURE_PACKAGES_sdb8000-apps = "\
	packagegroup-sdb8000-base \
"

IMAGE_FEATURES += "sdb8000-apps"
IMAGE_INSTALL_append += " kernel-image-fitimage"