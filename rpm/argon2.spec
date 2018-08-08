Name: tarantool-argon2
Version: 3.0.1
Release: 1%{?dist}
Summary: Password hash Argon2, winner of PHC
Group: Applications/Databases
License: BSD
URL: https://github.com/tarantool/argon2
Source0: https://github.com/tarantool/%{name}/archive/%{version}/%{name}-%{version}.tar.gz
BuildRequires: cmake >= 2.8
BuildRequires: gcc >= 4.5
BuildRequires: tarantool-devel >= 1.6.8.0
Requires: tarantool >= 1.6.8.0

%description
Password hash Argon2, winner of PHC

%prep
%setup -q -n %{name}-%{version}

%build

# Extracted from official argon2 source package spec on centos:
# https://centos.pkgs.org/7/epel-x86_64/libargon2-20161029-2.el7.x86_64.rpm.html
#
# Honours default RPM build options and library path, do not use -march=native
sed -e 's:-O3 -Wall:%{optflags}:' \
        -e 's:-march=\$(OPTTARGET) :${CFLAGS} :' \
        -e 's:CFLAGS += -march=\$(OPTTARGET)::' \
        -i phc-winner-argon2/Makefile

%cmake . -DCMAKE_BUILD_TYPE=RelWithDebInfo
make %{?_smp_mflags}

%install
%make_install

%files
%{_libdir}/tarantool/argon2.so

%changelog
* Tue Jul 31 2018 Albert Sverdlov <sverdlov@tarantool.org> 1.0.0-1
- Initial version

