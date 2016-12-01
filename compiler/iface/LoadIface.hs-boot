module LoadIface where
import Module (Module)
import TcRnMonad (IfM)
import HscTypes (ModIface, ProgramLifecyclePhase)
import Outputable (SDoc)

loadSysInterface :: SDoc -> Module -> ProgramLifecyclePhase -> IfM lcl ModIface
