!MNH_LIC Copyright 2000-2018 CNRS, Meteo-France and Universite Paul Sabatier
!MNH_LIC This is part of the Meso-NH software governed by the CeCILL-C licence
!MNH_LIC version 1. See LICENSE, CeCILL-C_V1-en.txt and CeCILL-C_V1-fr.txt  
!MNH_LIC for details. version 1.
!-----------------------------------------------------------------
!      #########################
MODULE MODI_INI_AIRCRAFT_BALLOON
!      #########################
!
INTERFACE
!
      SUBROUTINE INI_AIRCRAFT_BALLOON(TPINIFILE,                    &
                                      PTSTEP, TPDTSEG, PSEGLEN,     &
                                      KRR, KSV, KKU, OUSETKE,       &
                                      PLATOR, PLONOR                )
!
USE MODD_IO_ll, ONLY : TFILEDATA
USE MODD_TYPE_DATE
!
TYPE(TFILEDATA),    INTENT(IN) :: TPINIFILE !Initial file
REAL,               INTENT(IN) :: PTSTEP  ! time step
TYPE(DATE_TIME),    INTENT(IN) :: TPDTSEG ! segment date and time
REAL,               INTENT(IN) :: PSEGLEN ! segment length
INTEGER,            INTENT(IN) :: KRR     ! number of moist variables
INTEGER,            INTENT(IN) :: KSV     ! number of scalar variables
INTEGER,            INTENT(IN) :: KKU     ! number of vertical levels 
LOGICAL,            INTENT(IN) :: OUSETKE ! flag to use tke
REAL,               INTENT(IN) :: PLATOR  ! latitude of origine point
REAL,               INTENT(IN) :: PLONOR  ! longitude of origine point
!
!-------------------------------------------------------------------------------
!
END SUBROUTINE INI_AIRCRAFT_BALLOON
!
END INTERFACE
!
END MODULE MODI_INI_AIRCRAFT_BALLOON
!
!     ###############################################################
      SUBROUTINE INI_AIRCRAFT_BALLOON(TPINIFILE,                    &
                                      PTSTEP, TPDTSEG, PSEGLEN,     &
                                      KRR, KSV, KKU, OUSETKE,       &
                                      PLATOR, PLONOR                )
!     ###############################################################
!
!
!!****  *INI_AIRCRAFT_BALLOON* -
!!
!!    PURPOSE
!!    -------
!
!
!!**  METHOD
!!    ------
!!
!!
!!    EXTERNAL
!!    --------
!!
!!    IMPLICIT ARGUMENTS
!!    ------------------
!!
!!    REFERENCE
!!    ---------
!!
!!    AUTHOR
!!    ------
!!      Valery Masson             * Meteo-France *
!!
!!    MODIFICATIONS
!!    -------------
!!     Original 15/05/2000
!!               Apr, 20 2001: G.Jaubert: use in diag  with stationnary fields
!!               March, 2013 : O.Caumont, C.Lac : add vertical profiles
!!               OCT,2016 : G.Delautier LIMA
!!  Philippe Wautelet: 05/2016-04/2018: new data structures and calls for I/O
!!
!! --------------------------------------------------------------------------
!
!*      0. DECLARATIONS
!          ------------
!
USE MODD_AIRCRAFT_BALLOON
USE MODD_CONF
USE MODD_DIAG_FLAG
USE MODD_DYN_n
USE MODD_GRID
USE MODD_IO_ll,   ONLY : TFILEDATA
USE MODD_LUNIT_n, ONLY : TLUOUT
USE MODD_PARAM_n, ONLY : CCLOUD
USE MODD_PARAMETERS
!
USE MODE_FIELD,   ONLY : TFIELDDATA, TYPEREAL
USE MODE_GRIDPROJ
USE MODE_IO_ll
USE MODE_ll
USE MODE_MODELN_HANDLER
USE MODE_MSG
!
USE MODI_INI_BALLOON
USE MODI_INI_AIRCRAFT
!
IMPLICIT NONE
!
!*      0.1  declarations of arguments
!
TYPE(TFILEDATA),    INTENT(IN) :: TPINIFILE !Initial file
REAL,               INTENT(IN) :: PTSTEP  ! time step
TYPE(DATE_TIME),    INTENT(IN) :: TPDTSEG ! segment date and time
REAL,               INTENT(IN) :: PSEGLEN ! segment length
INTEGER,            INTENT(IN) :: KRR     ! number of moist variables
INTEGER,            INTENT(IN) :: KSV     ! number of scalar variables
INTEGER,            INTENT(IN) :: KKU     ! number of vertical levels 
LOGICAL,            INTENT(IN) :: OUSETKE ! flag to use tke
REAL,               INTENT(IN) :: PLATOR  ! latitude of origine point
REAL,               INTENT(IN) :: PLONOR  ! longitude of origine point
!
!-------------------------------------------------------------------------------
!
!       0.2  declaration of local variables
!
INTEGER :: IMI    ! current model index
INTEGER :: ISTORE ! number of storage instants
INTEGER :: ILUOUT ! logical unit
INTEGER :: IRESP  ! return code
INTEGER :: JSEG   ! loop counter
TYPE(TFIELDDATA) :: TZFIELD
!
!----------------------------------------------------------------------------
!
IMI=GET_CURRENT_MODEL_INDEX()
ILUOUT = TLUOUT%NLU
!----------------------------------------------------------------------------
!
!*      1.   Default values
!            --------------
!
IF ( CPROGRAM == 'DIAG  ') THEN
  IF ( .NOT. LAIRCRAFT_BALLOON ) RETURN
  IF (NTIME_AIRCRAFT_BALLOON == NUNDEF .OR. XSTEP_AIRCRAFT_BALLOON == XUNDEF) THEN
    WRITE(ILUOUT,*) "NTIME_AIRCRAFT_BALLOON and/or  XSTEP_AIRCRAFT_BALLOON not initialized in DIAG "
    WRITE(ILUOUT,*) "No calculations for Balloons and Aircraft"
    LAIRCRAFT_BALLOON=.FALSE.
    RETURN
  ENDIF
