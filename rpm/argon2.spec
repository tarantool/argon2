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
%cmake . -DCMAKE_BUILD_TYPE=RelWithDebInfo
make %{?_smp_mflags}

%install
%make_install

%files
%{_libdir}/tarantool/argon2.so

%changelog
* Tue Jul 31 2018 Albert Sverdlov <sverdlov@tarantool.org> 1.0.0-1
- Initial version

