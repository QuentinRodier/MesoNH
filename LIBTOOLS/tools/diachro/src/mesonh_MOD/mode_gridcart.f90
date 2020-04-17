!-----------------------------------------------------------------
!--------------- special set of characters for SCCS information
!--------------- C. Fischer 30/09/94
!      @(#) Lib:/opt/local/MESONH/sources/mode/s.mode_gridcart.f90, Version:1.9, Date:98/10/01, Last modified:98/06/04
!-----------------------------------------------------------------
!     ####################
      MODULE MODE_GRIDCART
!     ####################
!
!!****  *MODE_GRIDCART* -  module routine SM_GRIDCART 
!!
!!    PURPOSE
!!    -------
!       The purpose of this executive module  is to package 
!     the routine SM_GRIDCART 
!    
!      
!
!!
!!**  IMPLICIT ARGUMENTS
!!    ------------------
!!       NONE          
!!
!!    REFERENCE
!!    ---------
!!
!!
!!    AUTHOR
!!    ------
!!	V. Ducrocq       * Meteo France *
!!
!!    MODIFICATIONS
!!    -------------
!!      Original    06/05/94 
!--------------------------------------------------------------------------------
!
!*       0.    DECLARATIONS
!              ------------
!
!-------------------------------------------------------------------------------
!
CONTAINS
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!
!*       1.   ROUTINE SM_GRIDCART
!             -------------------
!-------------------------------------------------------------------------------
!     #########################################################################
      SUBROUTINE SM_GRIDCART(HLUOUT,PXHAT,PYHAT,PZHAT,PZS,OSLEVE,PLEN1,PLEN2,PZSMT,PDXHAT,PDYHAT,PZZ,PJ)
!     #########################################################################
!
!!****  *SM_GRIDCART * - routine to compute J 
!!
!!    PURPOSE
!!    -------
!       The purpose of this routine is to compute the Jacobian (J) in the case
!     of a cartesian geometry 
!      
!
!!**  METHOD
!!    ------
!!       The height z is first determined, and then J is computed 
!!     
!!
!!    EXTERNAL
!!    --------
!!      NONE
!!
!!    IMPLICIT ARGUMENTS
!!    ------------------
!!      Module MODD_PARAMETERS : contains array border depths
!! 
!!        JPHEXT,JPVEXT : Arrays border zone depth
!!
!!      Module MODD_CONF       : contains  configuration variables for 
!!                               all models
!
!!        NVERB        : Listing verbosity
!!
!!    REFERENCE
!!    ---------
!!      Technical Specifications Report of the Meso-NH project (chapters 2 and 3)
!!
!!
!!    AUTHOR
!!    ------
!!	V. Ducrocq       * Meteo France *
!!
!!    MODIFICATIONS
!!    -------------
!!      Original    06/05/94 
!!      updated                 V. Ducrocq  *Meteo France*   27/06/94 
!!      Updated                 P.M.        *LA*             22/07/94
!!      Updated                 V. Ducrocq  *Meteo France*   23/08/94 
!-------------------------------------------------------------------------------
!
!*       0.    DECLARATIONS
!              ------------
!
USE MODD_PARAMETERS       
USE MODD_CONF
!
USE MODI_VERT_COORD
!
IMPLICIT NONE
!
!*       0.1   Declarations of arguments
!
CHARACTER(LEN=*),       INTENT(IN)  :: HLUOUT            ! Output-listing name 
REAL, DIMENSION(:),     INTENT(IN)  :: PXHAT,PYHAT,PZHAT ! positions x,y,z in 
                                                         ! the cartesian plane
REAL, DIMENSION(:,:),   INTENT(IN)  :: PZS               ! orography
LOGICAL,                INTENT(IN)  :: OSLEVE            ! flag for SLEVE coordinate
REAL,                   INTENT(IN)  :: PLEN1             ! Decay scale for smooth topography
REAL,                   INTENT(IN)  :: PLEN2             ! Decay scale for small-scale topography deviation
REAL, DIMENSION(:,:),   INTENT(IN)  :: PZSMT             ! smooth orography
!
REAL, DIMENSION(:),     INTENT(OUT) :: PDXHAT            ! meshlength in x 
                                                         ! direction
REAL, DIMENSION(:),     INTENT(OUT) :: PDYHAT            ! meshlength in y 
                                                         ! direction 
REAL, DIMENSION(:,:,:), INTENT(OUT) :: PZZ               ! Height z
REAL, DIMENSION(:,:,:), INTENT(OUT) :: PJ                ! Jacobian of the
                                                         ! GCS transformation
!
!*       0.2   Declarations of local variables
!
REAL, DIMENSION(SIZE(PXHAT,1),SIZE(PYHAT,1),SIZE(PZHAT,1)) :: ZDZ ! meshlength in
                                                                  ! z direction 
REAL, DIMENSION(SIZE(PZS,1),SIZE(PZS,2)) :: ZBOUNDZ          ! Extrapolated
REAL                                     :: ZBOUNDX,ZBOUNDY  ! value for the 
                                                             ! upper bounds in 
                                                             ! z,x,y directions  
!
INTEGER      :: IIB,IJB,IKB      ! beginning of useful area of PXHAT,PYHAT,PZHAT  
INTEGER      :: IIE,IJE,IKE      ! end of useful area of PXHAT,PYHAT,PZHAT  
INTEGER      :: IIU,IJU,IKU      ! upper bounds of PXHAT,PYHAT,PZHAT  
INTEGER      :: IKLOOP           ! index for prints
INTEGER      :: ILUOUT,IRESP     ! logical unit number for prints, error code
!
!-------------------------------------------------------------------------------
!
!*       1    RETRIEVE LOGICAL UNIT NUMBERFOR OUTPUT-LISTING AND  DIMENSIONS 
!             --------------------------------------------------------------
!
CALL FMLOOK(HLUOUT,HLUOUT,ILUOUT,IRESP)
!
IIU = UBOUND(PXHAT,1)         
IJU = UBOUND(PYHAT,1)        
IKU = UBOUND(PZHAT,1)          
IIE = IIU-JPHEXT
IJE = IJU-JPHEXT
IKE = IKU-JPVEXT
IIB = 1+JPHEXT
IJB = 1+JPHEXT
IKB = 1+JPVEXT
!
IF(NVERB >= 10) THEN                         ! Parameter checking
  WRITE(ILUOUT,*) 'SM_GRIDCART: IIU,IJU,IKU=',IIU,IJU,IKU
  WRITE(ILUOUT,*) 'SM_GRIDCART: IIE,IJE,IKE=',IIE,IJE,IKE
  WRITE(ILUOUT,*) 'SM_GRIDCART: IIB,IJB,IKB=',IIB,IJB,IKB
ENDIF
!
!-------------------------------------------------------------------------------
!
!*       2.    COMPUTE Z
!              ---------
!
CALL VERT_COORD(OSLEVE,PZS,PZSMT,PLEN1,PLEN2,PZHAT,PZZ)
!
IF(NVERB >= 10) THEN                               !Value control
  WRITE(ILUOUT,*) 'SM_GRIDCART: Some PZS values:'
  WRITE(ILUOUT,*)  PZS(1,1),PZS(IIU/2,IJU/2),PZS(IIU,IJU)  
  WRITE(ILUOUT,*) 'SM_GRIDCART: Some PZZ values:'
  DO IKLOOP=1,IKU
    WRITE(ILUOUT,*) PZZ(1,1,IKLOOP),PZZ(IIU/2,IJU/2,IKLOOP), &
                    PZZ(IIU,IJU,IKLOOP)  
  END DO
ENDIF
!-------------------------------------------------------------------------------
!
!
!*       3.    COMPUTE J
!              ---------
!
ZBOUNDX      = 2.*PXHAT(IIU)   - PXHAT(IIU-1)
ZBOUNDY      = 2.*PYHAT(IJU)   - PYHAT(IJU-1)
ZBOUNDZ(:,:) = 2.*PZZ(:,:,IKU) - PZZ(:,:,IKU-1)
PDXHAT(:)  = EOSHIFT(PXHAT(:) ,1,ZBOUNDX)      - PXHAT(:)
PDYHAT(:)  = EOSHIFT(PYHAT(:) ,1,ZBOUNDY)      - PYHAT(:)
ZDZ(:,:,:) = EOSHIFT(PZZ(:,:,:),1,ZBOUNDZ(:,:),3) - PZZ(:,:,:)
PJ(:,:,:)  = SPREAD((SPREAD(PDXHAT(:),2,IJU) * SPREAD(PDYHAT(:),1,IIU)),3,IKU)  &
           * ZDZ(:,:,:) 
!
IF(NVERB >= 10) THEN                               !Value control
  WRITE(ILUOUT,*) 'Some PJ values:'
  DO IKLOOP=1,IKU
    WRITE(ILUOUT,*) PJ(1,1,IKLOOP),PJ(IIU/2,IJU/2,IKLOOP),  &
                    PJ(IIU,IJU,IKLOOP)  
  END DO
ENDIF
! 
!-------------------------------------------------------------------------------
!
END SUBROUTINE SM_GRIDCART
!-------------------------------------------------------------------------------
END MODULE MODE_GRIDCART