ENDIF
!
!
IF ( IMI == 1 ) THEN
  LFLYER=.FALSE.
!
  CALL DEFAULT_FLYER(TBALLOON1)
  CALL DEFAULT_FLYER(TBALLOON2)
  CALL DEFAULT_FLYER(TBALLOON3)
  CALL DEFAULT_FLYER(TBALLOON4)
  CALL DEFAULT_FLYER(TBALLOON5)
  CALL DEFAULT_FLYER(TBALLOON6)
  CALL DEFAULT_FLYER(TBALLOON7)
  CALL DEFAULT_FLYER(TBALLOON8)
  CALL DEFAULT_FLYER(TBALLOON9)
!
  CALL DEFAULT_FLYER(TAIRCRAFT1)
  CALL DEFAULT_FLYER(TAIRCRAFT2)
  CALL DEFAULT_FLYER(TAIRCRAFT3)
  CALL DEFAULT_FLYER(TAIRCRAFT4)
  CALL DEFAULT_FLYER(TAIRCRAFT5)
  CALL DEFAULT_FLYER(TAIRCRAFT6)
  CALL DEFAULT_FLYER(TAIRCRAFT7)
  CALL DEFAULT_FLYER(TAIRCRAFT8)
  CALL DEFAULT_FLYER(TAIRCRAFT9)
  CALL DEFAULT_FLYER(TAIRCRAFT10)
  CALL DEFAULT_FLYER(TAIRCRAFT11)
  CALL DEFAULT_FLYER(TAIRCRAFT12)
  CALL DEFAULT_FLYER(TAIRCRAFT13)
  CALL DEFAULT_FLYER(TAIRCRAFT14)
  CALL DEFAULT_FLYER(TAIRCRAFT15)
  CALL DEFAULT_FLYER(TAIRCRAFT16)
  CALL DEFAULT_FLYER(TAIRCRAFT17)
  CALL DEFAULT_FLYER(TAIRCRAFT18)
  CALL DEFAULT_FLYER(TAIRCRAFT19)
  CALL DEFAULT_FLYER(TAIRCRAFT20)
  CALL DEFAULT_FLYER(TAIRCRAFT21)
  CALL DEFAULT_FLYER(TAIRCRAFT22)
  CALL DEFAULT_FLYER(TAIRCRAFT23)
  CALL DEFAULT_FLYER(TAIRCRAFT24)
  CALL DEFAULT_FLYER(TAIRCRAFT25)
  CALL DEFAULT_FLYER(TAIRCRAFT26)
  CALL DEFAULT_FLYER(TAIRCRAFT27)
  CALL DEFAULT_FLYER(TAIRCRAFT28)
  CALL DEFAULT_FLYER(TAIRCRAFT29)
  CALL DEFAULT_FLYER(TAIRCRAFT30)
