C
C     FFTE: A FAST FOURIER TRANSFORM PACKAGE
C
C     (C) COPYRIGHT SOFTWARE, 2000-2004, 2008-2011, ALL RIGHTS RESERVED
C                BY
C         DAISUKE TAKAHASHI
C         FACULTY OF ENGINEERING, INFORMATION AND SYSTEMS
C         UNIVERSITY OF TSUKUBA
C         1-1-1 TENNODAI, TSUKUBA, IBARAKI 305-8573, JAPAN
C         E-MAIL: daisuke@cs.tsukuba.ac.jp
C
C
C     ZFFT3D SPEED TEST PROGRAM
C
C     FORTRAN77 SOURCE PROGRAM
C
C     WRITTEN BY DAISUKE TAKAHASHI
C
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER (NDA=16777216)
      COMPLEX*16 A(NDA)
      DIMENSION LNX(3),LNY(3),LNZ(3)
      SAVE A
C
      WRITE(6,*) ' NX,NY,NZ ='
      READ(5,*) NX,NY,NZ
      CALL FACTOR(NX,LNX)
      CALL FACTOR(NY,LNY)
      CALL FACTOR(NZ,LNZ)
C
      CALL INIT(A,NX*NY*NZ)
      CALL ZFFT3D(A,NX,NY,NZ,0)
      CALL ZFFT3D(A,NX,NY,NZ,-1)
      LOOP=1
C
!$ 10 CONTINUE
!$    TIME1=OMP_GET_WTIME()
      DO 20 I=1,LOOP
        CALL ZFFT3D(A,NX,NY,NZ,-1)
   20 CONTINUE
!$    TIME2=OMP_GET_WTIME()
!$    TIME0=TIME2-TIME1
!$    IF (TIME0 .LT. 1.0D0) THEN
!$      LOOP=LOOP*2
!$      GO TO 10
!$    END IF
!$    TIME0=TIME0/DBLE(LOOP)
!$    FLOPS=(2.5D0*DBLE(LNX(1)+LNY(1)+LNZ(1))
!$   1       +4.66666666666666D0*DBLE(LNX(2)+LNY(2)+LNZ(2))
!$   2       +6.8D0*DBLE(LNX(3)+LNY(3)+LNZ(3)))*2.0D0
!$   3       *DBLE(NX)*DBLE(NY)*DBLE(NZ)/TIME0/1.0D6
!$    WRITE(6,*) ' NX =',NX,' NY =',NY,' NZ =',NZ
!$    WRITE(6,*) ' TIME =',TIME0
!$    WRITE(6,*) FLOPS,' MFLOPS'
C
      STOP
      END
      SUBROUTINE INIT(A,N)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A(*)
C
!DIR$ VECTOR ALIGNED
      DO 10 I=1,N
C        A(I)=DCMPLX(DBLE(I),DBLE(N-I+1))
        A(I)=(0.0D0,0.0D0)
   10 CONTINUE
      RETURN
      END
