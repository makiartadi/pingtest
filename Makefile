TEMPDIR := $(shell readlink -m rpmbuild)
.SILENT:

help:
		echo "make test       - execute tests"
		echo "make package    - build rpm packge in ./pkg/"

test:
		./pingtest >/dev/null 2>&1 && echo Tests pass || (echo Tests fail && exit 1)

package:
		mkdir -p ${TEMPDIR}/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS,ENV}
		sed -e "s/__RELEASE__/$(shell git rev-list HEAD --count)/g" support/pingtest.spec > ${TEMPDIR}/pingtest.spec
		rm -rf pkg || :
		mkdir pkg

		cp ./pingtest ${TEMPDIR}/SOURCES

		rpmbuild -vv -bb --target="noarch" --clean --define "_topdir ${TEMPDIR}" ${TEMPDIR}/pingtest.spec
		find ${TEMPDIR} -type f -name '*.rpm' -print0 | xargs -0 -I {} mv {} ./pkg
		rm -rf ${TEMPDIR}