END IF
!
!----------------------------------------------------------------------------
!
!*      2.   Balloon initialization
!            ----------------------
IF (IMI == 1) CALL INI_BALLOON
!
CALL INI_LAUNCH(1,TBALLOON1)
CALL INI_LAUNCH(2,TBALLOON2)
CALL INI_LAUNCH(3,TBALLOON3)
CALL INI_LAUNCH(4,TBALLOON4)
CALL INI_LAUNCH(5,TBALLOON5)
CALL INI_LAUNCH(6,TBALLOON6)
CALL INI_LAUNCH(7,TBALLOON7)
CALL INI_LAUNCH(8,TBALLOON8)
CALL INI_LAUNCH(9,TBALLOON9)
!
!----------------------------------------------------------------------------
!
!*      3.   Aircraft initialization
!            -----------------------
!
IF (IMI == 1) CALL INI_AIRCRAFT
!
CALL INI_FLIGHT(1,TAIRCRAFT1)
CALL INI_FLIGHT(2,TAIRCRAFT2)
CALL INI_FLIGHT(3,TAIRCRAFT3)
CALL INI_FLIGHT(4,TAIRCRAFT4)
CALL INI_FLIGHT(5,TAIRCRAFT5)
CALL INI_FLIGHT(6,TAIRCRAFT6)
CALL INI_FLIGHT(7,TAIRCRAFT7)
CALL INI_FLIGHT(8,TAIRCRAFT8)
CALL INI_FLIGHT(9,TAIRCRAFT9)
CALL INI_FLIGHT(10,TAIRCRAFT10)
CALL INI_FLIGHT(11,TAIRCRAFT11)
CALL INI_FLIGHT(12,TAIRCRAFT12)
CALL INI_FLIGHT(13,TAIRCRAFT13)
CALL INI_FLIGHT(14,TAIRCRAFT14)
CALL INI_FLIGHT(15,TAIRCRAFT15)
CALL INI_FLIGHT(16,TAIRCRAFT16)
CALL INI_FLIGHT(17,TAIRCRAFT17)
CALL INI_FLIGHT(18,TAIRCRAFT18)
CALL INI_FLIGHT(19,TAIRCRAFT19)
CALL INI_FLIGHT(20,TAIRCRAFT20)
CALL INI_FLIGHT(21,TAIRCRAFT21)
CALL INI_FLIGHT(22,TAIRCRAFT22)
CALL INI_FLIGHT(23,TAIRCRAFT23)
CALL INI_FLIGHT(24,TAIRCRAFT24)
CALL INI_FLIGHT(25,TAIRCRAFT25)
CALL INI_FLIGHT(26,TAIRCRAFT26)
CALL INI_FLIGHT(27,TAIRCRAFT27)
CALL INI_FLIGHT(28,TAIRCRAFT28)
CALL INI_FLIGHT(29,TAIRCRAFT29)
CALL INI_FLIGHT(30,TAIRCRAFT30)
!
!----------------------------------------------------------------------------
!
!*      4.   Allocations of storage arrays
!            -----------------------------
!
IF (.NOT. LFLYER) RETURN
!
CALL ALLOCATE_FLYER(TBALLOON1)
CALL ALLOCATE_FLYER(TBALLOON2)
CALL ALLOCATE_FLYER(TBALLOON3)
CALL ALLOCATE_FLYER(TBALLOON4)
CALL ALLOCATE_FLYER(TBALLOON5)
CALL ALLOCATE_FLYER(TBALLOON6)
CALL ALLOCATE_FLYER(TBALLOON7)
CALL ALLOCATE_FLYER(TBALLOON8)
CALL ALLOCATE_FLYER(TBALLOON9)
!
CALL ALLOCATE_FLYER(TAIRCRAFT1)
CALL ALLOCATE_FLYER(TAIRCRAFT2)
CALL ALLOCATE_FLYER(TAIRCRAFT3)
CALL ALLOCATE_FLYER(TAIRCRAFT4)
CALL ALLOCATE_FLYER(TAIRCRAFT5)
CALL ALLOCATE_FLYER(TAIRCRAFT6)
CALL ALLOCATE_FLYER(TAIRCRAFT7)
CALL ALLOCATE_FLYER(TAIRCRAFT8)
CALL ALLOCATE_FLYER(TAIRCRAFT9)
CALL ALLOCATE_FLYER(TAIRCRAFT10)
CALL ALLOCATE_FLYER(TAIRCRAFT11)
CALL ALLOCATE_FLYER(TAIRCRAFT12)
CALL ALLOCATE_FLYER(TAIRCRAFT13)
CALL ALLOCATE_FLYER(TAIRCRAFT14)
CALL ALLOCATE_FLYER(TAIRCRAFT15)
CALL ALLOCATE_FLYER(TAIRCRAFT16)
CALL ALLOCATE_FLYER(TAIRCRAFT17)
CALL ALLOCATE_FLYER(TAIRCRAFT18)
CALL ALLOCATE_FLYER(TAIRCRAFT19)
CALL ALLOCATE_FLYER(TAIRCRAFT20)
CALL ALLOCATE_FLYER(TAIRCRAFT21)
CALL ALLOCATE_FLYER(TAIRCRAFT22)
CALL ALLOCATE_FLYER(TAIRCRAFT23)
CALL ALLOCATE_FLYER(TAIRCRAFT24)
CALL ALLOCATE_FLYER(TAIRCRAFT25)
CALL ALLOCATE_FLYER(TAIRCRAFT26)
CALL ALLOCATE_FLYER(TAIRCRAFT27)
CALL ALLOCATE_FLYER(TAIRCRAFT28)
CALL ALLOCATE_FLYER(TAIRCRAFT29)
CALL ALLOCATE_FLYER(TAIRCRAFT30)
!
!----------------------------------------------------------------------------
!----------------------------------------------------------------------------
!
CONTAINS
!
!----------------------------------------------------------------------------
!----------------------------------------------------------------------------
SUBROUTINE DEFAULT_FLYER(TPFLYER)
!
TYPE(FLYER), INTENT(OUT) :: TPFLYER
!
!
TPFLYER%NMODEL = 0
TPFLYER%MODEL = 'FIX'
TPFLYER%TYPE   = '      '
TPFLYER%TITLE  = '        '
TPFLYER%LAUNCH = TPDTSEG
TPFLYER%CRASH  = .FALSE.
TPFLYER%FLY    = .FALSE.
!
TPFLYER%T_CUR  = XUNDEF
TPFLYER%N_CUR  = 0
TPFLYER%STEP   = 60.     ! s
!
TPFLYER%LAT     = XUNDEF
TPFLYER%LON     = XUNDEF
TPFLYER%ALT     = XUNDEF
TPFLYER%WASCENT = 5.     ! m/s
TPFLYER%RHO     = XUNDEF
TPFLYER%PRES    = XUNDEF
!
TPFLYER%SEG     = 0
TPFLYER%SEGCURN = 1
TPFLYER%SEGCURT = 0.
!
TPFLYER%X_CUR   = XUNDEF
TPFLYER%Y_CUR   = XUNDEF
TPFLYER%Z_CUR   = XUNDEF
TPFLYER%P_CUR   = XUNDEF
!
END SUBROUTINE DEFAULT_FLYER
!----------------------------------------------------------------------------
!----------------------------------------------------------------------------
SUBROUTINE ALLOCATE_FLYER(TPFLYER)
!
!
TYPE(FLYER), INTENT(INOUT) :: TPFLYER
!
IF (TPFLYER%NMODEL > NMODEL) TPFLYER%NMODEL=0
IF (IMI /= TPFLYER%NMODEL .AND. .NOT. (IMI==1 .AND. TPFLYER%NMODEL==0) ) RETURN
!
IF ( CPROGRAM == 'DIAG  ' ) THEN
  ISTORE = INT ( NTIME_AIRCRAFT_BALLOON / TPFLYER%STEP ) + 1
