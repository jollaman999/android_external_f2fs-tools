LOCAL_PATH:= $(call my-dir)

# f2fs-tools depends on Linux kernel headers being in the system include path.
ifeq ($(HOST_OS),linux)

# The versions depend on $(LOCAL_PATH)/VERSION
version_CFLAGS := -DF2FS_MAJOR_VERSION=1 -DF2FS_MINOR_VERSION=8 -DF2FS_TOOLS_VERSION=\"1.8.0\" -DF2FS_TOOLS_DATE=\"2017-02-03\"
common_CFLAGS := -DWITH_ANDROID $(version_CFLAGS)
# Workaround for the <sys/types.h>/<sys/sysmacros.h> split, here now for
# bionic and coming later for glibc.
target_CFLAGS := $(common_CFLAGS) -include sys/sysmacros.h

# external/e2fsprogs/lib is needed for uuid/uuid.h
common_C_INCLUDES := $(LOCAL_PATH)/include external/e2fsprogs/lib/

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt
LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host
LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
include $(BUILD_HOST_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host_dyn
LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	lib/libf2fs_io.c \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
LOCAL_STATIC_LIBRARIES := \
	libf2fs_ioutils_host \
	libext2_uuid \
	libsparse_static \
	libz
# LOCAL_LDLIBS := -ldl
include $(BUILD_HOST_SHARED_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
# The LOCAL_MODULE name is referenced by the code. Don't change it.
LOCAL_MODULE := mkfs.f2fs
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_SRC_FILES := \
	lib/libf2fs_io.c \
	mkfs/f2fs_format_main.c
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_STATIC_LIBRARIES := \
	libf2fs_fmt \
	libext2_uuid \
	libsparse_static \
	libz
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
# The LOCAL_MODULE name is referenced by the code. Don't change it.
LOCAL_MODULE := fsck.f2fs
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_SRC_FILES := \
	fsck/dir.c \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	lib/libf2fs.c \
	lib/libf2fs_io.c
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_STATIC_LIBRARIES := \
	libext2_uuid \
	libsparse_static \
	libz
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

endif
