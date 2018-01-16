CREATE OR REPLACE PACKAGE CHATBOT.PASRVBITACORASBOTLOG AS 
/*******************************************************************************
   Proyecto:           CHATBOT
   Descripción:        Paquete para almacenamiento de log
   Elaboró:            MIGUEL DARIO 
   Fecha Elaboración:  Octubre 2017
********************************************************************************/
   csgError                CONSTANT NUMBER( 1 ) := 0;                                -- Constante con valor cero que significa error
   csgExito                CONSTANT NUMBER( 1 ) := 1;                                -- Constante con valor cero que significa exito
   csgPaquete              CONSTANT VARCHAR2( 25 CHAR ) := 'PASRVBITACORASBOTLOG.' ;  -- Constante con valor del nombre del paquete
   csgNumero0              CONSTANT NUMBER( 1 ) := 0;                                -- Constante con valor cero
   csgNumero1              CONSTANT NUMBER( 1 ) := 1;                                -- Constante con valor uno
   csgFormatoFechaCorto    CONSTANT VARCHAR2( 10 CHAR ) := 'DD/MM/YYYY';             -- Constante con valor de formato corto de fecha

   PROCEDURE SPALTABITACORALOGS(
      paModeloId        IN    CHATBOT.TAMODULOS.FIMODULOID%TYPE
      , paClase         IN    CHATBOT.TABITACORAHISTORICOS.FCCLASE%TYPE
      , paErrorExcp     IN    CHATBOT.TABITACORAHISTORICOS.FCERROR%TYPE
      , paValores       IN    CHATBOT.TABITACORAHISTORICOS.FCDATOSEXEPCION%TYPE
   ) ;

END PASRVBITACORASBOTLOG ;
/

CREATE OR REPLACE PACKAGE BODY CHATBOT.PASRVBITACORASBOTLOG 
IS
/*******************************************************************************
   Proyecto:           CHATBOT Canal Externo
   Descripción:        Paquete para almacenamiento de log
   Elaboró:            MIGUEL DARIO 
   Fecha Elaboración:  Octubre 2017
*******************************************************************************/
   PROCEDURE SPALTABITACORALOGS(
      paModeloId        IN    CHATBOT.TAMODULOS.FIMODULOID%TYPE
      , paClase         IN    CHATBOT.TABITACORAHISTORICOS.FCCLASE%TYPE
      , paErrorExcp     IN    CHATBOT.TABITACORAHISTORICOS.FCERROR%TYPE
      , paValores       IN    CHATBOT.TABITACORAHISTORICOS.FCDATOSEXEPCION %TYPE   
   )
   IS 
   /****************************************************************************
      Descripción:  Procedimiento para insertar registros en las tablas de bitacora de robot.
      Parámetros de entrada: 
                              paModuloId        MAQUINA DE ESTADOS
                              , paClase         CLASE O ARCHIVO .PY DONDE GENERO ERROR
                              , paErrorExcp     ERROR TECNICO

      Parámetros de Salida:   Ninguno
      Parámetros de 
         entrada-salida:      Ninguno.

      Elaboró:                DARIO RESENDIZ
      Fecha Elaboración:      OCTUBRE 2017
   ****************************************************************************/
      vlValores      CHATBOT.TABITACORAHISTORICOS.FCDATOSEXEPCION%TYPE := '' ;
   BEGIN

      vlValores := paValores ;

      IF paModeloId > csgNumero0
      AND LENGTH( paClase ) > csgNumero0
      AND LENGTH( paErrorExcp ) > csgNumero0 THEN
         IF vlValores IS NULL OR LENGTH( vlValores ) < csgNumero0 THEN
           vlValores := Empty_clob() ;
         END IF ;

         INSERT INTO CHATBOT.TABITACORAHISTORICOS( FIBITACORAHISTORICOSID,
                                                FIMODELOID,
                                                FCCLASE,
                                                FCERROR,
                                                FCDATOSEXEPCION )
         VALUES(  CHATBOT.SEQIDLOGBITACORA.NEXTVAL,
                  paModeloId,
                  paClase,
                  paErrorExcp,
                  vlValores   );
         COMMIT ;
      END IF ;

   END SPALTABITACORALOGS ;
   
   
   
   
   
   
   
END PASRVBITACORASBOTLOG ;