ELSE
  ISTORE = INT ( (PSEGLEN-XTSTEP) / TPFLYER%STEP ) + 1
ENDIF
!
IF (TPFLYER%NMODEL == 0) ISTORE=0
IF (TPFLYER%NMODEL > 0) THEN
  WRITE(ILUOUT,*) 'Aircraft or Balloon:',TPFLYER%TITLE,' nmodel=',TPFLYER%NMODEL
ENDIF
!
!
ALLOCATE(TPFLYER%TIME(ISTORE))
ALLOCATE(TPFLYER%X   (ISTORE))
ALLOCATE(TPFLYER%Y   (ISTORE))
ALLOCATE(TPFLYER%Z   (ISTORE))
ALLOCATE(TPFLYER%XLON(ISTORE))
ALLOCATE(TPFLYER%YLAT(ISTORE))
ALLOCATE(TPFLYER%ZON (ISTORE))
ALLOCATE(TPFLYER%MER (ISTORE))
ALLOCATE(TPFLYER%W   (ISTORE))
ALLOCATE(TPFLYER%P   (ISTORE))
ALLOCATE(TPFLYER%TH  (ISTORE))
ALLOCATE(TPFLYER%R   (ISTORE,KRR))
ALLOCATE(TPFLYER%SV  (ISTORE,KSV))
ALLOCATE(TPFLYER%RTZ (ISTORE,KKU))
ALLOCATE(TPFLYER%RZ (ISTORE,KKU,KRR))
ALLOCATE(TPFLYER%FFZ (ISTORE,KKU))
ALLOCATE(TPFLYER%IWCZ (ISTORE,KKU))
ALLOCATE(TPFLYER%LWCZ (ISTORE,KKU))
ALLOCATE(TPFLYER%CIZ (ISTORE,KKU))
IF (CCLOUD=='LIMA') THEN
  ALLOCATE(TPFLYER%CCZ  (ISTORE,KKU))
  ALLOCATE(TPFLYER%CRZ  (ISTORE,KKU))
