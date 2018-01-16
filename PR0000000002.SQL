CREATE OR REPLACE PACKAGE CHATBOT.PASRVUSUARIOS IS 
/*******************************************************************************
   Proyecto:                          DEX CHATBOT
   Descripción:                       Paquete para el control de opeaciones desde el WebHok
   Elaboró:                            MIGUEL DARIO 
   Fecha Elaboración:              Octubre 2017
*******************************************************************************/

   csgNumero0         CONSTANT NUMBER(1)   :=  0;                             --- Constante global valor igual a cero.
   csgNumero1         CONSTANT NUMBER(1)   :=  1;                             --- Constante global valor igual a uno.
   csgNumero2         CONSTANT NUMBER(1)   :=  2;                             --- Constante global valor igual a dos.
   csgNumero3         CONSTANT NUMBER(1)   :=  3;                             --- Constante global valor igual a cuatro.   
   csgNumero4         CONSTANT NUMBER(1)   :=  4;                             --- Constante global valor igual a cuatro.
   csgNumero5         CONSTANT NUMBER(1)   :=  5;                             --- Constante global valor igual a cinco.   

   PROCEDURE SPVALIDADUSUARIOS(
        paTipoOperacion       IN    VARCHAR2
      , PaUsuarioId              IN    CHATBOT.TAUSUARIOS.FINOIDFACEBOOK%TYPE
      , PaNombre           IN    CHATBOT.TAUSUARIOS.FCNOMBRE%TYPE
      , PaAPaterno         IN    CHATBOT.TAUSUARIOS.FCAPPATERNO%TYPE
      , PaConfirmacionTel  IN    CHATBOT.TAUSUARIOS.FICONFIRMACIONTELEFONO%TYPE
      , paDatosUsuario     OUT   SYS_REFCURSOR
      , PaCodigo           OUT   NUMBER
      , PaMensaje          OUT   VARCHAR2
   )    ;

   PROCEDURE SPGESTIONUSUARIOS(
      PaTipoOperacion     IN    VARCHAR
      , PaUsuarioId         IN    CHATBOT.TAUSUARIOS.FINOIDFACEBOOK%TYPE
      , paClienteIdDex     IN    CHATBOT.TAUSUARIOS.FINOIDCLIENTE%TYPE
      , PaNombre           IN    CHATBOT.TAUSUARIOS.FCNOMBRE%TYPE
      , PaAPaterno         IN    CHATBOT.TAUSUARIOS.FCAPPATERNO%TYPE
      , PaAMaterno         IN    CHATBOT.TAUSUARIOS.FCAPMATERNO%TYPE
      , PaFechaNacimiento  IN    VARCHAR2
      , PaTelefono         IN    VARCHAR2
      , PaListaNegra       IN    CHATBOT.TAUSUARIOS.FIBLOQUEO%TYPE
      , PaImagen           IN    BLOB
      , PaConfirmacionTel  IN    CHATBOT.TAUSUARIOS.FICONFIRMACIONTELEFONO%TYPE
      , PaDatosUsuario     OUT   SYS_REFCURSOR
      , PaCodigo           OUT   NUMBER
      , PaMensaje          OUT   VARCHAR2
   ) ;

   PROCEDURE SPGESTIONADIRECCIONUSUARIO(
      PaTipoOperacion      IN    VARCHAR2
      , PaUsuarioId        IN    CHATBOT.TAUSUARIOS.FINOIDFACEBOOK%TYPE
      , PaDireccion        IN    CHATBOT.TAUSUARIOS.FCDIRECCION%TYPE
      , PaCodigoPostal     IN    CHATBOT.TAUSUARIOS.FICODPOSTAL%TYPE
      , PaEstado           IN    CHATBOT.TAUSUARIOS.FCESTADO%TYPE
      , PaMunicipio        IN    CHATBOT.TAUSUARIOS.FCMUNICIPIO%TYPE
      , PaColonia          IN    CHATBOT.TAUSUARIOS. FCCOLONIA%TYPE
      , PaCodigo           OUT   NUMBER
      , PaMensaje          OUT   VARCHAR2
   ) ;

END PASRVUSUARIOS ;
/

