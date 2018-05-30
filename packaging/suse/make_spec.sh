#!/bin/bash

if [ -z "$1" ]; then
  cat <<EOF
usage:
  ./make_spec.sh PACKAGE [BRANCH]
EOF
  exit 1
fi

cd $(dirname $0)

YEAR=$(date +%Y)
VERSION=$(cat ../../VERSION)
REVISION=$(git rev-list HEAD | wc -l)
COMMIT=$(git rev-parse --short HEAD)
COMMIT_UNIX_TIME=$(git show -s --format=%ct)
VERSION="${VERSION%+*}+$(date -d @$COMMIT_UNIX_TIME +%Y%m%d).git_r${REVISION}_${COMMIT}"
NAME=$1
BRANCH=${2:-master}
SAFE_BRANCH=${BRANCH//\//-}

cat <<EOF > ${NAME}.spec
#
# spec file for package ${NAME}
#
# Copyright (c) $YEAR SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           $NAME
Url:            https://github.com/kubic-project/$NAME/
Version:        $VERSION
Release:        0
Source:         ${SAFE_BRANCH}.tar.gz
# to make check_if_valid_source_dir happy
Summary:        Supportconfig Plugin for SUSE CaaSP
License:        GPL-2.0
Group:          Documentation/SuSE
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch
BuildRequires:  supportconfig-plugin-resource
Requires:       supportconfig-plugin-resource
Requires:       supportconfig-plugin-tag
Requires:       perl-JSON
Requires:       perl-XML-Bare

%description
Extends supportconfig functionality to include system information about
SUSE Containers as a Platform. The supportconfig saves the plugin output to plugin-suse_caasp.txt.

%prep
%setup -q -n ${NAME}-${SAFE_BRANCH}

%build
gzip -9f suse-caasp-plugin.8

%install
install -d %{buildroot}/usr/lib/supportconfig/{plugins,resources}
install -d %{buildroot}/usr/share/man/man8
install -d %{buildroot}/var/lib/supportutils-plugin-suse-caasp
install -m 0544 suse_caasp %{buildroot}/usr/lib/supportconfig/plugins
install -m 0644 suse-caasp-plugin.8.gz %{buildroot}/usr/share/man/man8/suse-caasp-plugin.8.gz
install -m 0544 debug-salt %{buildroot}/var/lib/supportutils-plugin-suse-caasp/debug-salt

%files
%defattr(-,root,root)
%if 0%{?suse_version} < 1500
%doc COPYING.GPLv2
%else
%license COPYING.GPLv2
%endif
/usr/lib/supportconfig/plugins
/usr/lib/supportconfig/plugins/suse_caasp
/usr/share/man/man8/suse-caasp-plugin.8.gz
/var/lib/supportutils-plugin-suse-caasp
/var/lib/supportutils-plugin-suse-caasp/debug-salt

%changelog
EOF