ENDIF
ALLOCATE(TPFLYER%CRARE(ISTORE,KKU))
ALLOCATE(TPFLYER%CRARE_ATT(ISTORE,KKU))
ALLOCATE(TPFLYER%WZ(ISTORE,KKU))
ALLOCATE(TPFLYER%ZZ(ISTORE,KKU))
IF (OUSETKE) THEN
  ALLOCATE(TPFLYER%TKE (ISTORE))
ELSE
  ALLOCATE(TPFLYER%TKE (0))
END IF
ALLOCATE(TPFLYER%TKE_DISS(ISTORE))
ALLOCATE(TPFLYER%TSRAD (ISTORE))
ALLOCATE(TPFLYER%ZS  (ISTORE))
ALLOCATE(TPFLYER%DATIME(16,ISTORE))
!
ALLOCATE(TPFLYER%THW_FLUX  (ISTORE))
ALLOCATE(TPFLYER%RCW_FLUX  (ISTORE))
ALLOCATE(TPFLYER%SVW_FLUX  (ISTORE,KSV))
!
TPFLYER%TIME     = XUNDEF
TPFLYER%X        = XUNDEF
TPFLYER%Y        = XUNDEF
TPFLYER%Z        = XUNDEF
TPFLYER%XLON     = XUNDEF
TPFLYER%YLAT     = XUNDEF
TPFLYER%ZON      = XUNDEF
TPFLYER%MER      = XUNDEF
TPFLYER%W        = XUNDEF
TPFLYER%P        = XUNDEF
TPFLYER%TH       = XUNDEF
TPFLYER%R        = XUNDEF
TPFLYER%SV       = XUNDEF
TPFLYER%RTZ      = XUNDEF
TPFLYER%RZ       = XUNDEF
TPFLYER%FFZ      = XUNDEF
TPFLYER%CIZ      = XUNDEF
IF (CCLOUD=='LIMA') THEN
  TPFLYER%CRZ      = XUNDEF
  TPFLYER%CCZ      = XUNDEF
ENDIF
TPFLYER%IWCZ     = XUNDEF
TPFLYER%LWCZ     = XUNDEF
XLAM_CRAD        = 3.154E-3 ! (in m) <=> 95.04 GHz = Rasta cloud radar frequency
TPFLYER%CRARE    = XUNDEF
TPFLYER%CRARE_ATT= XUNDEF
TPFLYER%WZ= XUNDEF
TPFLYER%ZZ= XUNDEF
TPFLYER%TKE      = XUNDEF
TPFLYER%TSRAD    = XUNDEF
TPFLYER%ZS       = XUNDEF
TPFLYER%TKE_DISS = XUNDEF
TPFLYER%DATIME( 1,1:ISTORE) = TPDTSEG%TDATE%YEAR
TPFLYER%DATIME( 2,1:ISTORE) = TPDTSEG%TDATE%MONTH
TPFLYER%DATIME( 3,1:ISTORE) = TPDTSEG%TDATE%DAY
TPFLYER%DATIME( 4,1:ISTORE) = TPDTSEG%TIME
TPFLYER%DATIME( 5,1:ISTORE) = TPDTSEG%TDATE%YEAR
TPFLYER%DATIME( 6,1:ISTORE) = TPDTSEG%TDATE%MONTH
TPFLYER%DATIME( 7,1:ISTORE) = TPDTSEG%TDATE%DAY
TPFLYER%DATIME( 8,1:ISTORE) = TPDTSEG%TIME
TPFLYER%DATIME( 9,1:ISTORE) = TPDTSEG%TDATE%YEAR
TPFLYER%DATIME(10,1:ISTORE) = TPDTSEG%TDATE%MONTH
TPFLYER%DATIME(11,1:ISTORE) = TPDTSEG%TDATE%DAY
TPFLYER%DATIME(12,1:ISTORE) = TPDTSEG%TIME
TPFLYER%DATIME(13,1:ISTORE) = TPDTSEG%TDATE%YEAR
TPFLYER%DATIME(14,1:ISTORE) = TPDTSEG%TDATE%MONTH
TPFLYER%DATIME(15,1:ISTORE) = TPDTSEG%TDATE%DAY
TPFLYER%DATIME(16,1:ISTORE) = XUNDEF