CREATE OR REPLACE PACKAGE BODY CHATBOT.PASRVUSUARIOS IS 
/*******************************************************************************
   Proyecto:                          DEX CHATBOT
   Descripción:                       Paquete para el control de opeaciones desde el WebHok
   Elaboró:                            MIGUEL DARIO 
   Fecha Elaboración:              Octubre 2017
*******************************************************************************/

   PROCEDURE SPVALIDADUSUARIOS(
      paTipoOperacion      IN    VARCHAR2
      , PaUsuarioId        IN    CHATBOT.TAUSUARIOS.FINOIDFACEBOOK%TYPE
      , PaNombre           IN    CHATBOT.TAUSUARIOS.FCNOMBRE%TYPE
      , PaAPaterno         IN    CHATBOT.TAUSUARIOS.FCAPPATERNO%TYPE
      , PaConfirmacionTel  IN    CHATBOT.TAUSUARIOS.FICONFIRMACIONTELEFONO%TYPE
      , paDatosUsuario     OUT   SYS_REFCURSOR
      , PaCodigo           OUT   NUMBER
      , PaMensaje          OUT   VARCHAR2
   )IS
      cslPaqueteBD      CONSTANT VARCHAR2( 100 CHAR ) := 'PASRVUSUARIOS.SPVALIDADUSUARIOS'; --- Almacena el nombre del paquete de BD.   
      vlSQLErrm         VARCHAR2( 1024 CHAR )  := '';                     --- Almacena el mensaje a detalle asociado al código de error de Oracle.      
      vlParamFnBD       CLOB                   := '';                     --- Almacena los parámetros de entrada enviados a la función de BD.
      vlExiste          NUMBER( 1 )            := 0 ;
      vlConfirmacionTel CHATBOT.TAUSUARIOS.FICONFIRMACIONTELEFONO%TYPE := 0;
      vlRetornNull      SYS_REFCURSOR        ;
   BEGIN
      vlParamFnBD := 'SPVALIDADUSUARIOS( '|| PaUsuarioId 
         || ',' ||  PaNombre
         || ',' || PaAPaterno || ' )' ;

      CASE
      WHEN UPPER( PaTipoOperacion ) = 'VALIDA CLIENTE' THEN   
          IF PaUsuarioId > 0 THEN
             SELECT COUNT( ROWID )
             INTO vlExiste
             FROM CHATBOT.TAUSUARIOS
             WHERE FINOIDFACEBOOK = PaUsuarioId ;
    
             IF vlExiste >= 1 THEN
                OPEN paDatosUsuario FOR
                SELECT
                   FCNOMBRE,
                   FCAPPATERNO,
                   FCAPMATERNO,
                   FCDISPONIBLE
                FROM
                   CHATBOT.TAUSUARIOS
                WHERE
                   FINOIDFACEBOOK = PaUsuarioId ;
                   
                PaCodigo            := 1 ;
                PaMensaje           := 'CONSULTADO CON EXITO.' ;
                
             ELSE
                PaCodigo    := 0 ;
                PaMensaje   := 'NO EXISTE EL ID DE USUARIO' ;
             END IF ;
    
          ELSE         
             PaCodigo    := 0 ;
             PaMensaje   := 'VERIFIQUE EL PARAMETRO DEL ID DE FACEBOOK.' ;
             OPEN paDatosUsuario FOR
                SELECT ''FCNOMBRE,
                      ''FCAPPATERNO,
                      ''FCAPMATERNO,
                      ''FCDISPONIBLE
                FROM DUAL ;
          END IF ;
      
      
      WHEN UPPER( PaTipoOperacion ) = 'VALIDA TELEFONO CLIENTE' THEN
          SELECT COUNT( 1 )
            INTO vlExiste
            FROM CHATBOT.TAUSUARIOS
            WHERE FINOIDFACEBOOK = PaUsuarioId ;

            IF vlExiste >= 1 THEN
                SELECT FICONFIRMACIONTELEFONO
                INTO vlConfirmacionTel
                FROM CHATBOT.TAUSUARIOS
                WHERE FINOIDFACEBOOK =  PaUsuarioId  ;
            
                PaCodigo    := vlConfirmacionTel ;
                PaMensaje   := 'VERIFICACION EXITOSA' ;
                
            ELSIF vlExiste <= 0 THEN
                PaCodigo    := vlConfirmacionTel ;
                PaMensaje   := 'NO EXISTE EL USUARIO DE FACEBOOK' ;
                
            END IF ;
      
      ELSE
        PaCodigo    := vlConfirmacionTel ;
        PaMensaje   := 'SELECCIONE UNA OPCION PORFAVOR' ;
      
      END CASE ;
        
    
      EXCEPTION
      WHEN OTHERS THEN
         vlSQLErrm := TO_CHAR( SQLERRM );
         CHATBOT.PASRVBITACORASBOTLOG.SPALTABITACORALOGS( 
            1
            , cslPaqueteBD
            , vlSQLErrm
            , vlParamFnBD
         ) ;
         PaCodigo    := 0 ;
         
         PaMensaje   := vlSQLErrm ;
   END SPVALIDADUSUARIOS ;






   PROCEDURE SPGESTIONUSUARIOS(
      PaTipoOperacion      IN    VARCHAR
      , PaUsuarioId        IN    CHATBOT.TAUSUARIOS.FINOIDFACEBOOK%TYPE
      , paClienteIdDex     IN    CHATBOT.TAUSUARIOS.FINOIDCLIENTE%TYPE
      , PaNombre           IN    CHATBOT.TAUSUARIOS.FCNOMBRE%TYPE
      , PaAPaterno         IN    CHATBOT.TAUSUARIOS.FCAPPATERNO%TYPE
      , PaAMaterno         IN    CHATBOT.TAUSUARIOS.FCAPMATERNO%TYPE
      , PaFechaNacimiento  IN    VARCHAR2
      , PaTelefono         IN    VARCHAR2
      , PaListaNegra       IN    CHATBOT.TAUSUARIOS.FIBLOQUEO%TYPE      
      , PaImagen           IN    BLOB
      , PaConfirmacionTel  IN    CHATBOT.TAUSUARIOS.FICONFIRMACIONTELEFONO%TYPE
      , PaDatosUsuario     OUT   SYS_REFCURSOR
      , PaCodigo           OUT   NUMBER
      , PaMensaje          OUT   VARCHAR2
   )IS
      cslPaqueteBD    CONSTANT VARCHAR2( 100 CHAR ) := 'PASRVUSUARIOS.SPGESTIONUSUARIOS'; --- Almacena el nombre del paquete de BD.   
      vlSQLErrm       VARCHAR2( 1024 CHAR )     := '';                  --- Almacena el mensaje a detalle asociado al código de error de Oracle.      
      vlParamFnBD     CLOB                      := '';                  --- Almacena los parámetros de entrada enviados a la función de BD.
      vlExiste        NUMBER( 1 )               := 0 ;
      exeIdUsuario    EXCEPTION ;
   BEGIN
      SELECT COUNT( 1 )
      INTO vlExiste
      FROM CHATBOT.TAUSUARIOS
      WHERE FINOIDFACEBOOK = PaUsuarioId ;

      IF vlExiste = 0 THEN
         RAISE exeIdUsuario ;
      END IF ;

      vlParamFnBD := 'SPGESTIONUSUARIOS( '
         || PaTipoOperacion
         || ',' || PaUsuarioId
         || ',' || PaNombre
         || ',' || PaAPaterno
         || ',' || PaAMaterno
         || ',' || PaFechaNacimiento
         || ',' || PaTelefono
         || ',' || PaListaNegra
         || ',' || ' )' ;

      CASE 
      WHEN UPPER( PaTipoOperacion ) = 'ALTA SENCILLA DE USUARIO' THEN
         INSERT INTO CHATBOT.TAUSUARIOS( FINOIDFACEBOOK, FCNOMBRE, FCAPPATERNO )
         VALUES( PaUsuarioId, PaNombre, PaAPaterno ) ;
         COMMIT ;
         PaCodigo    := 1 ;
         PaMensaje   := 'ALTA SENCILLA EXITOSA.' ;

      WHEN UPPER( PaTipoOperacion ) = 'DATOS PERSONALES' THEN
         INSERT INTO CHATBOT.TAUSUARIOS( FINOIDFACEBOOK,
                                          FCNOMBRE,
                                          FCAPPATERNO,
                                          FCAPMATERNO,
                                          FDFECHANAC,
                                          FIBLOQUEO,
                                          FITELEFONO )
         VALUES( PaUsuarioId
                  , PaNombre
                  , PaAPaterno
                  , PaAMaterno
                  , TO_DATE( PaFechaNacimiento, 'DD-MM-YYYY' )
                  , PaListaNegra
                  , PaTelefono ) ;
         COMMIT ;
         PaCodigo    := 1 ;
         PaMensaje   := 'ALTA DE DATOS EXITOSA.' ;
        
        
      WHEN UPPER( PaTipoOperacion ) = 'AGREGA O MODIFICA TELEFONO' THEN
            PaCodigo    := 1 ;           
            PaMensaje   := 'MODIFICACION O INSERCION CON EXITOSA.' ;
                        
               UPDATE CHATBOT.TAUSUARIOS
               SET FITELEFONO = PaTelefono
                        , FICONFIRMACIONTELEFONO = PaConfirmacionTel
                WHERE FINOIDFACEBOOK = PaUsuarioId ;
                COMMIT;


      WHEN UPPER( PaTipoOperacion ) = 'MODIFICA DATOS USUARIO' THEN
         SELECT COUNT( ROWID )
         INTO vlExiste
         FROM CHATBOT.TAUSUARIOS
         WHERE FINOIDFACEBOOK = PaUsuarioId ;

         IF vlExiste >= 1 THEN
            UPDATE CHATBOT.TAUSUARIOS 
            SET FCNOMBRE      = PaNombre
               , FCAPPATERNO  = PaAPaterno
               , FCAPMATERNO  = PaAMaterno
            WHERE FINOIDFACEBOOK = PaUsuarioId ;

            PaCodigo    := 1 ;
            PaMensaje   := 'DATOS CAMBIADOS CON EXITO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaNombre
                     , PaAPaterno
                     , PaAMaterno
               FROM DUAL ;
         ELSE
            PaCodigo    := 0 ;
            
            PaMensaje   := 'VERIFICAR DATO: '||PaUsuarioId||' NO SE ACTUALIZO NINGUN DATO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaNombre
                     , PaAPaterno
                     , PaAMaterno
               FROM DUAL ;
         END IF ;

      WHEN UPPER( PaTipoOperacion ) = 'MODIFICA ID DEX DE USUARIO' THEN
         SELECT COUNT( ROWID )
         INTO vlExiste
         FROM CHATBOT.TAUSUARIOS 
         WHERE FINOIDFACEBOOK = PaUsuarioId ;

         IF vlExiste >= 1 THEN
            UPDATE CHATBOT.TAUSUARIOS
            SET FINOIDCLIENTE = paClienteIdDex
            WHERE FINOIDFACEBOOK = PaUsuarioId ;
            COMMIT;

            PaCodigo    := 1 ;
            
            PaMensaje   := 'DATOS CAMBIADOS CON EXITO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaNombre
                     , PaAPaterno
                     , PaAMaterno
               FROM DUAL ;
         ELSE
            PaCodigo    := 0 ;
            
            PaMensaje   := 'VERIFICAR DATO: '||PaUsuarioId||' NO SE ACTUALIZO NINGUN DATO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaTipoOperacion
                     , paClienteIdDex
                     , PaUsuarioId
               FROM DUAL ;
         END IF ;

      WHEN UPPER( PaTipoOperacion ) = 'MODIFICA FECHA NACIMIENTO USUARIO' THEN
         SELECT COUNT( ROWID )
         INTO vlExiste
         FROM CHATBOT.TAUSUARIOS 
         WHERE FINOIDFACEBOOK = PaUsuarioId ;

         IF vlExiste >= 1 THEN
            UPDATE CHATBOT.TAUSUARIOS 
            SET FDFECHANAC = TO_DATE( PaFechaNacimiento, 'DD-MM-YYYY' )
            WHERE FINOIDFACEBOOK = PaUsuarioId ;
            COMMIT;
            
            PaCodigo    := 1 ;
            
            PaMensaje   := 'FECHA NACIMIENTO CAMBIADA CON EXITO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaTipoOperacion
                     , PaUsuarioId
                     , PaFechaNacimiento
               FROM DUAL ;
         ELSE
            PaCodigo    := 0 ;
            
            PaMensaje   := 'VERIFICAR DATOS NO SE ACTUALIZO' ;
            OPEN PaDatosUsuario FOR
               SELECT PaNombre
                     , PaAPaterno
                     , PaAMaterno
               FROM DUAL ;
         END IF ;

      WHEN UPPER( PaTipoOperacion ) = 'MODIFICA STATUS LISTA NEGRA' THEN
         SELECT COUNT( ROWID )
         INTO vlExiste
         FROM CHATBOT.TAUSUARIOS 
         WHERE FINOIDFACEBOOK = PaUsuarioId ;

         IF vlExiste = 0 THEN
            PaCodigo    := 0 ;
            
            PaMensaje   := 'VERIFICAR DATO: '||PaUsuarioId||' NO SE ACTUALIZO NINGUN DATO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaTipoOperacion
                     , PaListaNegra
                     , PaUsuarioId
               FROM DUAL ;
         ELSE
            UPDATE CHATBOT.TAUSUARIOS 
            SET FIBLOQUEO = PaListaNegra
            WHERE FINOIDFACEBOOK = PaUsuarioId ;
            COMMIT ;

            PaCodigo    := 1 ;            
            PaMensaje   := 'EL STATUS DE LISTA NEGRA SE CAMBIO CON EXITO.' ;
            OPEN PaDatosUsuario FOR
               SELECT PaTipoOperacion
                     , PaListaNegra
                     , PaUsuarioId
               FROM DUAL ;            
         END IF ;

      WHEN UPPER( PaTipoOperacion ) = 'OBTEN DATOS DE USUARIO' THEN     
         SELECT COUNT( ROWID )
         INTO vlExiste
         FROM CHATBOT.TAUSUARIOS
         WHERE FINOIDFACEBOOK = PaUsuarioId ;

         IF vlExiste > 0 THEN
            OPEN PaDatosUsuario FOR
               SELECT
                  FINOIDCLIENTE,
                  FCNOMBRE,
                  FCAPPATERNO,
                  FCAPMATERNO,
                  TO_CHAR(
                     FDFECHANAC,
                     'DD/MM/YYYY'
                  ) FDFECHANAC,
                  FIBLOQUEO,
                  FITELEFONO,
                  FCDIRECCION,
                  LPAD(
                     TO_CHAR( FICODPOSTAL ),
                     5,
                     '0'
                  ) FICODPOSTAL,
                  FCESTADO,
                  FCMUNICIPIO,
                  FCCOLONIA
               FROM
                  CHATBOT.TAUSUARIOS
               WHERE 
                  FINOIDFACEBOOK = PaUsuarioId ;

            PaCodigo    := 1 ;
            PaMensaje   := 'CONSULTADO CON EXITO.' ;

         ELSE
            OPEN PaDatosUsuario FOR
               SELECT 0FINOIDCLIENTE,
                  ''FCNOMBRE,
                  ''FCAPPATERNO,
                  ''FCAPMATERNO,
                  ''FDFECHANAC,
                  0FIBLOQUEO,
                  ''FITELEFONO,
                  ''FCDIRECCION,
                  ''FICODPOSTAL,
                  ''FCESTADO,
                  ''FCMUNICIPIO,
                  ''FCCOLONIA 
               FROM DUAL ;

         PaCodigo    := 0 ;
         
         PaMensaje   := 'VERIFICAR LOS DATOS SIGUIENTES. ' ;

         END IF;

      ELSE
         OPEN PaDatosUsuario FOR
            SELECT 0FINOIDCLIENTE,
               ''FCNOMBRE,
               ''FCAPPATERNO,
               ''FCAPMATERNO,
               ''FDFECHANAC,
               0FIBLOQUEO,
               ''FITELEFONO,
               ''FCDIRECCION,
               ''FICODPOSTAL,
               ''FCESTADO,
               ''FCMUNICIPIO,
               ''FCCOLONIA 
            FROM DUAL ;

         PaCodigo    := 0 ;
         PaMensaje   := 'VERIFICAR LOS DATOS SIGUIENTES. ' ;
      END CASE ;


      EXCEPTION
      WHEN exeIdUsuario THEN
         PaCodigo    := 0 ;
         PaMensaje   := 'NO EXISTE EL USUARIO.' ;

      WHEN NO_DATA_FOUND THEN
         ROLLBACK;
         vlSQLErrm   := SQLERRM ;
         CHATBOT.PASRVBITACORASBOTLOG.SPALTABITACORALOGS(
            1
            , cslPaqueteBD
            , vlSQLErrm
            , vlParamFnBD
         ) ;
         
         PaCodigo    := 0 ;
         
         PaMensaje   := 'NO SE ENCONTRARON REGISTROS.' ;

      WHEN OTHERS THEN
         ROLLBACK;
         vlSQLErrm   := SQLERRM ;
         CHATBOT.PASRVBITACORASBOTLOG.SPALTABITACORALOGS(
            1
            , cslPaqueteBD
            , vlSQLErrm
            , vlParamFnBD
         ) ;
         PaCodigo    := 0 ;
         PaMensaje   := vlSQLErrm ;
   END SPGESTIONUSUARIOS ;






   PROCEDURE SPGESTIONADIRECCIONUSUARIO(
      PaTipoOperacion      IN    VARCHAR2
      , PaUsuarioId        IN    CHATBOT.TAUSUARIOS.FINOIDFACEBOOK%TYPE
      , PaDireccion        IN    CHATBOT.TAUSUARIOS.FCDIRECCION%TYPE
      , PaCodigoPostal     IN    CHATBOT.TAUSUARIOS.FICODPOSTAL%TYPE
      , PaEstado           IN    CHATBOT.TAUSUARIOS.FCESTADO%TYPE
      , PaMunicipio        IN    CHATBOT.TAUSUARIOS.FCMUNICIPIO%TYPE
      , PaColonia          IN    CHATBOT.TAUSUARIOS. FCCOLONIA%TYPE      
      , PaCodigo           OUT   NUMBER
      , PaMensaje          OUT   VARCHAR2
   )IS
      cslPaqueteBD    CONSTANT VARCHAR2( 100 CHAR ) := 'PASRVUSUARIOS.SPGESTIONADIRECCIONUSUARIO'; --- Almacena el nombre del paquete de BD.   
      vlSQLErrm       VARCHAR2( 1024 CHAR )        := '';               --- Almacena el mensaje a detalle asociado al código de error de Oracle.
      vlParamFnBD     CLOB                         := '';               --- Almacena los parámetros de entrada enviados a la función de BD.
      vlExiste        NUMBER( 1 )                  := 0 ;
   BEGIN

      CASE
      WHEN UPPER( PaTipoOperacion ) = 'CAMBIAR DATOS DIRECCION' THEN
         SELECT COUNT( ROWID )
         INTO vlExiste
         FROM CHATBOT.TAUSUARIOS
         WHERE FINOIDFACEBOOK = PaUsuarioId ;

         IF vlExiste > 0 THEN
            UPDATE CHATBOT.TAUSUARIOS 
            SET FCDIRECCION = PaDireccion
               , FICODPOSTAL = PaCodigoPostal
               , FCESTADO = PaEstado
               , FCMUNICIPIO = PaMunicipio
               , FCCOLONIA = PaColonia 
            WHERE FINOIDFACEBOOK = PaUsuarioId ;
            COMMIT ;

            PaCodigo    := 1 ;
            PaMensaje   := 'MODIFICACION EXITOSA.' ;
         ELSE
            PaCodigo    := 0 ;
            PaMensaje   := 'VERIFICAR DATOS NO SE ACTUALIZO' ;

         END IF ;      

      ELSE
         PaCodigo    := 0 ;
         PaMensaje   := 'NO SE ENCONTRO NADA VERIFICAR ID DE USUARIO.' ;
      END CASE ;

      EXCEPTION
      WHEN OTHERS THEN
         vlSQLErrm   := SQLERRM;
         CHATBOT.PASRVBITACORASBOTLOG.SPALTABITACORALOGS( 
            1
            , cslPaqueteBD
            , vlSQLErrm
            , vlParamFnBD
         ) ;
         PaCodigo    := 0 ;
         PaMensaje   := vlSQLErrm ;
   END SPGESTIONADIRECCIONUSUARIO ;






END PASRVUSUARIOS ;