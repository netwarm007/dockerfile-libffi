FROM tim03/lfs AS build-env
LABEL maintainer Chen, Wenli <chenwenli@chenwenli.com>

WORKDIR /usr/src
ADD http://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz .
COPY md5sums .
RUN md5sum -c md5sums
RUN \
	tar xvf libffi-3.2.1.tar.gz && \
	mv -v libffi-3.2.1 libffi && \
	pushd libffi && \
	sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    	    -i include/Makefile.in && \
	sed -e '/^includedir/ s/=.*$/=@includedir@/' \
	    -e 's/^Cflags: -I${includedir}/Cflags:/' \
	    -i libffi.pc.in        && \
	./configure --prefix=/usr --disable-static && \
	make -j"$(nproc)" && \
	make check && \
	make install && \
	popd && \
	rm -rf libffi
	