!
TPFLYER%THW_FLUX        = XUNDEF
TPFLYER%RCW_FLUX        = XUNDEF
TPFLYER%SVW_FLUX        = XUNDEF
END SUBROUTINE ALLOCATE_FLYER
!----------------------------------------------------------------------------
!----------------------------------------------------------------------------
SUBROUTINE INI_LAUNCH(KNBR,TPFLYER)
!
USE MODE_FMREAD
!
INTEGER,     INTENT(IN)    :: KNBR
TYPE(FLYER), INTENT(INOUT) :: TPFLYER
!
!
!
!*      0.2  declaration of local variables
!
REAL :: ZLAT ! latitude of the balloon
REAL :: ZLON ! longitude of the balloon
!
IF (TPFLYER%MODEL == 'MOB' .AND. TPFLYER%NMODEL /= 0) TPFLYER%NMODEL=1
IF (TPFLYER%NMODEL > NMODEL) TPFLYER%NMODEL=0
IF ( IMI /= TPFLYER%NMODEL ) RETURN
!
LFLYER=.TRUE.
!
IF (TPFLYER%TITLE=='          ') THEN
  WRITE(TPFLYER%TITLE,FMT='(A6,I2.2)') TPFLYER%TYPE,KNBR
END IF
!
IF ( CPROGRAM == 'MESONH' .OR. CPROGRAM == 'SPAWN ' .OR. CPROGRAM == 'REAL  ' ) THEN
  ! read the current location in the FM_FILE
  !
  TZFIELD%CMNHNAME   = TRIM(TPFLYER%TITLE)//'LAT'
  TZFIELD%CSTDNAME   = ''
  TZFIELD%CLONGNAME  = TRIM(TZFIELD%CMNHNAME)
  TZFIELD%CUNITS     = 'degree'
  TZFIELD%CDIR       = '--'
  TZFIELD%CCOMMENT   = ''
  TZFIELD%NGRID      = 0
  TZFIELD%NTYPE      = TYPEREAL
  TZFIELD%NDIMS      = 0
  TZFIELD%LTIMEDEP   = .TRUE.
  CALL IO_READ_FIELD(TPINIFILE,TZFIELD,ZLAT,IRESP)
  !
  IF ( IRESP /= 0 ) THEN
    WRITE(ILUOUT,*) "INI_LAUCH: Initial location take for ",TPFLYER%TITLE
  ELSE
    TZFIELD%CMNHNAME   = TRIM(TPFLYER%TITLE)//'LON'
    TZFIELD%CSTDNAME   = ''
    TZFIELD%CLONGNAME  = TRIM(TZFIELD%CMNHNAME)
    TZFIELD%CUNITS     = 'degree'
    TZFIELD%CDIR       = '--'
    TZFIELD%CCOMMENT   = ''
    TZFIELD%NGRID      = 0
    TZFIELD%NTYPE      = TYPEREAL
    TZFIELD%NDIMS      = 0
    TZFIELD%LTIMEDEP   = .TRUE.
    CALL IO_READ_FIELD(TPINIFILE,TZFIELD,ZLON)
    !
    TZFIELD%CMNHNAME   = TRIM(TPFLYER%TITLE)//'ALT'
    TZFIELD%CSTDNAME   = ''
    TZFIELD%CLONGNAME  = TRIM(TZFIELD%CMNHNAME)
    TZFIELD%CUNITS     = 'm'
    TZFIELD%CDIR       = '--'
    TZFIELD%CCOMMENT   = ''
    TZFIELD%NGRID      = 0
    TZFIELD%NTYPE      = TYPEREAL
    TZFIELD%NDIMS      = 0
    TZFIELD%LTIMEDEP   = .TRUE.
    CALL IO_READ_FIELD(TPINIFILE,TZFIELD,TPFLYER%Z_CUR)
    !
    TPFLYER%P_CUR   = XUNDEF
    !
    TZFIELD%CMNHNAME   = TRIM(TPFLYER%TITLE)//'WASCENT'
    TZFIELD%CSTDNAME   = ''
    TZFIELD%CLONGNAME  = TRIM(TZFIELD%CMNHNAME)
    TZFIELD%CUNITS     = 'm s-1'
    TZFIELD%CDIR       = '--'
    TZFIELD%CCOMMENT   = ''
    TZFIELD%NGRID      = 0
    TZFIELD%NTYPE      = TYPEREAL
    TZFIELD%NDIMS      = 0
    TZFIELD%LTIMEDEP   = .TRUE.
    CALL IO_READ_FIELD(TPINIFILE,TZFIELD,TPFLYER%WASCENT)
    !
    TZFIELD%CMNHNAME   = TRIM(TPFLYER%TITLE)//'RHO'
    TZFIELD%CSTDNAME   = ''
    TZFIELD%CLONGNAME  = TRIM(TZFIELD%CMNHNAME)
    TZFIELD%CUNITS     = 'kg m-3'
    TZFIELD%CDIR       = '--'
    TZFIELD%CCOMMENT   = ''
    TZFIELD%NGRID      = 0
    TZFIELD%NTYPE      = TYPEREAL
    TZFIELD%NDIMS      = 0
    TZFIELD%LTIMEDEP   = .TRUE.
    CALL IO_READ_FIELD(TPINIFILE,TZFIELD,TPFLYER%RHO)
    !
    CALL SM_XYHAT(PLATOR,PLONOR,&
              ZLAT,ZLON,        &
              TPFLYER%X_CUR, TPFLYER%Y_CUR )
    TPFLYER%FLY = .TRUE.
    WRITE(ILUOUT,*) &
    "INI_LAUCH: Current location read in FM file for ",TPFLYER%TITLE
    IF (TPFLYER%TYPE== 'CVBALL') THEN
      WRITE(ILUOUT,*) &
       " Lat=",ZLAT," Lon=",ZLON," Alt=",TPFLYER%Z_CUR," Wasc=",TPFLYER%WASCENT
    ELSE IF (TPFLYER%TYPE== 'ISODEN') THEN
      WRITE(ILUOUT,*) &
       " Lat=",ZLAT," Lon=",ZLON," Rho=",TPFLYER%RHO
    END IF
    !
    TPFLYER%STEP  = MAX ( PTSTEP, TPFLYER%STEP )
  END IF
  !
ELSE IF (CPROGRAM == 'DIAG  ' ) THEN
  IF ( LAIRCRAFT_BALLOON ) THEN
    ! read the current location in MODD_DIAG_FLAG
    !
    ZLAT=XLAT_BALLOON(KNBR)
    ZLON=XLON_BALLOON(KNBR)
    TPFLYER%Z_CUR=XALT_BALLOON(KNBR)
    IF (TPFLYER%Z_CUR /= XUNDEF .AND. ZLAT /= XUNDEF .AND. ZLON /= XUNDEF ) THEN
      CALL SM_XYHAT(PLATOR,PLONOR,       &
              ZLAT,ZLON,        &
              TPFLYER%X_CUR, TPFLYER%Y_CUR )
      TPFLYER%FLY = .TRUE.
      WRITE(ILUOUT,*) &
      "INI_LAUCH: Current location read in MODD_DIAG_FLAG for ",TPFLYER%TITLE
      WRITE(ILUOUT,*) &
            " Lat=",ZLAT," Lon=",ZLON," Alt=",TPFLYER%Z_CUR
    END IF
    !
    TPFLYER%STEP  = MAX (XSTEP_AIRCRAFT_BALLOON , TPFLYER%STEP )
  END IF
END IF
!
IF (TPFLYER%LAT==XUNDEF .OR.TPFLYER%LON==XUNDEF) THEN
  WRITE(ILUOUT,*) 'Error in balloon initial position (balloon number ',KNBR,' )'
  WRITE(ILUOUT,*) 'either LATitude or LONgitude is not given'
  WRITE(ILUOUT,*) 'TPBALLOON%LAT=',TPFLYER%LAT
  WRITE(ILUOUT,*) 'TPBALLOON%LON=',TPFLYER%LON
  WRITE(ILUOUT,*) 'Check your INI_BALLOON routine'
!callabortstop
  CALL PRINT_MSG(NVERB_FATAL,'GEN','INI_AIRCRAFT_BALLOON','')
END IF
!
CALL SM_XYHAT(PLATOR,PLONOR,       &
              TPFLYER%LAT, TPFLYER%LON,        &
              TPFLYER%XLAUNCH, TPFLYER%YLAUNCH )
!
END SUBROUTINE INI_LAUNCH
!----------------------------------------------------------------------------
!----------------------------------------------------------------------------
SUBROUTINE INI_FLIGHT(KNBR,TPFLYER)
!
INTEGER,     INTENT(IN)    :: KNBR
TYPE(FLYER), INTENT(INOUT) :: TPFLYER
!
IF (TPFLYER%MODEL == 'MOB' .AND. TPFLYER%NMODEL /= 0) TPFLYER%NMODEL=1
IF (TPFLYER%NMODEL > NMODEL) TPFLYER%NMODEL=0
IF ( IMI /= TPFLYER%NMODEL ) RETURN
!
LFLYER=.TRUE.
!
TPFLYER%STEP  = MAX ( PTSTEP, TPFLYER%STEP )
!
IF (TPFLYER%SEG==0) THEN
  WRITE(ILUOUT,*) 'Error in aircraft flight path (aircraft number ',KNBR,' )'
  WRITE(ILUOUT,*) 'There is ZERO flight segment defined.'
  WRITE(ILUOUT,*) 'TPAIRCRAFT%SEG=',TPFLYER%SEG
  WRITE(ILUOUT,*) 'Check your INI_AIRCRAFT routine'
!callabortstop
  CALL PRINT_MSG(NVERB_FATAL,'GEN','INI_FLIGHT','')
END IF
!
IF ( ANY(TPFLYER%SEGLAT(:)==XUNDEF) .OR. ANY(TPFLYER%SEGLON(:)==XUNDEF) ) THEN
  WRITE(ILUOUT,*) 'Error in aircraft flight path (aircraft number ',KNBR,' )'
  WRITE(ILUOUT,*) 'either LATitude or LONgitude segment'
  WRITE(ILUOUT,*) 'definiton is not complete.'
  WRITE(ILUOUT,*) 'TPAIRCRAFT%SEGLAT=',TPFLYER%SEGLAT
  WRITE(ILUOUT,*) 'TPAIRCRAFT%SEGLON=',TPFLYER%SEGLON
  WRITE(ILUOUT,*) 'Check your INI_AIRCRAFT routine'
!callabortstop
  CALL PRINT_MSG(NVERB_FATAL,'GEN','INI_AIRCRAFT_BALLOON','')
END IF
!
ALLOCATE(TPFLYER%SEGX(TPFLYER%SEG+1))
ALLOCATE(TPFLYER%SEGY(TPFLYER%SEG+1))
!
DO JSEG=1,TPFLYER%SEG+1
  CALL SM_XYHAT(PLATOR,PLONOR,                              &
                TPFLYER%SEGLAT(JSEG), TPFLYER%SEGLON(JSEG), &
                TPFLYER%SEGX(JSEG),   TPFLYER%SEGY(JSEG)    )
END DO
!
IF ( ANY(TPFLYER%SEGTIME(:)==XUNDEF) ) THEN
  WRITE(ILUOUT,*) 'Error in aircraft flight path (aircraft number ',KNBR,' )'
  WRITE(ILUOUT,*) 'definiton of segment duration is not complete.'
  WRITE(ILUOUT,*) 'TPAIRCRAFT%SEGTIME=',TPFLYER%SEGTIME
  WRITE(ILUOUT,*) 'Check your INI_AIRCRAFT routine'
!callabortstop
  CALL PRINT_MSG(NVERB_FATAL,'GEN','INI_AIRCRAFT_BALLOON','')
END IF
!
!
IF (TPFLYER%TITLE=='          ') THEN
  WRITE(TPFLYER%TITLE,FMT='(A6,I2.2)') TPFLYER%TYPE,KNBR
END IF
!
END SUBROUTINE INI_FLIGHT
!----------------------------------------------------------------------------
!----------------------------------------------------------------------------
!
END SUBROUTINE INI_AIRCRAFT_BALLOON